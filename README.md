# Jamf Pro Terraform Configuration

This project contains Terraform configurations for managing Jamf Pro resources using the deploymenttheory/jamfpro provider.

## Prerequisites

- Terraform >= 1.13.0
- Jamf Pro >= 11.20.0
- Appropriate permissions in Jamf Pro to manage resources via API

## Setup

1. **Install Terraform**: Follow the [official Terraform installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

2. **Configure Authentication**:
   - Copy `environments/production/terraform.tfvars.example` to `environments/production/terraform.tfvars`
   - Fill in your Jamf Pro server details and OAuth2 credentials

3. **Initialize Terraform**:
   ```bash
   cd environments/production
   terraform init
   ```

4. **Plan and Apply**:
   ```bash
   terraform plan
   terraform apply
   ```

## Authentication Methods

### Basic Authentication
```hcl
jamfpro_instance_fqdn = "https://yourcompany.jamfcloud.com"
jamfpro_auth_method = "basic"
jamfpro_username    = "your_username"
jamfpro_password    = "your_password"
```

### OAuth2 Authentication
```hcl
jamfpro_instance_fqdn = "https://yourcompany.jamfcloud.com"
jamfpro_auth_method   = "oauth2"
jamfpro_client_id     = "your_client_id"
jamfpro_client_secret = "your_client_secret"
```

## Important Notes

- **Jamf Cloud Load Balancing**: If using Jamf Cloud, enable `jamfpro_load_balancer_lock = true` to handle load balancer cookie issues
- **Custom Cookies**: For non-Jamf Cloud load balanced setups, use `custom_cookies` to specify a persistent cookie
- **Sensitive Data**: All credentials are marked as sensitive and will not be displayed in Terraform output

## Available Resources

The provider supports managing various Jamf Pro resources including:
- Buildings
- Departments
- Computer Groups (static and smart)
- Scripts and Script Categories
- Policies
- Mobile Device Groups
- And many more...

Refer to the [provider documentation](https://registry.terraform.io/providers/deploymenttheory/jamfpro/latest/docs) for a complete list of available resources.

## Examples

Production configurations should live under `environments/` (for example `environments/production`).

## Reusable Modules

### Computers Configuration Profile (Enterprise)

This repository includes an enterprise-focused module for **Computer (macOS) Configuration Profiles** with stronger defaults and guardrails.

This repository uses the provider's **plist generator** to define configuration profile payloads in Terraform (no `.mobileconfig` files required). Jamf Pro Configuration Profile options and payload types include:

- **General**
- **Application & Custom Settings** (including uploaded payloads)
- **Certificates**
- **Managed Login Items**
- **Privacy Preferences Policy Control (PPPC)**
- **System Extensions**

- **Module path**
  - `modules/computers-configuration-profile`
- **Example usage**
  - `environments/production`

### Multiple Profiles (Dynamic)

`environments/production` supports creating multiple profiles dynamically by setting a `profiles` map (each entry is created via `for_each` using the enterprise module).

Guardrails included:

- `scope.all_computers=true` requires `allow_all_computers=true` (to reduce accidental broad deployments)
- `self_service` must be set only when `distribution_method = "Make Available in Self Service"`

## Best Practices

1. Use version control for your Terraform configurations
2. Store sensitive data in environment variables or secure secret management
3. Use Terraform workspaces for managing multiple environments
4. Implement proper peer review processes for configuration changes
5. Use Terraform modules for reusable configurations

## Running Terraform

Run `terraform init/plan/apply` from the environment folder (for example `environments/production`) so Terraform picks up the correct variables and configuration.

## Support

- [Provider Documentation](https://registry.terraform.io/providers/deploymenttheory/jamfpro/latest/docs)
- [GitHub Repository](https://github.com/deploymenttheory/terraform-provider-jamfpro)
- [Community Slack](https://macadmins.org/) - #terraform-provider-jamfpro channel

## Disclaimer

This is a community-driven provider and is not officially supported by Jamf.
