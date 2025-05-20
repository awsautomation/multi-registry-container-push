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