# Create a master VM
resource "vsphere_virtual_machine" "vm" {
  resource_pool_id = "${var.resource_pool_id}"
  datastore_id     = "${var.datastore_id}"

  name        = "${var.vmName}${count.index + 1}"
  folder      = "${var.folder_path}"
  num_cpus    = "${var.vm_vcpu}"
  memory      = "${var.vm_memory}"
  count       = "${length(var.network_ips)}"

  guest_id    = "${var.guest_id}"
  scsi_type = "${var.scsi_type}"

  network_interface {
    network_id = "${var.network_id}"
  }

  disk {
    label = "disk0"
    size = "${var.disk_size}"
    thin_provisioned  = "true"
  }
  clone {
    template_uuid = "${var.template_uuid}"

    customize {
      windows_options {
              computer_name  = "${element(var.hostName, count.index)}"
              workgroup      = "workgroup"
              admin_password = "${var.admin_password}"
              auto_logon = true
              auto_logon_count = 1
              run_once_command_list = [
                "New-Item -Path c:\\test3 -ItemType directory",
                "timeout 120",
                "md c:\\scripts",
                "winrm quickconfig -force",
                "winrm quickconfig -q",
                "winrm quickconfig '-transport:http'",
                "winrm set \"winrm/config\" '@{MaxTimeoutms=\"7200000\"}'",
                "winrm set \"winrm/config/winrs\" '@{MaxMemoryPerShellMB=\"1024\"}'",
                "winrm set \"winrm/config/client\" '@{AllowUnencrypted=\"true\"}'",
                "winrm set \"winrm/config\" @{MaxEnvelopeSizekb=\"100000\"}",
                "winrm set \"winrm/config/Service\" @{AllowUnencrypted=\"true\"}",
                "winrm set \"winrm/config/service/auth\" '@{Basic=\"true\"}'",
                "winrm set \"winrm/config/client/auth\" '@{Basic=\"true\"}'",
                "winrm set \"winrm/config/service/auth\" '@{CredSSP=\"true\"}'",
                "winrm set \"winrm/config/listener?Address=*+Transport=HTTP\" '@{Port=\"5985\"}'",
                "netsh advfirewall firewall set rule group=\"remote administration\" new enable=yes",
                "netsh firewall add portopening TCP 5985 \"Port 5985\"",
                "net stop winrm",
                "sc config winrm start= auto",
                "net start winrm",
                "net user Administrator \"REDACTED\"",
                "wmic useraccount where \"name='Administrator'\" set PasswordExpires=FALSE",
              ]
            }
      network_interface {

        ipv4_address = "${element(var.network_ips, count.index)}"
        ipv4_netmask = "${var.network_subNet}"
      }

      ipv4_gateway = "${var.network_gateway}"
      dns_server_list = "${var.dns_servers}"
    }
  }
}