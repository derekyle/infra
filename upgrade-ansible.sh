#!/bin/bash
set -e

echo "=== Ansible Upgrade Script ==="
echo ""

echo "Step 1: Installing pip3..."
sudo apt update
sudo apt install -y python3-pip

echo ""
echo "Step 2: Removing old Ansible from apt..."
sudo apt remove -y ansible || true

echo ""
echo "Step 3: Installing latest stable Ansible via pip..."
pip3 install --user --upgrade ansible

echo ""
echo "Step 4: Updating PATH (add this to your ~/.bashrc if not already there)..."
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

echo ""
echo "Step 5: Verifying Ansible version..."
ansible --version

echo ""
echo "Step 6: Installing Ansible Galaxy roles..."
ansible-galaxy install -r requirements.yaml --force

echo ""
echo "Step 7: Installing Ansible Galaxy collections..."
ansible-galaxy collection install -r requirements.yaml --force

echo ""
echo "=== Upgrade Complete ==="
echo ""
echo "New Ansible version:"
ansible --version
echo ""
echo "Please run: source ~/.bashrc"
echo "Or start a new terminal session for PATH changes to take effect."
