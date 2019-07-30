
##################################
#### Create the VMs
##################################
resource "vsphere_virtual_machine" "node" {
  folder     = "${var.folder}"

  #####
  # VM Specifications
  ####
  count            = "${var.nodes["count"]}"
  resource_pool_id = "${var.vsphere_resource_pool_id}"

  name      = "${format("${lower(var.instance_name)}%02d", count.index + 1) }"
  num_cpus  = "${var.nodes["vcpu"]}"
  memory    = "${var.nodes["memory"]}"

  #scsi_controller_count = 1
  #scsi_type = "lsilogic-sas"

  ####
  # Disk specifications
  ####
  datastore_id  = "${var.datastore_id}"
  guest_id      = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type     = "${data.vsphere_virtual_machine.template.scsi_type}"

  disk {
      label            = "${format("${lower(var.instance_name)}%02d-boot.vmdk", count.index + 1) }"
      size             = "${var.boot_disk["disk_size"]        != "" ? var.boot_disk["disk_size"]        : data.vsphere_virtual_machine.template.disks.0.size}"
      eagerly_scrub    = "${var.boot_disk["eagerly_scrub"]    != "" ? var.boot_disk["eagerly_scrub"]    : data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
      thin_provisioned = "${var.boot_disk["thin_provisioned"] != "" ? var.boot_disk["thin_provisioned"] : data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
      keep_on_remove   = false
      unit_number      = 0
  }
  disk {
      label            = "${format("${lower(var.instance_name)}%02d_disk1.vmdk", count.index + 1) }"
      size             = "${var.additional_disk["disk_size"]}"
      eagerly_scrub    = "${var.additional_disk["eagerly_scrub"]    != "" ? var.additional_disk["eagerly_scrub"]    : data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
      thin_provisioned = "${var.additional_disk["thin_provisioned"] != "" ? var.additional_disk["thin_provisioned"] : data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
      keep_on_remove   = false
      unit_number      = 1
  }

  ####
  # Network specifications
  ####
  network_interface {
    network_id   = "${var.network_id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  ####
  # VM Customizations
  ####
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "${format("${lower(var.instance_name)}%02d", count.index + 1) }"
        domain    = "${var.domain != "" ? var.domain : format("%s.local", var.instance_name)}"
      }
      network_interface {
        ipv4_address  = "${var.staticipblock != "0.0.0.0/0" ? cidrhost(var.staticipblock, 1 + var.staticipblock_offset + count.index) : ""}"
        ipv4_netmask  = "${var.netmask}"
      }

      ipv4_gateway    = "${var.gateway}"
      dns_server_list = "${var.dns_servers}"
    }
  }
}

