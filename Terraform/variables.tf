variable "do_token" { sensitive = true }
variable "github_username" { description = "Ton pseudo GitHub" }
variable "ssh_key_name" { description = "Nom exact de ta clé SSH sur DigitalOcean" }
variable "ssh_private_key_path" { default = "~/.ssh/id_rsa" }