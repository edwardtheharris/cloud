Kubernetes Actual
=================

Installs required software for a Kubernetes master node.

Requirements
------------

A machine running ArchLinux.

Role Variables
--------------

None.

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
