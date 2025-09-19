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
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install OpenJDK 17 from default repository
RUN apt-get update && apt-get install -y openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Install SonarQube CLI (sonar-scanner)
ENV SONAR_SCANNER_VERSION=5.0.1.3006
ENV SONAR_SCANNER_HOME=/opt/sonar-scanner
RUN mkdir -p /opt \
    && wget --no-check-certificate -O /tmp/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip \
    && unzip -q /tmp/sonar-scanner.zip -d /opt/ \
    && mv /opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_SCANNER_HOME} \
    && rm /tmp/sonar-scanner.zip \
    && chmod +x ${SONAR_SCANNER_HOME}/bin/sonar-scanner

# Add SonarQube CLI to PATH
ENV PATH="${SONAR_SCANNER_HOME}/bin:${PATH}"

# Create workspace directory
WORKDIR /workspace

# Copy build scripts
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

# Default command
CMD ["/bin/bash"]