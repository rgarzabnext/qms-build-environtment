# QMS Build Environment

A Docker-based build environment with Maven and Node.js for building Angular projects and generating WAR files.

## Features

- **Java 17 JDK** - OpenJDK 17 for building Java projects
- **Maven 3.8.7** - For building Java projects and generating WAR files
- **Node.js 24.x** - Latest version for Angular builds with npm 11.6.0
- **Angular CLI** - Automatically installed during first Angular build
- **SonarQube CLI** - Code quality analysis with on-demand installation
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

### `/scripts/setup-sonarqube.sh`
Sets up SonarQube CLI (sonar-scanner):
- Downloads and installs the latest SonarQube CLI
- Configures environment for code quality analysis
- Only needs to be run once per container

### `/scripts/run-sonarqube.sh`
Runs SonarQube code analysis:
- Automatically installs SonarQube CLI if not present
- Generates basic configuration if `sonar-project.properties` not found
- Supports both Java and Node.js/Angular projects
- Uses environment variables for SonarQube server configuration

### `/scripts/build-with-sonar.sh`
Combined build and SonarQube analysis:
- Runs the standard build process first
- Optionally runs SonarQube analysis with `--with-sonar` flag
- Can be controlled by `RUN_SONARQUBE=true` environment variable

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

### SonarQube Analysis
```bash
# Setup SonarQube CLI (one-time setup)
docker-compose run --rm qms-build /scripts/setup-sonarqube.sh

# Run SonarQube analysis on any project
docker-compose run --rm qms-build /scripts/run-sonarqube.sh

# Build and analyze in one command
docker-compose run --rm qms-build /scripts/build-with-sonar.sh --with-sonar

# With environment variables for SonarQube server
docker-compose run --rm \
  -e SONAR_HOST_URL=https://your-sonarqube-server.com \
  -e SONAR_TOKEN=your-auth-token \
  qms-build /scripts/run-sonarqube.sh

# For projects with existing sonar-project.properties
docker-compose run --rm qms-build /scripts/run-sonarqube.sh
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

- **Java**: OpenJDK 17
- **Maven**: 3.8.7
- **Node.js**: 24.x (latest version with npm 11.6.0)
- **Angular CLI**: Latest version (auto-installed)
- **SonarQube CLI**: 5.0.1.3006 (auto-installed on demand)
- **npm**: Bundled with Node.js

## Volume Caching

The docker-compose setup includes volume caching for:
- Maven dependencies (`~/.m2`)
- npm cache (`~/.npm`)

This significantly speeds up subsequent builds.

## SonarQube Configuration

### Environment Variables

The SonarQube CLI can be configured using environment variables:

- `SONAR_HOST_URL`: SonarQube server URL (e.g., `https://sonarcloud.io`)
- `SONAR_TOKEN`: Authentication token for SonarQube server
- `SONAR_LOGIN`: Username for SonarQube authentication (alternative to token)
- `SONAR_PASSWORD`: Password for SonarQube authentication (used with SONAR_LOGIN)

### Configuration File

Create a `sonar-project.properties` file in your project root:

```properties
# Required settings
sonar.projectKey=my-project-key
sonar.projectName=My Project
sonar.projectVersion=1.0

# Source directories
sonar.sources=.
sonar.exclusions=target/**,node_modules/**,dist/**,coverage/**

# For Java projects
sonar.java.source=17
sonar.java.target=17
sonar.java.binaries=target/classes

# For TypeScript/Angular projects
sonar.typescript.lcov.reportPaths=coverage/lcov.info
```

If no configuration file exists, the script will generate a basic one automatically.

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