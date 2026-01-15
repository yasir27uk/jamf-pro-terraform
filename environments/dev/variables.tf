variable "profile_name_prefix" {
  type        = string
  description = "Prefix for the configuration profile name."
}

variable "profile_description" {
  type        = string
  description = "Description of the configuration profile."
}

variable "distribution_method" {
  type        = string
  default     = "Install Automatically"
}

variable "redeploy_on_update" {
  type        = string
  default     = "Newly Assigned"
}

variable "user_removable" {
  type        = bool
  default     = false
}

variable "profile_level" {
  type        = string
  default     = "System"
}

variable "version_number" {
  type        = string
  description = "Version shown in Self Service install button."
}

variable "plist_version_number" {
  type        = string
  description = "Payload plist version."
}

variable "organization_name" {
  type        = string
  default     = "Deployment Theory"
}

variable "payload_type" {
  type        = string
  default     = "com.apple.universalaccess"
}

variable "payload_display_name" {
  type        = string
  default     = "Accessibility"
}

variable "payload_configurations" {
  description = "Key/value pairs for plist payload configuration."
  type = list(object({
    key   = string
    value = any
  }))
}

variable "scope" {
  description = "Jamf Pro scope configuration."
  type = object({
    all_computers        = bool
    all_jss_users        = bool
    computer_ids         = list(number)
    computer_group_ids   = list(number)
    building_ids         = list(number)
    department_ids       = list(number)
    jss_user_ids         = list(number)
    jss_user_group_ids   = list(number)

    limitations = optional(object({
      network_segment_ids                  = list(number)
      ibeacon_ids                          = list(number)
      directory_service_or_local_usernames = list(string)
      directory_service_usergroup_ids      = list(number)
    }))

    exclusions = optional(object({
      computer_ids                         = list(number)
      computer_group_ids                   = list(number)
      building_ids                         = list(number)
      department_ids                       = list(number)
      network_segment_ids                  = list(number)
      jss_user_ids                         = list(number)
      jss_user_group_ids                   = list(number)
      directory_service_or_local_usernames = list(string)
      directory_service_usergroup_ids      = list(number)
      ibeacon_ids                          = list(number)
    }))
  })
}

variable "self_service_enabled" {
  type    = bool
  default = true
}

variable "self_service" {
  type = object({
    description             = string
    force_view_description  = bool
    feature_on_main_page    = bool
    notification            = bool
    notification_subject    = string
    notification_message    = string
    categories = list(object({
      id         = number
      display_in = bool
      feature_in = bool
    }))
  })
}
