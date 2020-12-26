FROM ruby:2.6-slim

WORKDIR /app

ENV ANSIBLE_VAULT_PASSWORD= \
    ANSIBLE_VAULT_PASSWORD_FILE=/root/.vault_password

RUN apt update && apt install -y gnupg && \
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/source.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
    apt update && apt install -y ansible git

CMD ["rake", "production:ci:depoy"]
