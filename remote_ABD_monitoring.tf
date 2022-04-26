
data "oci_ons_notification_topics" "test_notification_topics" {
    #Required
    compartment_id = var.compartment_id

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
  count = var.conf_mon == "True"
  #Required
  compartment_id = var.compartment_id
  name           = var.notification_topic_name
  #Optional
  description = var.notification_topic_description

}

##############################
##   SLACK SUBSCRIPTION   ####
##############################

resource "oci_ons_subscription" "test_subscription" {
    count = var.conf_mon == "True"
    #Required
    compartment_id = var.compartment_id
    endpoint = var.slack_endpoint
    protocol = var.protocol
    topic_id = data.oci_ons_notification_topics.test_notification_topics.notification_topics[0].topic_id
}


#################
##   EVENTS  ####
#################


resource "oci_events_rule" "oci_events_monitoring" {
  count = var.conf_mon == "True"
  #Required
  actions {
    #Required
    actions {
      #Required
      action_type = "OSS"
      is_enabled  = var.rule_actions_actions_is_enabled

      #Optional
      description = var.rule_actions_actions_description
      stream_id    = var.stream_endpoint
      topic_id = data.oci_ons_notification_topics.test_notification_topics.notification_topics[0].topic_id
  }

  actions {
      #Required
      action_type = "ONS"
      is_enabled  = var.rule_actions_actions_is_enabled

      #Optional
      description = var.rule_actions_actions_description
      topic_id = data.oci_ons_notification_topics.test_notification_topics.notification_topics[0].topic_id
  }

  }
  compartment_id = var.compartment_id
  condition      = var.rule_condition
  display_name   = var.rule_display_name
  is_enabled     = var.rule_is_enabled
  #Optional
  description = "${var.rule_description}"
}

#################
##   ALARMS  ####
#################

resource "oci_monitoring_alarm" "oci_atp_cpu_critical" {
    count = var.conf_mon == "True"
    #Required
    compartment_id = var.compartment_id
    destinations = [data.oci_ons_notification_topics.test_notification_topics.notification_topics[0].topic_id]
    display_name = "oci_atp_cpu_critical"
    is_enabled = var.alarm_enabled
    metric_compartment_id = var.compartment_id
    namespace = "oci_autonomous_database"
    query = "CpuUtilization[5m]{deploymentType = \"Shared\"}.max() > 80"
    severity = "CRITICAL"
   
}

resource "oci_monitoring_alarm" "oci_atp_session_warning" {
    count = var.conf_mon == "True"
    #Required
    compartment_id = var.compartment_id
    destinations = [data.oci_ons_notification_topics.test_notification_topics.notification_topics[0].topic_id]
    display_name = "oci_atp_session_warning"
    is_enabled = var.alarm_enabled
    metric_compartment_id = var.compartment_id
    namespace = "oci_autonomous_database"
    query = "Sessions[5m].rate() > 50"
    severity = "WARNING"
   
}
