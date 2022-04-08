# Copyright (c) 2022, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_user" "coa_demo_executer" {
  #Required
  user_id = var.user_id
}

data "oci_identity_availability_domains" "availability_domains" {
  #Required
  compartment_id = var.tenancy_id
}

data "oci_core_images" "this" {
  #Required
  compartment_id = var.default_compartment_id

  #Optional
  display_name = var.image_name
}


data "template_file" "flask_ATP_py_template" {
  template = file("./scripts/flask_ATP.py")

  vars = {
    ATP_password                        = var.adb_password
    ATP_alias                           = join("", [var.adb_db_name, "_medium"])
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}


data "template_file" "configure_backup_template" {
  template = file("./scripts/config_backup.sql")

  vars = {
    ATP_password = var.adb_password
    region       = var.region
    bucket       = "${var.names_prefix}bucket"
    namespace    = data.oci_objectstorage_namespace.user_namespace.namespace
    username     = var.username
    password     = var.password
  }
}


data "template_file" "configure_atp_temp" {
  template = file("./scripts/connect_atp.sh")

  vars = {
    ATP_alias = join("", [var.adb_db_name, "_medium"])
    password  = var.adb_password

  }
}


data "template_file" "atp_temp" {
  template = file("./scripts/connect_atp.sh")

  vars = {
    ATP_alias = join("", [var.adb_db_name, "_medium"])
    password  = var.adb_password

  }
}

data "template_file" "flask_ATP_sh_template" {
  template = file("./scripts/flask_ATP.sh")

  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "flask_bootstrap_template" {
  template = file("./scripts/flask_bootstrap.sh")

  vars = {
    ATP_tde_wallet_zip_file             = "adb_wallet.zip"
    oracle_instant_client_version       = var.oracle_instant_client_version
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "template_file" "sqlnet_ora_template" {
  template = file("./scripts/sqlnet.ora")

  vars = {
    oracle_instant_client_version_short = var.oracle_instant_client_version_short
  }
}

data "oci_objectstorage_namespace" "user_namespace" {

  compartment_id = var.default_compartment_id

}


data "oci_database_autonomous_database_backups" "test_autonomous_database_backups" {
  #Optional
  compartment_id = var.default_compartment_id
  display_name   = var.adb_display_name
}

data "oci_objectstorage_objects" "test_objects" {
  #Required
  bucket    = "${var.names_prefix}bucket"
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
}

