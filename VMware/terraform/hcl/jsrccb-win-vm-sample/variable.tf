variable "resource_pool_id"{
  description = "RP ID"
}

variable "datastore_id"{
  description = "DS ID Module"
}

variable "network_id"{
  description = "PG ID"
}

variable "template_uuid"{
  description = "Temp ID"
}

variable "hostName" {
  description = "VM hostanme"
  type = "list"
}

variable "vmName" {
  description = "VM name"
}

variable "folder_path" {
  description = "VM Folder Path"
}

variable "vm_vcpu" {
  description = "VM Vcpu count"
}

variable "vm_memory" {
  description = "VM memory"
}

variable "disk_size" {
  description = "Disk 0 size"
}

variable "guest_id" {
  description = "Guest OS"
}

variable "scsi_type" {
  description = "Guest OS SCSI type"
}

variable "dns_servers" {
  type = "list"
  description = "Vcenter comma-separated primary,secondary networking DNS"
}

variable "vsphere_domain" {
  description = "vCenter networking domain"
}

variable "network_ips" {
  description = "List of public IP's to assign to generated nodes. For single node same IP for master, proxy and two workers."
  type = "list"
}

variable "admin_password" {
  description = "Windows admin password"
}

variable "network_subNet" {
  description = "Public network prefix length"
}

variable "network_gateway" {
  description = "vCenter networking gateway"
}