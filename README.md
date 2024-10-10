# Azure VM: SLES + Docker + Azure Artifacts

SUSE Linux Enterprise Server deployment with Docker Compose on Azure VMs.

## Deployment

Generate the temporary keys to be used:

```sh
ssh-keygen -f modules/suse/id_rsa
```

Create the `.auto.tfvars` file from the template:

```sh
# Choose your distro
cp templates/suse(15|12).auto.tfvars .auto.tfvars
```

Set the `subscription_id` variable.

> [!TIP]
> Check for updates to packages installed via cloud-init user data

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

## Azure Artifacts

### Azure DevOps setup

Create an Artifact Feed of type Universal Packages in an ADO project.

> 💡 For practical implementation of this project, it is possible to select all members. However, implement minimal privilege in production.

<img src=".assets/feed.png" width=400 />

You must give [`Contributor`][1] permissions for the pipeline to publish packages. Check the [Pipelines permissions][2] sections for more information.

Now create a pipeline on ADO using [azure-pipeline.yaml](./azure-pipeline.yaml) as a template. Add the variables `projectName` and `feedName` accordingly.

Run the pipeline and confirm that the artifact has been generated.

<img src=".assets/artifact.png" width=350 />

### VM access to ADO

Add the VM System-Assigned identity to Azure DevOps.

When logged into the VM, login with the VM Managed Identity:

```sh
az login --identity --allow-no-subscriptions
```

The Azure DevOps Extension for the CLI is already installed via `userdata`.

It is necessary to run additional commands to allow a Managed Identity to connect to Azure DevOps. Follow the [documentation][3] to implemented that.


## CNI

To enable containers with advanced features, such as service endpoints, you need the [CNI][4].

More information on how to [deploy][5] the plugin and the [project][6] on GitHub.

## Crontab (SUSE 12)

Following [tutorial 1][7] and [tutorial 2][8], install Nginx.

> This was tested on SUSE 12 only

Prepare the installation:

```sh
sudo zypper addrepo -G -t yum -c 'http://nginx.org/packages/sles/12' nginx
wget http://nginx.org/keys/nginx_signing.key
sudo rpm --import nginx_signing.key
```

Install Nginx:

```sh
sudo zypper install nginx
```

Commands to control Nginx:

```sh
sudo systemctl start nginx
sudo systemctl restart nginx
sudo systemctl stop nginx
sudo systemctl status nginx
```

Instead of enabling the service directly, let's configure a `crontab`.

Create a file named `/opt/start-nginx.sh`:

```sh
echo "Starting NGINX"
sudo systemctl start nginx
echo "Completed starting NGINX"
```

Add the required permissions:

```sh
chmod +x /opt/start-nginx.sh
```

Edit the `crontab`:

```sh
crontab -e
```

Set the script path:

```sh
@reboot /opt/start-nginx.sh
```

Crontab logs can be view with the journal:

```sh
journalctl --no-hostname --output=short-precise | grep -i cron
```

---

### Clean-up

```
terraform destroy -auto-approve
```


[1]: https://learn.microsoft.com/en-us/azure/devops/artifacts/feeds/feed-permissions?view=azure-devops#permissions-table
[2]: https://learn.microsoft.com/en-us/azure/devops/artifacts/feeds/feed-permissions?view=azure-devops#pipelines-permissions
[3]: https://learn.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/service-principal-managed-identity?view=azure-devops#q-can-i-use-a-service-principal-or-managed-identity-with-azure-cli
[4]: https://learn.microsoft.com/en-us/azure/virtual-network/container-networking-overview
[5]: https://learn.microsoft.com/en-us/azure/virtual-network/deploy-container-networking#download-and-install-the-plug-in
[6]: https://github.com/Azure/azure-container-networking?tab=readme-ov-file
[7]: https://www.cyberciti.biz/faq/install-and-use-nginx-on-opensuse-linux/
[8]: https://www.cyberciti.biz/faq/how-to-install-nginx-on-suse-linux-enterprise-server-12/
