variable "profiles" {
  description = "Map of macOS configuration profiles to create. Keys are stable identifiers."

  type = map(object({
    name = string

    payloads      = optional(string)
    payloads_file = optional(string)

    redeploy_on_update  = optional(string, "Newly Assigned")
    distribution_method = optional(string, "Install Automatically")
    level               = optional(string, "System")

    payload_validate = optional(bool, true)
    user_removable   = optional(bool, false)

    site_id     = optional(number)
    category_id = optional(number)
    description = optional(string)

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

  validation {
    condition = alltrue([
      for _, p in var.profiles : (
        (try(p.payloads, null) == null) != (try(p.payloads_file, null) == null)
      )
    ])
    error_message = "For each profile, exactly one of payloads or payloads_file must be set."
  }

  validation {
    condition = alltrue([
      for k, p in var.profiles : (
        p.scope.all_computers == true ||
        p.scope.all_jss_users == true ||
        length(try(p.scope.computer_ids, [])) > 0 ||
        length(try(p.scope.computer_group_ids, [])) > 0 ||
        length(try(p.scope.building_ids, [])) > 0 ||
        length(try(p.scope.department_ids, [])) > 0 ||
        length(try(p.scope.jss_user_ids, [])) > 0 ||
        length(try(p.scope.jss_user_group_ids, [])) > 0
      )
    ])
    error_message = "Each profile scope must target something (profile keys in error)."
  }

  validation {
    condition = alltrue([
      for _, p in var.profiles : contains(["All", "Newly Assigned"], p.redeploy_on_update)
    ])
    error_message = "redeploy_on_update must be one of: 'All', 'Newly Assigned'."
  }

  validation {
    condition = alltrue([
      for _, p in var.profiles : contains(["Make Available in Self Service", "Install Automatically"], p.distribution_method)
    ])
    error_message = "distribution_method must be one of: 'Make Available in Self Service', 'Install Automatically'."
  }

  validation {
    condition = alltrue([
      for _, p in var.profiles : contains(["User", "System"], p.level)
    ])
    error_message = "level must be one of: 'User', 'System'."
  }
}
