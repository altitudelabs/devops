Altitude Labs Devops
===

## Table of content
1. [Deployment flow](#deployment-flow)

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
1. Clone this repository into your project `proj/` and add it to `.gitignore`.
   ```
   cd proj
   git clone https://github.com/altitudelabs/devops.git
   vim .gitignore
   ```

2. Create and config `devops-vars.yml` under `proj/`. You may take `example-devops-vars.yml` as starting point.
    ```
    cp devops/example-devops-vars.yml ./devops-vars.yml
    vim devops-vars.yml
    ```

    Yml Config options

    | variables       | descriptions              | default value|
    |-----------------|---------------------------|--------------|
    |`project_name` | project name, NO-SPACE-ALLOWED|template|
    |`keypair` |Key name to access the instance|altitudelabs|
    |`nginx_server_port` |Port number to start the server|7777|
    |`git_path` |Github repo, refer to http://github.com/{{ path }}|altitudelabs/nodeJS_template|
    |`app_js` |file for server start|server.js|

3. Go to `devops`. Make sure there is nothing after `[staging]` and `[production]` in `devops-hosts` file.
    ```
    cd devops
    vim devops-hosts
    ```

4. Start deployment using
    ```
    ./devops
    ```
    * Type your Github username and password when it asked.
    * Type your Godaddy username and password when it asked.

5. To deploy again without server setup, run
    ```
    ./devops deploy
    ```

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
  ansible-playbook -i devops-hosts --extra-vars="@../devops-vars.yml" devops-core/aws.yml
  ```

###### Provision EC2 instance and Deploy
  ```
  devops install
  ```
  or
  ```
  ansible-playbook -i devops-hosts --extra-vars="@../devops-vars.yml" devops-core/install.yml
  ```

###### Add subdomain to GoDaddy ac
  ```
  devops godaddy
  ```
  or
  ```
  ansible-playbook -i devops-hosts --extra-vars="@../devops-vars.yml" devops-core/godaddy.yml
  ```

###### Deploy
  ```
  devops deploy
  ```
  or
  ```
  ansible-playbook -i devops-hosts --extra-vars="@../devops-vars.yml" devops-core/webhook.yml
  ```

###### Terminate EC2 instance and remove from host file
  ```
  devops aws-terminate
  ```
  or
  ```
  ansible-playbook -i devops-hosts --extra-vars="@../devops-vars.yml" devops-core/aws-terminate.yml
  ```

