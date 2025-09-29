# Makefile for chrome-MCP-in-Docker

# Variables
IMAGE_NAME = mcp-chrome-bridge
CONTAINER_NAME = mcp-chrome-bridge
PORT = 12306

# Default target
.PHONY: help
help: ## Show this help message
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Build the Docker image
.PHONY: build
build: ## Build the Docker image
	docker build -t $(IMAGE_NAME) .

# Run the container
.PHONY: run
run: ## Run the container
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):$(PORT) $(IMAGE_NAME)

# Stop the container
.PHONY: stop
stop: ## Stop the container
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true

# Start with docker-compose
.PHONY: up
up: ## Start with docker-compose
	docker-compose up -d

# Stop with docker-compose
.PHONY: down
down: ## Stop with docker-compose
	docker-compose down

# Show container logs
.PHONY: logs
logs: ## Show container logs
	docker logs -f $(CONTAINER_NAME)

# Show docker-compose logs
.PHONY: logs-compose
logs-compose: ## Show docker-compose logs
	docker-compose logs -f

# Clean up images and containers
.PHONY: clean
clean: stop ## Clean up containers and images
	docker rmi $(IMAGE_NAME) || true

# Restart the container
.PHONY: restart
restart: stop run ## Restart the container

# Check if container is running
.PHONY: status
status: ## Check container status
	docker ps | grep $(CONTAINER_NAME) || echo "Container not running"

# Test the MCP server endpoint
.PHONY: test
test: ## Test the MCP server endpoint
	curl -f http://localhost:$(PORT)/mcp || echo "Server not responding"