variable "vsphere_server" {
  description = "Vcenter server fqdn or ip"
}

variable "vsphere_user" {
  description = "Vcenter user"
}

variable "vsphere_password" {
  description = "Vcenter password"
}

variable "vm_count" {
  description = "Number of windows vms to spin up"
}

variable "vm_prefix" {
  description = "Prefix for VM names"
}

