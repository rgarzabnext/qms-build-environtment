# QMS Build Environment
# Docker image with Maven and Node.js for building Angular projects and WAR files

# Start with Node.js 24 and add Java 21
FROM node:24

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Configure npm to use secure HTTPS registry
RUN npm config set registry https://registry.npmjs.org/

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Eclipse Temurin Java 21 from Adoptium repository
RUN wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add - || true \
    && echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list || true \
    && apt-get update || true \
    && apt-get install -y temurin-21-jdk || apt-get install -y openjdk-21-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Create workspace directory
WORKDIR /workspace

# Copy build scripts
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Default command
CMD ["/bin/bash"]