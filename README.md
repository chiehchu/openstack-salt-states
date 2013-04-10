OpenStack Salt States
=====================

These states are flexible and extensible.

They are designed to do large multi-node deployments, and to allow for
auto-discovery of different services and addresses.

There are few requirements for use.

Where to put it
---------------

This repository is designed to be used as `$SALT_ROOT/openstack`. For
example, this will generally be `/srv/salt/openstack`.

This structure was chosen so that you can easily import it as a submodule
within a git repo with your other salt states (and possibly pillar data).

Enable peer to peer interface
-----------------------------

In order to use these states, you must enable appropriate peer to peer
communicate. Minions query each other for information about deployed
openstack states.

See the full salt documentation for fine-grained control, but to enable
peer to peer communication across the board you can use:

`/etc/salt/master.d/peer.conf`

    peer:
        .*:
            - .*

Ceph configuration
------------------

First, setup some pillar data for your storage configuration.

    ceph:
        devices:
            node-0025904fc1de:
                0: sdb
                1: sdc
            node-0025904fc34c:
                2: sdb
                3: sdc

Then run `state.sls` `openstack.ceph` to deploy the configuration.
To make the cluster, you will then run:

    mkcephfs -a -c /etc/ceph/ceph.conf --mkfs

That's it!

Configuration
-------------

You can find full information about configuration values in `config.sls` and
`ceph/config.sls`.
