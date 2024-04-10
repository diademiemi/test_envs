# domain is not actually used for the dns records, only the subdomains are
# I change this with Ansible, I just don't want to define it in the tfvars
# default_domain = "terraform.test"
default_project = "rancher_test"

digitalocean_vms = [
  {
    image = "ubuntu-22-04-x64"
    name = "upstream01"
    size = "s-4vcpu-8gb"
    tags = ["rancher:upstream", "loadbalancer:upstream"]
    ansible_groups = ["upstream"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "upstream02"
    size = "s-4vcpu-8gb"
    tags = ["rancher:upstream", "loadbalancer:upstream"]
    ansible_groups = ["upstream"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "upstream03"
    size = "s-4vcpu-8gb"
    tags = ["rancher:upstream", "loadbalancer:upstream"]
    ansible_groups = ["upstream"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "downstream01"
    size = "s-4vcpu-8gb"
    tags = ["rancher:downstream"]
    ansible_groups = ["downstream", "downstream_master"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "downstream02"
    size = "s-4vcpu-8gb"
    tags = ["rancher:downstream"]
    ansible_groups = ["downstream", "downstream_master"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "downstream03"
    size = "s-4vcpu-8gb"
    tags = ["rancher:downstream"]
    ansible_groups = ["downstream", "downstream_master"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "downstream04"
    size = "s-4vcpu-8gb"
    tags = ["rancher:downstream", "loadbalancer:downstream-workers"]
    ansible_groups = ["downstream", "downstream_worker"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "downstream05"
    size = "s-4vcpu-8gb"
    tags = ["rancher:downstream", "loadbalancer:downstream-workers"]
    ansible_groups = ["downstream", "downstream_worker"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "downstream06"
    size = "s-4vcpu-8gb"
    tags = ["rancher:downstream", "loadbalancer:downstream-workers"]
    ansible_groups = ["downstream", "downstream_worker"]
  },
  {
    image = "ubuntu-22-04-x64"
    name = "client01"
    size = "s-4vcpu-8gb"
    tags = ["rancher:client"]
    ansible_groups = ["client"]
  }
]

digitalocean_lbs = [
  for i in ["upstream", "downstream-workers"] :
  {
    name        = "${i}"
    project     = "rancher_test"
    region      = "ams3"
    droplet_tag = "loadbalancer:${i}"

    healthcheck = {
      port                     = "${i == "upstream" ? 9345 : 80}"
      protocol                 = "tcp"
      check_interval_seconds   = 10
      response_timeout_seconds = 5
      unhealthy_threshold      = 3
      healthy_threshold        = 5
    }

    forwarding_rules = [
      {
        entry_port      = 80
        entry_protocol  = "http"
        target_port     = 80
        target_protocol = "http"
      },
      {
        entry_port      = 443
        entry_protocol  = "https"
        target_port     = 443
        target_protocol = "https"
        tls_passthrough = true
      },
    ]
  }
]
