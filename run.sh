#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -h|--help)
      HELP=1
      shift
      ;;
    --vm-mode)
      VM_MODE=1
      shift
      ;;
    *)
      HELP=0
      VM_MODE=1
      shift
      ;;
  esac
done

if [[ "$HELP" -eq 1 ]]; then
  echo "usage: ./run.sh [--vm-mode]"
  exit 0
fi

# First and foremost, get updated info and install system updates
#sudo dnf updateinfo
#sudo dnf upgrade

# Install Ansible and required roles
sudo dnf install -y ansible
ansible-galaxy install -r ansible/requirements.yml

if [[ "$VM_MODE" -eq 1 ]]; then
  echo "Running in VM mode..."
  ansible-playbook ansible/vm-playbook.yml -i ansible/hosts
else
  echo "Running in non-VM mode..."
  ansible-playbook ansible/playbook.yml -i ansible/hosts
fi

if [[ "$?" -eq 0 ]]; then
  neofetch
fi

