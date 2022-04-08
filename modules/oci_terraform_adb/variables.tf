## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl


# Copyright 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "adb" {
  description = "ADB generic variable"
  type = object({
    compartment_id                       = string,
    db_name                              = string,
    display_name                         = string,
    admin_password                       = string,
    are_primary_whitelisted_ips_used     = bool,
    cpu_core_count                       = string,
    ocpu_count                           = string,
    customer_contacts                    = list(object({
       email = string
    })),
    data_storage_size_in_gb              = string, 
    data_storage_size_in_tbs             = string,
    data_safe_status                     = string,
    db_version                           = string,
    db_workload                          = string,
    defined_tags                         = map(string),
    freeform_tags                        = map(string),
    is_access_control_enabled            = bool,
    is_auto_scaling_enabled              = bool,
    is_data_guard_enabled                = bool,
    is_free_tier                         = bool,
    is_mtls_connection_required          = bool,
    is_refreshable_clone                 = bool,
    license_model                        = string,
    nsg_ids                              = list(string),
    refreshable_mode                     = string,
    operations_insights_status           = string,
    private_endpoint_label               = string,
    rotate_key_trigger                   = string,
    scheduled_operations                 = list(object({
       day_of_week = list(object({
         name = string
       })),
       scheduled_start_time = string,
       scheduled_stop_time = string,
    })),
    standby_whitelisted_ips              = list(string),
    state                                = string,
    subnet_id                            = string,
    whitelisted_ips                      = list(string),
    
    autonomous_container_database_id     = string,
    autonomous_database_backup_id        = string,
    autonomous_database_id               = string,
    clone_type                           = string,
    autonomous_maintenance_schedule_type = string,
    is_dedicated                         = bool,
    is_preview_version_with_service_terms_accepted = bool,
    kms_key_id                           = string,
    source                               = string,
    source_id                            = string,
    switchover_to                        = string,
    timestamp                            = string,
    vault_id                             = string,
  })
}

variable default_compartment_id {
  description = "Default compartment OCID to use by resources unless otherwise specified"
  type = string
}

variable "adb_wallet_password_specials" {
  default = true
}

variable "adb_wallet_password_length" {
  default = 16
}

variable "adb_wallet_password_min_numeric" {
  default = 2
}

variable "adb_wallet_password_override_special" {
  default = ""
}

variable "conn_db" {
  default = ""
}

