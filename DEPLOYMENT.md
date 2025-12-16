# Deployment Guide

## Prerequisites

1. **Hetzner VPS** (77.42.44.3)
   - SSH access as root
   - Docker installed
   - Open ports: 80, 443, 22

2. **GitHub Container Registry Token**
   - Go to: https://github.com/settings/tokens
   - Create a new token (classic)
   - Select scopes: `write:packages`, `read:packages`, `delete:packages` (optional)
   - Copy the token (you won't see it again!)

3. **Domain Name**
   - Point `migraine-tracker.eu` A record to: 77.42.44.3

## Setup Steps

### 1. Configure Environment Variables

Create a `.env` file in the project root:

```bash
cp .env.example .env
```

Edit `.env` and add your secrets:

```bash
# Your GitHub token from step 2 above
KAMAL_REGISTRY_PASSWORD=ghp_xxxxxxxxxxxxxxxxxxxx

# Your Rails master key from config/master.key
RAILS_MASTER_KEY=your_master_key_here
```

**IMPORTANT**: Never commit `.env` or `config/master.key` to git!

### 2. Load Environment Variables

Before running Kamal commands, load your environment:

```bash
export $(cat .env | xargs)
```

Or add to your shell profile (~/.zshrc or ~/.bashrc):

```bash
# Load Kamal secrets
if [ -f ~/code/MyMigraineManager/.env ]; then
  export $(cat ~/code/MyMigraineManager/.env | grep -v '^#' | xargs)
fi
```

### 3. Prepare the Server

SSH into your Hetzner VPS and install Docker:

```bash
ssh root@77.42.44.3

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Verify Docker is running
docker --version
```

### 4. Set up SSH Access

Make sure you can SSH without password (using SSH keys):

```bash
# On your local machine
ssh-copy-id root@77.42.44.3

# Test connection
ssh root@77.42.44.3 "echo Connection successful"
```

### 5. Initial Deployment

From your local machine:

```bash
# Load environment variables
export $(cat .env | xargs)

# Set up the server (first time only)
bundle exec kamal setup

# Or if already set up, just deploy
bundle exec kamal deploy
```

### 6. Useful Kamal Commands

```bash
# Deploy latest changes
bundle exec kamal deploy

# View logs
bundle exec kamal app logs -f

# Open Rails console on production
bundle exec kamal app exec -i bin/rails console

# SSH into the server
bundle exec kamal app exec -i bash

# Rollback to previous version
bundle exec kamal rollback

# Check server status
bundle exec kamal details

# Remove all containers (careful!)
bundle exec kamal remove
```

## Security Checklist

- [x] `config/master.key` is gitignored
- [x] `.env` is gitignored
- [x] Secrets loaded from environment variables
- [x] `.env.example` provides template without secrets
- [ ] Set up firewall on Hetzner (allow 22, 80, 443)
- [ ] Change SSH port (optional but recommended)
- [ ] Set up automated backups for database
- [ ] Configure monitoring (optional)

## Troubleshooting

### "KAMAL_REGISTRY_PASSWORD not set"

Make sure you've exported environment variables:

```bash
export $(cat .env | xargs)
```

### Docker connection issues

Ensure Docker is running on the server:

```bash
ssh root@77.42.44.3 "systemctl status docker"
```

### SSL certificate issues

Let's Encrypt will automatically provision certificates. If you have issues:

```bash
bundle exec kamal traefik reboot
```

### Database issues

Check volume mounts and permissions:

```bash
bundle exec kamal app exec "ls -la /rails/storage"
```

## Next Steps

1. ✅ Server configured (77.42.44.3)
2. ✅ Domain configured (migraine-tracker.eu)
3. ✅ SSL enabled (Let's Encrypt)
4. Configure environment-specific secrets
5. Set up database backups
6. Configure monitoring (e.g., UptimeRobot, Better Uptime)
7. Set up CI/CD (GitHub Actions) for automated deployments
