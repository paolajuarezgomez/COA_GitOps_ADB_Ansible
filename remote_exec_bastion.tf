# Copyright (c) 2022, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#Upload private ssh key to bastion host to facilitate ssh access to backend instances
#Set the proper permissions(chmod 600) to the uploaded private key
resource "null_resource" "configure_bastion_host" {

  provisioner "file" {
    connection {
      user        = "opc"
      agent       = false
      private_key = chomp(file(var.ssh_private_key_path))
      timeout     = "10m"
      host        = oci_core_instance.bastion_instance.public_ip
    }

    source      = var.ssh_public_key_path
    destination = "/home/opc/.ssh/cos_key.openssh"
  }

  provisioner "remote-exec" {
    connection {
      user        = "opc"
      agent       = false
      private_key = chomp(file(var.ssh_private_key_path))
      timeout     = "10m"
      host        = oci_core_instance.bastion_instance.public_ip
    }

    inline = [
      "chmod 600 /home/opc/.ssh/cos_key.openssh"
    ]
  }
}