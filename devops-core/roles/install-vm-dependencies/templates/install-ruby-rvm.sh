#!/usr/bin/env bash

# Checking if RVM is installed
# if ! [ -d "~/.rvm" ]; then
#     echo "Installing RVM..."
#     \curl -sSL https://get.rvm.io | bash -s stable
#     source ~/.rvm/scripts/rvm
#     echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
# else
#     echo "Updating RVM..."
#     rvm get stable
# fi;

# echo -n "RVM version is: "
# rvm --version

# {% if 'version' in vm_dependencies.ruby %}
# echo "Installing Ruby..."
# rvm install {{vm_dependencies.ruby.version}}

# echo "Making installed Ruby the default one..."
# rvm use ruby {{vm_dependencies.ruby.version}}

# {% else %}
# echo "Installing Ruby..."
# rvm install ruby

# echo "Making installed Ruby the default one..."
# rvm use ruby --default
# {% endif %}

# echo "Installing latest version of Ruby Gems..."
# rvm rubygems current