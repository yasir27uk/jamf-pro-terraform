# Quick Start Guide

Get started with the Jamf Pro macOS Configuration Profile module in 5 minutes.

## Prerequisites

- Terraform >= 1.0.0 installed
- Jamf Pro account with API access
- Jamf Pro Terraform Provider configured

## Installation

### 1. Clone or Download Module

```bash
# Ensure module is in your project structure
your-project/
├── main.tf
├── variables.tf
└── modules/
    └── jamfpro-macos-profile/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### 2. Configure Provider

Create a `providers.tf` file:

```hcl
terraform {
  required_providers {
    jamfpro = {
      source  = "jamf/jamfpro"
      version = ">= 0.1.0"
    }
  }
}

provider "jamfpro" {
  # Configure your Jamf Pro credentials
  # Recommended: Use environment variables
  # JAMFPRO_URL, JAMFPRO_CLIENT_ID, JAMFPRO_CLIENT_SECRET
}
```

## Basic Usage

### 3. Create Your First Profile

Create a `main.tf` file:

```hcl
module "my_first_profile" {
  source = "./modules/jamfpro-macos-profile"
  
  # Required: Profile name
  profile_name = "My First Configuration Profile"
  
  # Optional: Add description
  profile_description = "This is my first profile created with Terraform"
  
  # Optional: Set version
  version_number = "1.0.0"
  
  # Scope: Target a computer group
  scope_computer_group_ids = [78]  # Replace with your group ID
  
  # Payload: Configure settings
  payload_content_type         = "com.apple.universalaccess"
  payload_content_display_name = "Accessibility Settings"
  
  payload_content_configurations = [
    { key = "voiceOverOnOffKey", value = true },
    { key = "closeViewHotkeysEnabled", value = true }
  ]
}

# Output the profile ID
output "profile_id" {
  value = module.my_first_profile.profile_id
}
```

### 4. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# View outputs
terraform output profile_id
```

## Common Patterns

### Pattern 1: Self-Service Profile

```hcl
module "self_service_profile" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Optional VPN Profile"
  
  # Enable self-service
  self_service_enabled = true
  self_service_install_button_text = "Install VPN"
  self_service_description = "Install this profile to access corporate VPN"
  
  # Make available to all users
  scope_all_jss_users = true
  
  # VPN Configuration
  payload_content_type = "com.apple.vpn.managed"
  payload_content_configurations = [
    { key = "VPNType", value = "IKEv2" },
    { key = "RemoteAddress", value = "vpn.company.com" }
  ]
}
```

### Pattern 2: Security Profile

```hcl
module "security_profile" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Corporate Security Baseline"
  version_number = "1.0.0"
  
  # Cannot be removed by users
  user_removable = false
  level = "System"
  
  # Deploy to all computers
  scope_all_computers = true
  
  # Security Settings
  payload_content_type = "com.apple.systempolicy-control"
  payload_content_configurations = [
    { key = "GatekeeperEnabled", value = true }
  ]
  
  # Add tags
  tags = ["security", "mandatory", "production"]
}
```

### Pattern 3: Advanced Scoping

```hcl
module "advanced_profile" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Network Restricted Profile"
  
  # Multiple scope targets
  scope_computer_group_ids = [78, 100, 205]
  scope_building_ids = [1348, 1349]
  
  # Network limitations
  limitation_network_segment_ids = [4, 5]
  
  # Exclusions
  exclusion_computer_ids = [16, 20]
  
  # Configuration
  payload_content_type = "com.apple.wifi"
  payload_content_configurations = [
    { key = "SSID", value = "Corporate-WiFi" }
  ]
}
```

## Quick Reference

### Required Variables
- `profile_name` (string): Name of the profile

### Most Common Optional Variables
- `version_number` (string): Version (default: "1.0")
- `scope_computer_group_ids` (list): Target computer groups
- `self_service_enabled` (bool): Enable self-service (default: true)
- `user_removable` (bool): Allow user removal (default: false)
- `tags` (list): Organizational tags

### Key Outputs
- `profile_id`: ID of created profile
- `is_deployed`: Whether profile will deploy
- `deployment_targets`: Number of targets

## Next Steps

1. **Explore Examples**: Check the `examples/` directory for more patterns
2. **Read Documentation**: See `README.md` for comprehensive documentation
3. **Best Practices**: Review `docs/VALIDATION_AND_BEST_PRACTICES.md`
4. **Test First**: Always test in development before production

## Troubleshooting

### Issue: Provider not configured
```bash
# Set environment variables
export JAMFPRO_URL="https://your-jamf-pro-instance.com"
export JAMFPRO_CLIENT_ID="your-client-id"
export JAMFPRO_CLIENT_SECRET="your-client-secret"
```

### Issue: Profile not deploying
```bash
# Check if scope is defined
terraform output is_deployed

# Should return "true"
```

### Issue: Invalid variables
```bash
# Validate your configuration
terraform validate
```

## Getting Help

- **Documentation**: See `README.md` and `docs/`
- **Examples**: Check `examples/` directory
- **Best Practices**: Review `docs/VALIDATION_AND_BEST_PRACTICES.md`
- **Module Summary**: See `docs/MODULE_SUMMARY.md`

## Production Deployment

Before deploying to production:

1. ✅ Test in development environment
2. ✅ Validate scope targets exist
3. ✅ Review payload configurations
4. ✅ Test self-service functionality
5. ✅ Verify notification settings
6. ✅ Plan deployment timing
7. ✅ Have rollback plan ready

```hcl
# Production example
module "production_profile" {
  source = "./modules/jamfpro-macos-profile"
  
  profile_name = "Production Security Profile"
  version_number = "1.0.0"
  
  scope_computer_group_ids = [78, 100, 205]
  user_removable = false
  
  tags = ["production", "stable", "security"]
}
```

---

**Ready to go!** You now have everything you need to start managing Jamf Pro macOS configuration profiles with Terraform.

For more advanced usage, check out the comprehensive documentation and examples.