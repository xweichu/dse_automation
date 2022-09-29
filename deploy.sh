#!/usr/bin/env bash

input="./deploy.cfg"

file="./terraform/terraform.tfvars"
flag=false
while IFS= read -r line
do
  if [ "$line" = "### TERRAFORM_CONFIG START ###" ]; then 
    echo $line > $file 
    flag=true
    continue
  fi;
  if [ "$flag" = true ]; then
    echo $line >> $file
  fi;
  if [ "$line" = "### TERRAFORM_CONFIG END ###" ]; then 
    flag=false
    break
  fi;
done < "$input"

file="./ansible/hosts"
flag=false
while IFS= read -r line
do
  if [ "$line" = "### DSE_INVENTORY START ###" ]; then 
    echo $line > $file 
    flag=true
    continue
  fi;
  if [ "$flag" = true ]; then
    echo $line >> $file
  fi;
  if [ "$line" = "### DSE_INVENTORY END ###" ]; then 
    flag=false
    break
  fi;
done < "$input"


file="./ansible/group_vars/all"
flag=false
while IFS= read -r line
do
  if [ "$line" = "### CASSANDRA_CONFIG START ###" ]; then 
    echo "---" > $file
    echo $line >> $file 
    flag=true
    continue
  fi;
  if [ "$flag" = true ]; then
    echo $line >> $file
  fi;
  if [ "$line" = "### CASSANDRA_CONFIG END ###" ]; then 
    flag=false
    break
  fi;
done < "$input"

echo dse_ver_target:  \"{{ dse_ver_major }}.{{ dse_ver_minor }}\" >> $file
echo data_file_directories: \"{{ dse_data_homedir }}/cassandra\" >> $file
echo commitlog_directory: \"{{ dse_data_homedir }}/commitlog\" >> $file
echo saved_caches_directory: \"{{ dse_data_homedir }}/saved_cahces\" >> $file
echo hints_directory: \"{{ dse_data_homedir }}/hints\" >> $file
echo cdc_raw_directory: \"{{ dse_data_homedir }}/cdc_raw\" >> $file
echo metadata_directory: \"{{ dse_data_homedir }}/metadata\" >> $file


user=$(cat "$input" | grep ubuntu_root_user)
password=$(cat "$input" | grep ubuntu_root_password)

array=($user)
user="${array[@]: -1:1}"

array=($password)
password="${array[@]: -1:1}"

echo "Settings populated to Terraform and Ansible..."
echo "Creating VMs..."

cd ./terraform
terraform init
terraform apply -auto-approve

echo "VMs are created sucessfully..."
echo "Waiting 120s..."
sleep 120

cd ../ansible/
ansible-playbook -i ./hosts dse_install.yml -u $user -e "ansible_password=$password" -e "ansible_become_pass=$password"

echo "Done!"