# domain is not actually used for the dns records, only the subdomains are
# I change this with Ansible, I just don't want to define it in the tfvars
# default_domain = "terraform.test"

digitalocean_vms = [
  {
    image = "ubuntu-22-04-x64"
    name = "portforward"
    size = "s-4vcpu-8gb"
  },
]

digitalocean_lbs = []
