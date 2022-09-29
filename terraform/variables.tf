variable vcenter_server {
  description = "vCenter Server hostname or IP"
  type = string
}

variable vcenter_user {
  description = "vCenter Server username"
  type = string
}

variable vcenter_password {
  description = "vCenter Server password"
  type = string
}

variable vcenter_insecure_ssl {
  description = "Allow insecure connection to the vCenter server (unverified SSL certificate)"
  type = bool
  default = true
}

variable vsphere_datacenter {
  description = "vsphere datacenter name"
  type = string
}

variable vsphere_compute_cluster {
  description = "vsphere compute cluster name"
  type = string
}

variable vsphere_datastore_name {
  description = "vsphere datastore name"
  type = string
}

variable vsphere_resource_pool_name {
  description = "vsphere resource pool name"
  type = string
}

variable vm_firmware {
  description = "firmware for the vm efi/bios"
  type = string
  default = "bios"
}

variable vsphere_network1 {
  description = "network1 name"
  type = string
}

variable vsphere_network2 {
  description = "network2 name"
  type = string
}

variable content_library {
  description = "content library name"
  type = string
}

variable vsphere_ubuntu_template_url {
  description = "ubuntu template url"
  type = string
}

variable vm_domain_name {
  description = "Domain name"
  type = string
}

variable num_of_vms {
  description = "Number of VMs"
  type = number
}

variable num_cpus {
  description = "Number of CPUs"
  type = number
  default = 8
}

variable mem_size {
  description = "Size of memory in MiB"
  type = number
  default = 8192
}

variable disk_size {
  description = "Size of disk in GiB"
  type = number
  default = 100
}

variable vsphere_vm_name_prefix {
  description = "vm name prefix"
  type = string
}

variable ipv4_gateway {
  description = "ipv4 gateway"
  type = string
}

variable network1_ips{
  description = "ips from network1"
  type = list(string)
}

variable network1_mask{
  description = "netmask for network1"
  type = number
}

variable network2_ips{
  description = "ips from network2"
  type = list(string)
}

variable network2_mask{
  description = "netmask for network2"
  type = number
}

variable dns_servers{
  description = "DNS server ip addresses"
  type = list(string)
}


