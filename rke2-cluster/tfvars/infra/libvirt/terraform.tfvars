# domain is not actually used for the dns records, only the subdomains are
# I change this with Ansible, I just don't want to define it in the tfvars
# domain       = "terraform.test"
network      = "192.168.21.0/24"
network_name = "terraform"
network_mode = "nat"

# Not strictly necessary, cloudinit_image can be a URL itself, but this makes it so that it only needs to be downloaded once and gets reused
download_urls = [
  { 
    dest = "/tmp/focal-server-cloudimg-amd64.img"
    url  = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  }
]

libvirt_vms = [
  {
    name = "master01"
    vcpu   = 4
    memory = 8192
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.51/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups = ["master"]
  },
  {
    name = "master02"
    vcpu   = 4
    memory = 8192
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.52/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups = ["master"]
  },
  {
    name = "master03"
    vcpu   = 4
    memory = 8192
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.53/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups = ["master"]
  },
  {
    name = "worker01"
    vcpu   = 2
    memory = 8192
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.61/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups = ["worker"]
  },
  {
    name = "worker02"
    vcpu   = 2
    memory = 8192
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.62/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups = ["worker"]
  },
  {
    name = "worker03"
    vcpu   = 2
    memory = 8192
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.63/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups = ["worker"]
  },
]


