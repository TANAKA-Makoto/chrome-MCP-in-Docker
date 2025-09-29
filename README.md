# chrome-MCP-in-Docker

Docker containerization for [mcp-chrome-bridge](https://github.com/hangwin/mcp-chrome) - MCP (Model Context Protocol) server that enables AI assistants to control Chrome browser through extensions.

## Overview

This Docker image packages the `mcp-chrome-bridge` npm package into a container, allowing you to run the MCP server in a containerized environment while connecting to Chrome extensions running on the host system.

## Features

- ✅ Containerized MCP Chrome Bridge server
- 🌐 HTTP connection support on port 12306
- 🔒 Secure non-root user execution
- 🐳 Easy deployment with Docker Compose
- 🔌 Host Chrome extension connectivity

## Prerequisites

- Docker and Docker Compose installed
- Chrome/Chromium browser with MCP Chrome extension installed on host
- [Chrome MCP Extension](https://github.com/hangwin/mcp-chrome/releases) downloaded and installed

## Quick Start

### Method 1: Using the Build Script (Recommended)

1. Clone this repository:
```bash
git clone https://github.com/TANAKA-Makoto/chrome-MCP-in-Docker.git
cd chrome-MCP-in-Docker
```

2. Run the build script:
```bash
./build.sh
```

3. Start the container:
```bash
docker-compose up -d
```

4. The MCP server will be available at `http://localhost:12306/mcp`

### Method 2: Using Docker Compose

```bash
# Build and start
docker-compose up -d --build

# Check logs
docker-compose logs -f
```

### Method 3: Using Docker directly

```bash
# Build the image
docker build -t mcp-chrome-bridge .

# Run the container
docker run -d -p 12306:12306 --name mcp-chrome-bridge mcp-chrome-bridge
```

### Method 4: Using Makefile

```bash
# Build the image
make build

# Start the container
make run

# Check status
make status

# View logs
make logs
```

> **Note**: If you encounter network or certificate issues during build, the `build.sh` script includes fallback configurations to handle restricted environments.

## Chrome Extension Setup

1. Download the latest Chrome extension from the [releases page](https://github.com/hangwin/mcp-chrome/releases)

2. Install the extension in Chrome:
   - Open Chrome and go to `chrome://extensions/`
   - Enable "Developer mode"
   - Click "Load unpacked" and select the downloaded extension folder

3. Configure the extension to connect to the containerized MCP server:
   - Click the extension icon
   - Set the connection URL to: `http://localhost:12306/mcp`
   - Click "Connect"

## MCP Client Configuration

Configure your MCP client (like Claude Desktop, CherryStudio, etc.) to connect to the containerized server:

### Streamable HTTP Connection (Recommended)
```json
{
  "mcpServers": {
    "chrome-mcp-server": {
      "type": "streamableHttp",
      "url": "http://localhost:12306/mcp"
    }
  }
}
```

### STDIO Connection (Alternative)
For clients that only support stdio, you can execute commands directly in the container:
```bash
docker exec -it mcp-chrome-bridge mcp-chrome-stdio
```

## Network Configuration

The container exposes port 12306 and uses bridge networking to allow communication with the host Chrome browser. The Chrome extension running on the host can connect to the containerized MCP server through this port.

## Available Tools

The containerized MCP server provides the same tools as the native installation:
- Browser tab management
- Screenshots and visual capture
- Network monitoring
- Content analysis and semantic search
- Interactive element control
- Bookmark and history management

For complete tool documentation, see: [Tools Documentation](https://github.com/hangwin/mcp-chrome/docs/TOOLS.md)

## Troubleshooting

### Build Issues

#### Certificate/Network Errors
If you encounter SSL certificate or network errors during build:

1. Use the build script which includes fallback configurations:
   ```bash
   ./build.sh
   ```

2. Or manually configure npm during build:
   ```bash
   docker build --build-arg NPM_CONFIG_STRICT_SSL=false -t mcp-chrome-bridge .
   ```

3. For corporate networks, you may need to configure proxy settings:
   ```bash
   docker build --build-arg HTTP_PROXY=your-proxy --build-arg HTTPS_PROXY=your-proxy -t mcp-chrome-bridge .
   ```

### Connection Issues
- Ensure the container is running: `docker-compose ps`
- Check if port 12306 is accessible: `curl http://localhost:12306/mcp`
- Verify Chrome extension is installed and configured correctly
- Check container logs: `docker-compose logs -f mcp-chrome-bridge`

### Container Logs
View container logs for debugging:
```bash
# Using docker-compose
docker-compose logs -f mcp-chrome-bridge

# Using docker directly
docker logs -f mcp-chrome-bridge

# Using Makefile
make logs
```

### Health Check
Test if the MCP server is running:
```bash
# Using the health check script
./healthcheck.sh

# Using curl directly
curl -f http://localhost:12306/mcp

# Using Makefile
make test
```

### Rebuilding
If you need to rebuild the container:
```bash
# Using docker-compose
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Using Makefile
make clean
make build
make run
```

## Available Commands

### Makefile Commands
```bash
make help           # Show available commands
make build          # Build the Docker image
make run            # Run the container
make stop           # Stop the container
make up             # Start with docker-compose
make down           # Stop with docker-compose
make logs           # Show container logs
make logs-compose   # Show docker-compose logs
make clean          # Clean up containers and images
make restart        # Restart the container
make status         # Check container status
make test           # Test the MCP server endpoint
```

### Docker Compose Commands
```bash
docker-compose up -d              # Start in background
docker-compose up --build         # Build and start
docker-compose down               # Stop and remove containers
docker-compose logs -f            # Follow logs
docker-compose ps                 # Show running containers
docker-compose restart            # Restart services
```

### Direct Docker Commands
```bash
docker build -t mcp-chrome-bridge .                    # Build image
docker run -d -p 12306:12306 mcp-chrome-bridge        # Run container
docker ps                                              # List containers
docker logs mcp-chrome-bridge                         # View logs
docker stop mcp-chrome-bridge                         # Stop container
docker rm mcp-chrome-bridge                           # Remove container
```

## License

This project is licensed under the MIT License - see the original [mcp-chrome project](https://github.com/hangwin/mcp-chrome) for details.

## Related Projects

- [mcp-chrome](https://github.com/hangwin/mcp-chrome) - Original MCP Chrome Bridge project
- [Model Context Protocol](https://modelcontextprotocol.io/) - MCP specification