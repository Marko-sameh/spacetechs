#!/bin/bash
# Production deployment script with secure environment variable handling

set -e

echo "🔐 Loading environment variables..."
if [ ! -f .env.local ]; then
    echo "❌ .env.local file not found!"
    exit 1
fi

# Load environment variables
export $(cat .env.local | grep -v '^#' | xargs)

echo "🏗️  Building Docker image with public variables..."
docker build \
  --file Dockerfile.secure \
  --build-arg NEXT_PUBLIC_API_BASE_URL="$NEXT_PUBLIC_API_BASE_URL" \
  --build-arg NEXT_PUBLIC_API_KEY="$NEXT_PUBLIC_API_KEY" \
  --build-arg NEXT_PUBLIC_BASE_PATH="$NEXT_PUBLIC_BASE_PATH" \
  --tag our-company:latest \
  .

echo "🚀 Starting container with runtime secrets..."
docker run -d \
  --name our-company-app \
  --restart unless-stopped \
  -p 3000:3000 \
  -e API_KEY="$API_KEY" \
  -e DATABASE_URL="$DATABASE_URL" \
  -e SESSION_SECRET="$SESSION_SECRET" \
  our-company:latest

echo "✅ Deployment complete!"
echo "🌐 Application available at http://localhost:3000"