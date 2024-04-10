Ansible Project - minecraft_testenv
========================================

This is a minecraft_testenv project

Hetzner
-------

```
# REQUIRED
export TF_VAR_hcloud_api_token=...  # e.g. 1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef

# OPTIONAL
export TF_VAR_default_datacenter=...  # e.g. ash-dc1
export TF_VAR_network_zone=...  # e.g. us-east
# DNS
export TF_VAR_cloudflare_api_token=...  # e.g. 1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef

export TF_VAR_cloudflare_default_domain_id=...  # e.g. 1234567890abcdef1234567890abcdef
## OR
export TF_VAR_cloudflare_default_domain=... e.g. example.com

```

Using Template
--------------
To use this minecraft_testenv for a new role, run


```bash
export NEW_PROJECT_NAME="NEW_NAME"

find README.md inventories playbooks vars files -type f -exec sed -i "s/minecraft_testenv/${NEW_PROJECT_NAME}/g" {} + # Do not run this more than once

# Remove this section from README.md
sed -i "/Using Template/Q" README.md
```

This is also provided as a script as `replace.sh`.  
