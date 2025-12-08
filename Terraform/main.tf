terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "web" {
  image  = "docker-20-04"           # Ubuntu + Docker déjà installé
  name   = "demo-devops-${formatdate("YYYYMMDD-hhmm", timestamp())}"
  region = "fra1"                   # ou nyc3, lon1, sfo3…
  size   = "s-1vcpu-1gb"            # 6 $/mois
  ssh_keys = [data.digitalocean_ssh_key.mykey.id]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "docker pull ghcr.io/${var.github_username}/demo-devops:latest",
      "docker stop demo-devops || true",
      "docker rm demo-devops || true",
      "docker run -d --restart unless-stopped --name demo-devops -p 80:80 ghcr.io/${var.github_username}/demo-devops:latest"
    ]
  }
}

data "digitalocean_ssh_key" "mykey" {
  name = var.ssh_key_name
}

resource "digitalocean_firewall" "web" {
  name        = "only-80"
  droplet_ids = [digitalocean_droplet.web.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}