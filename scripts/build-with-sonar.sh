#!/bin/bash
# Combined build and SonarQube analysis script

set -e

echo "Starting combined build and SonarQube analysis process..."

# First, run the normal build process
echo "Running standard build process..."
/scripts/build-full.sh

# Then run SonarQube analysis if requested
if [ "$1" = "--with-sonar" ] || [ "${RUN_SONARQUBE}" = "true" ]; then
    echo ""
    echo "Running SonarQube analysis..."
    /scripts/run-sonarqube.sh "${@:2}"
else
    echo ""
    echo "To run SonarQube analysis, use:"
    echo "  /scripts/build-with-sonar.sh --with-sonar"
    echo "  or set RUN_SONARQUBE=true environment variable"
fi

echo "Combined build process completed successfully!"