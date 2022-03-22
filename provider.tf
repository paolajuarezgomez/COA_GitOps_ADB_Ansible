## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

terraform {
  required_version = ">= 0.14"
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      
    }
    
    random = {
      source  = "hashicorp/random"
      version = "2.3.0" 
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = "user.pem"
  region           = var.region
}

