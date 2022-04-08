# Copyright (c) 2022, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  tcp_protocol  = "6"
  icmp_protocol = "1"
  udp_protocol  = "17"
  vrrp_protocol = "112"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
}

resource "oci_core_vcn" "coa_demo_vcn" {
  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id

  #Optional
  cidr_block = var.vcn_cidr
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  display_name   = "${var.names_prefix}vcn"
  dns_label      = "coavcn"
  freeform_tags  = var.freeform_tags
  is_ipv6enabled = false
}

resource "oci_core_internet_gateway" "coa_internet_gateway" {
  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  enabled = true
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  display_name  = "${var.names_prefix}IG"
  freeform_tags = var.freeform_tags
}

resource "oci_core_nat_gateway" "coa_nat_gateway" {
  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  display_name  = "${var.names_prefix}NAT-GW"
  freeform_tags = var.freeform_tags
}

resource "oci_core_route_table" "coa_ig_route_table" {
  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  display_name  = "${var.names_prefix}ig-route-table"
  freeform_tags = var.freeform_tags
  route_rules {
    network_entity_id = oci_core_internet_gateway.coa_internet_gateway.id

    #Optional
    description      = "Trafic to public internet to be routed through the IG"
    destination      = local.anywhere
    destination_type = "CIDR_BLOCK"
  }
}



resource "oci_core_route_table" "coa_nat_gw_route_table" {
  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  display_name  = "${var.names_prefix}nat-gw-route-table"
  freeform_tags = var.freeform_tags
  route_rules {
    network_entity_id = oci_core_nat_gateway.coa_nat_gateway.id

    #Optional
    description      = "Trafic to public internet to be routed through the NAT GW"
    destination      = local.anywhere
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "coa_vcn_security_list" {
  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  display_name = "${var.names_prefix}vcn-security-list"
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  freeform_tags = var.freeform_tags

  # Egress Rules
  egress_security_rules {
    destination = local.anywhere
    protocol    = local.all_protocols

    # Optional
    description      = "egress to anywhere"
    destination_type = "CIDR_BLOCK"
    #icmp_options = 
    stateless = false
  }
  # Ingress Rules
  ingress_security_rules {
    #Required
    protocol = local.tcp_protocol
    source   = local.anywhere

    #Optional
    description = "Allow ingress for SSH:22 from anywhere"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 22
      min = 22
      #Optional
      #source_port_range = 
    }
  }

  ingress_security_rules {
    description = "ping from anywhere"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = local.anywhere
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }

  ingress_security_rules {
    description = "Ping from inside the vcn"
    icmp_options {
      code = "-1"
      type = "3"
    }
    protocol    = "1"
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = <<Optional value not found in discovery>>
    #udp_options = <<Optional value not found in discovery>>
  }
}

resource "oci_core_security_list" "coa_public_subnet_security_list" {
  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  display_name = "${var.names_prefix}public-subnet-security-list"
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  freeform_tags = var.freeform_tags

  # Egress Rules
  #egress_security_rules = {}

  dynamic "ingress_security_rules" {
    for_each = var.lbaas_listening_ports
    content {
      #Required
      protocol = local.tcp_protocol
      source   = local.anywhere
      #Optional
      description = "Allow ingress for HTTPS:${ingress_security_rules.value} from anywhere"
      source_type = "CIDR_BLOCK"
      stateless   = false
      tcp_options {
        max = ingress_security_rules.value
        min = ingress_security_rules.value
        #Optional
        #source_port_range = 
      }
    }
  }
}


resource "oci_core_security_list" "coa_private_subnet_security_list" {

  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  display_name = "${var.names_prefix}private-subnet-security-list"
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  freeform_tags = var.freeform_tags

  # Egress Rules
  #egress_security_rules = {}

  # Ingress Rules
  ingress_security_rules {
    #Required
    protocol = local.tcp_protocol
    source   = var.vcn_cidr

    #Optional
    description = "Allow ingress for HTTP:80 from ${var.vcn_cidr}"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 80
      min = 80
      #Optional
      #source_port_range = 
    }
  }
}


resource "oci_core_security_list" "coa_atp_private_subnet_security_list" {
  #Required
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  display_name = "${var.names_prefix}private_atp-subnet-security-list"
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  freeform_tags = var.freeform_tags

  # Egress Rules
  #egress_security_rules = {}

  # Ingress Rules
  ingress_security_rules {
    #Required
    protocol = local.tcp_protocol
    source   = var.vcn_cidr

    #Optional
    description = "Allow ingress for listener from ${var.vcn_cidr}"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = 1522
      min = 1522
      #Optional
      #source_port_range = 
    }
  }
}

resource "oci_core_subnet" "coa_private_subnet" {
  #Required
  cidr_block     = var.private_subnet_cidr
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  display_name = "${var.names_prefix}private-subnet"
  dns_label    = "prvsubnet"
  #prohibit_public_ip_on_vnic = true
  freeform_tags     = var.freeform_tags
  route_table_id    = oci_core_route_table.coa_nat_gw_route_table.id
  security_list_ids = [oci_core_security_list.coa_vcn_security_list.id, oci_core_security_list.coa_private_subnet_security_list.id]
}

resource "oci_core_subnet" "coa_public_subnet" {
  #Required
  cidr_block     = var.public_subnet_cidr
  compartment_id = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id

  #Optional
  defined_tags = {
    "CCA_Basic_Tag.email" = data.oci_identity_user.coa_demo_executer.name
  }
  display_name      = "${var.names_prefix}public-subnet"
  dns_label         = "pubsubnet"
  freeform_tags     = var.freeform_tags
  route_table_id    = oci_core_route_table.coa_ig_route_table.id
  security_list_ids = [oci_core_security_list.coa_vcn_security_list.id, oci_core_security_list.coa_public_subnet_security_list.id]
}

####### ADB ######

resource "oci_core_subnet" "coa_atp_private_subnet" {
  cidr_block                 = var.private_atp_subnet_cidr
  display_name               = "${var.names_prefix}atp_private-subnet"
  dns_label                  = "atpprivsubnet"
  compartment_id             = var.network_compartment_id != null ? var.network_compartment_id : var.default_compartment_id
  vcn_id                     = oci_core_vcn.coa_demo_vcn.id
  prohibit_public_ip_on_vnic = true
  dhcp_options_id            = oci_core_dhcp_options.DhcpOptions1.id
  freeform_tags              = var.freeform_tags
  route_table_id             = oci_core_route_table.coa_ig_route_table.id
}


resource "oci_core_dhcp_options" "DhcpOptions1" {
  compartment_id = var.default_compartment_id
  vcn_id         = oci_core_vcn.coa_demo_vcn.id
  display_name   = "DHCPOptions1"

  // required
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type                = "SearchDomain"
    search_domain_names = ["example.com"]
  }
}