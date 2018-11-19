variable linode_token {}
variable pubkey {}

provider "linode" {
  token = "${var.linode_token}"
}

resource "linode_instance" "swarm-actual" {
  image           = "linode/arch"
  label           = "actual"
  group           = "swarm"
  region          = "us-west"
  type            = "g6-nanode-1"
  authorized_keys = ["${var.pubkey}"]
  root_pass       = "${var.linode_token}"
}

resource "linode_instance" "swarm-alpha" {
  image = "linode/arch"
  label = "alpha"
  group = "swarm"
  region = "us-west"
  type = "g6-nanode-1"
  authorized_keys = [ "${var.pubkey}" ]
  root_pass = "${var.linode_token}"
}

# resource "linode_instance" "swarm-bravo" {
#  image = "linode/arch"
#  label = "bravo"
#  group = "swarm"
#  region = "us-west"
#  type = "g6-nanode-1"
#  authorized_keys = [ "${var.pubkey}" ]
#  root_pass = "${var.linode_token}"
#}

#resource "linode_instance" "swarm-charlie" {
#  image = "linode/arch"
#  label = "charlie"
#  group = "swarm"
#  region = "us-west"
#  type = "g6-nanode-1"
#  authorized_keys = [ "${var.pubkey}" ]
#  root_pass = "${var.linode_token}"
#}

output "addresses" {
  value = [
    "${linode_instance.swarm-actual.ip_address}",
    "${linode_instance.swarm-alpha.ip_address}",
#    "${linode_instance.swarm-bravo.ip_address}",
#    "${linode_instance.swarm-charlie.ip_address}",
  ]
}

output "hostnames" {
  value = [
    "${linode_instance.swarm-actual.label}",
    "${linode_instance.swarm-alpha.label}",
#    "${linode_instance.swarm-bravo.label}",
#    "${linode_instance.swarm-charlie.label}",
  ]
}
