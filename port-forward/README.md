Ansible Project - port-forward
========================================

# [Info](#info)
This project is a collection of Ansible playbooks and roles to launch a temporary VPS which has a port forward to your local machine through Wireguard. It installs Wireguard on your local machine and a remote server, connects them together and sets up the port forward.

- [Ansible Project - port-forward](#ansible-project---port-forward)
- [Info](#info)
- [Requirements](#requirements)
- [Usage](#usage)
  - [Preparation](#preparation)
  - [Launch the infrastructure](#launch-the-infrastructure)
  - [Start port forwarding](#start-port-forwarding)
- [Notes](#notes)
- [Infrastructure](#infrastructure)
  - [Infrastructure Providers](#infrastructure-providers)
    - [Hetzner](#hetzner)
    - [DigitalOcean](#digitalocean)
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

## [Start port forwarding](#deploy)
```bash
ansible-playbook -i inventories/terraform playbooks/port-forward.yml
```

# [Notes](#notes)
The default ports to be forwarded are `80/TCP`, `443/TCP`, `25565/TCP`, `19132/TCP` and `19132/UDP`. You can change these by setting the `portforward_rules` variable in the `port-forward.yml` playbook or giving the variable as an extra argument.

The default Wireguard subnet is `192.168.150.0/24`. With the `portforward` host being `192.168.150.1/24` and the `localhost` host being `192.168.150.2/24`. You can change these by setting the `wireguard_subnet` variable in [inventories/terraform/group_vars/all/yml](inventories/terraform/group_vars/all.yml) or giving the variable as an extra argument, e.g. `-e wireguard_subnet=192.168.150.0/24`.

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
