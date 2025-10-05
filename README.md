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
docker run -p 5000:5000 flask-docker-app
```
