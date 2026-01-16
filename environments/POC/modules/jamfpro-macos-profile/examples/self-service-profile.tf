# ============================================================================
# Example 3: Self-Service Profile with Categories
# ============================================================================
# This example demonstrates a profile optimized for self-service deployment
# with rich user experience features and category management.

module "vpn_self_service_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  profile_name = "Remote Access VPN"
  profile_description = "VPN profile for secure remote access to corporate resources"
  version_number      = "3.2.1"
  
  # Distribution Settings
  distribution_method = "Make Available"
  redeploy_on_update  = "Newly Assigned"
  user_removable      = true  # Allow users to remove if needed
  level               = "User"
  
  # Scope - Available to all users for self-service
  scope_all_jss_users = true
  
  # Enhanced Self Service Configuration
  self_service_enabled = true
  self_service_install_button_text = "Install VPN - v3.2.1"
  self_service_description = <<-EOT
    Install this VPN profile to access corporate resources securely from remote locations.
    
    Features:
    • Secure encrypted connection
    • Automatic connection on corporate network detection
    • Support for multiple devices
    • 24/7 IT support available
    
    Please contact IT Help Desk if you experience any issues.
  EOT
  self_service_force_view_description = true
  self_service_feature_on_main_page    = true
  self_service_notification            = true
  self_service_notification_subject    = "🔒 New VPN Profile Available - v3.2.1"
  self_service_notification_message = <<-EOT
    A new VPN profile (v3.2.1) is now available in Self Service.
    
    This update includes:
    • Improved connection stability
    • Faster authentication
    • Enhanced security features
    
    Please install the new profile to ensure you have the latest security updates.
    
    Need help? Contact IT Help Desk at ext. 1234
  EOT
  
  # Multiple Self Service Categories
  self_service_categories = [
    {
      id         = 10  # Network & Internet
      display_in = true
      feature_in = true
    },
    {
      id         = 5   # Remote Work
      display_in = true
      feature_in = true
    },
    {
      id         = 15  # Security
      display_in = true
      feature_in = false  # Don't feature in Security category
    }
  ]
  
  # VPN Payload Configuration
  payload_root_description        = "Corporate Remote Access VPN"
  payload_root_enabled            = true
  payload_root_organization       = "Corporate IT"
  payload_root_removal_disallowed = false  # Allow users to remove
  payload_root_scope              = "User"
  payload_root_type               = "Configuration"
  
  payload_content_type         = "com.apple.vpn.managed"
  payload_content_display_name = "Corporate VPN"
  payload_content_enabled      = true
  payload_content_organization = "Corporate IT"
  payload_content_scope        = "User"
  
  payload_content_configurations = [
    # VPN Connection Settings
    { key = "VPNType", value = "IKEv2" },
    { key = "RemoteAddress", value = "vpn.company.com" },
    { key = "LocalIdentifier", value = "user@company.com" },
    { key = "LocalIdentifierType", value = "KeyID" },
    { key = "AuthenticationMethod", value = "Certificate" },
    { key = "SharedSecret", value = "your-shared-secret" },
    
    # Advanced Settings
    { key = "IKESecurityAssociationParameters", value = {
      EncryptionAlgorithm = "AES-256"
      IntegrityAlgorithm  = "SHA2-256"
      DiffieHellmanGroup  = 14
      LifeTimeInSeconds   = 28800
    }},
    { key = "ChildSecurityAssociationParameters", value = {
      EncryptionAlgorithm = "AES-256"
      IntegrityAlgorithm  = "SHA2-256"
      DiffieHellmanGroup  = 14
      LifeTimeInSeconds   = 3600
    }},
    
    # Connection Behavior
    { key = "OnDemandEnabled", value = true },
    { key = "OnDemandRules", value = [
      {
        Action = "Connect"
        URLStringProbe = "internal.company.com"
      },
      {
        Action = "Disconnect"
        InterfaceTypeMatch = "WiFi"
        SSIDMatch = ["Guest-WiFi", "Public-WiFi"]
      }
    ]},
    { key = "DisconnectOnIdle", value = true },
    { key = "DisconnectOnIdleTimeout", value = 600 }
  ]
  
  # Organizational Tags
  tags = ["vpn", "remote-work", "network", "self-service", "security", "optional"]
  
  # Metadata
  category_id = 10
  site_id     = 1
}

# Output for tracking
output "vpn_self_service_summary" {
  description = "Summary of VPN self-service profile"
  value = {
    profile_id    = module.vpn_self_service_profile.profile_id
    profile_name  = module.vpn_self_service_profile.profile_name
    version       = module.vpn_self_service_profile.profile_version
    available_to  = "All Users (Self Service)"
    categories    = 3
    notifications = true
  }
}