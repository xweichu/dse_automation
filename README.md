# DSE Workload Automation on vSphere

Automatically deploy DSE (**6.8**) clusters on vSphere using Terraform and Ansible. The automation may or may not work for other DSE versions.

# Prerequisites

The following dependencies are required to run this tool:
- Terraform
- Ansible
- sshpass
- whois

If above packages are not installed on your system, you can clone this repo and run the command: `bash ./env_prep.sh` to install the dependencies. The bash script was tested on Ubuntu 18.04/20.04 systems.  

This tool uses the [Ubuntu Cloud Images (ova)](https://cloud-images.ubuntu.com/) to provision the VMs so that users don't have to prepare the VM template manually. At this moment, only Ubuntu 18.04 images were tested.

## Instructions
 - Customize the [config/a_terraform.tfvars](https://github.com/xweichu/dse_automation/blob/main/config/a_terraform.tfvars) file to configure the infrustructure using Terraform. For more details, please refer to the example and comments in this repo.

 - Customize the [config/b_cassandra.cfg](https://github.com/xweichu/dse_automation/blob/main/config/b_cassandra.cfg) file to configure the DSE cluster.

 - Run the command `bash ./deploy.sh` to start the automation. 
 
 - Run the command `bash ./cleanup` to cleanup the deployment.

**Please note the \*.sh files in this repo are based on bash, simply run `./*.sh` or `sh ./*.sh` won't work. Use `bash ./*.sh` instead.**
