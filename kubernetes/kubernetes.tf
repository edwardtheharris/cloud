variable linode_token {}

provider "linode" {
  token = "${var.linode_token}"
}

resource "linode_instance" "kubernetes-actual" {
        image = "linode/archlinux"
        label = "kuberenetes-actual"
        group = "kubernetes"
        region = "us-west"
        type = "g6-nanode-1"
        authorized_keys = [ "${var.pubkey}" ]
        root_pass = "${var.linode_token}"
}

resource "linode_instance" "kubernetes-alpha" {
  image = "linode/archlinux"
  label = "kubernetes-alpha"
  group = "kubernetes"
  region = "us-west"
  type = "g6-nanode-1"
  authorized_keys = [ "${var.pubkey}" ]
  root_pass = "${var.linode_token}"
}
