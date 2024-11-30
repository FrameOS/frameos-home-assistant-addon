ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:latest
FROM $BUILD_FROM

# Set the working directory
WORKDIR /app

# Install necessary packages
RUN apk add --no-cache \
    python3 \
    python3-dev \
    py3-pip \
    nodejs \
    npm \
    git \
    redis \
    build-base \
    libffi-dev \
    openssl-dev \
    curl \
    xz \
    nim

# Clone FrameOS repository
RUN git clone --depth 1 https://github.com/FrameOS/frameos.git /app

# Install Python dependencies
WORKDIR /app/backend
RUN python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install --no-cache-dir -r requirements.txt

# Build the frontend
WORKDIR /app/frontend
RUN npm ci && npm run build

# Clean up frontend build artifacts
RUN rm -rf node_modules && \
    npm cache clean --force

# Build Nim components
WORKDIR /app/frameos
RUN nimble install -d -y && nimble build

# Expose the required port
EXPOSE 8989

# Copy the start script
COPY start.sh /app/backend/docker-start.sh
RUN chmod +x /app/backend/docker-start.sh

# Start the services
CMD [ "bash", "/app/backend/docker-start.sh" ]
