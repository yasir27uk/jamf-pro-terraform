# Jamf Pro macOS Configuration Profile - Examples

This directory contains comprehensive examples demonstrating various use cases and configurations for the Jamf Pro macOS Configuration Profile module.

## Available Examples

### 1. Basic Accessibility Profile (`basic-accessibility-profile.tf`)
**Complexity**: Beginner  
**Use Case**: Simple profile deployment with basic accessibility settings

**Features Demonstrated**:
- Minimal configuration requirements
- Basic scoping with computer groups
- Simple payload configuration
- Standard accessibility settings

**When to Use**:
- First-time users learning the module
- Simple profile requirements
- Testing module functionality
- Development environments

**Key Configuration**:
- Single computer group targeting
- Basic accessibility payload
- System-level deployment
- Version 1.0.0

---

### 2. Advanced Scoping Profile (`advanced-scoping-profile.tf`)
**Complexity**: Advanced  
**Use Case**: Complex deployment with comprehensive scoping, limitations, and exclusions

**Features Demonstrated**:
- Comprehensive scoping (computers, groups, buildings, departments, users)
- Network segment limitations
- Directory service integration
- Advanced exclusion rules
- Multi-category self-service
- Rich notification system

**When to Use**:
- Complex organizational requirements
- Network-sensitive deployments
- User-based targeting
- Production environments
- Security-critical profiles

**Key Configuration**:
- Multiple scope targets
- Network limitations
- User exclusions
- Self-service with notifications
- Corporate WiFi configuration

---

### 3. Self-Service Profile (`self-service-profile.tf`)
**Complexity**: Intermediate  
**Use Case**: Self-service deployment with rich user experience features

**Features Demonstrated**:
- Comprehensive self-service configuration
- Rich descriptions and formatting
- Multi-category support
- Advanced notification system
- User-level deployment
- Optional profile with user removal

**When to Use**:
- Optional user installations
- Remote worker support
- User-choice deployments
- Software distribution
- VPN and network profiles

**Key Configuration**:
- Self-service enabled
- Rich user descriptions
- Multiple categories
- Email notifications
- VPN payload configuration

---

### 4. Multi-Profile Deployment (`multi-profile-deployment.tf`)
**Complexity**: Expert  
**Use Case**: Deploying multiple related profiles with dependencies and orchestration

**Features Demonstrated**:
- Multiple profile management
- Profile dependencies
- Version coordination
- Mixed deployment strategies
- Comprehensive output aggregation
- Security baseline implementation

**When to Use**:
- Enterprise deployments
- Security baseline implementation
- Multi-tier configuration management
- Complex organizational needs
- Production environment setup

**Key Configuration**:
- 4 related profiles
- Different deployment levels
- Self-service integration
- Security configurations
- Dependency management

---

## How to Use These Examples

### Quick Start

1. **Choose an example** based on your requirements
2. **Copy the example** to your Terraform project
3. **Customize variables** for your environment
4. **Test in development** before production deployment

### Example Workflow

```bash
# 1. Navigate to your Terraform project
cd your-terraform-project

# 2. Copy an example
cp ../modules/jamfpro-macos-profile/examples/basic-accessibility-profile.tf .

# 3. Customize the configuration
# Edit the copied file with your specific values

# 4. Initialize Terraform
terraform init

# 5. Plan the deployment
terraform plan

# 6. Apply the configuration
terraform apply

# 7. Verify deployment
terraform output
```

### Customizing Examples

When customizing examples, focus on these key areas:

#### 1. Profile Identification
```hcl
profile_name = "Your Profile Name"
profile_description = "Your description"
version_number = "1.0.0"
```

#### 2. Scope Configuration
```hcl
# Update with your actual Jamf Pro IDs
scope_computer_group_ids = [78, 100, 205]
scope_building_ids = [1348, 1349]
```

#### 3. Payload Configuration
```hcl
# Configure your specific payload settings
payload_content_type = "com.apple.your-payload-type"
payload_content_configurations = [
  { key = "your_key", value = "your_value" }
]
```

#### 4. Self-Service Settings
```hcl
# Customize user-facing text
self_service_description = "Your custom description"
self_service_notification_message = "Your notification text"
```

---

## Example Variations

### Variation 1: Minimal Configuration

For simple deployments, start with minimal configuration:

```hcl
module "simple_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  profile_name = "Simple Profile"
  scope_computer_group_ids = [78]
  
  payload_content_type = "com.apple.example"
  payload_content_configurations = [
    { key = "setting", value = true }
  ]
}
```

### Variation 2: Production Configuration

For production, use comprehensive configuration:

```hcl
module "production_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  profile_name = "Production Security Profile"
  profile_description = "Corporate security baseline configuration"
  version_number = "1.0.0"
  
  # Comprehensive scoping
  scope_all_computers = true
  
  # Security settings
  user_removable = false
  level = "System"
  
  # Security payload
  payload_content_type = "com.apple.security"
  payload_content_configurations = [
    { key = "firewall_enabled", value = true },
    { key = "gatekeeper_enabled", value = true }
  ]
  
  # Organization
  tags = ["security", "production", "mandatory"]
  category_id = 10
}
```

### Variation 3: Development Configuration

For development/testing, use lightweight configuration:

```hcl
module "dev_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  profile_name = "Dev Test Profile"
  version_number = "0.1.0-dev"
  
  # Minimal scope
  scope_computer_ids = [12345]  # Test computer
  
  # Simple configuration
  payload_content_type = "com.apple.example"
  payload_content_configurations = [
    { key = "test_setting", value = true }
  ]
  
  # Development tags
  tags = ["development", "testing"]
}
```

---

## Testing Examples

### Before Production Deployment

Always test examples in a safe environment:

1. **Development Environment**
   - Use test computers or groups
   - Test basic functionality
   - Verify profile creation

2. **Staging Environment**
   - Use small user groups
   - Test self-service features
   - Verify notifications

3. **Production Environment**
   - Deploy to broader scope
   - Monitor deployment
   - Gather user feedback

### Validation Checklist

Before deploying examples to production:

- [ ] All required variables are configured
- [ ] Scope targets exist in Jamf Pro
- [ ] Payload configurations are valid
- [ ] Self-service descriptions are clear
- [ ] Notifications are appropriate
- [ ] Version numbers follow semantic versioning
- [ ] Tags are consistent with organizational standards
- [ ] Categories and sites are correct

---

## Troubleshooting Examples

### Common Issues

**Issue**: Profile not deploying
- Check scope configuration
- Verify target IDs exist
- Review Terraform plan output

**Issue**: Settings not applying
- Validate payload type
- Check configuration keys
- Verify payload is enabled

**Issue**: Self-service not working
- Ensure self_service_enabled = true
- Check category configurations
- Verify user scope

**Issue**: Notifications not sending
- Check notification settings
- Verify user email addresses
- Review Jamf Pro notification settings

---

## Contributing Examples

To contribute new examples:

1. **Follow naming convention**: `descriptive-name.tf`
2. **Include comments**: Explain complex configurations
3. **Document use cases**: Add to this README
4. **Test thoroughly**: Ensure examples work correctly
5. **Follow best practices**: Use module best practices

### Example Template

```hcl
# ============================================================================
# Example Name - Brief Description
# ============================================================================
# Detailed description of what this example demonstrates
# and when it should be used.

module "example_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  # Configuration here
}

# Outputs
output "example_output" {
  value = module.example_profile.profile_id
}
```

---

## Additional Resources

- [Main Module README](../README.md)
- [Validation and Best Practices](../docs/VALIDATION_AND_BEST_PRACTICES.md)
- [Terraform Provider Documentation](https://registry.terraform.io/providers/jamf/jamfpro/)
- [Jamf Pro Documentation](https://docs.jamf.com/)

---

## Support

For issues or questions about these examples:

1. Check the main module documentation
2. Review validation and best practices guide
3. Test in development environment first
4. Contact your Jamf Pro administrator
5. Review Terraform and Jamf Pro logs