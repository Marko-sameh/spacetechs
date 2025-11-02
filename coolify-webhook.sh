#!/bin/bash

# Coolify Webhook Setup Script
# Configures GitHub webhook for automatic deployments

set -e

echo "🔗 Setting up Coolify webhook for automatic deployments..."

# Configuration
GITHUB_REPO="${GITHUB_REPO:-YOUR_USERNAME/our-company}"
COOLIFY_URL="${COOLIFY_URL:-https://your-coolify-instance.com}"
WEBHOOK_SECRET="${WEBHOOK_SECRET}"

if [ -z "$WEBHOOK_SECRET" ]; then
    echo "❌ Error: WEBHOOK_SECRET environment variable is required"
    exit 1
fi

# Webhook URL for GitHub
WEBHOOK_URL="$COOLIFY_URL/webhooks/source/github/events/manual"

echo "📋 Webhook Configuration:"
echo "   Repository: $GITHUB_REPO"
echo "   Webhook URL: $WEBHOOK_URL"
echo "   Events: push, pull_request"

echo ""
echo "🔧 Manual Setup Required:"
echo "1. Go to: https://github.com/$GITHUB_REPO/settings/hooks"
echo "2. Click 'Add webhook'"
echo "3. Set Payload URL: $WEBHOOK_URL"
echo "4. Set Content type: application/json"
echo "5. Set Secret: $WEBHOOK_SECRET"
echo "6. Select events: 'Just the push event'"
echo "7. Ensure 'Active' is checked"
echo "8. Click 'Add webhook'"

echo ""
echo "✅ Webhook setup instructions provided"
echo "🔄 After setup, pushes to main branch will trigger automatic deployments"