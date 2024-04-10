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
    name = "mc"
    vcpu   = 4
    memory = 16384
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

  },
]


