terraform {
  required_providers {
    jamfpro = {
      source  = "deploymenttheory/jamfpro"
      version = "= 0.28.0"
    }
  }
  required_version = ">= 1.13.0"
}

provider "jamfpro" {
  auth_method = var.jamfpro_auth_method

  jamfpro_instance_fqdn = var.jamfpro_instance_fqdn
  client_id             = var.jamfpro_client_id
  client_secret         = var.jamfpro_client_secret

  enable_client_sdk_logs               = var.enable_client_sdk_logs
  client_sdk_log_export_path           = var.client_sdk_log_export_path
  hide_sensitive_data                  = var.jamfpro_hide_sensitive_data
  jamfpro_load_balancer_lock           = var.jamfpro_jamf_load_balancer_lock
  token_refresh_buffer_period_seconds  = 0
  mandatory_request_delay_milliseconds = var.jamfpro_mandatory_request_delay_milliseconds
  basic_auth_username                  = var.jamfpro_basic_auth_username
  basic_auth_password                  = var.jamfpro_basic_auth_password

}

module "computer_configuration_profile" {
  source = "../../modules/computers-configuration-profile"
  for_each = var.profiles != null ? {
    for k, v in var.profiles : k => merge(
      {
        payloads = var.payloads
      },
      v
    )
    } : {
    default = {
      name                = "${var.profile_name}-${var.version_number}"
      description         = var.profile_description
      redeploy_on_update  = var.redeploy_on_update
      distribution_method = var.distribution_method
      level               = "System"
      user_removable      = false
      allow_all_computers = var.allow_all_computers
      scope               = var.scope

      payloads = {
        payload_root = merge(
          var.payloads.payload_root,
          {
            payload_version_root = var.plist_version_number
          }
        )

        payload_content = merge(
          var.payloads.payload_content,
          {
            payload_version = var.plist_version_number
          }
        )
      }
    }
  }

  name                = each.value.name
  description         = try(each.value.description, null)
  distribution_method = try(each.value.distribution_method, "Install Automatically")
  redeploy_on_update  = try(each.value.redeploy_on_update, "Newly Assigned")
  user_removable      = try(each.value.user_removable, false)
  level               = try(each.value.level, "System")

  site_id     = try(each.value.site_id, null)
  category_id = try(each.value.category_id, null)

  allow_all_computers = try(each.value.allow_all_computers, false)
  scope               = each.value.scope

  payloads = each.value.payloads

  self_service = try(each.value.distribution_method, "Install Automatically") == "Make Available in Self Service" ? merge(
    var.self_service,
    try(each.value.self_service, {}),
    {
      install_button_text = "Install - ${var.version_number}"
    }
  ) : null
  timeouts = try(each.value.timeouts, {})
}

output "profile_ids" {
  value = { for k, m in module.computer_configuration_profile : k => m.id }
}

output "profile_uuids" {
  value = { for k, m in module.computer_configuration_profile : k => m.uuid }
}
