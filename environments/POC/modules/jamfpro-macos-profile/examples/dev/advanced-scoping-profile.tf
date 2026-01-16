# ============================================================================
# Example 2: Advanced Scoping with Limitations and Exclusions
# ============================================================================
# This example demonstrates advanced scoping capabilities including network
# segment limitations, user exclusions, and comprehensive targeting.

terraform {
  required_providers {
    jamfpro = {
      source  = "deploymenttheory/jamfpro"
      version = "= 0.30.0"
    }
  }
}

module "restricted_wifi_profile" {
  source = "../../../../modules/jamfpro-macos-profile"

  profile_name        = "Corporate WiFi Configuration"
  profile_description = "Corporate WiFi settings with network limitations and user exclusions"
  version_number      = "1.0"

  # Distribution Settings
  distribution_method = "Install Automatically"
  redeploy_on_update  = "Newly Assigned"
  user_removable      = false
  level               = "System"

  # Comprehensive Scope Configuration
  scope_all_computers      = true
  scope_computer_group_ids = [78, 100, 205]
  scope_building_ids       = [1348, 1349]
  scope_department_ids     = [37287, 37288]
  scope_jss_user_ids       = [1, 2, 3]
  scope_jss_user_group_ids = [4, 505]

  # Limitations - Only deploy on corporate network
  limitation_network_segment_ids             = [4, 5, 10]
  limitation_ibeacon_ids                     = [3, 4]
  limitation_directory_service_usernames     = ["admin", "it-staff"]
  limitation_directory_service_usergroup_ids = [3, 4]

  # Exclusions - Exclude test environments and specific users
  exclusion_computer_ids                    = [16, 20, 21] # Test computers
  exclusion_computer_group_ids              = [999]        # Test group
  exclusion_building_ids                    = [9999]       # Test building
  exclusion_department_ids                  = [99999]      # Test department
  exclusion_network_segment_ids             = [100]        # Guest network
  exclusion_jss_user_ids                    = [999]        # Test users
  exclusion_jss_user_group_ids              = [999]        # Test user groups
  exclusion_directory_service_usernames     = ["test-user", "temp-user"]
  exclusion_directory_service_usergroup_ids = [999]
  exclusion_ibeacon_ids                     = [999] # Test beacons

  # Self Service Configuration
  self_service_enabled                = true
  self_service_install_button_text    = "Install WiFi"
  self_service_description            = "Corporate WiFi configuration for secure network access"
  self_service_force_view_description = true
  self_service_feature_on_main_page   = true
  self_service_notification           = true
  self_service_notification_subject   = "WiFi Profile Update Available"
  self_service_notification_message   = "A new WiFi profile configuration is available. Please install to maintain network connectivity."

  self_service_categories = [
    {
      id         = 10
      display_in = true
      feature_in = true
    },
    {
      id         = 5
      display_in = false
      feature_in = true
    }
  ]

  # Payload Configuration
  payload_root_description        = "Corporate WiFi configuration"
  payload_root_enabled            = true
  payload_root_organization       = "IT Department"
  payload_root_removal_disallowed = true
  payload_root_scope              = "System"
  payload_root_type               = "Configuration"

  payload_content_type         = "com.apple.wifi"
  payload_content_display_name = "Corporate WiFi"
  payload_content_enabled      = true
  payload_content_organization = "IT Department"
  payload_content_scope        = "System"

  payload_content_configurations = [
    { key = "SSID", value = "Corporate-WiFi" },
    { key = "SSIDSTR", value = "Corporate-WiFi" },
    { key = "HiddenNetwork", value = false },
    { key = "EncryptionType", value = "WPA2" },
    { key = "Password", value = "your-encrypted-password" },
    { key = "AutoJoin", value = true },
    { key = "CaptivePortal", value = false }
  ]

  # Tags for organization
  tags = ["wifi", "network", "corporate", "mandatory", "production"]

  # Metadata
  category_id = 10
  site_id     = 1
}

# Outputs for monitoring and validation
output "wifi_profile_summary" {
  description = "Complete summary of WiFi profile configuration"
  value = {
    id           = module.restricted_wifi_profile.profile_id
    name         = module.restricted_wifi_profile.profile_name
    version      = module.restricted_wifi_profile.profile_version
    is_deployed  = module.restricted_wifi_profile.is_deployed
    targets      = module.restricted_wifi_profile.deployment_targets
    self_service = module.restricted_wifi_profile.self_service_enabled
    scope        = module.restricted_wifi_profile.scope_summary
  }
}