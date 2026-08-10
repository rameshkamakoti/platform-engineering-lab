from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify(
        service="payment-api",
        version="v2",
        status="running"
    )

@app.route("/health")
def health():
    return jsonify(
    status="healthy",
    version="v2"
), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
