#!/bin/bash
set -euo pipefail

# Java Backend Bootstrap Script
# Sets up Java development environment and validates existing Java projects

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
log_step() { echo -e "${CYAN}🔧 $1${NC}"; }

echo -e "${GREEN}☕ Setting up Java development environment...${NC}"

# Verify Java and Gradle are available
log_step "Verifying Java and Gradle installation..."

if ! command -v java &> /dev/null; then
    log_error "Java not found. Ensure 'mise install' has been run."
    exit 1
fi

if ! command -v gradle &> /dev/null; then
    log_error "Gradle not found. Ensure 'mise install' has been run."
    exit 1
fi

java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
gradle_version=$(gradle --version | grep "Gradle" | cut -d' ' -f2)

log_success "Java $java_version detected"
log_success "Gradle $gradle_version detected"

# Check for Java backend projects and validate them
log_step "Checking Java backend projects..."

java_projects_found=0

for project_dir in "$PROJECT_ROOT/backend"/*; do
    if [[ -d "$project_dir" && -f "$project_dir/build.gradle" ]]; then
        project_name=$(basename "$project_dir")
        log_info "Found Java project: $project_name"
        
        # Test if the project builds
        cd "$project_dir"
        if gradle build --quiet; then
            log_success "✓ $project_name builds successfully"
        else
            log_warning "⚠ $project_name has build issues"
        fi
        
        ((java_projects_found++))
    fi
done

cd "$PROJECT_ROOT"

if [[ $java_projects_found -eq 0 ]]; then
    log_warning "No Java projects found in backend/ directory"
    log_info "Java development environment is ready for new projects"
else
    log_success "Found and validated $java_projects_found Java project(s)"
fi

echo ""
log_success "Java development environment setup complete!"
echo ""
log_info "Available commands for Java projects:"
echo "  gradle build    # Build the project"
echo "  gradle run      # Run the application"
echo "  gradle test     # Run tests"
echo "  gradle clean    # Clean build artifacts"