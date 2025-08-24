#!/bin/bash
set -e

echo "🚀 Starting public pre-deploy bootstrap..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Clean up any existing directories
log_info "Cleaning up existing directories..."
rm -rf /tmp/script
rm -rf /tmp/bequant
log_success "Cleanup completed"

# Set up SSH key for private repo access
if [ -n "$GITHUB_DEPLOY_KEY" ]; then
    log_info "Setting up GitHub deploy key..."
    mkdir -p ~/.ssh
    echo "$GITHUB_DEPLOY_KEY" > ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
    echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts
    log_success "GitHub deploy key configured"
else
    log_error "GITHUB_DEPLOY_KEY environment variable not set!"
    exit 1
fi

# Clone the private repository
log_info "Cloning private repository..."
git clone git@github.com:bequant-dev/forum.git /tmp/bequant

# Run the main pre-deploy script from the private repo
log_info "Running main pre-deploy script..."
chmod +x /tmp/forum/pre-deploy.sh
bash /tmp/forum/pre-deploy.sh

log_success "Public pre-deploy bootstrap completed!" 