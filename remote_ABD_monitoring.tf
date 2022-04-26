

#################
##   TOPIC   ####
#################

resource "oci_ons_notification_topic" "CreateNotificationTopic" {
  #Required
  compartment_id = var.default_compartment_id
  name           = var.notification_topic_name
  #Optional
  description = var.notification_topic_description

}
