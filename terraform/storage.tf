

resource "oci_objectstorage_bucket" "test_bucket" {
  count = var.create_bucket == "True" ? 1 : 0
  #Required
  compartment_id = var.default_compartment_id
  name           = "${var.names_prefix}bucket"
  namespace      = data.oci_objectstorage_namespace.user_namespace.namespace

}