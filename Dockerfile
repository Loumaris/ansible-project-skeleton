FROM ubuntu:bionic

WORKDIR /app

ENV ANSIBLE_VAULT_PASSWORD= \
    ANSIBLE_VAULT_PASSWORD_FILE=/root/.vault_password

RUN apt update \
    && apt install -y software-properties-common \
    && apt-add-repository --yes --update ppa:ansible/ansible \
    && apt install -y ruby git ansible

CMD ["rake", "production:ci:depoy"]
