variable "jamfpro_auth_method" {
  type        = string
  description = "The Jamf Pro authentication method. Options are 'basic' for username/password or 'oauth2' for client id/secret."
  default     = "basic"
}

variable "jamfpro_instance_fqdn" {
  type        = string
  description = "The Jamf Pro instance FQDN (e.g., https://yourcompany.jamfcloud.com)"
  sensitive   = true
}

variable "jamfpro_username" {
  type        = string
  description = "The Jamf Pro username for basic authentication"
  sensitive   = true
  default     = ""
}

variable "jamfpro_password" {
  type        = string
  description = "The Jamf Pro password for basic authentication"
  sensitive   = true
  default     = ""
}

variable "profile_name" {
  type        = string
  description = "Jamf UI name for the configuration profile."
}

variable "profile_description" {
  type        = string
  description = "Description for the configuration profile."
  default     = null
}

variable "mobileconfig_path" {
  type        = string
  description = "Path to a Jamf-exported .mobileconfig file (checked into repo)."
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
}
