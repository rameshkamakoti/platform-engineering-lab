data "aws_iam_policy_document" "crossplane_s3_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:crossplane-system:provider-aws-s3-5eb9ca57abb1"
      ]
    }
  }
}

resource "aws_iam_policy" "crossplane_s3" {
  name        = "CrossplaneS3LabPolicy"
  description = "S3 permissions for Crossplane lab"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:*"
        ]

        Resource = [
          "arn:aws:s3:::payment-api-*",
          "arn:aws:s3:::payment-api-*/*",
          "arn:aws:s3:::platform-crossplane-lab-*",
          "arn:aws:s3:::platform-crossplane-lab-*/*"
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListAllMyBuckets"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "crossplane_s3" {
  name = "platform-crossplane-s3-role"

  assume_role_policy = data.aws_iam_policy_document.crossplane_s3_assume_role.json

  tags = {
    Name = "platform-crossplane-s3-role"
  }
}

resource "aws_iam_role_policy_attachment" "crossplane_s3" {
  role       = aws_iam_role.crossplane_s3.name
  policy_arn = aws_iam_policy.crossplane_s3.arn
}