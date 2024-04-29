Ansible Project - rke2-cluster
========================================

# [Info](#info)
This project is a collection of Ansible playbooks and roles to deploy an RKE2 Kubernetes cluster.

- [Ansible Project - rke2-cluster](#ansible-project---rke2-cluster)
- [Info](#info)
- [Requirements](#requirements)
- [Usage](#usage)
  - [Preparation](#preparation)
  - [Launch the infrastructure](#launch-the-infrastructure)
  - [Deploy the RKE2 cluster](#deploy-the-rke2-cluster)
  - [Stop the infrastructure](#stop-the-infrastructure)
- [Notes](#notes)
- [Infrastructure](#infrastructure)
  - [Infrastructure Providers](#infrastructure-providers)
    - [Hetzner](#hetzner)
    - [DigitalOcean](#digitalocean)
    - [Libvirt](#libvirt)
  - [DNS Providers](#dns-providers)
    - [DigitalOcean](#digitalocean-1)
    - [Cloudflare](#cloudflare)
    - [VyOS](#vyos)
    - [/etc/hosts](#etchosts)

# [Requirements](#req)
- Terraform
- Ansible
- Python3

# [Usage](#usage)

## [Preparation](#prep)
```bash
# Install required python packages
pip install -r requirements.txt

# Install required ansible packages
ansible-galaxy install -r requirements.yml
```

## [Launch the infrastructure](#launch)
Read the [Infrastructure](#infra) section for more information on variables and providers.
```bash
ansible-playbook -i inventories/terraform playbooks/terraform.yml
```

## [Deploy the RKE2 cluster](#deploy)
```bash
ansible-playbook -i inventories/terraform playbooks/rke2.yml
```

## [Stop the infrastructure](#stop)
```bash
ansible-playbook -i inventories/terraform playbooks/terraform.yml -e state=destroy
```

# [Notes](#notes)

# [Infrastructure](#infra)

## [Infrastructure Providers](#providers)

The default domain for all the providers is `terraform.test`. You can change this by setting the Terraform `default_domain` variable, e.g. `export TF_VAR_default_domain=example.com`.

The domain deployed within the VMs has no effect on the DNS records made (except for the /etc/hosts provider), it is just to set a hostname. Only subdomains are passed through to the DNS provider, e.g. `upstream.terraform.test` would be passed through as `upstream`. This way, the DNS provider vars can be set to any domain.

### [Hetzner](#hetzner)
Status: Done  

```bash
export TF_VAR_hcloud_api_token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# OPTIONAL
export TF_VAR_default_domain=terraform.test
export TF_VAR_default_datacenter=ash-dc1
export TF_VAR_network_zone=us-east
```

**Deploy**
Add `-e provider=hetzner` to the command, e.g.
```bash
ansible-playbook -i inventories/terraform playbooks/terraform.yml -e provider=hetzner
```


### [DigitalOcean](#digitalocean)
Status: Done

**Setup Variables**
```bash
export TF_VAR_digitalocean_api_token=dop_v1_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# OPTIONAL
export TF_VAR_default_domain=terraform.test
export TF_VAR_default_region=ams3
export TF_VAR_default_project="test"
```

**Deploy**
Add `-e provider=digitalocean` to the command, e.g.
```bash
ansible-playbook -i inventories/terraform playbooks/terraform.yml -e provider=digitalocean
```

### [Libvirt](#libvirt)
Status: WIP  

```bash
# OPTIONAL, not needed for local libvirt, this is the default
export TF_VAR_libvirt_uri=qemu:///system
export TF_VAR_default_domain=terraform.test


```

Libvirt automatically creates DNS entries for the VMs, so you do not need to set up a DNS provider.
To use this DNS server, you will need to set the server on your machine for the domain you used.
For systems using `systemd-resolved`, you can use the following command:
```bash

**Deploy**
Add `-e provider=libvirt` to the command, e.g.
```bash
ansible-playbook -i inventories/terraform playbooks/terraform.yml -e provider=libvirt
```

## [DNS Providers](#dns)

### [DigitalOcean](#digitalocean-dns)
Status: Done

```bash
export TF_VAR_digitalocean_api_token=dop_v1_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

export TF_VAR_digitalocean_default_domain=example.com
# OR (If you would like to use the domain ID instead of the domain name)
export TF_VAR_digitalocean_default_domain_id=123456789

```

**Deploy**
Add `-e dns_provider=digitalocean` to the command, e.g.

```bash
ansible-playbook -i inventories/terraform playbooks/terraform.yml -e dns_provider=digitalocean
```

### [Cloudflare](#cloudflare)
Status: Done

```bash
export TF_VAR_cloudflare_api_token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

export TF_VAR_cloudflare_default_domain=example.com
# OR (If you would like to use the domain ID instead of the domain name)
export TF_VAR_cloudflare_default_domain_id=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

```

**Deploy**
Add `-e dns_provider=cloudflare` to the command, e.g.

```bash
ansible-playbook -i inventories/terraform playbooks/terraform.yml -e dns_provider=cloudflare
```

### [VyOS](#vyos)
Status: Done

```bash
# OPTIONAL, these are the defaults. since this is fully local, the tfvars already have these values
export TF_VAR_vyos_ssh_user=vyos
export TF_VAR_vyos_ssh_password=vyos
export TF_VAR_vyos_ssh_port=22
export TF_VAR_vyos_ssh_ip=192.168.21.2

export TF_VAR_vyos_default_domain=example.com

```

**Deploy**
Add `-e dns_provider=vyos` to the command, e.g.

```bash
ansible-playbook -i inventories/terraform playbooks/terraform.yml -e dns_provider=vyos
```

You can use this DNS for local testing by running the following command:
```bash
resolvectl dns virbr1 192.168.21.2  # Or the IP you set for the vyos_ssh_ip
```

### [/etc/hosts](#etchosts)
Status: Done
Notes: Not achieved through Terraform, this is coded into the Ansible playbook.

```bash
# No variables
```

**Deploy**
Add `-e dns_provider=etchosts` to the command, e.g.

```bash
ansible-playbook -i inventories/terraform playbooks/terraform.yml -e dns_provider=etchosts
```
The playbook will prompt for your sudo password to edit the `/etc/hosts` file.
