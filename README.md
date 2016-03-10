Altitude Labs Devops
===

Aims - Automatically do these:
* create ec2 instance
* install node.js, mongodb, npm
* run deploy.sh to deploy repo
* pm2 run server
* add godaddy subdomain
* Webhook Github

## Things you need
* This repo
* Github Project (You need Admin permission to access 'Setting' page )
* deploy.sh in project root
* AWS access key and secret key
* Key pair for EC2 instance, for example, altitudelabs.pem
* Godaddy username and password

## Getting Started - Mac OSX

* Install ansible using `pip install ansible` if you have not.
* ssh add private key if you have not.
    ```
    eval `ssh-agent`
    ssh-add ~/.ssh/altitudelabs.pem
    ```

1. Copy all files and folder under you project root folder, so that your file structure will look like:
    ```
    //Project foo
    .
    +-- foo-assets
    +-- foo-other-folder
    +-- foo-server.js
    +-- devops-core         // Playbooks and default config
    +-- devops-hosts        // Host file for ec2 instances; from devops-core/devops-hosts.sample
    +-- devops-vars.yml     // Configurations file
    ```

2. Check your `./devops-host` file, it should have nothing after `[launched]`
    ```
    [local]
    localhost

    [launched]
    ```
    * Remark: If you are using different python interpreter, see FAQ.

3. Config `./devops-var.yml`

4. Open terminal, add AWS access and secret key to `~/.bash_profile`
    ```
    sudo vim ~/.bash_profile
    ```

    ```
    export AWS_ACCESS_KEY={{ aws_access_key }}
    export AWS_SECRET_KEY={{ aws_secret_key }}
    ```

5. Assign permission to shell script
    ```
    chmod u+x devops

    ```

6. Go to you project root file, create ec2 instance using
    ```
    ./devops aws
    ```
    * If success, you may see nginx welcome page.

7. Deploy
    ```
    ./devops install
    ```
    * When process pause, Copy the public key. Go to your git repo, click [Settings] -> [Deploy Keys]. Add the public key as deploy key. Then press Enter in terminal to continue the process.


8. Add subdomain
    ```
    ./devops godaddy
    ```
    * Type your Godaddy username and password when it asked. If this is success, you should see the site on the path as in `./devops-vars.yml` configurations

9. Webhook Github
    ```
    ./devops webhook
    ```
    * Then, go to your github repo, click [Settings] -> [Webhooks and Services] -> [Add webhook].
      * Payload URL url: `domain-name.com:autodeploy-port`, default port 8001.
      * Content type: `application/json`
      * `Just the push event`
      * `Active`

10. You're done! Now, try push new commits to the branch, you should see the site updated automatically.


## Yml Config options
```
---
#######################################################################################
###### Common Setting #################################################################

application_name:                       template                  # You repo will be install in this folder, NO-SPACE-ALLOWED
instance_name:                          template-staging          # Ec2 instance_name
keypair:                                altitudelabs              # Key name to access the instance (from ~/.ssh/)
nginx_server_name:                      template.altitudelabs.com # Godaddy will create this subdomain
nginx_server_port:                      7777                      # Port number to start the server

#######################################################################################
###### Install.yml Setting ############################################################

git_path:                               altitudelabs/nodeJS_template  # Github repo
git_branch:                             master                        # Github repo branch

deploy_sh_file:                         deploy.sh

app_js:                                 server.js                     # File to start the server
bashrc_env_var: |                                                     # ENV variables for server
                                        PORT={{ nginx_server_port }}  
                                        NODE_ENV=production
pm2_start_var:                          PORT={{ nginx_server_port }} NODE_ENV=production # Variables for pm2

#######################################################################################
###### webhook.yml Setting ############################################################
git_autodeploy_port:                    8001                          # Autodeploy port
git_autodeploy_pull_shell:              sudo ssh-agent bash -c 'ssh-add /home/ubuntu/.ssh/github_rsa; git pull' # Autodeploy do these thing along with git pull
git_autodeploy_deploy_shell:            ./{{ deploy_sh_file }} && pm2 restart app
```

## Commands

Run all of them
```
./devops
```

Create EC2 instance and add to host file
```
./devops aws
```
or
```
ansible-playbook -i devops-hosts --extra-vars="@devops-vars.yml" devops-core/aws.yml
```

Provision EC2 instance and Deploy
```
./devops install
```
or
```
ansible-playbook -i devops-hosts --extra-vars="@devops-vars.yml" devops-core/install.yml
```

Do subdomain to GoDaddy ac
```
./devops godaddy
```
or
```
ansible-playbook -i devops-hosts --extra-vars="@devops-vars.yml" devops-core/godaddy.yml
```

Run python script to webhook Github
```
./devops webhook
```
or
```
ansible-playbook -i devops-hosts --extra-vars="@devops-vars.yml" devops-core/webhook.yml
```

## FAQ

#### When running aws.yml
##### boto required for this module
Solutions
1. Install boto using `sudo pip install boto`
2. If boto was installed, and you installed more than 1 python in your computer, try `which python`, copy the path to `./devops-host` like
```
[local]
localhost ansible_python_interpreter=/Library/Frameworks/Python.framework/Versions/2.7/bin/python

[launched]
```
#####  No handler was ready to authenticate
1. `source ~/.bash_profile` before running `aws.yml`

##### Your quota allows for 0 more running instance
1. Go to AWS, delete useless ec2 instance first.

#### The authenticity of host can't be established. Are you sure you want to continue connecting (yes/no)?
`yes`
