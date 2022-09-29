#!/usr/bin/env bash

# Change needsrestart to automatic
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf

# Add user local bin to path
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]
then
  echo 'export PATH="$HOME/.local/bin:${PATH}"' >> $HOME/.bashrc
  export PATH="$HOME/.local/bin:${PATH}"
fi

# Install required software packages
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common vim

# Install the HashiCorp GPG key.
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg | gpg --enarmor

# Verify the key's fingerprint.
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
sudo apt-get update
sudo apt-get install -y terraform

# Install Python3
sudo apt-get install -y python3 python3-pip
echo "Upgrading pip and setuptools"
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade setuptools

# Install Ansible
sudo apt-get install -y ansible

# Install sshpass 
sudo apt-get install -y sshpass