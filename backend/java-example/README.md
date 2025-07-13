# Java Example Backend

A simple Java backend service demonstrating the project template structure with OpenJDK 21 and Gradle.

## Structure

```
java-example/
├── build.gradle           # Gradle build configuration
├── src/
│   ├── main/
│   │   ├── java/          # Source code
│   │   │   └── com/example/javaexample/
│   │   │       ├── Application.java      # Main application
│   │   │       └── GreetingService.java  # Example service
│   │   └── resources/     # Configuration files
│   │       └── logback.xml # Logging configuration
│   └── test/
│       ├── java/          # Test code
│       │   └── com/example/javaexample/
│       │       └── GreetingServiceTest.java
│       └── resources/     # Test resources
└── README.md
```

## Quick Start

```bash
# Build the project
gradle build

# Run the application
gradle run

# Run tests
gradle test

# Clean build artifacts
gradle clean
```

## Features

- **Java 21** - Latest LTS version of OpenJDK
- **Gradle 8.11.1** - Modern build system
- **JUnit 5** - Latest testing framework
- **AssertJ** - Fluent assertion library
- **SLF4J + Logback** - Professional logging
- **UTF-8 encoding** - Consistent character encoding

## Development

The example includes:

- `Application.java` - Main entry point with Hello World example
- `GreetingService.java` - Example service class with business logic
- `GreetingServiceTest.java` - Comprehensive unit tests
- Proper logging configuration with different levels
- Standard Gradle project structure

## Testing

Tests use JUnit 5 and AssertJ for fluent assertions:

```bash
gradle test
```

The test suite demonstrates:
- Given-When-Then test structure
- Edge case testing (null/empty inputs)
- Comprehensive coverage of service methods