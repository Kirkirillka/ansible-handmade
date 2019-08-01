# Quick start

Run Vagrantfile (it will starts CentOS7), provisioning will be started automatically:

```bash
vagrant up
```

Example of  `inventory.yml`:

```ini
[servers]
127.0.0.1:2222
```

Example of a playbook `test.yml` to be executed :

```yaml
- hosts: servers
  become: yes
  roles:
  - role: syslog-ng
    vars:
      REMOTE_ENABLED: true
      REMOTE_SYSLOG_SERVER: 127.0.0.1
      REMOTE_SYSLOG_PORT: 50514
      SOURCE_FILES:
        audit_centos: /var/log/audit/audit.log
        nginx_default: /var/log/nginx/access.log
```

Run the playbook:

```yaml
ansible-playbook -i inventory.yml test.yml
```