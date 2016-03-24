Altitude Labs Devops
===

## Table of content
1. [Development flow](#development-flow)
2. [Deployment flow](#deployment-flow)

## <a name="development-flow"></a>Development flow

#### Prerequisite
1. Docker (check [wiki](https://github.com/altitudelabs/devops/wiki/Docker#install-on-mac) for how to install)

#### Running your application with Docker
1) Run docker terminal (For Mac users only, skip to step2 if you are using Linux)

Whenever you open a new terminal, before you can start using docker, type:
    
    ```
    $ eval $(docker-machine env)
    ```


2) Go to your project directory. 
    
And create a file called `Dockerfile`. This file is used to program your **docker image**
   
    ```
    $ touch Dockerfile
    ```
    
    
3) Edit your `Dockerfile`. This file is to configure the docker image. You should set up the dependencies here. 

For the syntax, you may refer to [Docker official site](https://docs.docker.com/engine/reference/builder/).

_Example of_ `Dockerfile` for nodejs 

    # Latest Ubuntu LTS
    FROM ubuntu:14.04

    # Install common apt packages
    RUN apt-get update && \
        apt-get install --no-install-recommends -y software-properties-common

    # Install nodejs
    RUN apt-get install -y nodejs
    RUN apt-get install nodejs-legacy
    RUN apt-get install -y npm

    # Install npm modules
    RUN npm update && \
        npm install -g gulp

    # Network config
    EXPOSE 3000
    
4) Build your docker image with `Dockerfile` you have created, type

To build docker image, type:

    ```
    $ docker build -t image_name [dir_of_folder_containing_dockerfile]
    ```

5) Run your server within docker container

To run a docker container, type:
   
    ```
    $ docker run -v [local_mount_dir]:[docker_mount_dir] -p [docker_port]:[local_port] [image_name]
    ```

This command is to 
* load image and start a docker container
* mount to yours files to container (note that local_mount_dir has to be full path, you may use `-v $(pwd):[docker_mount_dir]` for current dir)
* map port from container to localhost 
* ssh into the container

6) Start your service

You are now inside the docker container. Run your service. For example,

    ```
    $ cd /docker_mount_dir
    $ gulp
    ```

6) Do ssh tunnelling for docker container (For Mac users only, skip if you are using Linux)

Create a new terminal, type
    
    ```
    $ eval $(docker-machine env)
    $ docker-machine ssh default -f -N -L [docker_port]:localhost:[local_port]
    ```

This allows you to access the docker container with `localhost`

7) Create other services, if any, by repeating step 1 to step 6 

For example, [mongoDB](https://docs.docker.com/engine/examples/mongodb/)


8) Open your browser and go to the url

    ```
    http://localhost:[server_port]
    ```

You should see the server is up and running.

9) You can then edit your project files as usual and everything works as if you are running server locally.

## Commands for docker
For useful docker commands, you may check [wiki](https://github.com/altitudelabs/devops/wiki/Docker#cmd).
   
## <a name="deployment-flow"></a>Deployment flow

Aims - Automatically do these:
* create ec2 instance
* install node.js, mongodb, npm
* run deploy.sh to deploy repo
* pm2 run server
* add godaddy subdomain
* Webhook Github

#### Things you need
* Github Project (You need Admin permission to access 'Setting' page )
* deploy.sh in project root
* AWS access key and secret key
* Key pair for EC2 instance, for example, altitudelabs.pem
* Godaddy username and password


#### Preparation
* Install ansible using
    ```
    pip install ansible
    ```
* Install boto using
    ```
    sudo /usr/bin/python -m easy_install boto
    ```
* ssh add private key if you have not.
    ```
    eval `ssh-agent`
    ssh-add ~/.ssh/altitudelabs.pem
    ```

* Add AWS access and secret key to `~/.bash_profile`
    ```
    sudo vim ~/.bash_profile
    ```

    ```
    export ANSIBLE_HOST_KEY_CHECKING=False
    export AWS_ACCESS_KEY={{ aws_access_key }}
    export AWS_SECRET_KEY={{ aws_secret_key }}
    ```
    

    
#### Getting Started - Mac OSX
1. Make sure there is nothing after `[staging]` and `[production]` in `devops-hosts` file.

2. Config `./devops-vars.yml`


    Yml Config options

    | variables       | descriptions              | default value|
    |-----------------|---------------------------|--------------|
    |`project_name` | project name, NO-SPACE-ALLOWED|template|
    |`keypair` |Key name to access the instance|altitudelabs|
    |`nginx_server_port` |Port number to start the server|7777|
    |`git_path` |Github repo, refer to http://github.com/{{ path }}|altitudelabs/nodeJS_template|
    |`app_js` |file for server start|server.js|


3. Go to you project root file, start deployment using
    ```
    ./devops
    ```
    * Type your Github username and password when it asked.
    * Type your Godaddy username and password when it asked.
    * After webhook url show up, go to your github repo, click [Settings] -> [Webhooks and Services] -> [Add webhook].
      * Payload URL url: `domain-name.com:autodeploy-port`, default port 8001.
      * Content type: `application/json`
      * `Just the push event`
      * `Active`

4. You're done! Now, try push new commits to the branch, you should see the site updated automatically.

#### Yml Config Variables

| variables       | descriptions              | default value|
|-----------------|---------------------------|--------------|
|`host_file_path` | hosts file path           |./devops-hosts|
|`project_name` | project name, NO-SPACE-ALLOWED|template|
|`keypair` |Key name to access the instance|altitudelabs|
|`nginx_staging_server_name` |Subdomain name for staging|'staging.{{ project_name }}.altitudelabs.com'|
|`nginx_production_server_name` |Subdomain name for production |'{{ project_name }}.altitudelabs.com'|
|`nginx_server_port` |Port number to start the server|7777|
|`git_path` |Github repo, refer to http://github.com/{{ path }}|altitudelabs/nodeJS_template|
|`git_production_branch` |Branch for production|master|
|`git_staging_branch` |Branch for staging|staging|
|`deploy_sh_file` |deploy shell script file name which store in project root folder|deploy.sh|
|`app_js` |file for server start|server.js|
|`bashrc_env_var` |environment variables|PORT={{ nginx_server_port }} NODE_ENV=production|
|`pm2_start_var`     |variables when start pm2|PORT={{ nginx_server_port }} NODE_ENV=production|
|`git_autodeploy_port` |port number for webhook|8001|
|`git_autodeploy_pull_shell` |script to git pull for webhook|sudo ssh-agent bash -c 'ssh-add /home/ubuntu/.ssh/github_rsa; git pull'|
|`git_autodeploy_deploy_shell` |script to deploy for webhook|./{{ deploy_sh_file }} && pm2 restart app|
|`vm_dependencies` |dependencies' name and version|see below|


#### Commands

###### Run all of them
  ```
  devops
  ```

###### Create EC2 instance and add to host file
  ```
  devops aws
  ```
  or
  ```
  ansible-playbook -i devops-hosts --extra-vars="@devops-vars.yml" devops-core/aws.yml
  ```

###### Provision EC2 instance and Deploy
  ```
  devops install
  ```
  or
  ```
  ansible-playbook -i devops-hosts --extra-vars="@devops-vars.yml" devops-core/install.yml
  ```

###### Add subdomain to GoDaddy ac
  ```
  devops godaddy
  ```
  or
  ```
  ansible-playbook -i devops-hosts --extra-vars="@devops-vars.yml" devops-core/godaddy.yml
  ```

###### Run python script to webhook Github
  ```
  devops webhook
  ```
  or
  ```
  ansible-playbook -i devops-hosts --extra-vars="@devops-vars.yml" devops-core/webhook.yml
  ```

###### Terminate EC2 instance and remove from host file
  ```
  devops aws-terminate
  ```
  or
  ```
  ansible-playbook -i devops-hosts --extra-vars="@devops-vars.yml" devops-core/aws-terminate.yml
  ```

