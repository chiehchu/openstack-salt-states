{% set debug = pillar.get('openstack.debug', 'True') %}
{% set source = pillar.get('openstack.source', 'deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main') %}

# Packaging.
{% macro package(name) %}
{{name}}:
    pkg:
        - installed
    pkgrepo.managed:
        - name: {{source}}
        - baseurl: {{source}}
        - humanname: openstack
        - file: /etc/apt/sources.list.d/openstack.list
    watch:
        - file: /etc/yum/repos.d/openstack.repo
        - file: /etc/apt/sources.list.d/{{source}}
    require:
        - pkgrepo: {{source}}
{% endmacro %}

# Computed quantities (once appropriate states are deployed).
{% set mysql_hosts = salt['publish.publish']('D@openstack.mysql:*', 'data.getval', 'openstack.mysql', expr_form='compound').values() %}
{% set rabbitmq_hosts = salt['publish.publish']('D@openstack.rabbitmq:*', 'data.getval', 'openstack.rabbitmq', expr_form='compound').values() %}
{% set keystone_hosts = salt['publish.publish']('D@openstack.keystone:*', 'data.getval', 'openstack.keystone', expr_form='compound').values() %}
{% set glance_hosts = salt['publish.publish']('D@openstack.glance:*', 'data.getval', 'openstack.glance', expr_form='compound').values() %}

# Network configuration.
{% set default_interface = pillar.get('openstack.interface.default', 'eth0') %}
{% set internal_interface = pillar.get('openstack.interface.internal', default_interface) %}
{% set nova_interface = pillar.get('openstack.interface.nova', default_interface) %}
{% set public_interface = pillar.get('openstack.interface.public', default_interface) %}

# Network auto-computed.
{% set internal_ip = salt['network.ip_addrs'](interface=internal_interface)|first %}
{% set nova_ip = salt['network.ip_addrs'](interface=nova_interface)|first %}
{% set public_ip = salt['network.ip_addrs'](interface=public_interface)|first %}

# Database configuration.
{% set mysql_keystone_database = pillar.get('openstack.keystone.database', 'keystone') %}
{% set mysql_keystone_username = pillar.get('openstack.keystone.username', 'keystone') %}
{% set mysql_keystone_password = pillar.get('openstack.keystone.password', '') %}

{% set mysql_nova_database = pillar.get('openstack.nova.database', 'nova') %}
{% set mysql_nova_username = pillar.get('openstack.nova.username', 'nova') %}
{% set mysql_nova_password = pillar.get('openstack.nova.password', '') %}

{% set mysql_glance_database = pillar.get('openstack.glance.database', 'glance') %}
{% set mysql_glance_username = pillar.get('openstack.glance.username', 'glance') %}
{% set mysql_glance_password = pillar.get('openstack.glance.password', '') %}

{% set mysql_cinder_database = pillar.get('openstack.cinder.database', 'cinder') %}
{% set mysql_cinder_username = pillar.get('openstack.cinder.username', 'cinder') %}
{% set mysql_cinder_password = pillar.get('openstack.cinder.password', '') %}

{% set mysql_horizon_database = pillar.get('openstack.horizon.database', 'horizon') %}
{% set mysql_horizon_username = pillar.get('openstack.horizon.username', 'horizon') %}
{% set mysql_horizon_password = pillar.get('openstack.horizon.password', '') %}

{% set mysql_quantum_database = pillar.get('openstack.quantum.database', 'quantum') %}
{% set mysql_quantum_username = pillar.get('openstack.quantum.username', 'quantum') %}
{% set mysql_quantum_password = pillar.get('openstack.quantum.password', '') %}

{% set os_username = pillar.get('openstack.admin_username', 'admin') %}
{% set os_password = pillar.get('openstack.admin_password', 'admin') %}
{% set os_tenant_name = pillar.get('openstack.admin_tenant_name', 'admin') %}

# Keystone configuration.
{% set keystone_port = pillar.get('openstack.keystone.port', '5000') %}
{% set keystone_auth = pillar.get('openstack.keystone.auth', '35357') %}

# Keystone services.
{% set nova_username = pillar.get('openstack.nova.username', 'nova') %}
{% set nova_password = pillar.get('openstack.nova.password', '') %}
{% set nova_tenant_name = pillar.get('openstack.nova.tenant_name', 'service') %}

{% set glance_username = pillar.get('openstack.glance.username', 'glance') %}
{% set glance_password = pillar.get('openstack.glance.password', '') %}
{% set glance_tenant_name = pillar.get('openstack.glance.tenant_name', 'service') %}
