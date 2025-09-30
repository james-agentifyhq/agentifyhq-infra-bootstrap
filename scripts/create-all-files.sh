#!/bin/bash
set -e

echo "Creating infrastructure-bootstrap files..."

# Change to bootstrap directory
cd "$(dirname "$0")/.."

# Ansible configuration
cat > ansible/ansible.cfg << 'EOF'
[defaults]
inventory = inventory/hosts.yaml
remote_user = ubuntu
host_key_checking = False
retry_files_enabled = False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
EOF

# Inventory hosts
cat > ansible/inventory/hosts.yaml << 'EOF'
all:
  children:
    k3s_servers:
      hosts:
        k3s-node-01:
          ansible_host: 192.168.1.100  # Change to your node IP
          ansible_user: ubuntu          # Change to your SSH user
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
EOF

# Group variables
cat > ansible/inventory/group_vars/all.yaml << 'EOF'
---
# K3s Configuration
k3s_version: v1.28.3+k3s1
k3s_disable_traefik: true  # We'll install Traefik via Helm
k3s_disable_servicelb: false
k3s_write_kubeconfig_mode: '0644'

# Helm Configuration
helm_version: v3.13.0
helm_install_dir: /usr/local/bin

# Node.js Configuration (optional)
nodejs_version: "20.x"
install_nodejs: false  # Set to true if needed

# Firewall Configuration
configure_firewall: true
allowed_ports:
  - 6443/tcp   # Kubernetes API
  - 10250/tcp  # Kubelet
  - 30080/tcp  # Traefik HTTP
  - 30443/tcp  # Traefik HTTPS
EOF

echo "Ansible configuration files created!"
