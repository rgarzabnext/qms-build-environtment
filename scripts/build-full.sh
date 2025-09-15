#!/bin/bash
# Combined build script for projects with both Angular frontend and Maven backend

set -e

echo "Starting combined build process..."

# Configure Maven to use insecure repositories for build environments
export MAVEN_OPTS="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true"

# Build Angular frontend if present
if [ -d "frontend" ] && [ -f "frontend/package.json" ]; then
    echo "Building Angular frontend..."
    cd frontend
    # Install Angular CLI globally if not present
    if ! command -v ng &> /dev/null; then
        echo "Angular CLI not found. Installing..."
        npm install -g @angular/cli@latest
    fi
    npm ci
    npm run build
    cd ..
    echo "Frontend build completed!"
elif [ -f "package.json" ]; then
    echo "Building Angular project in current directory..."
    # Install Angular CLI globally if not present
    if ! command -v ng &> /dev/null; then
        echo "Angular CLI not found. Installing..."
        npm install -g @angular/cli@latest
    fi
    npm ci
    npm run build
    echo "Angular build completed!"
fi

# Build Maven backend if present
if [ -f "pom.xml" ]; then
    echo "Building Maven backend..."
    mvn clean package
    echo "Backend build completed!"
    echo "WAR files generated:"
    find . -name "*.war" -type f
elif [ -d "backend" ] && [ -f "backend/pom.xml" ]; then
    echo "Building Maven backend..."
    cd backend
    mvn clean package
    cd ..
    echo "Backend build completed!"
    echo "WAR files generated:"
    find backend -name "*.war" -type f
fi

echo "Combined build process completed successfully!"