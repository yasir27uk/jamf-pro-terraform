variable "jamfpro_auth_method" {
  type        = string
  description = "The Jamf Pro authentication method. Options are 'basic' for username/password or 'oauth2' for client id/secret."
  default     = "oauth2"

  validation {
    condition     = contains(["basic", "oauth2"], var.jamfpro_auth_method)
    error_message = "jamfpro_auth_method must be 'basic' or 'oauth2'."
  }
}

variable "jamfpro_instance_fqdn" {
  type        = string
  description = "The Jamf Pro instance FQDN (e.g., https://yourcompany.jamfcloud.com)"
  sensitive   = true
  default     = null

  validation {
    condition     = var.jamfpro_instance_fqdn != null && length(trimspace(var.jamfpro_instance_fqdn)) > 0
    error_message = "jamfpro_instance_fqdn is required. Set it in environments/production/terraform.tfvars (do not commit) or via TF_VAR_jamfpro_instance_fqdn."
  }
}

variable "jamfpro_client_id" {
  type        = string
  description = "The Jamf Pro OAuth2 client id (required when auth_method is oauth2)."
  sensitive   = true
  default     = null

  validation {
    condition     = var.jamfpro_auth_method != "oauth2" || (var.jamfpro_client_id != null && length(trimspace(var.jamfpro_client_id)) > 0)
    error_message = "jamfpro_client_id is required when jamfpro_auth_method is 'oauth2'."
  }
}

variable "jamfpro_client_secret" {
  type        = string
  description = "The Jamf Pro OAuth2 client secret (required when auth_method is oauth2)."
  sensitive   = true
  default     = null

  validation {
    condition     = var.jamfpro_auth_method != "oauth2" || (var.jamfpro_client_secret != null && length(trimspace(var.jamfpro_client_secret)) > 0)
    error_message = "jamfpro_client_secret is required when jamfpro_auth_method is 'oauth2'."
  }
}

variable "profile_name" {
  type        = string
  description = "Jamf UI name for the configuration profile."
  default     = "Company Base Profile"
}

variable "profile_description" {
  type        = string
  description = "Description for the configuration profile."
  default     = null
}

variable "payload_header" {
  description = "Header-level payload fields for the plist generator (single-profile fallback)."
  type = object({
    payload_description_header  = string
    payload_enabled_header      = bool
    payload_organization_header = string
    payload_type_header         = string
    payload_version_header      = number

    payload_display_name_header       = optional(string)
    payload_removal_disallowed_header = optional(bool, false)
    payload_scope_header              = optional(string, "System")
  })
  default = {
    payload_description_header  = ""
    payload_enabled_header      = true
    payload_organization_header = "Company"
    payload_type_header         = "Configuration"
    payload_version_header      = 1
    payload_display_name_header = "Company Base Profile"
    payload_scope_header        = "System"
  }
}

variable "payload_content" {
  description = "Payload content block for the plist generator (single-profile fallback)."
  type = object({
    payload_description  = optional(string, "")
    payload_display_name = optional(string)
    payload_enabled      = optional(bool, true)
    payload_organization = string
    payload_type         = string
    payload_version      = number
    payload_scope        = optional(string, "System")

    settings = map(any)
  })
  default = {
    payload_description  = ""
    payload_display_name = "Company WiFi"
    payload_enabled      = true
    payload_organization = "Company"
    payload_type         = "com.apple.wifi.managed"
    payload_version      = 1
    payload_scope        = "System"
    settings = {
      SSID_STR = "CompanySSID"
      AutoJoin = true
    }
  }
}

variable "profiles" {
  description = "Optional map of configuration profiles to create. If provided, overrides the single profile_* variables and creates one profile per map entry."
  type = map(object({
    name = string

    description = optional(string)

    redeploy_on_update  = optional(string, "Newly Assigned")
    distribution_method = optional(string, "Install Automatically")
    level               = optional(string, "System")

    user_removable = optional(bool, false)

    site_id     = optional(number)
    category_id = optional(number)

    allow_all_computers = optional(bool, false)
    scope = object({
      all_computers = bool

      all_jss_users = optional(bool, false)

      building_ids       = optional(set(number), [])
      computer_group_ids = optional(set(number), [])
      computer_ids       = optional(set(number), [])
      department_ids     = optional(set(number), [])
      jss_user_group_ids = optional(set(number), [])
      jss_user_ids       = optional(set(number), [])

      limitations = optional(object({
        network_segment_ids                  = optional(set(number), [])
        ibeacon_ids                          = optional(set(number), [])
        directory_service_or_local_usernames = optional(set(string), [])
        directory_service_usergroup_ids      = optional(set(number), [])
      }))

      exclusions = optional(object({
        computer_ids                         = optional(set(number), [])
        computer_group_ids                   = optional(set(number), [])
        building_ids                         = optional(set(number), [])
        department_ids                       = optional(set(number), [])
        network_segment_ids                  = optional(set(number), [])
        jss_user_ids                         = optional(set(number), [])
        jss_user_group_ids                   = optional(set(number), [])
        directory_service_or_local_usernames = optional(set(string), [])
        directory_service_usergroup_ids      = optional(set(number), [])
        ibeacon_ids                          = optional(set(number), [])
      }))
    })

    payload_header = object({
      payload_description_header  = string
      payload_enabled_header      = bool
      payload_organization_header = string
      payload_type_header         = string
      payload_version_header      = number

      payload_display_name_header       = optional(string)
      payload_removal_disallowed_header = optional(bool, false)
      payload_scope_header              = optional(string, "System")
    })

    payload_content = object({
      payload_description  = optional(string, "")
      payload_display_name = optional(string)
      payload_enabled      = optional(bool, true)
      payload_organization = string
      payload_type         = string
      payload_version      = number
      payload_scope        = optional(string, "System")

      settings = map(any)
    })

    self_service = optional(object({
      install_button_text             = optional(string)
      self_service_description        = optional(string)
      force_users_to_view_description = optional(bool)
      feature_on_main_page            = optional(bool)
      notification                    = optional(bool)
      notification_subject            = optional(string)
      notification_message            = optional(string)

      self_service_categories = optional(list(object({
        id         = number
        display_in = optional(bool)
        feature_in = optional(bool)
      })), [])
    }))

    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }), {})
  }))
  default = null

  validation {
    condition = var.profiles == null || alltrue([
      for _, p in var.profiles : contains(["All", "Newly Assigned"], p.redeploy_on_update)
    ])
    error_message = "For each profile, redeploy_on_update must be one of: 'All', 'Newly Assigned'."
  }

  validation {
    condition = var.profiles == null || alltrue([
      for _, p in var.profiles : contains(["Make Available in Self Service", "Install Automatically"], p.distribution_method)
    ])
    error_message = "For each profile, distribution_method must be one of: 'Make Available in Self Service', 'Install Automatically'."
  }

  validation {
    condition = var.profiles == null || alltrue([
      for _, p in var.profiles : contains(["User", "System"], p.level)
    ])
    error_message = "For each profile, level must be one of: 'User', 'System'."
  }
}

variable "redeploy_on_update" {
  type        = string
  description = "Redeployment behavior when updated. Valid values are 'All' or 'Newly Assigned'."
  default     = "Newly Assigned"
}

variable "distribution_method" {
  type        = string
  description = "Distribution method. Valid values are 'Make Available in Self Service' or 'Install Automatically'."
  default     = "Install Automatically"
}

variable "allow_all_computers" {
  type        = bool
  description = "Guardrail: set true to allow scope.all_computers=true."
  default     = false
}

variable "scope" {
  description = "Scope configuration for the profile."
  type = object({
    all_computers = bool

    all_jss_users = optional(bool, false)

    building_ids       = optional(set(number), [])
    computer_group_ids = optional(set(number), [])
    computer_ids       = optional(set(number), [])
    department_ids     = optional(set(number), [])
    jss_user_group_ids = optional(set(number), [])
    jss_user_ids       = optional(set(number), [])

    limitations = optional(object({
      network_segment_ids                  = optional(set(number), [])
      ibeacon_ids                          = optional(set(number), [])
      directory_service_or_local_usernames = optional(set(string), [])
      directory_service_usergroup_ids      = optional(set(number), [])
    }))

    exclusions = optional(object({
      computer_ids                         = optional(set(number), [])
      computer_group_ids                   = optional(set(number), [])
      building_ids                         = optional(set(number), [])
      department_ids                       = optional(set(number), [])
      network_segment_ids                  = optional(set(number), [])
      jss_user_ids                         = optional(set(number), [])
      jss_user_group_ids                   = optional(set(number), [])
      directory_service_or_local_usernames = optional(set(string), [])
      directory_service_usergroup_ids      = optional(set(number), [])
      ibeacon_ids                          = optional(set(number), [])
    }))
  })

  default = {
    all_computers = false
  }
}
