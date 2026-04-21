# Terraform Docker Load Balancer

A Terraform configuration that deploys a Docker-based load balancer with two Nginx web servers. This setup demonstrates load balancing in action using Docker containers and a local Nginx reverse proxy.

## Architecture

```
┌─────────────────────────────────────┐
│      Host (localhost:8080)          │
├─────────────────────────────────────┤
│      Load Balancer Container        │
│    (Nginx Reverse Proxy :80)        │
├─────────────────────────────────────┤
│         Docker Network               │
│  (web_network - Private)            │
├──────────────────┬──────────────────┤
│                  │                  │
│  Web Server 1    │   Web Server 2   │
│  (Port 80)       │   (Port 80)      │
│  Shows "Server   │   Shows "Server  │
│   ONE"           │    TWO"          │
└──────────────────┴──────────────────┘
```

## What This Configuration Does

- **Docker Network**: Creates a private network (`web_network`) for container communication
- **Web Servers**: Deploys two Nginx containers serving custom HTML pages
  - `web_server_1`: Displays "Server ONE"
  - `web_server_2`: Displays "Server TWO"
- **Load Balancer**: Deploys an Nginx container configured as a reverse proxy
  - Listens on `localhost:8080`
  - Distributes traffic between the two web servers using round-robin load balancing
- **Nginx Config**: Generates and mounts a custom Nginx configuration for load balancing

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0)
- [Docker](https://www.docker.com/products/docker-desktop) installed and running
- Docker daemon must be accessible locally

## Files

| File | Purpose |
|------|---------|
| `providers.tf` | Defines Docker provider configuration |
| `main.tf` | Creates web servers and Docker network |
| `loadbalancer.tf` | Creates load balancer container and Nginx config |
| `outputs.tf` | Defines output variables |

## Usage

### Initialize Terraform

```bash
terraform init
```

This downloads the required Docker provider (kreuzwerker/docker v3.0.1).

### Plan the Deployment

```bash
terraform plan
```

Review the resources that will be created.

### Deploy the Infrastructure

```bash
terraform apply
```

Approve the plan to create the containers and network.

### Access the Application

Once deployed, visit: **http://localhost:8080**

Refresh the page multiple times to see the load balancer alternating between "Server ONE" and "Server TWO".

### Destroy the Infrastructure

```bash
terraform destroy
```

Removes all containers and the Docker network.

## Outputs

After deployment, Terraform provides:

- **website_url**: The URL to access the load-balanced application (`http://localhost:8080`)

View outputs anytime with:
```bash
terraform output
```

## Load Balancing Configuration

The Nginx load balancer uses a round-robin algorithm to distribute requests:

```nginx
upstream my_servers {
    server web_server_1:80;
    server web_server_2:80;
}
```

Each incoming request to port 8080 is proxied to one of the backend servers.

## Files Generated During Deployment

- `terraform.tfstate`: State file (tracks infrastructure state)
- `terraform.tfstate.backup`: Backup state file
- `.terraform.lock.hcl`: Dependency lock file
- `nginx.conf`: Generated Nginx configuration file
- `.terraform/`: Terraform working directory

## Notes

- This is a development/learning setup, not production-ready
- Containers run in the background after deployment
- The setup uses Docker's local socket for communication
- All containers run on the same private network for secure communication

## Troubleshooting

### Containers won't start
- Ensure Docker Desktop is running
- Check Docker daemon status: `docker ps`

### Can't access localhost:8080
- Verify containers are running: `docker ps`
- Check load balancer logs: `docker logs load_balancer`

### Port already in use
- Change `external = 8080` in `loadbalancer.tf` to an available port

## License

This project is open source and available under the MIT License.
