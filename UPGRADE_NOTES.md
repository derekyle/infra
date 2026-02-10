# Ansible Upgrade Notes

## Summary

This upgrade transitions your Ansible setup from version 2.10.8 to the latest stable version, and updates all module syntax to be compatible with modern Ansible.

## Changes Made

### 1. Files Updated

#### [requirements.yaml](requirements.yaml)
- **Removed version pins** to allow installation of latest compatible versions
- Removed `geerlingguy.docker` version pin (was: 6.1.0)
- Removed version constraints from collections:
  - `community.general` (was: `>=3.0.0,<4.0.0`, now: latest)
  - `ansible.posix` (was: `>=1.3.0,<2.0.0`, now: latest)
  - `community.docker` (was: `>=2.0.0,<3.0.0`, now: latest)

#### [roles/media_server_init/tasks/container-apps.yml](roles/media_server_init/tasks/container-apps.yml)
- **Changed:** `community.docker.docker_compose` → `community.docker.docker_compose_v2`
- This module works with docker-compose v2 (the modern Go-based version)

#### [update_containers.yaml](update_containers.yaml)
- **Changed:** `community.docker.docker_compose` → `community.docker.docker_compose_v2`
- **Changed:** `pull: yes` → `pull: always` (new syntax)
- **Removed:** `restarted: yes` parameter (not needed with `docker_compose_v2`)

#### [roles/media_server_init/tasks/main.yml](roles/media_server_init/tasks/main.yml)
- **Changed:** All `include:` → `include_tasks:` (deprecated syntax removed in Ansible 2.16+)

#### [roles/telegraf/tasks/main.yml](roles/telegraf/tasks/main.yml)
- **Changed:** All `include:` → `include_tasks:` (deprecated syntax removed in Ansible 2.16+)

### 2. New File Created

#### [upgrade-ansible.sh](upgrade-ansible.sh)
An automated script to:
1. Install pip3
2. Remove old apt-based Ansible
3. Install latest Ansible via pip
4. Update PATH
5. Reinstall all Galaxy roles and collections

## How to Upgrade

### Run the upgrade script:

```bash
./upgrade-ansible.sh
```

After the script completes:

```bash
source ~/.bashrc
```

### Verify the upgrade:

```bash
ansible --version
ansible-galaxy collection list
ansible-galaxy list
```

## What Changed in docker_compose_v2

The new `docker_compose_v2` module:
- Works with docker-compose v2 (docker compose plugin)
- Uses different parameter syntax
- More actively maintained
- Better performance

### Key Parameter Changes:
- `pull: yes` → `pull: always` or `pull: policy`
- `restarted: yes` → Handled automatically by `state: present`
- Works with `docker compose` (space) instead of `docker-compose` (hyphen)

## Compatibility Notes

### Requires:
- **Ansible:** 2.15.0 or higher
- **Docker Compose:** v2 (installed as Docker plugin)
- **Python:** 3.8 or higher

### Docker Compose v2 Installation

If you don't have docker-compose v2 on your target server:

```bash
# On the target server (mediaserver)
sudo apt update
sudo apt install docker-compose-plugin
```

Verify:
```bash
docker compose version
```

## Testing After Upgrade

1. **Syntax check:**
   ```bash
   ansible-playbook run.yaml --syntax-check --vault-password-file .vault-password
   ```

2. **Dry run:**
   ```bash
   ansible-playbook -b run.yaml --check --vault-password-file .vault-password
   ```

3. **Run with specific tags:**
   ```bash
   ansible-playbook -b run.yaml --tags container-apps --limit mediaserver --vault-password-file .vault-password
   ```

## Rollback Instructions

If you need to rollback:

```bash
# Remove pip-based Ansible
pip3 uninstall ansible ansible-core

# Reinstall old version via apt
sudo apt install ansible=2.10.8*

# Reinstall old collection versions
ansible-galaxy collection install community.docker:2.7.14 --force
ansible-galaxy collection install community.general:3.8.10 --force
ansible-galaxy collection install ansible.posix:1.6.2 --force

# Revert code changes (git)
git checkout roles/media_server_init/tasks/main.yml
git checkout roles/media_server_init/tasks/container-apps.yml
git checkout roles/telegraf/tasks/main.yml
git checkout update_containers.yaml
git checkout requirements.yaml
```

## Additional Notes

- The vault.yaml file is encrypted with Ansible Vault and was not modified
- All Tailscale configuration changes from earlier are preserved
- The nzbget-tailscale service configuration is unchanged
