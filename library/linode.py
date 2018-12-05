#!/usr/bin/env python
"""Linode management module."""

# Copyright: Ansible Project
# GNU General Public License v3.0+ (see COPYING or
# https://www.gnu.org/licenses/gpl-3.0.txt)
import os
import linode_api4
from ansible.module_utils.basic import AnsibleModule

# __metaclass__ = type


def create_linode(module, client):
    """Add a new linode.

    state = present, absent
    """
    try:
        new_linode, root_pass = client.linode.instance_create(
            image=module.params.get('image'),
            label=module.params.get('name'),
            ltype=module.params.get('type'),
            authorized_keys=module.params.get('authorized_keys'),
            region=module.params.get('region'))
    except (TypeError, linode_api4.errors.ApiError) as exception:
        module.fail_json(msg="Failed: %s" % exception)

    return {'changed': True,
            'instances': [
                {'id': new_linode.id,
                 'ipv4': new_linode.ipv4,
                 'name': new_linode.label,
                 'root_pass': root_pass}]}


def list_linodes(module, client):
    """List instances for the given account.

    state = list
    """
    return {
        'module': module,
        'changed': False,
        'instances': [linode.label for linode in client.linode.instances()]
    }


def manage_linodes(module, client):
    """Function for management of Linodes.

    :param module: The current module.
    :param client: Linode API client.
    """
    manage_functions = {
        'absent': remove_linode,
        'list': list_linodes,
        'present': create_linode,
        'tagged': tag_linode,
    }
    module.log(module.params.get('state'))

    return manage_functions.get(
        module.params.get('state'))(module, client)


def tag_linode(module, client):
    """Update a linode's metadata."""
    try:
        tlinode = client.linode.instances(
            linode_api4.Instance.label == module.params.get('name'))[0]
        changed = [
            tlinode.tags.append(tag) for tag in module.params.get('tags')]
        tlinode.save()
    except linode_api4.errors.ApiError as exc:
        module.fail_json(msg="Failed: %s" % exc)

    return {
        'changed': True,
        'instances': [{
            'id': tlinode.id,
            'chagned': changed,
            'tags': tlinode.tags}]}


def remove_linode(module, client):
    """Remove an existing linode."""
    try:
        rem_linode = client.linode.instances(
            linode_api4.Instance.id == module.params.get('id'))[0]
        linode_id = rem_linode.id
        rem_linode.delete()
    except (TypeError, IndexError, linode_api4.errors.ApiError) as exception:
        module.fail_json(msg="Failed: %s" % exception)

    return {'changed': True,
            'instances': [{'id': linode_id}]}


def start_linode(module, client):
    """Start a given linode."""
    return {'module': module, 'client': client}


def stop_linode(module, client):
    """Stop a given Linode."""
    return {'module': module, 'client': client}


def main():
    """Main module execution."""
    module = AnsibleModule(
        argument_spec={
            "authorized_keys": {'type': 'list'},
            "authorized_users": {'type': 'list'},
            "backups_enabled": {'type': 'bool'},
            "backup_id": {'type': 'int'},
            'booted': {'type': 'bool'},
            "group": {'type': 'str'},
            'image': {'type': 'str'},
            'id': {'type': 'str'},
            'type': {'type': 'str'},
            'name': {'type': 'str'},
            "private_ip": {'type': 'bool'},
            'public_key': {'type': 'str'},
            'region': {'type': 'str'},
            'root_pass': {'type': 'str', 'no_log': True},
            "stackscript_id": {'type': 'int'},
            "stackscript_data": {'type': 'str'},
            'state': {
                'type': 'str',
                'default': 'present',
                'choices': [
                    'absent', 'active', 'deleted', 'list',
                    'present', 'restarted', 'started', 'stopped',
                    'tagged',
                    ]},
            "swap_size": {'type': 'int'},
            'tags': {'type': 'list'},
            'token': {'type': 'str', 'no_log': True},
        },
    )

    # Setup the api_key
    if not module.params.get('token'):
        try:
            module.params.update({
                'token': os.environ.get('LINODE_TOKEN')})
        except KeyError as exception:
            module.fail_json(msg='Unable to load %s' % exception)

    # setup the auth
    try:
        client = linode_api4.LinodeClient(module.params.get('token'))
    except KeyError as exception:
        module.fail_json(msg='%s' % exception)

    results = manage_linodes(module, client)
    module.exit_json(
        changed=results.get('changed'), instances=results.get('instances'))


ANSIBLE_METADATA = {'metadata_version': '1.1',
                    'status': ['preview'],
                    'supported_by': 'community'}

if __name__ == '__main__':
    main()
