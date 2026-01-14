variable "name" {
  type        = string
  description = "Jamf UI name for configuration profile."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}

variable "payload_header" {
  description = "Header-level payload fields for the plist generator."
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
}

variable "payload_content" {
  description = "Payload content block for the plist generator."
  type = object({
    payload_description        = optional(string, "")
    payload_display_name       = optional(string)
    payload_enabled            = optional(bool, true)
    payload_organization       = string
    payload_type               = string
    payload_version            = number
    payload_removal_disallowed = optional(bool, false)
    payload_scope              = optional(string, "System")

    settings = map(any)
  })
}

variable "redeploy_on_update" {
  type        = string
  description = "Redeployment behavior when updated. Valid values are 'All' or 'Newly Assigned'."
  default     = "Newly Assigned"

  validation {
    condition     = contains(["All", "Newly Assigned"], var.redeploy_on_update)
    error_message = "redeploy_on_update must be one of: 'All', 'Newly Assigned'."
  }
}

variable "distribution_method" {
  type        = string
  description = "Distribution method. Valid values are 'Make Available in Self Service' or 'Install Automatically'."
  default     = "Install Automatically"

  validation {
    condition     = contains(["Make Available in Self Service", "Install Automatically"], var.distribution_method)
    error_message = "distribution_method must be one of: 'Make Available in Self Service', 'Install Automatically'."
  }
}

variable "level" {
  type        = string
  description = "Deployment level. Valid values are 'User' or 'System'."
  default     = "System"

  validation {
    condition     = contains(["User", "System"], var.level)
    error_message = "level must be one of: 'User', 'System'."
  }
}

variable "payload_validate" {
  type        = bool
  description = "Whether to validate the profile payload."
  default     = true
}

variable "user_removable" {
  type        = bool
  description = "Whether the configuration profile is user removable."
  default     = false
}

variable "site_id" {
  type        = number
  description = "Jamf Pro Site ID."
  default     = null
}

variable "category_id" {
  type        = number
  description = "Jamf Pro Category ID."
  default     = null
}

variable "description" {
  type        = string
  description = "Description of the configuration profile."
  default     = null
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

  validation {
    condition = (
      var.scope.all_computers == true ||
      var.scope.all_jss_users == true ||
      length(var.scope.computer_ids) > 0 ||
      length(var.scope.computer_group_ids) > 0 ||
      length(var.scope.building_ids) > 0 ||
      length(var.scope.department_ids) > 0 ||
      length(var.scope.jss_user_ids) > 0 ||
      length(var.scope.jss_user_group_ids) > 0
    )
    error_message = "scope must target something: set all_computers=true (and allow_all_computers=true) or provide at least one target id set."
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
  default = null
}

variable "timeouts" {
  description = "Resource operation timeouts."
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = {}
}
