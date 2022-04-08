
locals {
    current_time = timestamp()
}


resource "oci_database_autonomous_database_backup" "autonomous_database_backup" {
  # Create the backup only if the autonomous database id is provided and has been configured for backups.

  #Required
  autonomous_database_id = var.adb_id
  display_name           = "Manual_Backup_${local.current_time}"
}


