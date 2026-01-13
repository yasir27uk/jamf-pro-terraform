# Jamf Pro Terraform Configuration

This project contains Terraform configurations for managing Jamf Pro resources using the deploymenttheory/jamfpro provider.

## Prerequisites

- Terraform >= 1.13.0
- Jamf Pro >= 11.20.0
- Appropriate permissions in Jamf Pro to manage resources via API

## Setup

1. **Install Terraform**: Follow the [official Terraform installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

2. **Configure Authentication**:
   - Copy `terraform.tfvars.example` to `terraform.tfvars`
   - Fill in your Jamf Pro server details and credentials
   - Choose between basic authentication (username/password) or OAuth2 (client ID/secret)

3. **Initialize Terraform**:
   ```bash
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
auth_method = "basic"
jamfpro_instance_fqdn = "https://yourcompany.jamfcloud.com"
basic_auth_username   = "your_username"
basic_auth_password   = "your_password"
```

### OAuth2 Authentication
```hcl
auth_method = "oauth2"
jamfpro_instance_fqdn = "https://yourcompany.jamfcloud.com"
client_id   = "your_client_id"
client_secret = "your_client_secret"
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

Jamf Pro Configuration Profile **Options** are defined inside the `.mobileconfig` payload you pass to the module. This includes:

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

### Computers Configuration Profiles (Multi-Profile)

If you want to manage many configuration profiles from one environment, use the multi-profile module (creates profiles via `for_each`).

- **Module path**
  - `modules/computers-configuration-profiles`

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
