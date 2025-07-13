# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SinkChart is a plugin-based map management tool designed specifically for video game exploration. It is an alternative to pre-populated maps that spoil the exploration experience.
It enables players to create, annotate and share game maps with unprecedented ease and precision. The platform addresses a critical gap in the gaming ecosystem by providing a clean, 
intuitive interface where players can load blank game maps and enhance them with custom pins, detailed notes, and strategic annotations that can be saved locally and shared with others using a lightweight file format. 

The core strength of SinkChart lies in its modular, plugin-based architecture that allows game-specific customization while maintaining a unified user experience across all supported titles.
Each plugin can provide base maps for specific games along with tailored annotation types—whether that's marking loot spawns in survival games, 
documenting raid strategies in MMORPGs, or sharing exploration discoveries in open-world adventures. 
This approach ensures that SinkChart scales organically with the gaming community's needs while providing developers and content creators with the flexibility to extend functionality for emerging games and evolving player requirements.

## Current State

- Initial workspace structure created with Cargo workspace
- Basic crate structure for core, ui, tauri-app, plugins, common, and integrations
- Development tooling configured (mise, mask, clippy, rustfmt)
- Security tooling configured (cargo-audit, cargo-deny)
- AGPLv3 license compliance setup
- Bootstrap scripts for cross-platform development setup

## Architecture

SinkChart uses a **vertical slice architecture** with selective crate boundaries organized as a Cargo workspace:

- **`sinkchart-core`**: Core business logic, map management, annotation system
- **`sinkchart-ui`**: Dioxus UI components and layout management  
- **`sinkchart-tauri-app`**: Tauri application shell and main entry point
- **`sinkchart-common`**: Shared utilities, error handling, configuration
- **`sinkchart-plugins`**: Plugin system and dynamic loading
- **`sinkchart-integrations`**: External integrations (export/import, sync)

## Technology Stack

- **Language**: Rust (stable toolchain)
- **UI Framework**: Dioxus 0.6
- **Desktop Framework**: Tauri 2.0
- **Build System**: Cargo workspace
- **Task Runner**: Mask (markdown-based)
- **Tool Management**: mise
- **License**: AGPLv3-or-later

## Development Setup

### Quick Start

```bash
# Bootstrap development environment
./scripts/bootstrap.sh    # Linux/macOS
# or
.\scripts\bootstrap.ps1   # Windows

# Common development commands
mask build    # Build the project
mask dev      # Run development server
mask test     # Run tests
mask lint     # Run clippy linter
mask fmt      # Format code
mask audit    # Security audit
```

### Project Structure

```
sinkchart/
├── crates/               # Rust crates
│   ├── core/            # Core business logic
│   ├── ui/              # Dioxus UI components
│   ├── tauri-app/       # Tauri application shell
│   ├── plugins/         # Plugin system
│   ├── common/          # Shared utilities
│   └── integrations/    # External integrations
├── scripts/             # Build and deployment scripts
├── docs/                # Documentation
└── assets/              # Application assets
```

## Build Commands

- **Development**: `mask dev` - Runs the Tauri development server
- **Build**: `mask build` - Builds release version
- **Test**: `mask test` - Runs all tests in workspace
- **Lint**: `mask lint` - Runs clippy with strict settings
- **Format**: `mask fmt` - Formats all code
- **Audit**: `mask audit` - Security vulnerability scanning

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