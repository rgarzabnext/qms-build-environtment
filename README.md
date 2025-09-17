# QMS Build Environment

A Docker-based build environment with Maven and Node.js for building Angular projects and generating WAR files.

## Features

- **Java 21 JDK** - Latest long-term support version from Eclipse Temurin
- **Maven 3.8.7** - For building Java projects and generating WAR files
- **Node.js 24.x** - Latest version for Angular builds with npm 11.6.0
- **Angular CLI** - Automatically installed during first Angular build
- **Build Scripts** - Ready-to-use scripts for common build tasks
- **Volume Caching** - Maven and npm caches for faster builds

## Quick Start

### Using Docker Compose (Recommended)

```bash
# Build the image
docker-compose build

# Run an interactive session
docker-compose run --rm qms-build

# Build your project (inside the container)
/scripts/build-full.sh
```

### Using Docker directly

```bash
# Build the image
docker build -t qms-build-env .

# Run interactively with current directory mounted
docker run -it --rm -v $(pwd):/workspace qms-build-env

# Run a specific build command
docker run --rm -v $(pwd):/workspace qms-build-env /scripts/build-maven.sh
```

## Build Scripts

The image includes several pre-built scripts in `/scripts/`:

### `/scripts/build-angular.sh`
Builds Angular projects:
- Installs npm dependencies with `npm ci`
- Runs `npm run build`
- Validates package.json exists

### `/scripts/build-maven.sh`
Builds Maven projects and generates WAR files:
- Cleans and compiles the project
- Runs tests (skip with `--skip-tests` argument)
- Packages into WAR files
- Lists generated WAR files

### `/scripts/build-full.sh`
Combined build for full-stack projects:
- Automatically detects Angular frontend (in `frontend/` or root)
- Automatically detects Maven backend (in `backend/` or root)
- Builds both in the correct order

## Usage Examples

### Angular Project
```bash
# Place your Angular project in the current directory
docker-compose run --rm qms-build /scripts/build-angular.sh
```

### Maven Project
```bash
# Place your Maven project in the current directory
docker-compose run --rm qms-build /scripts/build-maven.sh
```

### Full-stack Project
```bash
# For projects with both frontend/ and backend/ directories
docker-compose run --rm qms-build /scripts/build-full.sh
```

### Custom Commands
```bash
# Run custom Maven commands
docker-compose run --rm qms-build mvn clean install

# Run custom npm commands
docker-compose run --rm qms-build npm run test

# Interactive development
docker-compose run --rm qms-build bash
```

## Project Structure Support

The build environment supports various project structures:

### Separated Frontend/Backend
```
project/
├── frontend/          # Angular project
│   ├── package.json
│   └── src/
└── backend/           # Maven project
    ├── pom.xml
    └── src/
```

### Single Angular Project
```
project/
├── package.json       # Angular project
├── angular.json
└── src/
```

### Single Maven Project
```
project/
├── pom.xml           # Maven project
└── src/
```

## Installed Versions

- **Java**: OpenJDK 21 (Eclipse Temurin LTS)
- **Maven**: 3.8.7
- **Node.js**: 24.x (latest version with npm 11.6.0)
- **Angular CLI**: Latest version (auto-installed)
- **npm**: Bundled with Node.js

## Volume Caching

The docker-compose setup includes volume caching for:
- Maven dependencies (`~/.m2`)
- npm cache (`~/.npm`)

This significantly speeds up subsequent builds.

## Development

### Building the Image
```bash
docker build -t qms-build-env .
```

### Testing the Image
```bash
# Test all installations
docker run --rm qms-build-env bash -c "java -version && mvn -version && node -version && ng version"
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the Docker image builds successfully
5. Submit a pull request

## License

This project is licensed under the MIT License.