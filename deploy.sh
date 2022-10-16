#!/usr/bin/env bash

echo "moving terraform configuration file"
cp ./config/a_terraform.tfvars ./terraform/terraform.tfvars

echo "generating asnsible configuration files"
input="./config/b_cassandra.cfg"

hosts="./ansible/hosts"
all="./ansible/group_vars/all"

echo "# host file" > $hosts
flag=true

while IFS= read -r line
do
  if [ "$line" = "### dse configurations [don't edit this comment line]" ]; then 
    echo "# all file" > $all
    flag=false
    continue
  fi;
  if [ "$flag" = true ]; then
    echo $line >> $hosts
  else
    echo $line >> $all
  fi;
done < "$input"

echo dse_ver_target:  \"{{ dse_ver_major }}.{{ dse_ver_minor }}\" >> $all
echo data_file_directories: \"{{ dse_data_homedir }}/cassandra\" >> $all
echo commitlog_directory: \"{{ dse_data_homedir }}/commitlog\" >> $all
echo saved_caches_directory: \"{{ dse_data_homedir }}/saved_cahces\" >> $all
echo hints_directory: \"{{ dse_data_homedir }}/hints\" >> $all
echo cdc_raw_directory: \"{{ dse_data_homedir }}/cdc_raw\" >> $all
echo metadata_directory: \"{{ dse_data_homedir }}/metadata\" >> $all

echo "generating cloud_init.yml and parsing user credentials..."
input="./terraform/terraform.tfvars"
IFS='\"'

username=$(cat "$input" | grep ^username | tail -1)
read -ra array <<< "$username"
username="${array[@]: -1:1}"

password=$(cat "$input" | grep ^pswd | tail -1)
read -ra array <<< "$password"
password="${array[@]: -1:1}"
pssword_plain=$password

sshkey=$(cat "$input" | grep ^ssh_authorized_key | tail -1)
read -ra array <<< "$sshkey"
sshkey="${array[@]: -1:1}"

output="./terraform/cloud_init.yml"
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

cd ./terraform
terraform init
terraform apply -auto-approve 
echo "sleeping for 120s ..."
sleep 240


if [ ${#sshkey} -gt 0 ]; then
  cd ../ansible/
  ansible-playbook -i ./hosts dse_install.yml
else
  cd ../ansible/
  ansible-playbook -i ./hosts dse_install.yml -u $username -e "ansible_password=$pssword_plain" -e "ansible_become_pass=$pssword_plain"
fi;

