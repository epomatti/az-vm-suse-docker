# Azure VM running SLES + Docker

Automation to provision a SUSE Linux Enterprise Server with Docker Compose.

Generate the temporary keys to be used:

```sh
ssh-keygen -f modules/suse/id_rsa
```

Create the resources:

```sh
terraform init
terraform apply -auto-approve
```

Connect to the virtual machine:

```sh
ssh -i modules/suse/id_rsa suseadmin@<<PUBLIC-IP>>
```

Check `cloud-init`:

```sh
cloud-init status
```


https://docs.docker.com/compose/install/standalone/
https://scc.suse.com/packages?name=SUSE%20Linux%20Enterprise%20Server&version=12.5&arch=x86_64&query=docker-compose&module=
