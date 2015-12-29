Altitude Labs Devops
===

Note: deploy-node-app, deploy-blog roles needs work

Creates new EC2 instance it
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