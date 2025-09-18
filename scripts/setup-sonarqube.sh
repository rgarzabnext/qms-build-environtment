#!/bin/bash
# Install SonarQube CLI (sonar-scanner) script

set -e

echo "Setting up SonarQube CLI..."

# Check if sonar-scanner is already installed
if command -v sonar-scanner &> /dev/null; then
    echo "SonarQube CLI is already installed."
    sonar-scanner --version
    exit 0
fi

# Install SonarQube CLI
echo "Installing SonarQube CLI version ${SONAR_SCANNER_VERSION}..."

# Create installation directory
mkdir -p /opt

# Download and install SonarQube CLI
wget -O /tmp/sonar-scanner.zip "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip"
unzip -q /tmp/sonar-scanner.zip -d /opt/
mv "/opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux" "${SONAR_SCANNER_HOME}"
rm /tmp/sonar-scanner.zip
chmod +x "${SONAR_SCANNER_HOME}/bin/sonar-scanner"

echo "SonarQube CLI installed successfully!"
echo "Version: $(sonar-scanner --version)"