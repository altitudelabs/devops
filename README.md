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
* Github Project (You need Admin permission to access 'Setting' page )
* deploy.sh in project root
* AWS access key and secret key
* Key pair for EC2 instance, for example, altitudelabs.pem
* Godaddy username and password


## Preparation
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
    
## Getting Started - Mac OSX
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
