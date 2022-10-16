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

variable "networks" {
  type = list(object({
    name = string
    ovf_mapping = string
  }))
}

variable "ips" {
  type = list(list(object({
      ipv4_address = string
      ipv4_netmask = string
    })))
}


variable content_library {
  description = "content library name"
  type = string
}

variable template_url {
  description = "template url"
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
  description = "vm name prefix which appears in vSphere"
  type = string
}

variable ipv4_gateway {
  description = "ipv4 gateway"
  type = string
}

variable dns_servers {
  description = "DNS ip list"
  type = list(string)
}


variable username {
  description = "username for linux system"
  type = string
}

variable pswd {
  description = "plain text password for linux system"
  type = string
  default = ""
}

variable ssh_authorized_key {
  description = "public key for ssh"
  type = string
  default = ""
}
