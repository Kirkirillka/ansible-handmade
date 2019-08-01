syslog-ng Ansible role
=========

A little Ansible role which will help you to install and configure very convenient and useful syslog daemon syslog-ng.

Practically, this role performs:

- Basic syslog-ng installation. Any other syslog daemon will be deleted.
- Remote logging configuration.

Requirements
------------

Tested on:

-  CentOS7


Role Variables
--------------

|Variable|Type|Default value| Description|
|---|---|---|---|
|REMOTE_ENABLED|bool|false| Is to be set to enable remote logs receiver target|
|REMOTE_SYSLOG_SERVER|string|127.0.0.1| An address for a log receiver to send to|
|REMOTE_SYSLOG_PORT|integer|50514| A port a log receiver is listening on|
|SOURCE_FILES|dict| empty| A dictionary to map files in the host for syslog-ng to include. They are used to send in remote logging. If a specified log file won't be found on the system, it is skipped. |

Dependencies
------------

No external dependencies are required.

Example Playbook
----------------

Example of a playbook to install syslog-ng with default settings

```yaml
- hosts: servers
  roles:
  - role: syslog-ng
```

Install syslog-ng with remote logging and additional log files

```yaml
- hosts: servers
  roles:
  - role: syslog-ng
    vars:
      REMOTE_ENABLED: true
      REMOTE_SYSLOG_SERVER: 10.90.23.3
      REMOTE_SYSLOG_PORT: 514
      SOURCE_FILES:
        audit_centos: /var/log/audit/audit.log
        nginx_default: /var/log/nginx/access.log

```

License
-------

MIT

Author Information
------------------

@kirkirillka