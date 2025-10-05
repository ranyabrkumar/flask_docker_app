# app/main.py

import os
from flask import Flask, render_template, request
from dotenv import load_dotenv

# Load .env
load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv("SECRET_KEY", "default_key")

@app.route('/', methods=["GET", "POST"])
def home():
    if request.method == "POST":
        username = request.form.get("username")
        return render_template("result.html", username=username)
    return render_template("index.html")
