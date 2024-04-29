# domain is not actually used for the dns records, only the subdomains are
# I change this with Ansible, I just don't want to define it in the tfvars
# default_domain = "terraform.test"

digitalocean_vms = [
  {
    image = "ubuntu-22-04-x64"
    name = "master01"
    size = "s-4vcpu-8gb"
    tags = ["rke2:master"]
    ansible_groups = ["master"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "master02"
    size = "s-4vcpu-8gb"
    tags = ["rke2:master"]
    ansible_groups = ["master"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "master03"
    size = "s-4vcpu-8gb"
    tags = ["rke2:master"]
    ansible_groups = ["master"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "worker01"
    size = "s-4vcpu-8gb"
    tags = ["rke2:worker"]
    ansible_groups = ["worker"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "worker02"
    size = "s-4vcpu-8gb"
    tags = ["rke2:worker"]
    ansible_groups = ["worker"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "worker03"
    size = "s-4vcpu-8gb"
    tags = ["rke2:worker"]
    ansible_groups = ["worker"]
  },
]

digitalocean_lbs = []
