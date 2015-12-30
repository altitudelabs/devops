Altitude Labs Devops
===

Note: deploy-node-app, deploy-blog roles needs work

## Getting Started - Mac OSX

Create and configure the following files:

* production: host file for production instances; from hosts.sample
* staging: host file for staging instances; from hosts.sample
* env_vars/base.yml: global configurations from base.sample.yml

Add AWS access and secret key to ~/.bash_profile

```
export AWS_ACCESS_KEY={{ aws_access_key }}
export AWS_SECRET_KEY={{ aws_secret_key }}
```

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