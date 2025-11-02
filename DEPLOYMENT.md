# Secure Coolify Deployment Guide

## Overview
This guide provides step-by-step instructions for deploying the Next.js application securely using Coolify without exposing source code.

## Prerequisites
- Coolify instance running and accessible
- GitHub repository with the source code
- Domain `spacetechs.net` pointing to your Coolify server
- Coolify API token

## Files Created
- `Dockerfile` - Multi-stage build for secure deployment
- `.dockerignore` - Excludes unnecessary files from build
- `coolify-deploy.json` - Deployment configuration
- `deploy.sh` - Automated deployment script
- `.env.production` - Production environment variables
- `coolify-webhook.sh` - Webhook setup script

## Deployment Steps

### 1. Update Configuration
Edit `coolify-deploy.json` with your actual values:
```json
{
  "project_uuid": "your-actual-project-uuid",
  "server_uuid": "your-actual-server-uuid",
  "destination_uuid": "your-actual-destination-uuid",
  "git_repository": "https://github.com/yourusername/our-company"
}
```

### 2. Set Environment Variables
```bash
export COOLIFY_URL="https://your-coolify-instance.com"
export COOLIFY_API_TOKEN="your-api-token"
export WEBHOOK_SECRET="your-webhook-secret"
```

### 3. Deploy Application
```bash
chmod +x deploy.sh
./deploy.sh
```

### 4. Setup Automatic Deployments
```bash
chmod +x coolify-webhook.sh
./coolify-webhook.sh
```

## Security Features

### Source Code Protection
- Multi-stage Docker build removes source files
- Only production artifacts are included in final image
- No source code cloned to host system

### HTTPS Configuration
- Automatic Let's Encrypt SSL certificate
- HTTP to HTTPS redirect enforced
- Security headers enabled

### Environment Security
- Production environment variables isolated
- Sensitive data managed through Coolify UI
- No hardcoded secrets in repository

## Verification Steps

### 1. Check Deployment Status
```bash
curl -H "Authorization: Bearer $COOLIFY_API_TOKEN" \
     "$COOLIFY_URL/api/v1/applications/$APP_UUID"
```

### 2. Verify HTTPS
```bash
curl -I https://spacetechs.net
```

### 3. Check SSL Certificate
```bash
openssl s_client -connect spacetechs.net:443 -servername spacetechs.net
```

### 4. Verify No Source Code Exposure
```bash
# SSH into Coolify server and check container
docker exec <container-id> ls -la
# Should only show built artifacts, not source files
```

## DNS Configuration
Ensure your domain points to the Coolify server:
```
A record: spacetechs.net → [Coolify-Server-IP]
```

## Troubleshooting

### Build Failures
- Check Dockerfile syntax
- Verify all dependencies in package.json
- Review build logs in Coolify dashboard

### SSL Issues
- Verify domain DNS resolution
- Check Let's Encrypt rate limits
- Ensure port 80/443 are accessible

### Deployment Errors
- Validate API token permissions
- Check project/server UUIDs
- Review Coolify server logs

## Monitoring
- Access logs via Coolify dashboard
- Monitor SSL certificate expiration
- Set up health checks for the application

## Rollback Procedure
1. Access Coolify dashboard
2. Navigate to application deployments
3. Select previous successful deployment
4. Click "Redeploy"

## Support
For issues:
1. Check Coolify documentation
2. Review application logs
3. Verify configuration files
4. Contact system administrator