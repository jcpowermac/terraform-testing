variable "template_name" {
  type    = string
  default = "jcallen-scbr6-rhcos"
}

variable "vsphere_datacenter" {
  type    = string
  default = "SDDC-Datacenter"

}
variable "vsphere_cluster" {
  type    = string
  default = "Cluster-1"
}

variable "vsphere_username" {
  type    = string
  default = "jcallen@openldap-vsphere.openshiftcorp.com"
}

variable "vsphere_password" {
  type    = string
  default = ""
}

variable "vsphere_url" {
  type    = string
  default = "vcenter.sddc-44-233-241-153.vmwarevmc.com"
}
variable "vsphere_network" {
  type    = string
  default = "dev"
}

provider "vsphere" {
  user                 = var.vsphere_username
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_url
  allow_unverified_ssl = false
}

provider "vsphereprivate" {
  user                 = var.vsphere_username
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_url
  allow_unverified_ssl = false
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_virtual_machine" "template" {
  name          = vsphereprivate_import_ova.import.name
  datacenter_id = data.vsphere_datacenter.datacenter.id

depends_on = [vsphereprivate_import_ova.import]
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = "WorkloadDatastore"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_tag_category" "category" {
  name        = "openshift-jcallen-scbr6"

}

data "vsphere_tag" "tag" {
  name =  "jcallen-scbr6"
  category_id = data.vsphere_tag_category.category.id
}


resource "vsphereprivate_import_ova" "import" {
  name       = "test-terraform-template2"
  filename   = "./rhcos.ova"
  cluster    = var.vsphere_cluster
  datacenter = var.vsphere_datacenter
  datastore  = "WorkloadDatastore"
  network    = var.vsphere_network
  //folder     = "${var.vsphere_datacenter}/vm/jcallen-scbr6"
  folder     = "jcallen-scbr6"
  tag        = data.vsphere_tag.tag.id
}


/*
resource "vsphere_virtual_machine" "vm" {

  name                 = "terraform-test3"
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id         = data.vsphere_datastore.datastore.id
  num_cpus             = 1
  num_cores_per_socket = 1
  memory               = 1024
  guest_id             = data.vsphere_virtual_machine.template.guest_id
  enable_disk_uuid     = "true"

  wait_for_guest_net_timeout  = "0"
  wait_for_guest_net_routable = "false"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = 16
  thin_provisioned     = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  eagerly_scrub = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}
*/

output "template" {
  value = data.vsphere_virtual_machine.template
}
