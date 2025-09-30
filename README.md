# Infrastructure Bootstrap

Ansible-based host-level provisioning for K3s GitOps platform.

## Purpose

This repository contains Ansible playbooks and roles for:
- System preparation (OS updates, dependencies)
- K3s installation and configuration
- Helm installation
- Node.js installation (optional)

## Prerequisites

- Ubuntu 20.04+ or similar Linux distribution
- Ansible 2.9+ installed on control machine
- SSH access to target nodes
- Sudo privileges on target nodes

## Quick Start

```bash
# 1. Update inventory
vim ansible/inventory/hosts.yaml

# 2. Configure variables
vim ansible/inventory/group_vars/all.yaml

# 3. Run bootstrap
ansible-playbook ansible/playbooks/bootstrap.yaml

# 4. Verify installation
ssh <target-host>
k3s kubectl get nodes
```

## Directory Structure

```
ansible/
├── inventory/          # Target hosts and variables
├── roles/             # Reusable Ansible roles
├── playbooks/         # Executable playbooks
└── ansible.cfg        # Ansible configuration
scripts/               # Helper scripts
docs/                  # Additional documentation
```

## Usage

### Full Bootstrap
```bash
ansible-playbook ansible/playbooks/bootstrap.yaml
```

### Individual Components
```bash
# K3s only
ansible-playbook ansible/playbooks/k3s-install.yaml

# Helm only
ansible-playbook ansible/playbooks/helm-install.yaml
```

### Uninstall
```bash
ansible-playbook ansible/playbooks/uninstall.yaml
```

## Configuration

### Inventory

Edit `ansible/inventory/hosts.yaml` to define your target nodes:

```yaml
all:
  children:
    k3s_servers:
      hosts:
        k3s-node-01:
          ansible_host: 192.168.1.100
          ansible_user: ubuntu
```

### Variables

Edit `ansible/inventory/group_vars/all.yaml` for global settings:

```yaml
k3s_version: v1.28.3+k3s1
k3s_disable_traefik: true
helm_version: v3.13.0
```

## Roles

### system-prep
- Update apt packages
- Install required dependencies
- Configure firewall rules

### k3s
- Download and install K3s
- Configure K3s server
- Setup kubeconfig for non-root access

### helm
- Download and install Helm binary
- Configure Helm repositories

### node
- Install Node.js and npm (optional)

## Next Steps

After bootstrap completes:
1. Verify K3s cluster: `k3s kubectl get nodes`
2. Check kubeconfig: `kubectl config view`
3. Proceed to `infrastructure-platform` repo for platform components

## Troubleshooting

### K3s not starting
```bash
sudo systemctl status k3s
sudo journalctl -u k3s -f
```

### Permission denied for kubectl
```bash
# Fix kubeconfig permissions
sudo chown $USER:$USER ~/.kube/config
```

### Ansible connection issues
```bash
# Test connectivity
ansible all -m ping -i ansible/inventory/hosts.yaml
```

## Support

Refer to `docs/infrastructure-architecture.md` for full infrastructure design.
