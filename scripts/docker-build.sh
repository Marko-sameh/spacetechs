#!/bin/bash

# Secure Docker build script for Next.js application
set -e

# Load environment variables
if [ -f .env.local ]; then
    export $(cat .env.local | grep -v '^#' | xargs)
fi

# Build the Docker image with build arguments
docker build \
  --build-arg NEXT_PUBLIC_API_BASE_URL="$NEXT_PUBLIC_API_BASE_URL" \
  --build-arg NEXT_PUBLIC_API_KEY="$NEXT_PUBLIC_API_KEY" \
  --build-arg NEXT_PUBLIC_BASE_PATH="$NEXT_PUBLIC_BASE_PATH" \
  -t our-company:latest \
  .

echo "✅ Docker image built successfully!"
echo "🚀 Run with: docker run -p 3000:3000 --env-file .env.local our-company:latest"