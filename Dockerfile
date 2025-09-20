# QMS Build Environment
# Docker image with Maven and Node.js for building Angular projects and WAR files

# Start with Node.js 24 and add Java 24
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

# Install Eclipse Temurin JDK 24
ENV JAVA_HOME=/usr/lib/jvm/jdk-24
ENV PATH="${JAVA_HOME}/bin:${PATH}"
RUN mkdir -p /usr/lib/jvm \
    && wget -O /tmp/openjdk24.tar.gz https://github.com/adoptium/temurin24-binaries/releases/download/jdk-24.0.2%2B12/OpenJDK24U-jdk_x64_linux_hotspot_24.0.2_12.tar.gz \
    && tar -xzf /tmp/openjdk24.tar.gz -C /usr/lib/jvm \
    && mv /usr/lib/jvm/jdk-24.0.2+12 ${JAVA_HOME} \
    && rm /tmp/openjdk24.tar.gz \
    && update-alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 1 \
    && update-alternatives --install /usr/bin/javac javac ${JAVA_HOME}/bin/javac 1

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