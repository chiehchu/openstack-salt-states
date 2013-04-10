{% set openstack = pillar.get('openstack', {}) %}
{% set debug = openstack.get('debug', 'True') %}
{% set source = openstack.get('source', 'deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main') %}

# Packaging.
# NOTE: This goes hand-in-hand with the source listed above.
# For the time being, these recipes only support Ubuntu precise w/
# cloud archive -- although it would be a straight-forward path to
# support other distributions.
{% macro package(name) %}
keyring-{{name}}:
    pkg.latest:
        - name: ubuntu-cloud-keyring
{{name}}:
    pkg:
        - latest
    pkgrepo.managed:
        - name: {{source}}
        - baseurl: {{source}}
        - humanname: openstack
        - file: /etc/apt/sources.list.d/openstack.list
    require:
        - pkgrepo: {{source}}
        - pkg: ubuntu-cloud-keyring
{% endmacro %}

# Network configuration.
{% set networks = openstack.get('networks', {}) %}
{% set interfaces = openstack.get('interfaces', {}) %}
{% set default_interface = interfaces.get('default', 'eth1') %}

{% set public_network = networks.get('public', '') %}
{% set public_interface = interfaces.get('public', default_interface) %}
{% set nova_network = networks.get('nova', '') %}
{% set nova_interface = interfaces.get('nova', default_interface) %}
{% set internal_network = networks.get('internal', '') %}

# Ugly network IP extraction (automatic based on subnet from config).
{% set _pre_cmd = "python -c 'from salt.modules.network import interfaces, _calculate_subnet; print ((([x for x in [[ip.get(\"address\") for ip in ipv4 if \"" %}
{% set _post_cmd = "\" == _calculate_subnet(ip.get(\"address\"), ip.get(\"netmask\"))] for ipv4 in [itr.get(\"inet\") for itr in interfaces().values() if itr.get(\"inet\")]] if len(x) > 0] + [[]])[0]) + [\"\"])[0]'" %}
{% set internal_ip = salt['cmd.run'](_pre_cmd + internal_network + _post_cmd) %}
{% set nova_ip = salt['cmd.run'](_pre_cmd + nova_network + _post_cmd) %}
{% set public_ip = salt['cmd.run'](_pre_cmd + public_network + _post_cmd) %}

# Database configuration.
{% set keystone = openstack.get('keystone', {}) %}
{% set mysql_keystone_database = keystone.get('database', 'keystone') %}
{% set mysql_keystone_username = keystone.get('username', 'keystone') %}
{% set mysql_keystone_password = keystone.get('password', '') %}

{% set nova = openstack.get('nova', {}) %}
{% set mysql_nova_database = nova.get('database', 'nova') %}
{% set mysql_nova_username = nova.get('username', 'nova') %}
{% set mysql_nova_password = nova.get('password', '') %}

{% set glance = openstack.get('glance', {}) %}
{% set mysql_glance_database = glance.get('database', 'glance') %}
{% set mysql_glance_username = glance.get('username', 'glance') %}
{% set mysql_glance_password = glance.get('password', '') %}

{% set cinder = openstack.get('cinder', {}) %}
{% set mysql_cinder_database = cinder.get('database', 'cinder') %}
{% set mysql_cinder_username = cinder.get('username', 'cinder') %}
{% set mysql_cinder_password = cinder.get('password', '') %}

{% set horizon = openstack.get('horizon', {}) %}
{% set mysql_horizon_database = horizon.get('database', 'horizon') %}
{% set mysql_horizon_username = horizon.get('username', 'horizon') %}
{% set mysql_horizon_password = horizon.get('password', '') %}

{% set admin = openstack.get('admin', {}) %}
{% set os_username = admin.get('username', 'admin') %}
{% set os_password = admin.get('password', 'admin') %}
{% set os_tenant_name = admin.get('tenant_name', 'admin') %}

# Rabbit configuration.
{% set rabbit = openstack.get('rabbit', {}) %}
{% set rabbitmq_user = rabbit.get('user', 'guest') %}
{% set rabbitmq_password = rabbit.get('password', 'guest') %}
{% set rabbitmq_vhost = rabbit.get('vhost', '/') %}

# Keystone configuration.
{% set keystone_port = keystone.get('port', '5000') %}
{% set keystone_auth = keystone.get('auth', '35357') %}
{% set keystone_token = keystone.get('token', '') %}

# API configuration.
{% set api = openstack.get('api', {}) %}
{% set ec2_port = api.get('ec2', '8773') %}
{% set compute_port = api.get('compute', '8774') %}
{% set glance_api_port = glance.get('api', '9292') %}
{% set glance_registry_port = glance.get('registry', '9191') %}

# Keystone services.
{% set service_tenant_name = keystone.get('tenant_name', 'service') %}
{% set keystone_nova_password = keystone.get('nova', '') %}
{% set keystone_glance_password = keystone.get('glance', '') %}
{% set keystone_cinder_password = keystone.get('cinder', '') %}

# Debug output.
echo internal {{ internal_ip }}:
    cmd:
        - run
echo public {{ public_ip }}:
    cmd:
        - run
echo nova {{ nova_ip }}:
    cmd:
        - run
