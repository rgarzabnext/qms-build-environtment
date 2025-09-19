#!/bin/bash
# SonarQube analysis script for projects

set -e

echo "Starting SonarQube analysis..."

# Verify SonarQube CLI is available
if ! command -v sonar-scanner &> /dev/null; then
    echo "Error: SonarQube CLI (sonar-scanner) is not available."
    echo "Please ensure the Docker image includes SonarQube CLI installation."
    exit 1
fi

echo "SonarQube CLI version: $(sonar-scanner --version | head -n 1)"

# Check if we have a sonar-project.properties file
if [ ! -f "sonar-project.properties" ]; then
    echo "Warning: sonar-project.properties not found."
    echo "Creating a basic configuration file..."
    
    # Detect project type and generate basic configuration
    PROJECT_NAME=$(basename "$(pwd)")
    
    cat > sonar-project.properties << EOF
# Basic SonarQube project configuration
sonar.projectKey=${PROJECT_NAME}
sonar.projectName=${PROJECT_NAME}
sonar.projectVersion=1.0
sonar.sources=.

# Language and file patterns
EOF

    # Add language-specific configurations
    if [ -f "pom.xml" ]; then
        echo "# Java project detected" >> sonar-project.properties
        echo "sonar.java.source=17" >> sonar-project.properties
        echo "sonar.java.target=17" >> sonar-project.properties
        echo "sonar.java.binaries=target/classes" >> sonar-project.properties
        echo "sonar.exclusions=target/**,**/node_modules/**" >> sonar-project.properties
    elif [ -f "package.json" ]; then
        echo "# Node.js/Angular project detected" >> sonar-project.properties
        echo "sonar.javascript.lcov.reportPaths=coverage/lcov.info" >> sonar-project.properties
        echo "sonar.typescript.lcov.reportPaths=coverage/lcov.info" >> sonar-project.properties
        echo "sonar.exclusions=node_modules/**,dist/**,coverage/**,*.spec.ts,*.spec.js" >> sonar-project.properties
    fi
    
    echo "Generated basic sonar-project.properties file."
    echo "Please customize it according to your SonarQube server configuration."
    echo ""
fi

echo "Current SonarQube configuration:"
cat sonar-project.properties
echo ""

# Check for required SonarQube server configuration
if [ -z "${SONAR_HOST_URL}" ] && ! grep -q "sonar.host.url" sonar-project.properties; then
    echo "Warning: SONAR_HOST_URL environment variable not set and sonar.host.url not found in sonar-project.properties"
    echo "You may need to set SONAR_HOST_URL or add sonar.host.url to your sonar-project.properties file"
fi

if [ -z "${SONAR_TOKEN}" ] && ! grep -q "sonar.token" sonar-project.properties && [ -z "${SONAR_LOGIN}" ]; then
    echo "Warning: No authentication configured."
    echo "Set SONAR_TOKEN environment variable or add sonar.token to sonar-project.properties"
    echo "Alternatively, set SONAR_LOGIN and SONAR_PASSWORD environment variables"
fi

# Run SonarQube analysis
echo "Running SonarQube analysis..."

# Build additional arguments from environment variables
SONAR_ARGS=""
if [ -n "${SONAR_HOST_URL}" ]; then
    SONAR_ARGS="${SONAR_ARGS} -Dsonar.host.url=${SONAR_HOST_URL}"
fi
if [ -n "${SONAR_TOKEN}" ]; then
    SONAR_ARGS="${SONAR_ARGS} -Dsonar.token=${SONAR_TOKEN}"
fi
if [ -n "${SONAR_LOGIN}" ]; then
    SONAR_ARGS="${SONAR_ARGS} -Dsonar.login=${SONAR_LOGIN}"
fi
if [ -n "${SONAR_PASSWORD}" ]; then
    SONAR_ARGS="${SONAR_ARGS} -Dsonar.password=${SONAR_PASSWORD}"
fi

# Execute sonar-scanner with additional arguments
if [ -n "${SONAR_ARGS}" ]; then
    echo "Running: sonar-scanner ${SONAR_ARGS} $@"
    sonar-scanner ${SONAR_ARGS} "$@"
else
    echo "Running: sonar-scanner $@"
    sonar-scanner "$@"
fi

echo "SonarQube analysis completed!"