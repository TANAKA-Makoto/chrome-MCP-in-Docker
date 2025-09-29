FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json ./

# Install wget for health checks and install npm packages
RUN apk add --no-cache wget && \
    npm install

# Expose the HTTP port for MCP server
EXPOSE 12306

# Create a non-root user for security
RUN adduser -D -u 1000 mcpuser && \
    chown -R mcpuser:mcpuser /app

USER mcpuser

# Default command to start the MCP bridge server
CMD ["npx", "mcp-chrome-bridge", "start", "--host", "0.0.0.0", "--port", "12306"]