# Latest Ubuntu LTS
FROM ubuntu:14.04

# Install ansible
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get install -y ansible


# Add playbooks and roles
COPY . /.ansible
WORKDIR /.ansible

# Install dependencies with ansible
RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN ansible-playbook --extra-vars="@devops-vars.yml" devops-core/docker.yml -c local

RUN mkdir /zappwears
WORKDIR /zappwears
RUN pwd

