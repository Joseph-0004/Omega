output "ip_publique" {
  value       = digitalocean_droplet.web.ipv4_address
  description = "Ouvre http://<cette-ip> pour voir ton site en production !"
}