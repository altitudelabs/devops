Altitude Labs Devops
===

Note: deploy-node-app, deploy-blog roles needs work

## Getting Started

Create and configure the following files:

* production: host file for production instances; from hosts.sample
* staging: host file for staging instances; from hosts.sample
* env_vars/base.yml: global configurations from base.sample.yml

## Commands

Create EC2 instance and add to host file
```
ansible-playbook -i staging aws.yml
```

Provision EC2 instance
```
ansible-playbook -i staging install.yml
```

Deploy
```
ansible-playbook -i staging deploy.yml
```