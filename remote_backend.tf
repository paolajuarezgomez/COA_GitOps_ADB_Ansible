
terraform {
  backend "s3" {
    bucket   = "terraform-backend"
    key      = "terraform.tfstate"
    # Add your region
    region   = "eu-frankfurt-1"
    # https://<namespace>.compat.objectstorage.<region>.oraclecloud.com
    # Modiy the endpoint value with your data.
    endpoint = "https://frxfz3gch4zb.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
    shared_credentials_file     = "./cred_store"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
