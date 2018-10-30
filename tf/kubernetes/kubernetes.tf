variable linode_token {}
variable pubkey {}

provider "linode" {
  token = "${var.linode_token}"
}

resource "linode_instance" "kubernetes-actual" {
  image = "linode/arch"
  label = "kuberenetes-actual"
  group = "kubernetes"
  region = "us-west"
  type = "g6-nanode-1"
  authorized_keys = [ "${var.pubkey}" ]
  root_pass = "${var.linode_token}"

  provisioner "local-exec" {
    command = "ansible-playbook wait.yml"
  }

  provisioner "local-exec" {
    command = "cd ../; ansible-playbook archlinux.yml"
  }
}

resource "ansible_host" "kubernetes-actual" {
    inventory_hostname = "${kubernetes-actual.ip_address}"
    groups = ["kubernetes"]
    vars {
        ansible_user = "root"
    }
}

resource "ansible_group" "kubernetes" {
  inventory_group_name = "kubernetes"
  # children = ["foo", "bar", "baz"]
  # vars {
  #   foo = "bar"
  #   bar = 2
  # }
}

#resource "linode_instance" "kubernetes-alpha" {
#  image = "linode/arch"
#  label = "kubernetes-alpha"
#  group = "kubernetes"
#  region = "us-west"
#  type = "g6-nanode-1"
#  authorized_keys = [ "${var.pubkey}" ]
#  root_pass = "${var.linode_token}"
#}
