# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a polyglot monorepo template designed for modern software development. It provides a flexible foundation for building applications using multiple programming languages and technologies within a single repository structure.

The template emphasizes:
- **Cross-platform development** with consistent tooling across Windows, macOS, and Linux
- **Modular architecture** supporting multiple backend services and frontend applications
- **Automated setup** through intelligent bootstrap scripts
- **Developer experience** with unified tool management and standardized workflows

## Current State

- Polyglot monorepo structure with language-agnostic tooling
- Java backend support with OpenJDK 21 and Gradle
- Development tooling configured (mise for tool management)
- Bootstrap scripts for cross-platform development setup
- Security tooling and compliance setup
- AGPLv3 license compliance

## Architecture

This template uses a **polyglot monorepo architecture** organized by technology domains:

- **`backend/`**: Backend services in various languages (Java, etc.)
- **`frontend/`**: Frontend applications and shared UI components
- **`shared/`**: Common libraries and utilities
- **`scripts/`**: Build, deployment, and bootstrap scripts
- **`docs/`**: Documentation and architectural decisions

### Java Backend Modules

Java backend services follow standard Gradle project structure:

```
backend/{module-name}/
├── build.gradle           # Gradle build configuration
├── src/
│   ├── main/
│   │   ├── java/          # Source code (com.example.{module})
│   │   └── resources/     # Configuration files
│   └── test/
│       ├── java/          # Test code
│       └── resources/     # Test resources
└── README.md
```

## Technology Stack

### Core Tools
- **Tool Management**: mise (unified tool version management)
- **Task Runner**: Custom bootstrap scripts
- **License**: AGPLv3-or-later

### Java Backend
- **Language**: Java (OpenJDK 21)
- **Build System**: Gradle 8.11.1
- **Testing**: JUnit 5 + AssertJ
- **Logging**: SLF4J + Logback

## Development Setup

### Quick Start

```bash
# Bootstrap development environment
./scripts/bootstrap.sh    # Linux/macOS
# or
.\scripts\bootstrap.ps1   # Windows

# The bootstrap process will automatically run all platform-specific scripts in scripts/bootstrap/
```

### Java Backend Development

The template includes Java backend support with an example project:

- **`backend/java-example/`** - Complete Java project demonstrating the template structure
- Bootstrap scripts validate Java development environment and existing projects
- All Java projects use OpenJDK 21 and Gradle 8.11.1

### Project Structure

```
project-template/
├── backend/              # Backend services
│   └── java-example/    # Example Java project with Hello World
├── frontend/            # Frontend applications
├── shared/              # Shared libraries and utilities
├── scripts/             # Build and deployment scripts
│   └── bootstrap/       # Platform-specific bootstrap scripts
├── docs/                # Documentation
└── mise.toml           # Tool version management
```

## Build Commands

### Java Backend Modules

Each Java module supports standard Gradle commands:

```bash
cd backend/java-example

# Build the project
gradle build

# Run the application
gradle run

# Run tests
gradle test

# Clean build artifacts
gradle clean
```

## Key Development Practices

- **Security-first**: All dependencies are audited, AGPLv3 compliant
- **Cross-platform**: Builds for Windows, macOS, Linux
- **Plugin system**: Modular architecture for game-specific extensions
- **Developer Certificate of Origin**: Sign commits with `git commit -s`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes following existing patterns
4. Sign commits with DCO: `git commit -s`
5. Submit a pull request

## License Compliance

SinkChart is licensed under AGPLv3-or-later. All contributions must be compatible with this license. See `docs/COMPLIANCE.md` for details.

## Repository Configuration

- We are using an "ignore everything" gitignore policy with explicit allowlists.