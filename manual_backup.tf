locals {
    current_time = timestamp()
}


resource "oci_database_autonomous_database_backup" "autonomous_database_backup" {
  count = var.run_manual_backup == "True" ? 1 : 0

  # Create the backup only if the autonomous database id is provided and has been configured for backups.

  #Required
  #autonomous_database_id = module.adb[*].adb_database.adb_database_id
  autonomous_database_id = oci_database_autonomous_database.test_autonomous_database.id
  display_name           = "Manual_Backup_${local.current_time}"

  depends_on = [null_resource.configure_backup]
}
