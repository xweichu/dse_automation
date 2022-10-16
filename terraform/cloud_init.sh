#!/usr/bin/env bash
input="./terraform.tfvars"

IFS='\"'

username=$(cat "$input" | grep ^username | tail -1)
read -ra array <<< "$username"
username="${array[@]: -1:1}"

password=$(cat "$input" | grep ^pswd | tail -1)
read -ra array <<< "$password"
password="${array[@]: -1:1}"

sshkey=$(cat "$input" | grep ^ssh_authorized_key | tail -1)
read -ra array <<< "$sshkey"
sshkey="${array[@]: -1:1}"

output="./cloud_init.yml"
echo "#cloud-config" > $output
echo "users:" >> $output
echo "  - name: $username" >> $output
echo "    shell: /bin/bash" >> $output
echo "    sudo: ['ALL=(ALL) NOPASSWD:ALL']" >> $output
echo "    groups: sudo, users, admin" >> $output
if [ ${#sshkey} -gt 0 ]; then
  echo "    ssh_authorized_keys:" >> $output
  echo "      - $sshkey" >> $output
fi;
echo "ssh_pwauth: True" >> $output
if [ ${#password} -gt 0 ]; then
  password=$(mkpasswd --method=SHA-512 --rounds=4096 $password)
  echo "chpasswd:" >> $output
  echo "  list: |" >> $output
  echo "    $username:$password" >> $output
  echo "  expire: false" >> $output
fi;
echo "hostname: linuxserver" >> $output

terraform init
terraform apply -auto-approve 
echo "sleeping for 120s ..."
sleep 120

