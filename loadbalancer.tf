# Create a local config file for Nginx to act as a Load Balancer
resource "local_file" "nginx_conf" {
  filename = "${path.module}/nginx.conf"
  content  = <<-EOT
    events {}
    http {
        upstream my_servers {
            server web_server_1:80;
            server web_server_2:80;
        }
        server {
            listen 80;
            location / {
                proxy_pass http://my_servers;
            }
        }
    }
  EOT
}

# The Load Balancer Container
resource "docker_container" "load_balancer" {
  name  = "load_balancer"
  image = docker_image.nginx_img.image_id
  ports {
    internal = 80
    external = 8080 # Access your site at http://localhost:8080
  }
  networks_advanced {
    name = docker_network.private_network.name
  }
  # Mount the config file we generated above
  volumes {
    host_path      = abspath(local_file.nginx_conf.filename)
    container_path = "/etc/nginx/nginx.conf"
  }
}
