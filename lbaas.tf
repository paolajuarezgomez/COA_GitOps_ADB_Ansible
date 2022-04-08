# Copyright (c) 2022, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #converting list to set as for_each doeas not support lists, just sets
  ssl_port_set = toset(matchkeys(var.lbaas_listening_ports, var.lbaas_listening_ports, ["443"]))
  ports_set    = toset(var.lbaas_listening_ports)
}

resource "oci_load_balancer_load_balancer" "coa_load_balancer" {

  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id

  display_name = "${var.names_prefix}load-balancer"
  shape        = var.load_balancer_shape
  subnet_ids   = [oci_core_subnet.coa_public_subnet.id]

  #Optional
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  freeform_tags = var.freeform_tags
  is_private    = false
}

resource "oci_load_balancer_backend_set" "coa_backend_set" {
  #Required
  health_checker {
    protocol = "HTTP"

    #Optional
    interval_ms       = "10000"
    port              = "80"
    retries           = "3"
    return_code       = "200"
    timeout_in_millis = "3000"
    url_path          = "/"
  }
  load_balancer_id = oci_load_balancer_load_balancer.coa_load_balancer.id
  name             = "${var.names_prefix}backend-set"
  policy           = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "coa_backends" {
  count = var.cluster_size

  #Required
  backendset_name  = oci_load_balancer_backend_set.coa_backend_set.name
  ip_address       = oci_core_instance.web_instance[count.index].create_vnic_details[0].private_ip
  load_balancer_id = oci_load_balancer_load_balancer.coa_load_balancer.id
  port             = "80"
}


resource "oci_load_balancer_certificate" "coa_lbaas_certificate" {
  for_each = local.ssl_port_set

  #Required
  certificate_name = "${var.names_prefix}coa-lbaas-certificate"
  load_balancer_id = oci_load_balancer_load_balancer.coa_load_balancer.id

  #Optional
  ca_certificate     = file(var.lb_ca_certificate)
  private_key        = file(var.lb_private_key)
  public_certificate = file(var.lb_public_certificate)

  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_listener" "coa_listeners" {
  for_each = local.ports_set

  #Required
  default_backend_set_name = oci_load_balancer_backend_set.coa_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.coa_load_balancer.id
  name                     = "${var.names_prefix}listener-${each.key}"
  port                     = each.key
  protocol                 = "HTTP"

  dynamic "ssl_configuration" {
    for_each = each.value == "443" ? toset(["443"]) : toset([])
    content {
      #Optional
      certificate_name        = oci_load_balancer_certificate.coa_lbaas_certificate[ssl_configuration.value].certificate_name
      verify_peer_certificate = false
    }
  }
}






