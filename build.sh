#!/bin/bash

# Build script for chrome-MCP-in-Docker
# This script handles potential network and registry issues

set -e

echo "Building chrome-MCP-in-Docker image..."

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH"
    exit 1
fi

# Build with network host to avoid registry issues in some environments
echo "Attempting to build with network host..."
if docker build --network=host -t mcp-chrome-bridge .; then
    echo "✅ Build successful!"
    echo ""
    echo "You can now run the container with:"
    echo "  docker run -d -p 12306:12306 --name mcp-chrome-bridge mcp-chrome-bridge"
    echo ""
    echo "Or use docker compose:"
    echo "  docker compose up -d"
    echo ""
    echo "The MCP server will be available at http://localhost:12306/mcp"
else
    echo "❌ Build failed. Trying with alternative configuration..."
    
    # Try with different npm registry
    echo "Building with alternative npm configuration..."
    cat > Dockerfile.alt << EOF
FROM node:18-alpine

WORKDIR /app

COPY package.json ./

# Alternative npm configuration for restricted environments
RUN npm config set registry https://registry.npmjs.org/ && \\
    npm config set strict-ssl false && \\
    npm install --no-audit --no-fund

EXPOSE 12306

RUN adduser -D -u 1000 mcpuser && \\
    chown -R mcpuser:mcpuser /app

USER mcpuser

CMD ["npx", "mcp-chrome-bridge", "start", "--host", "0.0.0.0", "--port", "12306"]
EOF

    if docker build -f Dockerfile.alt -t mcp-chrome-bridge .; then
        echo "✅ Build successful with alternative configuration!"
        rm Dockerfile.alt
    else
        echo "❌ Build failed. Please check your network connectivity and Docker setup."
        rm -f Dockerfile.alt
        exit 1
    fi
fi

echo ""
echo "🚀 Ready to use! Check README.md for usage instructions."