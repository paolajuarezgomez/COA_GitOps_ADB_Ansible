# Copyright 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

resource "oci_database_autonomous_database" "adb_database" {
  # Required
    compartment_id                      = var.adb.compartment_id != null ? var.adb.compartment_id :var.default_compartment_id # Updatable
    db_name                             = var.adb.db_name

  # Optional
    # Updatables
    display_name                         = var.adb.display_name
    admin_password                       = var.adb.admin_password
    are_primary_whitelisted_ips_used     = var.adb.are_primary_whitelisted_ips_used # Null if not DG enabled or Access Control disabled
    cpu_core_count                       = var.adb.cpu_core_count
    ocpu_count                           = var.adb.ocpu_count # Incompatible with cpu_core_count. This lets assign fractions of OCPU for ADB over dedicated infra
    dynamic "customer_contacts" {
      for_each = var.adb.customer_contacts
      content {
        email = customer_contacts.value.email # Email for outages and scheduled announcements for the ADB
      }
    } 
    data_storage_size_in_gb              = var.adb.data_storage_size_in_gb # Only valid for dedicated infrastructure. Incompatible with data_storage_size_in_tbs
    data_storage_size_in_tbs             = var.adb.data_storage_size_in_tbs
    data_safe_status                     = var.adb.data_safe_status # REGISTERED | NOT_REGISTERED
    db_version                           = var.adb.db_version # Depends on db_workload. AJD & APEX just support 19c
    db_workload                          = var.adb.db_workload # Valids: OLTP | DW | AJD (JSON) | APEX. Can just be updated from AJD -> OLTP or from OLTP -> AJD
    defined_tags                         = var.adb.defined_tags
    freeform_tags                        = var.adb.freeform_tags
    is_access_control_enabled            = var.adb.is_access_control_enabled # If enabled access is enabled by whitelistedIps. If disable access is NSG
    is_auto_scaling_enabled              = var.adb.is_auto_scaling_enabled # Default: FALSE
    is_data_guard_enabled                = var.adb.is_data_guard_enabled # Indicates in-region DG. Not applicable to cross-region AutoDG or DG in dedicated or ExaCC
    is_free_tier                         = var.adb.is_free_tier # Default: FALSE. AJD or APEX not avaible for always free
    is_mtls_connection_required          = var.adb.is_mtls_connection_required # TRUE if mTLS is required
    is_refreshable_clone                 = var.adb.is_refreshable_clone # Applicable when source=CLONE_TO_REFRESHABLE. True for creating refreshable. False for detaching clone from source
    license_model                        = var.adb.license_model # BRING_YOUR_OWN_LICENSE | LICENSE_INCLUDED. NULL if dedicated. AJD not support BYOL
    nsg_ids                              = var.adb.nsg_ids # List of OCID's of NSG. If private access at least 1 NSG is required
    refreshable_mode                     = var.adb.refreshable_mode # Applies if source=CLONE_TO_REFRESHABLE. Refresh mode for the clone. Valids: AUTOMATIC
    operations_insights_status           = var.adb.operations_insights_status # Status of operations insights. Valids: ENABLED | NOT_ENABLED
    private_endpoint_label               = var.adb.private_endpoint_label 
    rotate_key_trigger                   = var.adb.rotate_key_trigger # Only when true is_dedicated
    dynamic "scheduled_operations" {
      for_each = var.adb.scheduled_operations
      content {

        dynamic "day_of_week" {
          for_each = scheduled_operations.value.day_of_week
          content {
            name = day_of_week.value.name # Day of the week to schedule: MONDAY, TUESDAY...
          }
        }
        scheduled_start_time = scheduled_operations.value.scheduled_start_time # Start time
        scheduled_stop_time = scheduled_operations.value.scheduled_stop_time # Stop time
      }
    }
             
    standby_whitelisted_ips              = var.adb.standby_whitelisted_ips
    state                                = var.adb.state # AVAILABLE | STOPPED. Used to stop your ADB (and part of billing)
    subnet_id                            = var.adb.subnet_id # Will disabled public secure access
    whitelisted_ips                      = var.adb.whitelisted_ips # Clients IPs to include in ACL. Array of CIDR or VCN OCID separated by ;

    # Non-updatable
    autonomous_container_database_id     = var.adb.autonomous_container_database_id # Only for dedicated envs
    autonomous_database_backup_id        = var.adb.autonomous_database_backup_id # Required when source=BACKUP_FROM_ID
    autonomous_database_id               = var.adb.autonomous_database_id # Required when source=BACKUP_FROM_TIMESTAMP
    clone_type                           = var.adb.clone_type # Required when source=BACKUP_FROM_ID | BACKUP_FROM_TIMESTAMP | DATABASE. Can be FULL | METADATA 
    autonomous_maintenance_schedule_type = var.adb.autonomous_maintenance_schedule_type # EARLY | REGULAR
    is_dedicated                         = var.adb.is_dedicated # TRUE if dedicated infrastructure
    is_preview_version_with_service_terms_accepted = var.adb.is_preview_version_with_service_terms_accepted # TRUE if ADB preview version is provisioned and accepted terms of service
    kms_key_id                           = var.adb.kms_key_id #d OCID of OKV key container for TDE encryption
    source                               = var.adb.source # For shared: NONE (new) | BACKUP_FROM_ID | BACKUP_FROM_TIMESTAMP. For other: DATABASE | CROSS_REGION_DATAGUARD
    source_id                            = var.adb.source_id # Required when source=CLONE_TO_REFRESHABLE | DATABASE. OCID or source ADB
    switchover_to                        = var.adb.switchover_to # Applicable if true is_data_guard_enabled. Valids: PRIMARY | STANDBY. Def: PRIMARY
    timestamp                            = var.adb.timestamp # Required when source=BACKUP_FROM_TIMESTAMP
    vault_id                             = var.adb.vault_id # OCID of the OKV if any
}

resource "random_password" "wallet_password" {
  length           = var.adb_wallet_password_length
  special          = var.adb_wallet_password_specials
  min_numeric      = var.adb_wallet_password_min_numeric
  override_special = var.adb_wallet_password_override_special
}

resource "oci_database_autonomous_database_wallet" "adb_database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.adb_database.id
  password               = random_password.wallet_password.result
  base64_encode_content  = "true"
}