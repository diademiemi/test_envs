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
    name = "upstream"
    ansible_name = "upstream-lb"
    vcpu   = 1
    memory = 1024
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.50/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    cloudinit_custom_user_data = <<-EOT
packages:
  - haproxy

write_files:
  - path: /etc/haproxy/haproxy.cfg
    content: |
      global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

      defaults
        log     global
        mode    tcp
        option  tcplog
        timeout connect 5000ms
        timeout client  50000ms
        timeout server  50000ms

      frontend tcp_front_80
        bind *:80
        default_backend tcp_back_80

      frontend tcp_front_443
        bind *:443
        default_backend tcp_back_443

      backend tcp_back_80
        balance roundrobin
        server srv1 192.168.21.51:80 check
        server srv2 192.168.21.52:80 check
        server srv3 192.168.21.53:80 check

      backend tcp_back_443
        balance roundrobin
        server srv1 192.168.21.51:443 check
        server srv2 192.168.21.52:443 check
        server srv3 192.168.21.53:443 check

runcmd:
  - systemctl enable haproxy
  - systemctl start haproxy

EOT

  },
  {
    name = "downstream-workers"
    ansible_name = "downstream-workers-lb"
    vcpu   = 1
    memory = 1024
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.60/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    cloudinit_custom_user_data = <<-EOT
packages:
  - haproxy

write_files:
  - path: /etc/haproxy/haproxy.cfg
    content: |
      global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

      defaults
        log     global
        mode    tcp
        option  tcplog
        timeout connect 5000ms
        timeout client  50000ms
        timeout server  50000ms

      frontend tcp_front_80
        bind *:80
        default_backend tcp_back_80

      frontend tcp_front_443
        bind *:443
        default_backend tcp_back_443

      backend tcp_back_80
        balance roundrobin
        server srv1 192.168.21.64:80 check
        server srv2 192.168.21.65:80 check
        server srv3 192.168.21.66:80 check

      backend tcp_back_443
        balance roundrobin
        server srv1 192.168.21.64:443 check
        server srv2 192.168.21.65:443 check
        server srv3 192.168.21.66:443 check

runcmd:
  - systemctl enable haproxy
  - systemctl start haproxy

EOT

  },
  {
    name = "upstream01"
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

    ansible_groups = ["upstream"]
  },
  {
    name = "upstream02"
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

    ansible_groups = ["upstream"]
  },
  {
    name = "upstream03"
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

    ansible_groups = ["upstream"]
  },
  {
    name = "downstream01"
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

    ansible_groups = ["downstream", "downstream_master"]
  },
  {
    name = "downstream02"
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

    ansible_groups = ["downstream", "downstream_master"]
  },
  {
    name = "downstream03"
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

    ansible_groups = ["downstream", "downstream_master"]
  },
  {
    name = "downstream04"
    vcpu   = 2
    memory = 6144
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.64/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups = ["downstream", "downstream_worker"]
  },
  {
    name = "downstream05"
    vcpu   = 2
    memory = 6144
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.65/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups = ["downstream", "downstream_worker"]
  },
  {
    name = "downstream06"
    vcpu   = 2
    memory = 6144
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.66/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups = ["downstream", "downstream_worker"]
  },
  {
    name = "client01"
    vcpu   = 1
    memory = 1024
    cloudinit_image = "/tmp/focal-server-cloudimg-amd64.img"

    password_auth         = true
    network_interfaces = [
      {
        name         = "ens3"
        network_name = "terraform"

        dhcp = false

        ip      = "192.168.21.71/24"
        gateway = "192.168.21.1"

        nameservers = [
          "192.168.21.1"
        ]
      }
    ]

    ansible_groups   = ["linux"]
  },
]


