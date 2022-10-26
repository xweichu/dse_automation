## vCenter configurations
vcenter_server = "mvc06.isvlab.vmware.com"
vcenter_user = "administrator@vsphere.local"
vcenter_password = "P@ssword123!"
vsphere_datacenter = "Datacenter"
vsphere_compute_cluster ="Cluster"
vsphere_datastore_name = "vsanDatastore"
vsphere_resource_pool_name = "cloud_init"
content_library = "cloud_init_lib"

## vm cloud init image configurations 
# different versions of ubuntu cloud images can be found here:https://cloud-images.ubuntu.com/
# the following images were tested.
# Ubuntu 18.04
template_url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova"
# Ubuntu 20.04
# template_url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.ova"
# Ubuntu 22.04
# template_url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
# Ubuntu 22.10
# template_url = "https://cloud-images.ubuntu.com/kinetic/current/kinetic-server-cloudimg-amd64.ova"

## vm configurations
vsphere_vm_name_prefix = "cloud"
num_of_vms = 2
num_cpus = 16
# memory size in MB.
mem_size = 32768
# disk size in GB
disk_size = 256

# Example using one network interfaces per vm
networks = [{name="wdc-vds01-vm-c", ovf_mapping="eth0"}]
ips = [
  # ips for vm_1, 172.16.22.155 is for wdc-vds01-vm-c
  [{ipv4_address="172.16.22.155",ipv4_netmask="23"}],
  # ips for vm_2, 172.16.22.156 is for wdc-vds01-vm-c
  [{ipv4_address="172.16.22.156",ipv4_netmask="23"}]
]


# Example using two network interfaces per vm, one uses public ip and the other uses private ip
# networks = [{name="wdc-vds01-vm-c", ovf_mapping="eth0"}, {name="wdc-vds01-vm-b", ovf_mapping="eth1"}]
# ips = [
  # ips for vm_1, 172.16.22.155 is for wdc-vds01-vm-c, and 172.16.20.155 is for wdc-vds01-vm-b
#  [{ipv4_address="172.16.22.155",ipv4_netmask="23"}, {ipv4_address="172.16.20.155",ipv4_netmask="23"}],
  # ips for vm_2, 172.16.22.156 is for wdc-vds01-vm-c, and 172.16.20.156 is for wdc-vds01-vm-b
#  [{ipv4_address="172.16.22.156",ipv4_netmask="23"}, {ipv4_address="172.16.20.156",ipv4_netmask="23"}]
# ]


ipv4_gateway = "172.16.23.253"
dns_servers = ["172.16.16.16","172.16.16.17"]

## add a user to the vms
# configure either or both password and ssh_authorization_key, otherwise vms won't be accessible.
# just comment out the line if pswd or ssh_authorized_key is not used.

# username is required
username = "vmware"

# password is in plain text, it will be encrypted using hash functions. 
# remove the pswd value from this config file to keep it safe.
pswd = "P@ssword123!"

# ssh_authorized_key is a more secure way.
# ssh_authorized_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgTs+JAc+AvATWlwRlzoJoy/GDx1oOmvYlmAjcDd++9Z16HgyxMDRqKFU05ehPsIhzd3En3vRFP8adfxQjsJqpdW4sVz1aPkqRX0IGSFyMLg6XzxqGnd0uAK3mVbNGm1q26Bh41tsBlbtZfaz/3XbVTGRTbDsf9eYm24nNDpctn/b/BJg1EJaKzYXe6bFXw2PNbkwA+8l7U1XUXtua/xHAQjcL/ZFe75s7HHzedhQT58F2WHCLOf4t/w1UGEcL31CEtuJsBISK6rUWyAxqeikpB9rrG0mctttnf2MTpq5JSiGKn4dPctadf9W3xGg921vMfNDSUmM4Yix8B+qd0FALpncuupg583VuqibZa/xnSX0MJ70ylb2rKHbRmVHRf9PMRAsKCOWA+gaFbWavy/gSL4Q6TEyN+MQxCm9wFlH6yp6Q9+bBluzCsIBTMBoR6n2PKTlcjGBolZn3tcwXTI5c2YD0RqOGYAoUYd62rwTbOqX4FHmDlA1dDZVG3urGElU= vmware@vmware"

