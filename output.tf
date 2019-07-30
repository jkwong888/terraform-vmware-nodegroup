output "node_ips" {
    description = "IP addresses of created nodes"
    value = "${vsphere_virtual_machine.node.*.default_ip_address}"
}

output "node_hostnames" {
    description = "hostname of created nodes"
    value = "${vsphere_virtual_machine.node.*.name}"
}