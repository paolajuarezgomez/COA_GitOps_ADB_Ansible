

resource "null_resource" "files_backup" {
  count = var.conf_manual_backup == "True" ? var.cluster_size : 0


  provisioner "file" {
    connection {
      type         = "ssh"
      user         = "opc"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      host         = oci_core_instance.web_instance[count.index].create_vnic_details[0].private_ip
      private_key  = chomp(file(var.ssh_private_key_path))
      script_path  = "/home/opc/.ssh/cos_key.openssh"
      agent        = false
      timeout      = "10m"
    }
    content     = data.template_file.configure_backup_template.rendered
    destination = "/tmp/config_backup.sql"

  }

  provisioner "file" {
    connection {
      type         = "ssh"
      user         = "opc"
      private_key  = chomp(file(var.ssh_private_key_path))
      bastion_host = oci_core_instance.bastion_instance.public_ip
      host         = oci_core_instance.web_instance[count.index].create_vnic_details[0].private_ip
      script_path  = "/home/opc/.ssh/cos_key.openssh"
      agent        = false
      timeout      = "10m"
    }
    content     = data.template_file.atp_temp.rendered
    destination = "/tmp/conn_atp.sh"
  }

  depends_on = [null_resource.configure_cluster_node_flask]
}




resource "null_resource" "configure_backup" {
  count = var.conf_manual_backup == "True" ? var.cluster_size : 0

  provisioner "remote-exec" {
    connection {
      type         = "ssh"
      user         = "opc"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      host         = oci_core_instance.web_instance[count.index].create_vnic_details[0].private_ip
      private_key  = chomp(file(var.ssh_private_key_path))
      script_path  = "/home/opc/.ssh/cos_key.openssh"
      agent        = false
      timeout      = "10m"
    }
    inline = [
      "chmod +x /tmp/config_backup.sql",
      "chmod +x /tmp/conn_atp.sh",
      "sh /tmp/conn_atp.sh",
      "echo 'Connected'"]
  }

  depends_on = [null_resource.files_backup]
}
