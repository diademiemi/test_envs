network_cidr = "10.0.0.0/16"
network_name = "dev"
subnet_cidr      = "10.0.1.0/24"

# domain is not actually used for the dns records, only the subdomains are
# I change this with Ansible, I just don't want to define it in the tfvars
# default_domain = "terraform.test"

hetzner_vms = [
  {
    name = "upstream01"
    type = "cpx31"
    image       = "ubuntu-22.04"
    labels = {
      "rancher" = "upstream"
      "loadbalancer" = "upstream"
    }
    network_ip         = "10.0.1.41"
    ansible_groups = ["upstream"]
  },
  {
    name = "upstream02"
    type = "cpx31"
    labels = {
      "rancher" = "upstream"
      "loadbalancer" = "upstream"
    }
    image       = "ubuntu-22.04"
    network_ip         = "10.0.1.42"
    ansible_groups = ["upstream"]
  },
  {
    name = "upstream03"
    type = "cpx31"
    image       = "ubuntu-22.04"
    labels = {
      "rancher" = "upstream"
      "loadbalancer" = "upstream"
    }
    network_ip         = "10.0.1.43"
    ansible_groups = ["upstream"]
  },
  {
    name = "downstream01"
    type = "cpx21"
    image       = "ubuntu-22.04"
    labels = {
      "rancher" = "downstream"
    }
    network_ip         = "10.0.1.51"
    ansible_groups = ["downstream", "downstream_master"]
  },
  {
    name = "downstream02"
    type = "cpx21"
    image       = "ubuntu-22.04"
    labels = {
      "rancher" = "downstream"
    }
    network_ip         = "10.0.1.52"
    ansible_groups = ["downstream", "downstream_master"]
  },
  {
    name = "downstream03"
    type = "cpx21"
    image       = "ubuntu-22.04"
    labels = {
      "rancher" = "downstream"
    }
    network_ip         = "10.0.1.53"
    ansible_groups = ["downstream", "downstream_master"]
  },
  {
    name = "downstream04"
    type = "cpx31"
    image       = "ubuntu-22.04"
    labels = {
      "rancher" = "downstream"
      "loadbalancer" = "downstream-workers"
    }
    network_ip         = "10.0.1.61"
    ansible_groups = ["downstream", "downstream_worker"]
  },
  {
    name = "downstream05"
    type = "cpx31"
    image       = "ubuntu-22.04"
    labels = {
      "rancher" = "downstream"
      "loadbalancer" = "downstream-workers"
    }
    network_ip         = "10.0.1.62"
    ansible_groups = ["downstream", "downstream_worker"]
  },
  {
    name = "downstream06"
    type = "cpx31"
    image       = "ubuntu-22.04"
    labels = {
      "rancher" = "downstream"
      "loadbalancer" = "downstream-workers"
    }
    network_ip         = "10.0.1.63"
    ansible_groups = ["downstream", "downstream_worker"]
  },
  {
    name = "client01"
    type = "cpx11"
    image       = "ubuntu-22.04"
    labels = {
      "rancher" = "client"
    }
    network_ip         = "10.0.1.71"
  }
]

hetzner_lbs = [
  for i in ["upstream", "downstream-workers"] :
  {
    name        = "${i}"

    network_zone = "eu-central"

    targets = [
      {
        type = "label_selector"
        selector = "loadbalancer=${i}"
      }
    ]

    services = [
      {
        protocol = "tcp"
        listen_port = 80
        destination_port = 80
      },
      {
        protocol = "tcp"
        listen_port = 443
        destination_port = 443
      }
    ]
  }
]
