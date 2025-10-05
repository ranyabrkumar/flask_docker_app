# Flask Docker App

This is a simple Flask application designed to be dockerized in later lessons.

# Navigate to project directory
cd flask_docker_app

# Create virtual environment (optional but recommended)
python3 -m venv venv
source venv/bin/activate    # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the app
python app/main.py

# Docker installation steps:

### Update the System:
```
sudo apt update && sudo apt upgrade -y
```

### Install Prerequisites:

```
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg \
    lsb-release -y
```

### Add Docker's Official GPG Key

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

###   Install Docker:
```
sudo apt update\nsudo apt install docker-ce docker-ce-cli containerd.io -y
```

### Add Your User to the Docker Group :

```
sudo usermod -aG docker $USER
```
#### Note: This allows you to run Docker without using 'sudo'. You must log out and log back in, or run the following command to apply the new group permissions:

### Enable and Start Docker:

```
sudo systemctl enable docker
sudo systemctl start docker
```

### Test Docker:

```
docker --version
docker run hello-world
```
# Step 1: Create Dockerfile in the Root
```
# Use official Python image
FROM python:3.11-slim
# Set working directory
WORKDIR /app
# Copy dependency file
COPY app/requirements.txt .
# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt
# Copy source code
COPY ./app ./app
# Set environment variables
ENV FLASK_APP=app/main.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=development
# Expose the port
EXPOSE 5000
# Run the application
CMD ["flask", "run"]
```

# Create .dockerignore
```
venv/
__pycache__/
*.pyc
*.pyo
*.pyd
*.log
.DS_Store
.env
```
# Build the Docker Image
```
docker build -t flask-docker-app .
```

# Run the Container
```
docker run -p 8000:8000 flask-docker-app
```
<img width="1673" height="395" alt="image" src="https://github.com/user-attachments/assets/e8cb0fc0-5245-47af-9fc1-692bcf292205" />

# Use Environment Variables for Configuration
## Rebuild image
```docker build -t flask-docker-app .```

<img width="1210" height="574" alt="image" src="https://github.com/user-attachments/assets/dfe156ae-a58f-4456-a56d-e7cf7da527d1" />

## Run container with .env variables passed in
```docker run -d --env-file .env -p 80:5000 flask-docker-app```
# Docker Compose Integration
## Update main.py to Handle Form Input
```
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
```
## Update index.html with a Form
```
<!-- app/templates/index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Flask Form</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Enter Your Name</h1>
        <form method="POST">
            <input type="text" name="username" placeholder="Your name" required>
            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>
```
## Create result.html to Show Form Output
```
<!-- app/templates/result.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Result</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Hello, {{ username }}! 👋</h1>
        <a href="/">Go Back</a>
    </div>
</body>
</html>
```    

## Create docker-compose.yml
```
version: '3.8'

services:
  web:
    build: .
    container_name: flask_app
    ports:
      - "80:5000"
    env_file:
      - .env
    restart: unless-stopped
```

```docker compose up --build -d```
<img width="1420" height="412" alt="image" src="https://github.com/user-attachments/assets/7f4804dc-1b31-4c74-8725-c6e90a9203dd" />
