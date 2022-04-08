# Copyright (c) 2022, Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.



#############################
# tenancy details
#############################

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
variable "tenancy_id" {
  description = "Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)"
}

# Get this from OCI > Identity > Users (for your user account)
variable "user_id" {
  description = "Get this from OCI > Identity > Users (for your user account)"
}

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
variable "fingerprint" {
  description = "The fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))"
}

# this is the full path on your local system to the private key used for the API key pair
variable "private_key_path" {
  description = "This is the full path on your local system to the private key used for the API key pair"
}

# region (us-phoenix-1, ca-toronto-1, etc)
variable "region" {
  default     = "eu-frankfurt-1"
  description = "region (us-phoenix-1, ca-toronto-1, etc)"
}

# default compartment 
variable "default_compartment_id" {
  description = "default compartment OCID"
}

#############################
# naming convension
#############################

# the prefix that will be used for all the names of the OCI artifacts that this automation will provision
variable "names_prefix" {
  type        = string
  default     = "coa-demo-"
  description = "the prefix that will be used for all the names of the OCI artifacts that this automation will provision"
}

# the defined tags to be used for all the artifacts that this automation will provision
variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "the defined tags to be used for all the artifacts that this automation will provision"
}

# the freeform tags to be used for all the artifacts that this automation will provision
variable "freeform_tags" {
  type        = map(string)
  default     = { "Demo" = "COA Change Management Operations Demo" }
  description = "the freeform tags to be used for all the artifacts that this automation will provision"
}

#############################
# COA Demo network
#############################

# The specific network compartment id. If this is null then the default, project level compartment_id will be used.
variable "network_compartment_id" {
  description = "The specific network compartment id. If this is null then the default, project level compartment_id will be used."
}

# VCN CIDR
variable "vcn_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VCN CIDR"
}

# private subnet CIDR
variable "private_subnet_cidr" {
  type        = string
  default     = "10.0.0.0/24"
  description = "private subnet CIDR"
}

# public subnet CIDR
variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.10.0/24"
  description = "public subnet CIDR"
}

# public subnet CIDR
variable "private_atp_subnet_cidr" {
  type        = string
  default     = "10.0.11.0/24"
  description = "private subnet CIDR"
}


#############################
# OCI COA LBaaS
#############################

# The COA LBaaS Shape
variable "load_balancer_shape" {
  type        = string
  default     = "10Mbps-Micro"
  description = "The COA LBaaS Shape"
}

# LBaaS listening ports
# Accepted values: ["80", "443", "<port number>"] 
variable "lbaas_listening_ports" {
  type        = list(string)
  default     = ["443"]
  description = "Accepted values: [80, 443, port number]"
}

# The path to the load balancer CA certificate
variable "lb_ca_certificate" {
  type        = string
  default     = "./certs/ca.crt"
  description = "The path to the load balancer CA certificate"
}

# The path to the load balancer private_key
variable "lb_private_key" {
  type        = string
  default     = "./certs/loadbalancer.key"
  description = "The path to the load balancer private_key"
}

# The path to the load balancer public_certificate
variable "lb_public_certificate" {
  type        = string
  default     = "./certs/loadbalancer.crt"
  description = "The path to the load balancer public_certificate"
}
#############################
# OCI COA WEB Instances
#############################

# The specific compute compartment id. If this is null then the default, project level compartment_id will be used.
variable "compute_compartment_id" {
  description = "The specific compute compartment id. If this is null then the default, project level compartment_id will be used."
}

# The number of cluster nodes to be provisioned
variable "cluster_size" {
  type        = number
  default     = 2
  description = "The number of cluster nodes to be provisioned"
}

# Compute instances ssh public key
variable "ssh_private_key_path" {
  description = "Compute instances ssh public key"
}

# Compute instances ssh private key
variable "ssh_public_key_path" {
  description = "Compute instances ssh private key"
}

# The name of the shape to be used for all the provisioned compute instances. The automation will automatically figure out the OCID for the spaecific shape name in the target region.
variable "shape" {
  type        = string
  default     = "VM.Standard2.1"
  description = "The name of the shape to be used for all the provisioned compute instances. The automation will automatically figure out the OCID for the spaecific shape name in the target region."
}

# The name of the image to be used for all the provisioned compute instances. The automation will automatically figure out the OCID for the specific image name in the target region.
variable "image_name" {
  type        = string
  default     = "Oracle-Linux-8.5-2021.12.08-0"
  description = "The name of the image to be used for all the provisioned compute instances. The automation will automatically figure out the OCID for the specific image name in the target region."
}

# Which product to install
# Accepted values: ["Apache", "Nginx", "Flask"] 
variable "install_product" {
  type        = string
  default     = "Nginx"
  description = "Accepted values: [Apache, Nginx, Flask]"
}



#############################
# ADB
#############################

# Deploy Database Layer. If you deploy this layer you have to choose Flask option in the previus step
# Accepted values: ["True", "False"] 
variable "deploy_adb" {
  type        = string
  default     = "True"
  description = "Accepted values: [True, False]"
}

variable "adb_password" {
  type        = string
  description = "Initial ADB ADMIN user password"
}

variable "adb_db_name" {
  type        = string
  description = "ADB DB Name"
}

variable "adb_display_name" {
  type        = string
  description = "ADB display name shown in the console"
}

variable "adb_db_version" {
  type        = string
  default     = "19c"
  description = "ADB Oracle database version"
}

variable "adb_workload" {
  type        = string
  default     = "OLTP"
  description = "ADB workload type: OLTP, DW"
}

variable "ATP_tde_wallet_zip_file" {
  type        = string
  default     = "adb_wallet.zip"
  description = "Name of the file where to store the ADB wallet"
}

variable "oracle_instant_client_version" {
  type        = string
  default     = "19.10"
  description = "Oracle client version"
}

variable "oracle_instant_client_version_short" {
  type        = string
  default     = "19.10"
  description = "Oracle client version short name"
}

variable "create_bucket" {
  type        = string
  default     = "True"
  description = "create Bucket for manual Backups"
}

variable "conf_manual_backup" {
  type        = string
  default     = "True"
  description = "condition to conf manua backup"
}

variable "conn_db" {
  default = ""
}

variable "username" {
  default = ""
  sensitive   = true
}

variable "password" {
  default = ""
  sensitive   = true
}
