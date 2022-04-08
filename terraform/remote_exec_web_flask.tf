resource "null_resource" "configure_cluster_node_flask" {
  count = var.install_product == "Flask" && var.deploy_adb == "True" ? var.cluster_size : 0

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
    content     = data.template_file.sqlnet_ora_template.rendered
    destination = "/tmp/sqlnet.ora"
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
    source      = "${path.module}/adb_wallet.zip"
    destination = "/tmp/adb_wallet.zip"
  }

  provisioner "file" {
    connection {
      type         = "ssh"
      user         = "opc"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      host         = oci_core_instance.web_instance[count.index].create_vnic_details[0].private_ip
      script_path  = "/home/opc/.ssh/cos_key.openssh"
      private_key  = chomp(file(var.ssh_private_key_path))
      agent        = false
      timeout      = "10m"
    }
    content     = data.template_file.flask_ATP_py_template.rendered
    destination = "/tmp/flask_ATP.py"
  }

  provisioner "file" {
    connection {
      type         = "ssh"
      user         = "opc"
      bastion_host = oci_core_instance.bastion_instance.public_ip
      host         = oci_core_instance.web_instance[count.index].create_vnic_details[0].private_ip
      script_path  = "/home/opc/.ssh/cos_key.openssh"
      private_key  = chomp(file(var.ssh_private_key_path))
      agent        = false
      timeout      = "10m"
    }
    content     = data.template_file.flask_ATP_sh_template.rendered
    destination = "/tmp/flask_ATP.sh"
  }

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
    content     = data.template_file.flask_bootstrap_template.rendered
    destination = "/tmp/flask_bootstrap.sh"
  }

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
      "chmod +x /tmp/flask_bootstrap.sh",
    "sudo /tmp/flask_bootstrap.sh"]
  }
  depends_on = [module.adb]
}


