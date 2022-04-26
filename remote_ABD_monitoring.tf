
data "oci_ons_notification_topics" "test_notification_topics" {
    #Required
    compartment_id = var.default_compartment_id

    #Optional
    name = var.notification_topic_name
  
}

output "Databases_topic" {
  value = data.oci_ons_notification_topics.test_notification_topics.notification_topics[0].topic_id
}


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
