variable linode_token {}
variable pubkey {}

provider "linode" {
  token = "${var.linode_token}"
}

resource "linode_instance" "kubernetes-actual" {
  image           = "linode/arch"
  label           = "kuberenetes-actual"
  group           = "kubernetes"
  region          = "us-west"
  type            = "g6-nanode-1"
  authorized_keys = ["${var.pubkey}"]
  root_pass       = "${var.linode_token}"
}

resource "linode_instance" "kubernetes-alpha" {
  image = "linode/arch"
  label = "kubernetes-alpha"
  group = "kubernetes"
  region = "us-west"
  type = "g6-nanode-1"
  authorized_keys = [ "${var.pubkey}" ]
  root_pass = "${var.linode_token}"
}

output "inventory_hostname" {
  value = [
    "${linode_instance.kubernetes-actual.ip_address}",
    "${linode_instance.kubernetes-alpha.ip_address}"
  ]
}
