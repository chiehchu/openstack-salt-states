include:
    - base

apache2:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - pkg: openstack-dashboard
    require:
        - pkg: openstack-dashboard
        - file: /etc/openstack-dashboard/local_settings.py
