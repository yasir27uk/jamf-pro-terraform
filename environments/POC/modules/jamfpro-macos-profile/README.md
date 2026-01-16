# Jamf Pro macOS Configuration Profile Module

A highly enhanced, feature-rich, future-proof, and reusable Terraform module for creating and managing macOS configuration profiles in Jamf Pro.

## 🚀 Features

- **Comprehensive Scoping**: Target computers, groups, buildings, departments, and users with advanced limitations and exclusions
- **Self-Service Integration**: Full self-service configuration with categories, notifications, and custom messaging
- **Payload Management**: Flexible payload configuration with support for various configuration types
- **Production-Ready**: Built-in validation, defaults, and best practices for enterprise environments
- **Reusable Design**: Module-based architecture for consistent profile management across environments
- **Enhanced Outputs**: Detailed information about created profiles for reference and automation
- **Version Control**: Automatic version numbering and profile naming conventions
- **Tagging Support**: Organize profiles with custom tags for better management

## 📋 Requirements

- Terraform >= 1.0.0
- Jamf Pro Terraform Provider
- Appropriate Jamf Pro API permissions

## 🔧 Installation

### Module Structure

```
modules/
└── jamfpro-macos-profile/
    ├── main.tf              # Main module logic
    ├── variables.tf         # Variable definitions
    ├── outputs.tf           # Output definitions
    ├── README.md           # This file
    ├── examples/           # Usage examples
    └── docs/               # Additional documentation
```

### Basic Usage

```hcl
module "accessibility_profile" {
  source = "./modules/jamfpro-macos-profile"
  
  # Required Variables
  profile_name = "Accessibility Settings"
  
  # Optional - Basic Configuration
  profile_description = "Base Level Accessibility settings for vision"
  version_number      = "1.0"
  
  # Scope Configuration
  scope_computer_group_ids = [78, 1]
  
  # Payload Configuration
  payload_content_type     = "com.apple.universalaccess"
  payload_content_display_name = "Accessibility"
  
  payload_content_configurations = [
    { key = "closeViewFarPoint", value = 2 },
    { key = "closeViewHotkeysEnabled", value = true },
    { key = "contrast", value = 0 },
    { key = "voiceOverOnOffKey", value = true }
  ]
}
```

## 📖 Configuration Reference

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `profile_name` | `string` | The name of the macOS configuration profile (1-100 characters) |

### Optional Variables - Profile Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `profile_description` | `string` | `""` | Description of the configuration profile |
| `distribution_method` | `string` | `"Install Automatically"` | How the profile should be distributed. Options: `Install Automatically`, `Make Available`, `Install Prompt` |
| `redeploy_on_update` | `string` | `"Newly Assigned"` | When to redeploy the profile after updates. Options: `Newly Assigned`, `All` |
| `user_removable` | `bool` | `false` | Whether users can remove the profile |
| `level` | `string` | `"System"` | The level at which the profile is applied. Options: `System`, `User` |
| `version_number` | `string` | `"1.0"` | The version number (format: X.Y or X.Y.Z) |

### Optional Variables - Scope Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `scope_all_computers` | `bool` | `false` | Deploy to all computers |
| `scope_all_jss_users` | `bool` | `false` | Deploy to all Jamf Pro users |
| `scope_computer_ids` | `list(number)` | `[]` | List of computer IDs to target |
| `scope_computer_group_ids` | `list(number)` | `[]` | List of computer group IDs to target |
| `scope_building_ids` | `list(number)` | `[]` | List of building IDs to target |
| `scope_department_ids` | `list(number)` | `[]` | List of department IDs to target |
| `scope_jss_user_ids` | `list(number)` | `[]` | List of Jamf Pro user IDs to target |
| `scope_jss_user_group_ids` | `list(number)` | `[]` | List of Jamf Pro user group IDs to target |

### Optional Variables - Scope Limitations

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `limitation_network_segment_ids` | `list(number)` | `[]` | Network segment IDs for limitations |
| `limitation_ibeacon_ids` | `list(number)` | `[]` | iBeacon IDs for limitations |
| `limitation_directory_service_usernames` | `list(string)` | `[]` | Directory service or local usernames for limitations |
| `limitation_directory_service_usergroup_ids` | `list(number)` | `[]` | Directory service user group IDs for limitations |

### Optional Variables - Scope Exclusions

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `exclusion_computer_ids` | `list(number)` | `[]` | Computer IDs to exclude from deployment |
| `exclusion_computer_group_ids` | `list(number)` | `[]` | Computer group IDs to exclude |
| `exclusion_building_ids` | `list(number)` | `[]` | Building IDs to exclude |
| `exclusion_department_ids` | `list(number)` | `[]` | Department IDs to exclude |
| `exclusion_network_segment_ids` | `list(number)` | `[]` | Network segment IDs to exclude |
| `exclusion_jss_user_ids` | `list(number)` | `[]` | Jamf Pro user IDs to exclude |
| `exclusion_jss_user_group_ids` | `list(number)` | `[]` | Jamf Pro user group IDs to exclude |
| `exclusion_directory_service_usernames` | `list(string)` | `[]` | Directory service usernames to exclude |
| `exclusion_directory_service_usergroup_ids` | `list(number)` | `[]` | Directory service user group IDs to exclude |
| `exclusion_ibeacon_ids` | `list(number)` | `[]` | iBeacon IDs to exclude |

### Optional Variables - Self Service Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `self_service_enabled` | `bool` | `true` | Enable self-service for this profile |
| `self_service_install_button_text` | `string` | `"Install"` | Text for the install button in self-service |
| `self_service_description` | `string` | `""` | Description shown in self-service |
| `self_service_force_view_description` | `bool` | `false` | Force users to view description before installation |
| `self_service_feature_on_main_page` | `bool` | `true` | Feature this profile on the main self-service page |
| `self_service_notification` | `bool` | `false` | Send notification when profile is available |
| `self_service_notification_subject` | `string` | `"New Profile Available"` | Subject line for self-service notification |
| `self_service_notification_message` | `string` | `"A new profile is available"` | Message body for self-service notification |
| `self_service_categories` | `list(object)` | `[]` | List of self-service category configurations |

### Optional Variables - Payload Configuration

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `payload_root_description` | `string` | `""` | Description for the root payload |
| `payload_root_enabled` | `bool` | `true` | Enable the root payload |
| `payload_root_organization` | `string` | `""` | Organization for the root payload |
| `payload_root_removal_disallowed` | `bool` | `false` | Prevent removal of root payload |
| `payload_root_scope` | `string` | `"System"` | Scope for the root payload |
| `payload_root_type` | `string` | `"Configuration"` | Type of the root payload |
| `payload_content_configurations` | `list(object)` | `[]` | List of configuration key-value pairs |
| `payload_content_description` | `string` | `""` | Description for the payload content |
| `payload_content_display_name` | `string` | `""` | Display name for the payload content |
| `payload_content_enabled` | `bool` | `true` | Enable the payload content |
| `payload_content_organization` | `string` | `""` | Organization for the payload content |
| `payload_content_type` | `string` | `""` | Type of the payload content |
| `payload_content_scope` | `string` | `"System"` | Scope for the payload content |

### Optional Variables - Tags and Metadata

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `tags` | `list(string)` | `[]` | List of tags to apply to the profile |
| `category_id` | `number` | `null` | Category ID for the profile in Jamf Pro |
| `site_id` | `number` | `null` | Site ID for the profile |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `profile_id` | The ID of the created configuration profile |
| `profile_name` | The normalized name of the created profile |
| `profile_version` | The version number of the profile |
| `scope_summary` | Summary of the scope configuration |
| `self_service_enabled` | Whether self-service is enabled |
| `payload_count` | Number of payload configurations |
| `deployment_targets` | Total number of deployment targets |
| `is_deployed` | Whether the profile will be deployed |

## 🎯 Use Cases

### 1. Basic Accessibility Profile

```hcl
module "basic_accessibility" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Basic Accessibility Settings"
  profile_description = "Essential accessibility configurations"
  
  scope_computer_group_ids = [78]
  
  payload_content_type = "com.apple.universalaccess"
  payload_content_display_name = "Accessibility"
  
  payload_content_configurations = [
    { key = "voiceOverOnOffKey", value = true },
    { key = "closeViewHotkeysEnabled", value = true }
  ]
}
```

### 2. Advanced Scoping with Limitations

```hcl
module "restricted_profile" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Restricted WiFi Settings"
  profile_description = "Corporate WiFi configuration with limitations"
  
  scope_all_computers = true
  
  # Only deploy when on corporate network
  limitation_network_segment_ids = [4, 5]
  
  # Exclude test computers
  exclusion_computer_ids = [16, 20]
  
  payload_content_type = "com.apple.wifi"
  payload_content_display_name = "WiFi"
  
  payload_content_configurations = [
    { key = "SSID", value = "Corporate-WiFi" }
  ]
}
```

### 3. Self-Service Profile with Categories

```hcl
module "self_service_profile" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Optional VPN Profile"
  profile_description = "VPN profile for remote access"
  
  self_service_enabled = true
  self_service_install_button_text = "Install VPN"
  self_service_description = "Install this profile to access corporate resources remotely"
  self_service_force_view_description = true
  self_service_notification = true
  self_service_notification_subject = "VPN Profile Available"
  self_service_notification_message = "A new VPN profile is available for installation."
  
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
  
  scope_all_computers = true
  
  payload_content_type = "com.apple.vpn"
  payload_content_display_name = "VPN"
  
  payload_content_configurations = [
    { key = "VPNType", value = "IKEv2" },
    { key = "RemoteAddress", value = "vpn.company.com" }
  ]
}
```

### 4. Multi-Version Profile Management

```hcl
module "accessibility_v1" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Accessibility Settings"
  version_number = "1.0"
  
  scope_computer_group_ids = [78]
  
  payload_content_type = "com.apple.universalaccess"
  payload_content_configurations = [
    { key = "voiceOverOnOffKey", value = true }
  ]
}

module "accessibility_v2" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Accessibility Settings"
  version_number = "2.0"
  
  scope_computer_group_ids = [78]
  
  payload_content_type = "com.apple.universalaccess"
  payload_content_configurations = [
    { key = "voiceOverOnOffKey", value = true },
    { key = "closeViewHotkeysEnabled", value = true },
    { key = "contrast", value = 0 }
  ]
}
```

## 🏷️ Tagging Strategy

Use tags to organize and manage your profiles:

```hcl
module "profile" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Security Settings"
  tags = [
    "security",
    "production",
    "mandatory",
    "2024-Q1"
  ]
  
  # ... other configuration
}
```

## 🔒 Best Practices

### 1. Version Management
- Always use semantic versioning (X.Y.Z)
- Update version numbers when making significant changes
- Use version numbers in profile names for easy identification

### 2. Scope Management
- Use computer groups instead of individual computers when possible
- Implement limitations for network-sensitive profiles
- Use exclusions sparingly and document reasons

### 3. Self-Service
- Provide clear descriptions for self-service profiles
- Enable notifications for important updates
- Use appropriate categories for organization

### 4. Payload Configuration
- Use descriptive display names for payloads
- Test configurations in non-production environments first
- Document the purpose of each configuration key

### 5. Testing and Validation
- Test profiles in a small scope before broad deployment
- Use version numbers to track changes
- Monitor deployment status and user feedback

## 🐛 Troubleshooting

### Profile Not Deploying
- Verify scope is correctly configured (check `is_deployed` output)
- Ensure target computers/groups exist in Jamf Pro
- Check API permissions and connectivity

### Payload Not Applying
- Verify payload type is correct for your configuration
- Check payload scope matches profile level
- Ensure configuration keys are valid for the payload type

### Self-Service Issues
- Verify self-service is enabled in Jamf Pro
- Check category IDs are valid
- Ensure users have self-service access

## 📚 Additional Resources

- [Jamf Pro Documentation](https://docs.jamf.com/)
- [Terraform Provider Documentation](https://registry.terraform.io/providers/jamf/jamfpro/)
- [Apple Configuration Profile Reference](https://developer.apple.com/business/documentation/)

## 🤝 Contributing

To improve this module:
1. Test changes in a non-production environment
2. Update documentation for new features
3. Follow semantic versioning
4. Provide examples for new use cases

## 📄 License

This module is provided as-is for use with Jamf Pro and Terraform.

## 🆘 Support

For issues related to:
- **Module functionality**: Check this README and examples
- **Jamf Pro API**: Refer to Jamf Pro documentation
- **Terraform**: Check Terraform documentation and provider issues