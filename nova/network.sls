{% import "openstack/config.sls" as config with context %}
include:
    - openstack.nova.base

{{ config.package("nova-network") }}
    service.running:
        - enable: True
        - watch:
            - pkg: nova-network
            - file: /etc/nova/nova.conf
            - file: /etc/nova/policy.json
    require:
        - pkg: nova-network
        - file: /etc/nova/nova.conf
        - file: /etc/nova/policy.json
