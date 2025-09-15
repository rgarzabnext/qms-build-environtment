#!/bin/bash
# Build Angular project script

set -e

echo "Building Angular project..."

if [ ! -f "package.json" ]; then
    echo "Error: package.json not found. Make sure you're in an Angular project directory."
    exit 1
fi

# Install Angular CLI globally if not present
if ! command -v ng &> /dev/null; then
    echo "Angular CLI not found. Installing..."
    npm install -g @angular/cli@latest
fi

# Install dependencies
echo "Installing npm dependencies..."
npm ci

# Build the project
echo "Building Angular project..."
npm run build

echo "Angular build completed successfully!"