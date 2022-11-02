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

data "vsphere_network" "network" {
  count = length(var.networks)
  name          = var.networks[count.index].name
  datacenter_id   = data.vsphere_datacenter.my_datacenter.id
}

resource "vsphere_content_library" "content_library" {
  name            = var.content_library
  storage_backing = [data.vsphere_datastore.my_datastore.id]
}

resource "vsphere_content_library_item" "content_library_item" {
  name        = "vm_template"
  library_id  = vsphere_content_library.content_library.id
  file_url    = var.template_url
}

resource "vsphere_virtual_machine" "my_vms" {
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
    unit_number = 0
    size = var.system_disk_size
  }

 disk {
    label = "disk1"
    unit_number = 1
    size = var.data_disk_size
  }
  disk {
    label = "disk2"
    unit_number = 2
    size = var.log_disk_size
  }


  firmware = var.vm_firmware
  dynamic "network_interface" {
    for_each = data.vsphere_network.network
    content {
      network_id = network_interface.value.id
      ovf_mapping = var.networks[index(data.vsphere_network.network, network_interface.value)].ovf_mapping
    }
  }
  cdrom {
    client_device = true
  }
  clone {
    template_uuid = vsphere_content_library_item.content_library_item.id
    customize {
      linux_options {
        host_name = format("%s-%02d", var.vsphere_vm_name_prefix, count.index + 1)
        domain    = "example.com"
      }
      dynamic "network_interface" {
        for_each = var.ips[count.index]
          content {
            ipv4_address = network_interface.value.ipv4_address
            ipv4_netmask = network_interface.value.ipv4_netmask
        }
      }
      ipv4_gateway = var.ipv4_gateway
      dns_server_list = var.dns_servers
     }
  }
  vapp {
    properties = {
      user-data = "${base64encode(file("./cloud_init.yml"))}"
    }
  }
}

# Anti-affinity rule
resource "vsphere_compute_cluster_vm_anti_affinity_rule" "my_vms_anti_affinity_rule" {
  count               = (var.num_of_vms > 0) ? 1 : 0
  name                = format("%s-anti-affinity-rule", "my_vms_ati_affinity_rule")
  compute_cluster_id  = data.vsphere_compute_cluster.compute_cluster.id
  virtual_machine_ids = vsphere_virtual_machine.my_vms.*.id
}
