#
# vSphere Provider
#

provider "vsphere" {
  vsphere_server = var.vcenter_server
  user = var.vcenter_user
  password = var.vcenter_password
  allow_unverified_ssl = var.vcenter_insecure_ssl
}

data "vsphere_datacenter" "my_datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name            = var.vsphere_compute_cluster
  datacenter_id   = data.vsphere_datacenter.my_datacenter.id
}

data "vsphere_datastore" "my_datastore" {
  name = var.vsphere_datastore_name
  datacenter_id = data.vsphere_datacenter.my_datacenter.id

}

resource "vsphere_resource_pool" "my_resource_pool" {
  name = var.vsphere_resource_pool_name
  parent_resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
}


data "vsphere_network" "my_network1" {
  name = var.vsphere_network1
  datacenter_id = data.vsphere_datacenter.my_datacenter.id
}

data "vsphere_network" "my_network2" {
  name = var.vsphere_network2
  datacenter_id = data.vsphere_datacenter.my_datacenter.id
}

resource "vsphere_content_library" "content_library" {
  name            = var.content_library
  storage_backing = [data.vsphere_datastore.my_datastore.id]
}

resource "vsphere_content_library_item" "content_library_item" {
  name        = "ubuntuTemplate"
  library_id  = vsphere_content_library.content_library.id
  file_url    = var.vsphere_ubuntu_template_url
}

resource "vsphere_virtual_machine" "cassandra_vms" {
  count  = var.num_of_vms
  name = format("%s-%02d", var.vsphere_vm_name_prefix, count.index + 1)
  resource_pool_id = vsphere_resource_pool.my_resource_pool.id
  datastore_id     = data.vsphere_datastore.my_datastore.id
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  num_cpus = var.num_cpus
  memory = var.mem_size
  disk {
    label = "disk0"
    size = var.disk_size
  }
  firmware = var.vm_firmware
   network_interface {
    network_id  = data.vsphere_network.my_network1.id
    ovf_mapping = "eth0"
   }
   network_interface {
    network_id  = data.vsphere_network.my_network2.id
   }
   clone {
     template_uuid = vsphere_content_library_item.content_library_item.id
     customize {
      linux_options {
        host_name = format("%s-%02d", var.vsphere_vm_name_prefix, count.index + 1)
        domain    = var.vm_domain_name
      }
      network_interface {
        ipv4_address = var.network1_ips[count.index]
        ipv4_netmask = var.network1_mask
      }
      network_interface {
        ipv4_address = var.network2_ips[count.index]
        ipv4_netmask = var.network2_mask
      }
      ipv4_gateway = var.ipv4_gateway
      dns_server_list = var.dns_servers


     }
   }
}

# Anti-affinity rule
resource "vsphere_compute_cluster_vm_anti_affinity_rule" "cassandra_anti_affinity_rule" {
  count               = (var.num_of_vms > 0) ? 1 : 0
  name                = format("%s-anti-affinity-rule", "cassandra")
  compute_cluster_id  = data.vsphere_compute_cluster.compute_cluster.id
  virtual_machine_ids = vsphere_virtual_machine.cassandra_vms.*.id
}
