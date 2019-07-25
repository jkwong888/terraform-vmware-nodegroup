##################################
#### Collect resource IDs
##################################
data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_cluster}/Resources/${var.vsphere_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.network_label}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Create a folder
resource "vsphere_folder" "icpenv" {
  count = "${var.folder != "" ? 1 : 0}"
  path = "${var.folder}"
  type = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


locals  {
  folder_path = "${var.folder != "" ?
        element(concat(vsphere_folder.icpenv.*.path, list("")), 0)
        : ""}"
}
