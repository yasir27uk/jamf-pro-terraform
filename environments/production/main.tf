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
  auth_method = var.jamfpro_auth_method

  jamfpro_instance_fqdn = var.jamfpro_instance_fqdn
  client_id             = var.jamfpro_client_id
  client_secret         = var.jamfpro_client_secret

  jamfpro_load_balancer_lock = true
}

module "computer_configuration_profile" {
  source = "../../modules/computers-configuration-profile"

  name                = var.profile_name
  description         = var.profile_description
  redeploy_on_update  = var.redeploy_on_update
  distribution_method = var.distribution_method
  level               = "System"

  payloads_file    = var.mobileconfig_path
  payload_validate = true
  user_removable   = false

  allow_all_computers = var.allow_all_computers
  scope               = var.scope
}

output "profile_id" {
  value = module.computer_configuration_profile.id
}

output "profile_uuid" {
  value = module.computer_configuration_profile.uuid
}
