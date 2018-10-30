variable linode_token {}

provider "linode" {
  token = "${var.linode_token}"
}

resource "linode_instance" "terraform-web" {
        image = "linode/ubuntu18.04"
        label = "Terraform-Web-Example"
        group = "Terraform"
        region = "us-east"
        type = "g6-standard-1"
        authorized_keys = [ "YOUR_PUBLIC_SSH_KEY" ]
        root_pass = "YOUR_ROOT_PASSWORD"
}
