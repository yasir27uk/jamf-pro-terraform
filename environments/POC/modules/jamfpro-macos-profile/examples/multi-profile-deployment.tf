# ============================================================================
# Example 4: Multi-Profile Deployment with Dependencies
# ============================================================================
# This example demonstrates deploying multiple related profiles with
# proper versioning and dependency management.

# ============================================================================
# Base Security Profile - Foundation Profile
# ============================================================================
module "base_security_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  profile_name = "Base Security Configuration"
  profile_description = "Foundation security settings - must be installed first"
  version_number      = "1.0.0"
  
  # Critical settings - cannot be removed by users
  user_removable = false
  level          = "System"
  
  # Deploy to all computers
  scope_all_computers = true
  
  # Security Payload
  payload_content_type         = "com.apple.systempolicy-control"
  payload_content_display_name = "Security Baseline"
  payload_content_enabled      = true
  payload_content_organization = "Security Team"
  payload_content_scope        = "System"
  
  payload_content_configurations = [
    { key = "GatekeeperEnabled", value = true },
    { key = "GatekeeperAllowAppsAnywhere", value = false },
    { key = "GatekeeperEnableAssessment", value = true },
    { key = "DisableGuestAccount", value = true },
    { key = "EnableFDE", value = true }
  ]
  
  tags = ["security", "baseline", "critical", "mandatory"]
}

# ============================================================================
# Firewall Profile - Depends on Base Security
# ============================================================================
module "firewall_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  profile_name = "Firewall Configuration"
  profile_description = "Advanced firewall rules and settings"
  version_number      = "2.0.0"
  
  # Cannot be removed by users
  user_removable = false
  level          = "System"
  
  # Deploy to all computers
  scope_all_computers = true
  
  # Firewall Payload
  payload_content_type         = "com.apple.alf"
  payload_content_display_name = "Application Firewall"
  payload_content_enabled      = true
  payload_content_organization = "Security Team"
  payload_content_scope        = "System"
  
  payload_content_configurations = [
    { key = "globalstate", value = 1 },  # Enable firewall
    { key = "allowsignedenabled", value = 1 },
    { key = "allowdownloadsignedenabled", value = 1 },
    { key = "stealthenabled", value = 1 },
    { key = "loggingenabled", value = 1 },
    { key = "loggingoption", value = "throttledlog" }
  ]
  
  tags = ["security", "firewall", "network", "mandatory"]
}

# ============================================================================
# Safari Settings Profile - User Level
# ============================================================================
module "safari_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  profile_name = "Safari Browser Settings"
  profile_description = "Corporate browser configuration and security settings"
  version_number      = "3.1.2"
  
  # User level settings
  user_removable = false
  level          = "User"
  
  # Deploy to all users
  scope_all_jss_users = true
  
  # Self Service for updates
  self_service_enabled = true
  self_service_install_button_text = "Update Safari Settings"
  self_service_description = "Corporate Safari configuration with security and privacy settings"
  self_service_force_view_description = true
  
  # Safari Payload
  payload_content_type         = "com.apple.Safari"
  payload_content_display_name = "Safari Configuration"
  payload_content_enabled      = true
  payload_content_organization = "IT Department"
  payload_content_scope        = "User"
  
  payload_content_configurations = [
    { key = "HomePage", value = "https://portal.company.com" },
    { key = "NewWindowBehavior", value = 0 },
    { key = "AutoFillFromAddressBook", value = false },
    { key = "AutoFillCreditCardData", value = false },
    { key = "AutoFillMiscellaneousForms", value = false },
    { key = "AutoFillPasswords", value = false },
    { key = "ShowFavoritesBar", value = false },
    { key = "ShowStatusBar", value = false },
    { key = "ShowURLInCompletions", value = false },
    { key = "WarnAboutFraudulentWebsites", value = true },
    { key = "BlockStorageManagerAPI", value = true },
    { key = "IncludeDevelopMenu", value = false },
    { key = "WebKitDeveloperExtrasEnabledPreferenceKey", value = false }
  ]
  
  tags = ["browser", "safari", "security", "productivity", "corporate"]
}

# ============================================================================
# Optional Developer Tools Profile - Self Service Only
# ============================================================================
module "developer_tools_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  profile_name = "Developer Tools Configuration"
  profile_description = "Optional developer tools and settings for engineering team"
  version_number      = "1.5.0"
  
  # User removable - optional profile
  user_removable = true
  level          = "User"
  
  # Self Service only
  distribution_method = "Make Available"
  scope_all_jss_users = true
  
  # Rich Self Service Experience
  self_service_enabled = true
  self_service_install_button_text = "Install Developer Tools"
  self_service_description = <<-EOT
    Developer Tools Configuration
    
    This profile installs the following:
    • Xcode command line tools
    • Developer certificates
    • Git configuration
    • Docker Desktop settings
    • Homebrew configuration
    
    Please note: This profile is intended for developers only.
  EOT
  self_service_force_view_description = true
  self_service_feature_on_main_page    = true
  self_service_notification            = true
  self_service_notification_subject    = "Developer Tools Update Available"
  
  self_service_categories = [
    { id = 20, display_in = true, feature_in = true }
  ]
  
  # Developer Payload
  payload_content_type         = "com.apple.developer"
  payload_content_display_name = "Developer Tools"
  payload_content_enabled      = true
  payload_content_organization = "Engineering"
  payload_content_scope        = "User"
  
  payload_content_configurations = [
    { key = "XcodeCommandLineTools", value = true },
    { key = "GitEnabled", value = true },
    { key = "DockerEnabled", value = true },
    { key = "HomebrewEnabled", value = true },
    { key = "DeveloperMode", value = true }
  ]
  
  tags = ["development", "developer", "engineering", "optional", "tools"]
}

# ============================================================================
# Deployment Summary Outputs
# ============================================================================

output "security_deployment" {
  description = "Summary of security profile deployments"
  value = {
    base_security = {
      id      = module.base_security_profile.profile_id
      name    = module.base_security_profile.profile_name
      version = module.base_security_profile.profile_version
      targets = module.base_security_profile.deployment_targets
      status  = "Active"
    }
    firewall = {
      id      = module.firewall_profile.profile_id
      name    = module.firewall_profile.profile_name
      version = module.firewall_profile.profile_version
      targets = module.firewall_profile.deployment_targets
      status  = "Active"
    }
  }
}

output "user_configuration_deployment" {
  description = "Summary of user configuration deployments"
  value = {
    safari = {
      id           = module.safari_profile.profile_id
      name         = module.safari_profile.profile_name
      version      = module.safari_profile.profile_version
      self_service = module.safari_profile.self_service_enabled
      status       = "Active"
    }
    developer_tools = {
      id           = module.developer_tools_profile.profile_id
      name         = module.developer_tools_profile.profile_name
      version      = module.developer_tools_profile.profile_version
      self_service = module.developer_tools_profile.self_service_enabled
      status       = "Available"
    }
  }
}

output "total_deployments" {
  description = "Total number of profiles deployed"
  value = {
    system_profiles = 2  # base_security, firewall
    user_profiles   = 2  # safari, developer_tools
    total           = 4
  }
}