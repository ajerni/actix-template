# Rust Actix Web Server - Docker Compose Template

This template provides a ready-to-use Docker Compose setup for a Rust Actix Web server with Traefik integration.

## Quick Start

1. Build and run the container:
   ```bash
   docker-compose up --build
   ```

2. The server will be available at your configured domain through Traefik with TLS.

## Customizing for New Projects

When creating a new project from this template, you need to update the following:

### 1. **docker-compose.yml** (4 changes)

- **Service name** (line 4): Change `actix-server` to your project name (e.g., `my-api`, `user-service`)
- **Container name** (line 8): Change `actix_server` to match (e.g., `my_api`, `user_service`)
- **Port mapping** (line 11): Change `8083:8080` if the host port conflicts with other services
- **Traefik host** (line 16): Change `actix.ernilabs.com` to your domain (e.g., `myapi.ernilabs.com`)
- **Traefik router/service names** (lines 16 - 19): Update `actix-server` to match your service name

### 2. **Cargo.toml** (2 changes)

- **Package name** (line 2): Change `actix-server` to your project name
- **Binary name** (line 7): Change `actix-server` to match the package name

### 3. **Dockerfile**

- ✅ No changes needed - it's generic and works for all projects

### 4. **main.rs**

- Replace with your application endpoints and business logic

## Quick Checklist for New Projects

- [ ] Replace all instances of `actix-server` / `actix_server` with your project name
- [ ] Update the domain in Traefik labels
- [ ] Change the port if needed (check for conflicts)
- [ ] Update `Cargo.toml` package name
- [ ] Write your application code in `main.rs`

## Project Structure

```
.
├── docker-compose.yml    # Docker Compose configuration with Traefik
├── Dockerfile            # Multi-stage build for Rust application
├── Cargo.toml           # Rust project dependencies
├── main.rs              # Your Actix Web application code
└── README.md            # This file
```

## Network Configuration

This template uses the `iotnetwork` external network for Traefik integration. Make sure this network exists on your server:

```bash
docker network create iotnetwork
```

## Local Testing

For local testing, create the `iotnetwork` manually once (it only needs to be done once):

```bash
docker network create iotnetwork
docker-compose up --build
```

The server will be accessible at `http://localhost:8083` (or your configured port).

**Note:** The network will persist after creation, so you only need to create it once. If you want to remove it later:
```bash
docker network rm iotnetwork
```

**On your server:**
- The `iotnetwork` already exists as an external network
- Just run `docker-compose up --build` as normal

## Deployment to Server

To upload your files to your vserver via SSH, you have several options:

### Option 1: rsync

```bash
# On your local machine
# Option 1: Navigate first, then sync
cd /Users/andi/projekte/test
rsync -avz --exclude 'target' --exclude '.git' ./ user@server.com:/usr/local/sbin
```

### Option 2: Git (If using version control)

If you're using git, clone on the server:

```bash
# On your server
git clone your-repo-url
cd project-name
```
