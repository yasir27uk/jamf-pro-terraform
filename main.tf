terraform {
  required_providers {
    jamfpro = {
      source  = "deploymenttheory/jamfpro"
      version = ">= 0.30.0"
    }
  }
  required_version = ">= 1.13.0"
}

provider "jamfpro" {
  # Authentication method: "basic" or "oauth2"
  auth_method = var.jamfpro_auth_method

  # For basic authentication
  jamfpro_instance_fqdn = var.jamfpro_instance_fqdn
  basic_auth_username   = var.jamfpro_username
  basic_auth_password   = var.jamfpro_password

  # For OAuth2 authentication (alternative to basic)
  # client_id     = var.jamfpro_client_id
  # client_secret = var.jamfpro_client_secret

  # Optional: Enable load balancer lock for Jamf Cloud
  jamfpro_load_balancer_lock = true

  # Optional: Custom cookies for non-Jamf Cloud load balanced setups
  # custom_cookies = [
  #   {
  #     name  = "cookie_name"
  #     value = "cookie_value"
  #   }
  # ]
}
