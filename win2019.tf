## Configure the vSphere Provider
provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_user
  password             = var.vsphere_password
  allow_unverified_ssl = true
}

## Build VM
data "vsphere_datacenter" "dc" {
  name = "Lab"
}

data "vsphere_datastore" "datastore" {
  name          = "vStorage1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "Nginx_Demo"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "mgmt_lan" {
  name          = "Management Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "Appserver-1-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "win2019-template" {
  name          = "Win2019-Packer-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "win2019-vm" {
  name             = "win2019-vm-${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  scsi_type = data.vsphere_virtual_machine.win2019-template.scsi_type

  num_cpus                  = 4
  memory                    = 8192
  wait_for_guest_ip_timeout = 10
  guest_id = "windows9Server64Guest"
  count = 1

  network_interface {
    network_id   = data.vsphere_network.mgmt_lan.id
    adapter_type = "vmxnet3"
  }

  disk {
    size             = 40
    label            = "w2019-disk"
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.win2019-template.id
 
}
  #provisioner "local-exec" {
    #command = "sleep 120; cp inventory hosts; sed -i 's/PUBLICIP/${vsphere_virtual_machine.win2019-vm.default_ip_address}/g' hosts;ansible-playbook -i hosts playbook.yaml -v"
  #}
}

