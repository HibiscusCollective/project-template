#!/bin/bash
set -euo pipefail

# Project Bootstrap Script
# Auto-detects project type and sets up development environment

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

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

echo -e "${GREEN}🚀 Auto-detecting and bootstrapping development environment...${NC}"

# Check platform support
case "$(uname)" in
    "Linux"|"Darwin")
        log_success "Detected $(uname) - supported platform"
        ;;
    *)
        log_error "Unsupported platform: $(uname)"
        echo "This script supports Linux and macOS only."
        echo "For Windows, use bootstrap.ps1"
        exit 1
        ;;
esac

# Core setup function
setup_core() {
    log_step "Setting up core tools (mise + GitHub token)..."
    local mise_script="$SCRIPT_DIR/bootstrap/mise.sh"
    
    if [[ -f "$mise_script" ]]; then
        source "$mise_script"
    else
        log_warning "Core mise setup script not found, using built-in setup"
        
        # Install mise if not present
        if ! command -v mise &> /dev/null; then
            log_step "Installing mise..."
            curl https://mise.run | sh
            export PATH="$HOME/.local/bin:$PATH"
            
            # Add to shell profile
            case "$SHELL" in
                */bash) echo 'eval "$(mise activate bash)"' >> ~/.bashrc ;;
                */zsh) echo 'eval "$(mise activate zsh)"' >> ~/.zshrc ;;
                */fish) echo 'mise activate fish | source' >> ~/.config/fish/config.fish ;;
            esac
        fi
        
        # Install tools first (including gh CLI)
        cd "$PROJECT_ROOT"
        mise install
        
        # Setup GitHub token using gh CLI
        log_step "Setting up GitHub token for API rate limits..."
        if [[ ! -f "$PROJECT_ROOT/mise.local.toml" ]]; then
            # Ensure gh is available
            if ! command -v gh &> /dev/null; then
                log_error "gh CLI not found. Please ensure it's defined in mise.toml"
                log_warning "Skipping GitHub token setup - you may hit API rate limits"
            else
                # Check if user is already authenticated
                if gh auth status &> /dev/null; then
                    log_step "Getting GitHub token from gh CLI..."
                    github_token=$(gh auth token 2>/dev/null)
                    
                    if [[ -n "$github_token" ]]; then
                        cat > "$PROJECT_ROOT/mise.local.toml" << EOF
[env]
GITHUB_TOKEN = "$github_token"
EOF
                        log_success "GitHub token configured from gh CLI in mise.local.toml"
                    else
                        log_warning "Failed to get GitHub token from gh CLI, falling back to manual entry"
                        read -p "Enter GitHub token manually (no permissions needed, just for API rate limits): " -s github_token
                        echo
                        if [[ -n "$github_token" ]]; then
                            cat > "$PROJECT_ROOT/mise.local.toml" << EOF
[env]
GITHUB_TOKEN = "$github_token"
EOF
                            log_success "GitHub token configured manually in mise.local.toml"
                        else
                            log_warning "No GitHub token provided - you may hit API rate limits"
                        fi
                    fi
                else
                    log_step "GitHub CLI not authenticated. Choose an option:"
                    echo "1. Authenticate with gh CLI (run: gh auth login)"
                    echo "2. Enter token manually"
                    read -p "Enter choice (1/2): " -n 1 -r
                    echo
                    
                    if [[ $REPLY == "2" ]]; then
                        read -p "Enter GitHub token (no permissions needed, just for API rate limits): " -s github_token
                        echo
                        if [[ -n "$github_token" ]]; then
                            cat > "$PROJECT_ROOT/mise.local.toml" << EOF
[env]
GITHUB_TOKEN = "$github_token"
EOF
                            log_success "GitHub token configured manually in mise.local.toml"
                        else
                            log_warning "No GitHub token provided - you may hit API rate limits"
                        fi
                    else
                        log_warning "Please run 'gh auth login' and re-run this script"
                        log_warning "Skipping GitHub token setup - you may hit API rate limits"
                    fi
                fi
            fi
        else
            log_success "GitHub token already configured in mise.local.toml"
        fi
    fi
}

# Run all platform-specific bootstrap scripts
run_bootstrap_scripts() {
    log_step "Running all bootstrap scripts for this platform..."
    
    local bootstrap_dir="$SCRIPT_DIR/bootstrap"
    local script_count=0
    
    # Check if bootstrap directory exists
    if [[ ! -d "$bootstrap_dir" ]]; then
        log_warning "Bootstrap directory not found at $bootstrap_dir"
        return 0
    fi
    
    # Run all .sh scripts in the bootstrap directory
    for script in "$bootstrap_dir"/*.sh; do
        # Check if glob matched any files
        if [[ ! -f "$script" ]]; then
            continue
        fi
        
        local script_name=$(basename "$script")
        log_step "Running bootstrap script: $script_name"
        
        if [[ -x "$script" ]]; then
            source "$script"
        else
            log_warning "Script $script_name is not executable, sourcing anyway..."
            source "$script"
        fi
        
        ((script_count++))
    done
    
    if [[ $script_count -eq 0 ]]; then
        log_info "No .sh bootstrap scripts found in $bootstrap_dir"
    else
        log_success "Executed $script_count bootstrap script(s)"
    fi
}

# Main execution
main() {
    setup_core
    run_bootstrap_scripts
    
    # Verify installation
    log_step "Verifying installation..."
    command -v mise && mise --version
    
    echo ""
    log_success "Bootstrap completed successfully!"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo "1. Reload your shell: source ~/.bashrc (or ~/.zshrc)"
    echo "2. Run project-specific commands (check README.md)"
    echo ""
}

main "$@"