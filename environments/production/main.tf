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

locals {
  profiles = var.profiles != null ? var.profiles : {
    default = {
      name                = var.profile_name
      description         = var.profile_description
      payloads_file       = var.mobileconfig_path
      redeploy_on_update  = var.redeploy_on_update
      distribution_method = var.distribution_method
      level               = "System"
      payload_validate    = true
      user_removable      = false
      allow_all_computers = var.allow_all_computers
      scope               = var.scope
    }
  }
}

module "computer_configuration_profile" {
  source   = "../../modules/computers-configuration-profile"
  for_each = local.profiles

  name                = each.value.name
  description         = try(each.value.description, null)
  redeploy_on_update  = try(each.value.redeploy_on_update, "Newly Assigned")
  distribution_method = try(each.value.distribution_method, "Install Automatically")
  level               = try(each.value.level, "System")

  payloads_file       = each.value.payloads_file
  payload_validate    = try(each.value.payload_validate, true)
  user_removable      = try(each.value.user_removable, false)
  site_id             = try(each.value.site_id, null)
  category_id         = try(each.value.category_id, null)
  allow_all_computers = try(each.value.allow_all_computers, false)
  scope               = each.value.scope
}

output "profile_ids" {
  value = { for k, m in module.computer_configuration_profile : k => m.id }
}

output "profile_uuids" {
  value = { for k, m in module.computer_configuration_profile : k => m.uuid }
}
