####################################
#### vSphere Access Credentials ####
####################################
variable "vsphere_server" {
  description = "vsphere server to connect to"
  default     = "___INSERT_YOUR_OWN____"
}

# Set username/password as environment variables VSPHERE_USER and VSPHERE_PASSWORD

variable "allow_unverified_ssl" {
  description = "Allows terraform vsphere provider to communicate with vsphere servers with self signed certificates"
  default     = "true"
}

##############################################
##### vSphere deployment specifications ######
##############################################

variable "vsphere_datacenter_id" {
  description = "ID of the vsphere datacenter to deploy to"
  default     = "___INSERT_YOUR_OWN____"
}

variable "vsphere_cluster_id" {
  description = "ID of vsphere cluster to deploy to"
  default     = "___INSERT_YOUR_OWN____"
}

variable "vsphere_resource_pool_id" {
  description = "ID resource pool to deploy to."
  default     = ""
}

variable "network_id" {
  description = "ID of network to provision VMs on. All VMs will be provisioned on the same network"
  default     = "___INSERT_YOUR_OWN____"
}

variable "datastore_id" {
  description = "ID of datastore to use for the VMs"
  default     = ""
}

## Note
# Because of https://github.com/terraform-providers/terraform-provider-vsphere/issues/271 templates must be converted to VMs on ESX 5.5 (and possibly other)
variable "template" {
  description = "ID of template or VM to clone for the VM creations. "
  default     = "___INSERT_YOUR_OWN____"
}

variable "folder" {
  description = "Name of VM Folder to provision the new VMs in. The folder must exist"
  default     = ""
}

variable "instance_name" {
  description = "Name of the ICP installation, will be used as basename for VMs"
  default     = "icptest"
}

variable "domain" {
  description = "Specify domain name to be used for linux customization on the VMs, or leave blank to use <instance_name>.icp"
  default     = ""
}

variable "staticipblock" {
  description = "Specify start unused static ip cidr block to assign IP addresses to the cluster, e.g. 172.16.0.0/16.  Set to 0.0.0.0/0 for DHCP."
  default     = "0.0.0.0/0"
}

variable "staticipblock_offset" {
  description = "Specify the starting offset of the staticipblock to begin assigning IP addresses from.  e.g. with staticipblock 172.16.0.0/16, offset of 10 will cause IP address assignment to begin at 172.16.0.11."
  default     = 0
}

variable "gateway" {
  description = "Default gateway for the newly provisioned VMs. Leave blank to use DHCP"
  default     = ""
}

variable "netmask" {
  description = "Netmask in CIDR notation when using static IPs. For example 16 or 24. Set to 0 to retrieve from DHCP"
  default     = 0
}

variable "dns_servers" {
  description = "DNS Servers to configure on VMs"
  default     = ["8.8.8.8", "8.8.4.4"]
}

#################################
##### ICP Instance details ######
#################################
variable "nodes" {
  type = map

  default = {
    count  = "1"
    vcpu   = "8"
    memory = "16384"

    start_iprange = "" # Leave blank for DHCP, else masters will be allocated range starting from this address
  }
}

variable "boot_disk" {
  type = map

  default = {
    disk_size             = "100"      # Specify size or leave empty to use same size as template.
    thin_provisioned      = "true"      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub         = "false"      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove   = "false" # Set to 'true' to not delete a disk on removal.
  }
}

variable "additional_disk" {
  type = map

  default = {
    disk_size             = "100"      # Specify size or leave empty to use same size as template.
    thin_provisioned      = "true"      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub         = "false"      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove   = "false" # Set to 'true' to not delete a disk on removal.
  }
}

