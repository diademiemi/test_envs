network_cidr = "10.0.0.0/16"
network_name = "dev"
subnet_cidr      = "10.0.1.0/24"

# domain is not actually used for the dns records, only the subdomains are
# I change this with Ansible, I just don't want to define it in the tfvars
# default_domain = "terraform.test"

hetzner_vms = [
  {
    name = "mc"
    type = "cpx31"
    image       = "ubuntu-22.04"
  },
]

hetzner_lbs = []
