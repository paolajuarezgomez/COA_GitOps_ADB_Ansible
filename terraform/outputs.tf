# Copyright (c) 2022, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.



locals {

  #########################
  ## ADB
  #########################
  #
  # adb_details = {
  #   adb            = module.adb.adb_database
  #  wallet_content = module.adb.adb_database.adb_wallet_content
  # }



  #########################
  ## Networking Details
  #########################


  networking_details = {
    vcn = {
      vcn_name       = oci_core_vcn.coa_demo_vcn.display_name,
      vcn_id         = oci_core_vcn.coa_demo_vcn.id,
      vcn_cidr_block = oci_core_vcn.coa_demo_vcn.cidr_block
      vcn_dns_label  = oci_core_vcn.coa_demo_vcn.dns_label
    },
    route_tables = {
      ig_route_table = {
        route_table_name  = oci_core_route_table.coa_ig_route_table.display_name,
        route_table_id    = oci_core_route_table.coa_ig_route_table.id,
        route_table_rules = oci_core_route_table.coa_ig_route_table.route_rules
      },
      nat_gw_route_table = {
        route_table_name  = oci_core_route_table.coa_nat_gw_route_table.display_name,
        route_table_id    = oci_core_route_table.coa_nat_gw_route_table.id,
        route_table_rules = oci_core_route_table.coa_nat_gw_route_table.route_rules
      }
    }
    private-subnet = {
      subnet_name    = oci_core_subnet.coa_private_subnet.display_name,
      subnet_cidr    = oci_core_subnet.coa_private_subnet.cidr_block,
      route_table    = oci_core_route_table.coa_nat_gw_route_table.display_name,
      dns_label      = "${oci_core_vcn.coa_demo_vcn.dns_label}.${oci_core_subnet.coa_private_subnet.dns_label}",
      security_lists = [oci_core_security_list.coa_vcn_security_list.display_name, oci_core_security_list.coa_private_subnet_security_list.display_name]
    },
    public-subnet = {
      subnet_name    = oci_core_subnet.coa_public_subnet.display_name,
      subnet_cidr    = oci_core_subnet.coa_public_subnet.cidr_block,
      route_table    = oci_core_route_table.coa_ig_route_table.display_name,
      dns_label      = "${oci_core_vcn.coa_demo_vcn.dns_label}.${oci_core_subnet.coa_public_subnet.dns_label}",
      security_lists = [oci_core_security_list.coa_vcn_security_list.display_name, oci_core_security_list.coa_public_subnet_security_list.display_name]
    },
    internet-gw = {
      ig_name = oci_core_internet_gateway.coa_internet_gateway.display_name
    },
    security_lists = {
      coa_vcn_level_sec_list = {
        name = oci_core_security_list.coa_vcn_security_list.display_name
      },
      coa_public_subnet_sec_list = {
        name = oci_core_security_list.coa_public_subnet_security_list.display_name
      },
      coa_private_subnet_sec_list = {
        name = oci_core_security_list.coa_private_subnet_security_list.display_name
      }
    }
  }


  #########################
  ## Compute Details
  #########################
  compute_details = {
    bastion_instance = {
      name       = oci_core_instance.bastion_instance.display_name,
      public_ip  = oci_core_instance.bastion_instance.public_ip,
      private_ip = oci_core_instance.bastion_instance.create_vnic_details[0].private_ip,
      hostname   = oci_core_instance.bastion_instance.create_vnic_details[0].hostname_label
    },
    web_instances = {
      for web_instance in oci_core_instance.web_instance :
      web_instance.display_name => {
        display_name = web_instance.display_name
        private_ip   = web_instance.create_vnic_details[0].private_ip,
        hostname     = web_instance.create_vnic_details[0].hostname_label,
        web_server   = "${var.install_product == "Apache" ? "Apache Web server listening on http://${web_instance.create_vnic_details[0].private_ip}:80" : var.install_product == "Nginx" ? "NGINX Web server listening on http://${web_instance.create_vnic_details[0].private_ip}:80" : var.install_product == "Flask" ? "Flash Web server listening on http://${web_instance.create_vnic_details[0].private_ip}:80" : var.install_product == "ORDS" ? "ORDS listening on http://:80" : "No WEB Server installed"}"
      }
    }
  }

  #########################
  ## LbaaS Details
  #########################
  lbaas_details = {
    coa_lbaas = {
      name    = oci_load_balancer_load_balancer.coa_load_balancer.display_name,
      shape   = oci_load_balancer_load_balancer.coa_load_balancer.shape,
      subnet  = oci_core_subnet.coa_public_subnet.display_name,
      private = oci_load_balancer_load_balancer.coa_load_balancer.is_private,
      backend_set = {
        name   = oci_load_balancer_backend_set.coa_backend_set.name,
        policy = oci_load_balancer_backend_set.coa_backend_set.policy,
        backends = {
          for backend in oci_load_balancer_backend.coa_backends :
          backend.ip_address => {
            ip_address = backend.ip_address,
            port       = backend.port
          }
        }
        listeners = {
          for listener in oci_load_balancer_listener.coa_listeners :
          listener.name => {
            name       = listener.name,
            protocol   = listener.protocol,
            ip_address = oci_load_balancer_load_balancer.coa_load_balancer.ip_address_details[0].ip_address,
            port       = listener.port,
            app_url    = "${listener.port == 443 ? "https://${oci_load_balancer_load_balancer.coa_load_balancer.ip_address_details[0].ip_address}:${listener.port}" : "http://${oci_load_balancer_load_balancer.coa_load_balancer.ip_address_details[0].ip_address}:${listener.port}"}"
          }
        }
      }
    }
  }
}


#########################
## COA DEMO Details
#########################

output "COA_Demo_Details" {
  value = {
    automation_run_by  = data.oci_identity_user.coa_demo_executer.name,
    networking_details = local.networking_details,
    compute_details    = local.compute_details,
    lbaas_details      = local.lbaas_details
  }
}

#########################
## Storage
#########################

output "bucket" {
  value = {
    bucketname = data.oci_objectstorage_objects.test_objects.bucket
  }
}

output "database" {
  value = {
    adb            = module.adb[*].adb_database.adb_database_id
  }
}

