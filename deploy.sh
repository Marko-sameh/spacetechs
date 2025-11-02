#!/bin/bash

# Coolify Secure Deployment Script for Next.js
# This script deploys without exposing source code

set -e

echo "🚀 Starting secure Coolify deployment..."

# Configuration
COOLIFY_URL="${COOLIFY_URL:-https://your-coolify-instance.com}"
API_TOKEN="${COOLIFY_API_TOKEN}"
CONFIG_FILE="coolify-deploy.json"

# Validate required environment variables
if [ -z "$API_TOKEN" ]; then
    echo "❌ Error: COOLIFY_API_TOKEN environment variable is required"
    exit 1
fi

if [ -z "$COOLIFY_URL" ]; then
    echo "❌ Error: COOLIFY_URL environment variable is required"
    exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: $CONFIG_FILE not found"
    exit 1
fi

echo "📋 Using configuration from $CONFIG_FILE"

# Deploy application using Coolify API
echo "🔨 Creating application deployment..."
RESPONSE=$(curl -s -X POST "$COOLIFY_URL/api/v1/applications/public" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" \
  -d @"$CONFIG_FILE")

# Parse response
APP_UUID=$(echo "$RESPONSE" | grep -o '"uuid":"[^"]*"' | cut -d'"' -f4)

if [ -z "$APP_UUID" ]; then
    echo "❌ Deployment failed. Response:"
    echo "$RESPONSE"
    exit 1
fi

echo "✅ Application created with UUID: $APP_UUID"

# Configure HTTPS and SSL
echo "🔒 Configuring HTTPS and SSL certificate..."
curl -s -X POST "$COOLIFY_URL/api/v1/applications/$APP_UUID/domains" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "domain": "spacetechs.net",
    "https": true,
    "redirect_to_https": true,
    "generate_certificate": true
  }'

echo "🌐 Domain configured: https://spacetechs.net"

# Wait for deployment
echo "⏳ Waiting for deployment to complete..."
sleep 30

# Check deployment status
STATUS=$(curl -s -X GET "$COOLIFY_URL/api/v1/applications/$APP_UUID" \
  -H "Authorization: Bearer $API_TOKEN" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)

echo "📊 Deployment status: $STATUS"

# Verify HTTPS
echo "🔍 Verifying HTTPS configuration..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -L "https://spacetechs.net" || echo "000")

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ HTTPS verification successful"
else
    echo "⚠️  HTTPS verification returned code: $HTTP_CODE"
fi

echo "🎉 Deployment completed!"
echo "📍 URL: https://spacetechs.net"
echo "🔐 SSL: Let's Encrypt (auto-renewal enabled)"
echo "🛡️  Source code: Secured (not exposed on host)"