# Copyright 2022 Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# NOTICE: You should avoid to push the "terraform.tfvars" file for pushing to your GIT by adding to .gitignore

# Needed variables to setup Terraform for being access to connect with a valir user authorized to create resources in your tenancy and compartment.

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
tenancy_id = "ocid1.tenancy.oc1..aaaaaaaaxzpxbcag7zgamh2erlggqro3y63tvm2rbkkjz4z2zskvagupiz7a"

# Get this from OCI > Identity > Users (for your user account)
user_id = "ocid1.user.oc1..aaaaaaaamoz7ype3cfnznsrzxaw3qrq4sjym2mqfcm6fgj3inli2levpxswq"

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
fingerprint = "e5:a5:d3:a1:64:37:fa:73:9f:99:51:c4:2c:55:fc:7f"

# this is the full path on your local system to the private key used for the API key pair
private_key_path = "/Users/pjuarez/.oci/oci_api_key.pem"

# region (us-phoenix-1, ca-toronto-1, etc)
region = "eu-frankfurt-1"