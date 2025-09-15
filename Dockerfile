# QMS Build Environment
# Docker image with Maven and Node.js for building Angular projects and WAR files

FROM eclipse-temurin:17-jdk

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies, Node.js, and Maven from Ubuntu repositories
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    nodejs \
    npm \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Create workspace directory
WORKDIR /workspace

# Copy build scripts
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Default command
CMD ["/bin/bash"]