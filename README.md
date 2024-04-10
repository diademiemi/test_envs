# Test Environments
Test environments I use for development purposes

Test Environment | Description | Platforms
--- | --- | ---
[minecraft-testenv](./minecraft-testenv) | A test environment for Minecraft servers | Libvirt, DigitalOcean, Hetzner, localhost
[rke2-cluster](./rke2-cluster) | A test environment for RKE2 Kubernetes clusters | Libvirt, DigitalOcean, Hetzner
[rancher-platform-rke2-cluster](./rancher-platform-rke2-cluster) | A test environment for Rancher Platform with an RKE2 Kubernetes cluster | Libvirt, DigitalOcean, Hetzner

## Deployment
Check the README.md in each test environment for deployment instructions.

### Terraform
Terraform is used to create the infrastructure for the test environments. I make use of my [diademiemi/terraform_standard_environment](https://github.com/diademiemi/terraform_standard_environment) repository as a submodule for the Terraform code. Only the variables are stored in the test environment directories.

## License
[MIT](./LICENSE)