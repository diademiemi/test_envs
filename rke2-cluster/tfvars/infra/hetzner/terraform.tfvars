network_cidr = "10.0.0.0/16"
network_name = "dev"
subnet_cidr      = "10.0.1.0/24"

# domain is not actually used for the dns records, only the subdomains are
# I change this with Ansible, I just don't want to define it in the tfvars
# default_domain = "terraform.test"

hetzner_vms = [
  {
    name = "master01"
    type = "cpx31"
    image       = "ubuntu-22.04"
    labels = {
      "rke2" = "master"
    }
    network_ip         = "10.0.1.41"
    ansible_groups = ["master"]
  },
  {
    name = "master02"
    type = "cpx31"
    labels = {
      "rke2" = "master"
    }
    image       = "ubuntu-22.04"
    network_ip         = "10.0.1.42"
    ansible_groups = ["master"]
  },
  {
    name = "master03"
    type = "cpx31"
    image       = "ubuntu-22.04"
    labels = {
      "rke2" = "master"
    }
    network_ip         = "10.0.1.43"
    ansible_groups = ["master"]
  },
  {
    name = "worker01"
    type = "cpx21"
    image       = "ubuntu-22.04"
    labels = {
      "rke2" = "worker"
    }
    network_ip         = "10.0.1.51"
    ansible_groups = ["worker"]
  },
  {
    name = "worker02"
    type = "cpx21"
    image       = "ubuntu-22.04"
    labels = {
      "rke2" = "worker"
    }
    network_ip         = "10.0.1.52"
    ansible_groups = ["worker"]
  },
  {
    name = "worker03"
    type = "cpx21"
    image       = "ubuntu-22.04"
    labels = {
      "rke2" = "worker"
    }
    network_ip         = "10.0.1.53"
    ansible_groups = ["worker"]
  },
]

hetzner_lbs = []
