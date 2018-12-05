Linodes
=======

Instantiates and configures various services based in [Linode](https://cloud.linode.com).

Some notes on [loops in Terraform](https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9).

Requirements
------------

Ansible, Terraform, a module here, a library there. For the most part it's pretty self contained and you should be okay with just Ansible and Terraform.

### Environment

    PROJECT=(kubernetes|swarm)


Build Status
------------

[![Build Status](https://travis-ci.com/edwardtheharris/linodes.svg?branch=master)](https://travis-ci.com/edwardtheharris/linodes)

Dependencies
------------

None.

Example Playbook
----------------

```yaml
- hosts: kubernetes
  roles:
     - { role: edwardtheharris.linodes.kubernetes-actual, x: 42 }
```

License
-------

BSD

Author Information
------------------

N/A
test
