# Create a private network for our containers
resource "docker_network" "private_network" {
  name = "web_network"
}

# Pull the Nginx image
resource "docker_image" "nginx_img" {
  name         = "nginx:latest"
  keep_locally = true
}

# Web Server 1
resource "docker_container" "web_server_1" {
  name  = "web_server_1"
  image = docker_image.nginx_img.image_id
  networks_advanced {
    name = docker_network.private_network.name
  }
  # Custom index page to show load balancing in action
  upload {
    content = "<h1>Server ONE</h1>"
    file    = "/usr/share/nginx/html/index.html"
  }
}

# Web Server 2
resource "docker_container" "web_server_2" {
  name  = "web_server_2"
  image = docker_image.nginx_img.image_id
  networks_advanced {
    name = docker_network.private_network.name
  }
  upload {
    content = "<h1>Server TWO</h1>"
    file    = "/usr/share/nginx/html/index.html"
  }
}
