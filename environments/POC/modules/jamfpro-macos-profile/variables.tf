# ============================================================================
# Jamf Pro macOS Configuration Profile Module - Variables
# ============================================================================
# This file contains all input variables for the module with validation,
# descriptions, and production-ready defaults.

variable "profile_name" {
  description = "The name of the macOS configuration profile"
  type        = string
  validation {
    condition     = length(var.profile_name) > 0 && length(var.profile_name) <= 100
    error_message = "Profile name must be between 1 and 100 characters."
  }
}

variable "profile_description" {
  description = "Description of the configuration profile"
  type        = string
  default     = ""
}

variable "distribution_method" {
  description = "How the profile should be distributed"
  type        = string
  default     = "Install Automatically"
  validation {
    condition     = contains(["Install Automatically", "Make Available", "Install Prompt"], var.distribution_method)
    error_message = "Distribution method must be one of: Install Automatically, Make Available, Install Prompt"
  }
}

variable "redeploy_on_update" {
  description = "When to redeploy the profile after updates"
  type        = string
  default     = "Newly Assigned"
  validation {
    condition     = contains(["Newly Assigned", "All"], var.redeploy_on_update)
    error_message = "Redeploy on update must be either 'Newly Assigned' or 'All'"
  }
}

variable "user_removable" {
  description = "Whether users can remove the profile"
  type        = bool
  default     = false
}

variable "level" {
  description = "The level at which the profile is applied"
  type        = string
  default     = "System"
  validation {
    condition     = contains(["System", "User"], var.level)
    error_message = "Level must be either 'System' or 'User'"
  }
}

variable "version_number" {
  description = "The version number to include in the name and install button text"
  type        = string
  default     = "1.0"
  validation {
    condition     = can(regex("^\\d+\\.\\d+(\\.\\d+)?$", var.version_number))
    error_message = "Version number must be in format X.Y or X.Y.Z (e.g., 1.0, 2.3.1)"
  }
}

# ============================================================================
# Scope Variables
# ============================================================================

variable "scope_all_computers" {
  description = "Deploy to all computers"
  type        = bool
  default     = false
}

variable "scope_all_jss_users" {
  description = "Deploy to all Jamf Pro users"
  type        = bool
  default     = false
}

variable "scope_computer_ids" {
  description = "List of computer IDs to target"
  type        = list(number)
  default     = []
  validation {
    condition     = length(var.scope_computer_ids) == 0 || alltrue([for id in var.scope_computer_ids : id > 0])
    error_message = "All computer IDs must be positive numbers."
  }
}

variable "scope_computer_group_ids" {
  description = "List of computer group IDs to target"
  type        = list(number)
  default     = []
  validation {
    condition     = length(var.scope_computer_group_ids) == 0 || alltrue([for id in var.scope_computer_group_ids : id > 0])
    error_message = "All computer group IDs must be positive numbers."
  }
}

variable "scope_building_ids" {
  description = "List of building IDs to target"
  type        = list(number)
  default     = []
}

variable "scope_department_ids" {
  description = "List of department IDs to target"
  type        = list(number)
  default     = []
}

variable "scope_jss_user_ids" {
  description = "List of Jamf Pro user IDs to target"
  type        = list(number)
  default     = []
  validation {
    condition     = length(var.scope_jss_user_ids) == 0 || alltrue([for id in var.scope_jss_user_ids : id > 0])
    error_message = "All user IDs must be positive numbers."
  }
}

variable "scope_jss_user_group_ids" {
  description = "List of Jamf Pro user group IDs to target"
  type        = list(number)
  default     = []
}

# ============================================================================
# Scope Limitations
# ============================================================================

variable "limitation_network_segment_ids" {
  description = "Network segment IDs for limitations"
  type        = list(number)
  default     = []
}

variable "limitation_ibeacon_ids" {
  description = "iBeacon IDs for limitations"
  type        = list(number)
  default     = []
}

variable "limitation_directory_service_usernames" {
  description = "Directory service or local usernames for limitations"
  type        = list(string)
  default     = []
}

variable "limitation_directory_service_usergroup_ids" {
  description = "Directory service user group IDs for limitations"
  type        = list(number)
  default     = []
}

# ============================================================================
# Scope Exclusions
# ============================================================================

variable "exclusion_computer_ids" {
  description = "Computer IDs to exclude from deployment"
  type        = list(number)
  default     = []
}

variable "exclusion_computer_group_ids" {
  description = "Computer group IDs to exclude from deployment"
  type        = list(number)
  default     = []
}

variable "exclusion_building_ids" {
  description = "Building IDs to exclude from deployment"
  type        = list(number)
  default     = []
}

variable "exclusion_department_ids" {
  description = "Department IDs to exclude from deployment"
  type        = list(number)
  default     = []
}

variable "exclusion_network_segment_ids" {
  description = "Network segment IDs to exclude from deployment"
  type        = list(number)
  default     = []
}

variable "exclusion_jss_user_ids" {
  description = "Jamf Pro user IDs to exclude from deployment"
  type        = list(number)
  default     = []
}

variable "exclusion_jss_user_group_ids" {
  description = "Jamf Pro user group IDs to exclude from deployment"
  type        = list(number)
  default     = []
}

variable "exclusion_directory_service_usernames" {
  description = "Directory service usernames to exclude from deployment"
  type        = list(string)
  default     = []
}

variable "exclusion_directory_service_usergroup_ids" {
  description = "Directory service user group IDs to exclude from deployment"
  type        = list(number)
  default     = []
}

variable "exclusion_ibeacon_ids" {
  description = "iBeacon IDs to exclude from deployment"
  type        = list(number)
  default     = []
}

# ============================================================================
# Self Service Configuration
# ============================================================================

variable "self_service_enabled" {
  description = "Enable self-service for this profile"
  type        = bool
  default     = true
}

variable "self_service_install_button_text" {
  description = "Text for the install button in self-service"
  type        = string
  default     = "Install"
}

variable "self_service_description" {
  description = "Description shown in self-service"
  type        = string
  default     = ""
}

variable "self_service_force_view_description" {
  description = "Force users to view description before installation"
  type        = bool
  default     = false
}

variable "self_service_feature_on_main_page" {
  description = "Feature this profile on the main self-service page"
  type        = bool
  default     = true
}

variable "self_service_notification" {
  description = "Send notification when profile is available"
  type        = bool
  default     = false
}

variable "self_service_notification_subject" {
  description = "Subject line for self-service notification"
  type        = string
  default     = "New Profile Available"
}

variable "self_service_notification_message" {
  description = "Message body for self-service notification"
  type        = string
  default     = "A new profile is available for installation."
}

variable "self_service_categories" {
  description = "List of self-service category configurations"
  type = list(object({
    id         = number
    display_in = bool
    feature_in = bool
  }))
  default = []
  validation {
    condition     = length(var.self_service_categories) == 0 || alltrue([for cat in var.self_service_categories : cat.id > 0])
    error_message = "All category IDs must be positive numbers."
  }
}

# ============================================================================
# Payload Configuration
# ============================================================================

variable "payload_root_description" {
  description = "Description for the root payload"
  type        = string
  default     = ""
}

variable "payload_root_enabled" {
  description = "Enable the root payload"
  type        = bool
  default     = true
}

variable "payload_root_organization" {
  description = "Organization for the root payload"
  type        = string
  default     = ""
}

variable "payload_root_removal_disallowed" {
  description = "Prevent removal of root payload"
  type        = bool
  default     = false
}

variable "payload_root_scope" {
  description = "Scope for the root payload"
  type        = string
  default     = "System"
}

variable "payload_root_type" {
  description = "Type of the root payload"
  type        = string
  default     = "Configuration"
}

variable "payload_content_configurations" {
  description = "List of configuration key-value pairs for the payload content"
  type = list(object({
    key   = string
    value = any
  }))
  default = []
}

variable "payload_content_description" {
  description = "Description for the payload content"
  type        = string
  default     = ""
}

variable "payload_content_display_name" {
  description = "Display name for the payload content"
  type        = string
  default     = ""
}

variable "payload_content_enabled" {
  description = "Enable the payload content"
  type        = bool
  default     = true
}

variable "payload_content_organization" {
  description = "Organization for the payload content"
  type        = string
  default     = ""
}

variable "payload_content_type" {
  description = "Type of the payload content (e.g., com.apple.universalaccess)"
  type        = string
  default     = ""
}

variable "payload_content_scope" {
  description = "Scope for the payload content"
  type        = string
  default     = "System"
}

# ============================================================================
# Tags and Metadata
# ============================================================================

variable "tags" {
  description = "List of tags to apply to the profile for organization"
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.tags) == 0 || alltrue([for tag in var.tags : length(tag) > 0])
    error_message = "All tags must be non-empty strings."
  }
}

variable "category_id" {
  description = "Category ID for the profile in Jamf Pro"
  type        = number
  default     = null
}

variable "site_id" {
  description = "Site ID for the profile"
  type        = number
  default     = null
}




