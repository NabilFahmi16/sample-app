#!/usr/bin/env python3
from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def main():
    return render_template("index.html")

if __name__ == "__main__":
    # Listen on ALL interfaces, port 5050
    app.run(host="0.0.0.0", port=5050)