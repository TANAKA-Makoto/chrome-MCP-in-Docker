#!/bin/bash

# Health check script for MCP Chrome Bridge container

set -e

# Check if the MCP server is responding
if curl -f -s "http://localhost:12306/mcp" > /dev/null 2>&1; then
    echo "✅ MCP Chrome Bridge server is healthy"
    exit 0
else
    echo "❌ MCP Chrome Bridge server is not responding"
    exit 1
fi