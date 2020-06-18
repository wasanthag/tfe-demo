# Key Outputs


# windows Server IP
output "Windows_Server_Public_IP" {
  value = ["{vsphere_virtual_machine.win2019-vm.*.default_ip_address}"]
}

