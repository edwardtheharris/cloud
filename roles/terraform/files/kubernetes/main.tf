variable linode_token {}
variable pubkey {}

provider "linode" {
  token = "${var.linode_token}"
}

resource "linode_instance" "kubernetes-actual" {
  image           = "linode/arch"
  label           = "actual"
  group           = "kubernetes"
  region          = "us-west"
  type            = "g6-nanode-1"
  authorized_keys = ["${var.pubkey}"]
  root_pass       = "${var.linode_token}"
}

resource "linode_instance" "kubernetes-alpha" {
  image = "linode/arch"
  label = "alpha"
  group = "kubernetes"
  region = "us-west"
  type = "g6-nanode-1"
  authorized_keys = [ "${var.pubkey}" ]
  root_pass = "${var.linode_token}"
}

# resource "linode_instance" "kubernetes-bravo" {
#  image = "linode/arch"
#  label = "bravo"
#  group = "kubernetes"
#  region = "us-west"
#  type = "g6-nanode-1"
#  authorized_keys = [ "${var.pubkey}" ]
#  root_pass = "${var.linode_token}"
#}

#resource "linode_instance" "kubernetes-charlie" {
#  image = "linode/arch"
#  label = "charlie"
#  group = "kubernetes"
#  region = "us-west"
#  type = "g6-nanode-1"
#  authorized_keys = [ "${var.pubkey}" ]
#  root_pass = "${var.linode_token}"
#}

output "addresses" {
  value = [
    "${linode_instance.kubernetes-actual.ip_address}",
    "${linode_instance.kubernetes-alpha.ip_address}",
#    "${linode_instance.kubernetes-bravo.ip_address}",
#    "${linode_instance.kubernetes-charlie.ip_address}",
  ]
}

output "hostnames" {
  value = [
    "${linode_instance.kubernetes-actual.label}",
    "${linode_instance.kubernetes-alpha.label}",
#    "${linode_instance.kubernetes-bravo.label}",
#    "${linode_instance.kubernetes-charlie.label}",
  ]
}
