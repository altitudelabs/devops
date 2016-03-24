Altitude Labs Devops
===

## Table of content
1. [Development flow](#development-flow)
2. [Deployment flow](#deployment-flow)

## <a name="development-flow"></a>Development flow

#### Prerequisite
1. Docker (check [here](https://github.com/altitudelabs/devops/wiki/Docker/_edit#install-on-mac) on how to install)

#### Running your application with Docker
1) Launch **Docker Quickstart Terminal**. You should see a welcome message in terminal.

![](https://cloud.githubusercontent.com/assets/5036163/13979800/d3e2e5fc-f115-11e5-9ff3-1777a81b1b06.png)

2) Go to your project directory. And create a file called `Dockerfile`. This file will be used to create a **docker image**

![](https://cloud.githubusercontent.com/assets/5036163/13980060/3f2a60f0-f117-11e5-9f64-b5d6ffa90312.png)

3) Make your `Dockerfile`. This file is to configure the docker image. You should set up the dependencies here. 

For the syntax, you may refer to [Docker official site](https://docs.docker.com/engine/reference/builder/).

_Example of_ `Dockerfile`

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

    RUN mkdir /src
    WORKDIR /src

![](https://cloud.githubusercontent.com/assets/5036163/13980814/74b0cc1a-f11b-11e5-8b2e-6d5c3b96ab51.png)

4) Build your docker image with `Dockerfile` you have created.

Type `$ docker build -t image_name .`

`.` refers to the directory of folder containing `Dockerfile`.

Type `$ docker images` to check the image you have created.

In this example, you can see that there is in image called `image_name` in the repository.

![](https://cloud.githubusercontent.com/assets/5036163/13981191/80ecbd5c-f11d-11e5-962a-ca5e62de614a.png)

5) Run your server within docker container

Type `$ docker run -v [repo_path]:/src -p [server_port_in_docker]:[server_port_in_local] [image_name] [cmd_to_start_server]`

![](https://cloud.githubusercontent.com/assets/5036163/13981535/9c7aaece-f11f-11e5-8aee-930c9f7ba2de.png)

6) Do ssh tunnelling for docker container (For Mac users only, skip if you are using Linux)

Launch another **Docker Quickstart Terminal** 

And type `docker-machine ssh default -f -N -L [server_port_in_docker]:localhost:[server_port_in_local]`

This allows you to access the docker container with `localhost`

![](https://cloud.githubusercontent.com/assets/5036163/13981848/898fdc1a-f121-11e5-9252-288432fc4575.png)

7) Open your browser and go to the url on which the server is running.

You should see the server is up and running.

![](https://cloud.githubusercontent.com/assets/5036163/13981787/2bc968bc-f121-11e5-8f61-8aadcfaa6334.png) 

8) You can then edit your project files as usual. 

   For useful docker commands, you may check [here](https://github.com/altitudelabs/devops/wiki/Docker/_edit#cmd).
   
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
* Docker (see [_wiki_](https://github.com/altitudelabs/devops/wiki/Docker/_edit#install-on-mac))


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
1. Make sure there is nothing after `[launched]` in `devops-hosts` file.

2. Config `./devops-vars.yml`

3. Go to you project root file, start deployment using
    ```
    ./devops
    ```
    * Type your Github username and password when it asked.
    * Type your Godaddy username and password when it asked. If this is success, you should see the site on the path as in `./devops-vars.yml` configurations
    * After webhook url show up, go to your github repo, click [Settings] -> [Webhooks and Services] -> [Add webhook].
      * Payload URL url: `domain-name.com:autodeploy-port`, default port 8001.
      * Content type: `application/json`
      * `Just the push event`
      * `Active`

4. You're done! Now, try push new commits to the branch, you should see the site updated automatically.

See Wiki page for more details.


