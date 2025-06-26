# multi-registry-container-push
This project demonstrates a complete CI/CD pipeline using GitHub Actions to build a Docker image from source code and push it to both Amazon ECR and Docker Hub. It showcases a practical example of automating Docker workflows for multi-registry deployments using GitHub-hosted runners.

# 🚀 Docker CI/CD with GitHub Actions

This project demonstrates how to use **GitHub Actions** to build a Docker image and push it to **Amazon ECR** and **Docker Hub** automatically on every push to the `main` branch.

---

## 📦 What It Does

- Builds a Docker image using the project's `Dockerfile`
- Pushes the image to:
  - 🐳 Docker Hub
  - 🧊 Amazon Elastic Container Registry (ECR)
- Uses **GitHub Actions** for continuous integration and deployment

---

## 🛠️ Tech Stack

- Docker
- GitHub Actions
- Amazon ECR
- Docker Hub
- AWS CLI
- Azure

---

## ⚙️ Setup Instructions

### 1. 🔑 Configure GitHub Secrets

Go to your repo → **Settings** → **Secrets and Variables** → **Actions**, and add:

| Secret Name             | Description                                                              |
| ----------------------- | ------------------------------------------------------------------------ |
| `DOCKER_USERNAME`       | Docker Hub username                                                      |
| `DOCKER_PASSWORD`       | Docker Hub password or token                                             |
| `DOCKER_REPOSITORY`     | Docker Hub repo (e.g., `yourname/py-app`)                                |
| `AWS_ACCESS_KEY_ID`     | AWS access key                                                           |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key                                                           |
| `ECR_REGISTRY`          | ECR registry URL (e.g., `123456789012.dkr.ecr.ap-south-1.amazonaws.com`) |
| `ECR_REPOSITORY`        | ECR repo name (e.g., `py-app`)                                           |
| `AZURE_CLIENT_ID`       | Azure SP client ID                                                       |
| `AZURE_CLIENT_SECRET`   | Azure SP client secret                                                   |
| `AZURE_TENANT_ID`       | Azure tenant ID                                                          |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID                                                    |
| `ACR_NAME`              | Azure Container Registry name (without domain, e.g., `myregistry`)       |
| `APP_SERVICE_NAME`      | Name of the Azure App Service (e.g., `myapp-service`)                    |

---


### 2. 🧪 Sample Dockerfile

```dockerfile
# Stage 1: Build Python dependencies
FROM python:3.11-slim as builder
WORKDIR /app
COPY app/requirements.txt .
RUN pip install --user -r requirements.txt

# Stage 2: Final image with Python app and NGINX
FROM python:3.11-slim
WORKDIR /app

# Copy installed packages
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Copy source code
COPY app/ ./app
COPY app/wsgi.py .

# Copy and configure NGINX
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
RUN apt-get update && apt-get install -y nginx && apt-get clean

# Expose ports
EXPOSE 80

# Start both NGINX and the app using a shell script
CMD ["sh", "-c", "uvicorn app.wsgi:app --host 0.0.0.0 --port 8000 & nginx -g 'daemon off;'"]
