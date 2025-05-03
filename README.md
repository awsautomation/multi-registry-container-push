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

---

## ⚙️ Setup Instructions

### 1. 🔑 Configure GitHub Secrets

Go to your repo → **Settings** → **Secrets and Variables** → **Actions**, and add:

| Name                    | Description                              |
|-------------------------|------------------------------------------|
| `AWS_ACCESS_KEY_ID`     | From AWS IAM user                        |
| `AWS_SECRET_ACCESS_KEY` | From AWS IAM user                        |
| `ECR_REGISTRY`          | e.g., `123456789012.dkr.ecr.ap-southeast-2.amazonaws.com` |
| `ECR_REPOSITORY`        | e.g., `my-app`                           |
| `DOCKER_USERNAME`       | Docker Hub username                      |
| `DOCKER_PASSWORD`       | Docker Hub access token or password      |
| `DOCKER_REPOSITORY`     | e.g., `yourdockerhubuser/my-app`         |

---

### 2. 🧪 Sample Dockerfile

```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
