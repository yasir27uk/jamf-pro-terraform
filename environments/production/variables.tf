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
  default     = "https://yourcompany.jamfcloud.com"

  validation {
    condition     = var.jamfpro_instance_fqdn != null && length(trimspace(var.jamfpro_instance_fqdn)) > 0
    error_message = "jamfpro_instance_fqdn is required. Set it in environments/production/terraform.tfvars (do not commit) or via TF_VAR_jamfpro_instance_fqdn."
  }
}

variable "jamfpro_client_id" {
  type        = string
  description = "The Jamf Pro OAuth2 client id (required when auth_method is oauth2)."
  sensitive   = true
  default     = "your_client_id"

  validation {
    condition     = var.jamfpro_auth_method != "oauth2" || (var.jamfpro_client_id != null && length(trimspace(var.jamfpro_client_id)) > 0)
    error_message = "jamfpro_client_id is required when jamfpro_auth_method is 'oauth2'."
  }
}

variable "jamfpro_client_secret" {
  type        = string
  description = "The Jamf Pro OAuth2 client secret (required when auth_method is oauth2)."
  sensitive   = true
  default     = "your_client_secret"

  validation {
    condition     = var.jamfpro_auth_method != "oauth2" || (var.jamfpro_client_secret != null && length(trimspace(var.jamfpro_client_secret)) > 0)
    error_message = "jamfpro_client_secret is required when jamfpro_auth_method is 'oauth2'."
  }
}

variable "version_number" {
  description = "The version number to include in the name and install button text."
  type        = string
  default     = "1.0"
}

variable "plist_version_number" {
  description = "Payload version number used for plist payload header/content versions."
  type        = number
  default     = 1
}

variable "profile_name" {
  type        = string
  description = "Jamf UI name for the configuration profile."
  default     = "Company - PPPC + System Extensions"
}

variable "profile_description" {
  type        = string
  description = "Description for the configuration profile."
  default     = "Managed by Terraform"
}

variable "payloads" {
  description = "Provider-doc style payloads input with payload_root and payload_content.configuration (single-profile fallback)."
  type = object({
    payload_root = object({
      payload_description_root        = optional(string, "")
      payload_enabled_root            = optional(bool, true)
      payload_organization_root       = string
      payload_removal_disallowed_root = optional(bool, false)
      payload_scope_root              = optional(string, "System")
      payload_type_root               = string
      payload_version_root            = number
    })

    payload_content = object({
      configuration = optional(list(object({
        key   = string
        value = string
      })), [])

      payload_description  = optional(string, "")
      payload_display_name = optional(string)
      payload_enabled      = optional(bool, true)
      payload_organization = string
      payload_type         = string
      payload_version      = number
      payload_scope        = optional(string, "System")
    })
  })
  default = {
    payload_root = {
      payload_description_root        = "Base Level Accessibility settings for vision"
      payload_enabled_root            = true
      payload_organization_root       = "Deployment Theory"
      payload_removal_disallowed_root = false
      payload_scope_root              = "System"
      payload_type_root               = "Configuration"
      payload_version_root            = 1
    }

    payload_content = {
      payload_description  = ""
      payload_display_name = "Accessibility"
      payload_enabled      = true
      payload_organization = "Deployment Theory"
      payload_type         = "com.apple.universalaccess"
      payload_version      = 1
      payload_scope        = "System"

      configuration = [
        { key = "closeViewFarPoint", value = "2" },
        { key = "closeViewHotkeysEnabled", value = "true" },
        { key = "closeViewNearPoint", value = "10" },
        { key = "closeViewScrollWheelToggle", value = "true" },
        { key = "closeViewShowPreview", value = "true" },
        { key = "closeViewSmoothImages", value = "true" },
        { key = "contrast", value = "0" },
        { key = "flashScreen", value = "false" },
        { key = "grayscale", value = "false" },
        { key = "mouseDriver", value = "false" },
        { key = "mouseDriverCursorSize", value = "3" },
        { key = "mouseDriverIgnoreTrackpad", value = "false" },
        { key = "mouseDriverInitialDelay", value = "1.0" },
        { key = "mouseDriverMaxSpeed", value = "3" },
        { key = "slowKey", value = "false" },
        { key = "slowKeyBeepOn", value = "false" },
        { key = "slowKeyDelay", value = "0" },
        { key = "stereoAsMono", value = "false" },
        { key = "stickyKey", value = "false" },
        { key = "stickyKeyBeepOnModifier", value = "false" },
        { key = "stickyKeyShowWindow", value = "false" },
        { key = "voiceOverOnOffKey", value = "true" },
        { key = "whiteOnBlack", value = "false" },
      ]
    }
  }
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
    payload_description_header  = "Base Level Accessibility settings for vision"
    payload_enabled_header      = true
    payload_organization_header = "Deployment Theory"
    payload_type_header         = "Configuration"
    payload_version_header      = 1
    payload_display_name_header = "Company - PPPC + System Extensions"
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

    settings = optional(map(any), {})
    settings_list = optional(list(object({
      key   = string
      value = string
    })), [])
  })
  default = {
    payload_description  = ""
    payload_display_name = "Accessibility"
    payload_enabled      = true
    payload_organization = "Deployment Theory"
    payload_type         = "com.apple.universalaccess"
    payload_version      = 1
    payload_scope        = "System"
    settings             = {}
    settings_list = [
      { key = "closeViewFarPoint", value = "2" },
      { key = "closeViewHotkeysEnabled", value = "true" },
      { key = "closeViewNearPoint", value = "10" },
      { key = "closeViewScrollWheelToggle", value = "true" },
      { key = "closeViewShowPreview", value = "true" },
      { key = "closeViewSmoothImages", value = "true" },
      { key = "contrast", value = "0" },
      { key = "flashScreen", value = "false" },
      { key = "grayscale", value = "false" },
      { key = "mouseDriver", value = "false" },
      { key = "mouseDriverCursorSize", value = "3" },
      { key = "mouseDriverIgnoreTrackpad", value = "false" },
      { key = "mouseDriverInitialDelay", value = "1.0" },
      { key = "mouseDriverMaxSpeed", value = "3" },
      { key = "slowKey", value = "false" },
      { key = "slowKeyBeepOn", value = "false" },
      { key = "slowKeyDelay", value = "0" },
      { key = "stereoAsMono", value = "false" },
      { key = "stickyKey", value = "false" },
      { key = "stickyKeyBeepOnModifier", value = "false" },
      { key = "stickyKeyShowWindow", value = "false" },
      { key = "voiceOverOnOffKey", value = "true" },
      { key = "whiteOnBlack", value = "false" },
    ]
  }
}

variable "self_service" {
  description = "Self Service configuration. Only valid when distribution_method is 'Make Available in Self Service'."
  type = object({
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
  })
  default = {
    install_button_text             = null
    self_service_description        = "This is the self service description"
    force_users_to_view_description = true
    feature_on_main_page            = true
    notification                    = true
    notification_subject            = "New Profile Available"
    notification_message            = "A new profile is available for installation."
    self_service_categories = [
      { id = 10, display_in = true, feature_in = true },
      { id = 5, display_in = false, feature_in = true },
    ]
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

    payloads = object({
      payload_root = object({
        payload_description_root        = optional(string, "")
        payload_enabled_root            = optional(bool, true)
        payload_organization_root       = string
        payload_removal_disallowed_root = optional(bool, false)
        payload_scope_root              = optional(string, "System")
        payload_type_root               = string
        payload_version_root            = number
      })

      payload_content = object({
        configuration = optional(list(object({
          key   = string
          value = string
        })), [])

        payload_description  = optional(string, "")
        payload_display_name = optional(string)
        payload_enabled      = optional(bool, true)
        payload_organization = string
        payload_type         = string
        payload_version      = number
        payload_scope        = optional(string, "System")
      })
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
    all_computers      = false
    all_jss_users      = false
    computer_ids       = [16, 20, 21]
    computer_group_ids = [78, 1]
    building_ids       = [1348, 1349]
    department_ids     = [37287, 37288]
    jss_user_ids       = [2, 1]
    jss_user_group_ids = [4, 505]

    limitations = {
      network_segment_ids                  = [4, 5]
      ibeacon_ids                          = [3, 4]
      directory_service_or_local_usernames = ["Jane Smith", "John Doe"]
      directory_service_usergroup_ids      = [3, 4]
    }

    exclusions = {
      computer_ids                         = [16, 20, 21]
      computer_group_ids                   = [78, 1]
      building_ids                         = [1348, 1349]
      department_ids                       = [37287, 37288]
      network_segment_ids                  = [4, 5]
      jss_user_ids                         = [2, 1]
      jss_user_group_ids                   = [4, 505]
      directory_service_or_local_usernames = ["Jane Smith", "John Doe"]
      directory_service_usergroup_ids      = [3, 4]
      ibeacon_ids                          = [3, 4]
    }
  }
}
