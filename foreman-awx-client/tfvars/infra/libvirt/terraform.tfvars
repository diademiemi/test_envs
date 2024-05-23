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
    url  = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  }
]

libvirt_vms = [
  {
    name = "foreman"
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
    name = "awx"
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
    name = "client"
    vcpu   = 4
    memory = 8192

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.101/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    cloudinit_use_user_data = false
    cloudinit_use_network_data = false

    ansible_enabled = false
  },
]


