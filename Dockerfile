# Stage 1: Build Frontend
FROM node:18 as builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# NORMALIZATION: Rename output to 'build_output'
RUN if [ -d "dist" ]; then mv dist build_output; else mv build build_output; fi

# Stage 2: Production Setup
FROM node:18-slim
RUN apt-get update && apt-get install -y nginx

WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install
COPY backend/ .

# Copy Frontend Build
COPY --from=builder /app/frontend/build_output /var/www/html/

# Nginx Config
RUN echo 'server { listen 80; location / { root /var/www/html; index index.html index.htm; try_files $uri $uri/ /index.html; } location /api/ { proxy_pass http://127.0.0.1:3000; proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection "upgrade"; proxy_set_header Host $host; proxy_cache_bypass $http_upgrade; } }' > /etc/nginx/sites-available/default

EXPOSE 80
CMD service nginx start && npm start