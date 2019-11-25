data "digitalocean_droplet_snapshot" "martian1" {
  name_regex = "^martian"
  region = "lon1"
  most_recent = true
}

resource "digitalocean_droplet" "martian1" {
  image = data.digitalocean_droplet_snapshot.martian1.id
  name = "martian1"
  region = "lon1"
  size = "s-1vcpu-1gb"
  private_networking = true
}

output "ipv4_address" {
  value = digitalocean_droplet.martian1.ipv4_address
}
