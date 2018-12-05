variable linode_token {}
variable pubkey {}

provider "linode" {
  token = "${var.linode_token}"
}

resource "linode_instance" "swarm" {
  count = 3
  image           = "linode/arch"
  label           = "swarm-${count.index}"
  group           = "swarm"
  region          = "us-west"
  type            = "g6-nanode-1"
  authorized_keys = ["${var.pubkey}"]
  root_pass       = "${var.linode_token}"
}

output "addresses" {
  value = ["${linode_instance.swarm.*.ip_address}",]
}

output "hostnames" {
  value = ["${linode_instance.swarm.*.label}",]
}
