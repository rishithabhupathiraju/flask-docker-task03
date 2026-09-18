from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify({
        "message": "Student API is running",
        "status": "success"
    })


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy"
    })


@app.route("/students")
def students():
    return jsonify([
        {"id": 1, "name": "Rishitha", "course": "CSE"},
        {"id": 2, "name": "Anjali", "course": "CSE"}
    ])


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
