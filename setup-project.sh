#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Actix Web Project Setup Script${NC}"
echo "=================================="
echo ""

# Get project name
read -p "Enter project name (e.g., my-api, user-service): " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
    echo "Error: Project name cannot be empty"
    exit 1
fi

# Convert project name to different formats
PROJECT_NAME_UNDERSCORE=$(echo "$PROJECT_NAME" | tr '-' '_')
PROJECT_NAME_HYPHEN=$(echo "$PROJECT_NAME" | tr '_' '-')

# Get port
read -p "Enter host port (default: 8083): " HOST_PORT
HOST_PORT=${HOST_PORT:-8083}

# Get domain (optional, defaults to project-name.ernilabs.com)
read -p "Enter domain (default: ${PROJECT_NAME_HYPHEN}.ernilabs.com): " DOMAIN
DOMAIN=${DOMAIN:-${PROJECT_NAME_HYPHEN}.ernilabs.com}

echo ""
echo -e "${YELLOW}Configuration:${NC}"
echo "  Project name: $PROJECT_NAME_HYPHEN"
echo "  Container name: $PROJECT_NAME_UNDERSCORE"
echo "  Host port: $HOST_PORT"
echo "  Domain: $DOMAIN"
echo ""
read -p "Continue with these settings? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Updating files..."

# Update docker-compose.yml
if [ -f "docker-compose.yml" ]; then
    echo "  - Updating docker-compose.yml"
    sed -i.bak \
        -e "s/actix-server:/${PROJECT_NAME_HYPHEN}:/g" \
        -e "s/actix_server/${PROJECT_NAME_UNDERSCORE}/g" \
        -e "s/8083:8080/${HOST_PORT}:8080/g" \
        -e "s/actix\.ernilabs\.com/${DOMAIN}/g" \
        -e "s/actix-server/${PROJECT_NAME_HYPHEN}/g" \
        docker-compose.yml
    rm -f docker-compose.yml.bak
else
    echo "  - Warning: docker-compose.yml not found"
fi

# Update Cargo.toml
if [ -f "Cargo.toml" ]; then
    echo "  - Updating Cargo.toml"
    sed -i.bak \
        -e "s/name = \"actix-server\"/name = \"${PROJECT_NAME_HYPHEN}\"/g" \
        Cargo.toml
    rm -f Cargo.toml.bak
else
    echo "  - Warning: Cargo.toml not found"
fi

# Update Dockerfile
if [ -f "Dockerfile" ]; then
    echo "  - Updating Dockerfile"
    sed -i.bak \
        -e "s/actix-server/${PROJECT_NAME_HYPHEN}/g" \
        Dockerfile
    rm -f Dockerfile.bak
else
    echo "  - Warning: Dockerfile not found"
fi

echo ""
echo -e "${GREEN}✓ Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the changes in docker-compose.yml, Cargo.toml, and Dockerfile"
echo "  2. Update main.rs with your application code"
echo "  3. Run: docker-compose up --build"
echo ""

