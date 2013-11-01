{% import "openstack/config.sls" as config with context %}
include:
    - openstack.keystone.base

{{ config.package("memcached") }}
    service.running:
        - name: memcached
        - enable: True

{{ config.package("keystone") }}
    service.running:
        - name: keystone
        - enable: True
        - watch:
            - pkg: keystone
            - pkg: python-eventlet
            - file: /etc/keystone/keystone.conf
            - file: /etc/keystone/policy.json
            - file: /etc/keystone/init.sh
    require:
        - service: memcached
        - file: /etc/keystone/keystone.conf
        - file: /etc/keystone/policy.json
        - file: /etc/keystone/init.sh
