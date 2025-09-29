<!-- Quality & Security Overview -->
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)
[![Known Vulnerabilities](https://snyk.io/test/github/CalebSargeant/infra/badge.svg)](https://snyk.io/test/github/CalebSargeant/infra)

<!-- Code Quality & Maintainability -->
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)
[![Technical Debt](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=sqale_index)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)

<!-- Code Metrics -->
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=coverage)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=bugs)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)
[![Code Smells](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=code_smells)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)

<!-- Project Stats -->
[![infracost](https://img.shields.io/endpoint?url=https://dashboard.api.infracost.io/shields/json/a160e93c-2b08-4d69-b714-28ff13449df0/repos/f87bb12c-cefc-4a81-8b99-fa8af676abc9/branch/2ee22093-5387-4cd3-b45c-afeef5628480)](https://dashboard.infracost.io/org/github-n3hyh/repos/f87bb12c-cefc-4a81-8b99-fa8af676abc9?tab=branches)
[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=ncloc)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)
[![Duplicated Lines (%)](https://sonarcloud.io/api/project_badges/measure?project=CalebSargeant_infra&metric=duplicated_lines_density)](https://sonarcloud.io/summary/new_code?id=CalebSargeant_infra)

# Monolithic Deployments
Embracing the simplicity of unified infrastructure management in a fragmented world.

## MacOs Tooling
- [Homebrew](https://brew.sh/)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-macos)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)
- [Docker](https://docs.docker.com/docker-for-mac/install/)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos)

## Single-Node Kubernetes Cluster

### Assumptions
* You're using a Raspberry Pi 5 (like I am at home) as your hardware of choice for your Kubernetes single-node cluster.
* You've purchased the Pironman5 case for your Raspberry Pi 5 (this case is kick-ass, [check it out](https://docs.sunfounder.com/projects/pironman5/en/latest/)!).
* The majority of companies use Helm for their Kubernetes deployments, and they use Terragrunt to manage the Helm chart deployments. So, we'll follow this methodology to stick with "industry standards". 

### Prerequisites
- Flash an SD card or NVME drive with the latest Raspberry Pi OS Lite image (with OS customizations).
- Set it and forget it (plug the pi into power and preferably ethernet).
- Copy the SSH public key to authorized keys: `ssh-copy-id -i ~/.ssh/id_rsa.pub username@hostname`
- Install the tools you need on your local machine (`kubectl`, `helm`, `terragrunt`, `ansible`, etc.). See the MacOs Tooling section above.
- SOPS - see k3s-sops-gpg-secret ansible role

### Bootstrap

Run the following command to bootstrap your pi (You need to be inside `./ansible`):
```yaml
ansible-playbook -i hosts pi-k3s-bootstrap.yml
```

The above will install k3s, deploy a GitHub Private Runner, and install the necessary tools on the pi. View the file to see what it does.
### Deploy
Now you can deploy your Helm charts using Terragrunt.