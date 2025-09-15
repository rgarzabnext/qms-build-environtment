#!/bin/bash
# Build Maven project and generate WAR file script

set -e

echo "Building Maven project..."

if [ ! -f "pom.xml" ]; then
    echo "Error: pom.xml not found. Make sure you're in a Maven project directory."
    exit 1
fi

# Configure Maven to use insecure repositories for build environments
export MAVEN_OPTS="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true"

# Clean and compile
echo "Cleaning and compiling Maven project..."
mvn clean compile

# Run tests (optional, can be skipped with -DskipTests)
if [ "$1" != "--skip-tests" ]; then
    echo "Running tests..."
    mvn test
fi

# Package WAR file
echo "Packaging WAR file..."
mvn package

echo "Maven build completed successfully!"
echo "WAR files generated in target/ directory:"
find target -name "*.war" -type f