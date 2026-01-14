# Module: `computers-configuration-profile`

This module manages a Jamf Pro **macOS Configuration Profile** using the provider resource `jamfpro_macos_configuration_profile_plist_generator`.

- Payloads are authored in **Terraform (HCL)** and generated into a plist/mobileconfig payload by the provider.
- Supports a flexible `settings` map for payload key/value items.
  - Scalars (string/number/bool) are supported.
  - Maps are treated as **nested dictionaries** (1 level deep).

## Inputs

### Required

- `name` (string)
  - Jamf UI name for the configuration profile.
- `scope` (object)
  - Target scope for the profile. Must target something.
- `payload_header` (object)
  - Header-level plist generator fields.
- `payload_content` (object)
  - Payload content fields + `settings` map.

### Optional

- `description` (string)
- `distribution_method` (string)
  - `Install Automatically` (default) or `Make Available in Self Service`
- `redeploy_on_update` (string)
  - `Newly Assigned` (default) or `All`
- `level` (string)
  - `System` (default) or `User`
- `user_removable` (bool)
- `site_id` (number)
- `category_id` (number)
- `allow_all_computers` (bool)
  - Guardrail: must be `true` if `scope.all_computers = true`.
- `self_service` (object)
  - Only valid when `distribution_method = "Make Available in Self Service"`.
- `timeouts` (object)

## Outputs

- `id`
- `uuid`
- `name`

## Example

```hcl
module "wifi" {
  source = "../../modules/computers-configuration-profile"

  name        = "Company WiFi"
  description = "Managed by Terraform"

  allow_all_computers = false
  scope = {
    all_computers      = false
    computer_group_ids = [123]
  }

  payload_header = {
    payload_description_header  = "Managed by Terraform"
    payload_enabled_header      = true
    payload_organization_header = "Company"
    payload_type_header         = "Configuration"
    payload_version_header      = 1
    payload_display_name_header = "Company WiFi"
    payload_scope_header        = "System"
  }

  payload_content = {
    payload_display_name = "Wi-Fi"
    payload_enabled      = true
    payload_organization = "Company"
    payload_type         = "com.apple.wifi.managed"
    payload_version      = 1
    payload_scope        = "System"

    settings = {
      SSID_STR = "CompanySSID"
      AutoJoin = true
      # Nested dictionary example (1 level)
      SomeDict = {
        ChildA = "x"
        ChildB = 123
      }
    }
  }
}
```
