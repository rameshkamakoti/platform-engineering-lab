resource "aws_security_group" "alb" {
  name        = "platform-alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = aws_vpc.platform.id

  tags = {
    Name = "platform-alb-sg"
  }
}

resource "aws_security_group" "eks" {
  name        = "platform-eks-sg"
  description = "Security Group for EKS Worker Nodes"
  vpc_id      = aws_vpc.platform.id

  tags = {
    Name = "platform-eks-sg"
  }
}

resource "aws_security_group" "database" {
  name        = "platform-db-sg"
  description = "Security Group for PostgreSQL Database"
  vpc_id      = aws_vpc.platform.id

  tags = {
    Name = "platform-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  description = "Allow HTTPS from Internet"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_eks" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.eks.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"

  description = "Allow ALB traffic to EKS"
}

resource "aws_vpc_security_group_ingress_rule" "eks_from_alb" {
  security_group_id            = aws_security_group.eks.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"

  description = "Allow HTTPS from ALB"
}

resource "aws_vpc_security_group_egress_rule" "eks_to_database" {
  security_group_id            = aws_security_group.eks.id
  referenced_security_group_id = aws_security_group.database.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"

  description = "Allow PostgreSQL traffic from EKS to database"
}

resource "aws_vpc_security_group_ingress_rule" "database_from_eks" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.eks.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"

  description = "Allow PostgreSQL from EKS"
}