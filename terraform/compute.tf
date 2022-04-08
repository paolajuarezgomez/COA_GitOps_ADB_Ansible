# Copyright (c) 2022, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource "oci_core_instance" "web_instance" {
  count = var.cluster_size

  #Required
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[count.index % length(data.oci_identity_availability_domains.availability_domains.availability_domains)].name
  compartment_id      = var.compute_compartment_id != null ? var.compute_compartment_id : var.default_compartment_id
  shape               = var.shape

  create_vnic_details {

    #Optional
    assign_public_ip = false
    defined_tags = {
      "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
    }
    display_name   = "${var.names_prefix}web${count.index}vnic"
    freeform_tags  = var.freeform_tags
    hostname_label = "${var.names_prefix}web${count.index}"
    subnet_id      = oci_core_subnet.coa_private_subnet.id
  }
  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key_path))
  }
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  display_name = "${var.names_prefix}web${count.index}"
  #fault_domain = "FAULT-DOMAIN-${random_integer.random_fault_domain[count.index].result}"
  freeform_tags = var.freeform_tags
  source_details {
    #Required
    source_id   = data.oci_core_images.this.images[0].id
    source_type = "image"
  }
  preserve_boot_volume = false
}

resource "oci_core_instance" "bastion_instance" {

  #Required
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[1 % length(data.oci_identity_availability_domains.availability_domains.availability_domains)].name
  compartment_id      = var.compute_compartment_id != null ? var.compute_compartment_id : var.default_compartment_id
  shape               = var.shape

  create_vnic_details {

    #Optional
    assign_public_ip = true
    defined_tags = {
      "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
    }
    display_name   = "${var.names_prefix}bastionvnic"
    freeform_tags  = var.freeform_tags
    hostname_label = "${var.names_prefix}bastion"
    subnet_id      = oci_core_subnet.coa_public_subnet.id
  }
  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key_path))
  }
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  display_name = "${var.names_prefix}bastion"
  #fault_domain = "FAULT-DOMAIN-${random_integer.random_fault_domain[count.index].result}"
  freeform_tags = var.freeform_tags
  source_details {
    #Required
    source_id   = data.oci_core_images.this.images[0].id
    source_type = "image"
  }
  preserve_boot_volume = false
}

resource "random_integer" "random_fault_domain" {
  count = var.cluster_size
  min   = 1
  max   = 3
}