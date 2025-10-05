# Dockerfile
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