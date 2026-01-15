# Jamf Pro macOS Configuration Profile (Plist Generator)

Reusable Terraform module for managing Jamf Pro macOS configuration profiles
using plist payload generation.

## Features
- Fully typed inputs
- Optional Self Service support
- Dynamic payload configuration
- Supports complex scoping, limitations & exclusions
- CI/CD friendly

## Usage

```hcl
module "accessibility_profile" {
  source = "./modules/jamfpro-macos-plist-profile"

  profile_name_prefix   = "accessibility-seeing"
  profile_description   = "Base Accessibility configuration"
  version_number        = "1.0"
  plist_version_number  = "1.0"

  payload_configurations = [
    { key = "grayscale", value = false },
    { key = "contrast",  value = 0 }
  ]

  scope = {
    all_computers      = false
    all_jss_users      = false
    computer_ids       = [1, 2]
    computer_group_ids = []
    building_ids       = []
    department_ids     = []
    jss_user_ids       = []
    jss_user_group_ids = []
  }

  self_service = {
    description            = "Install accessibility profile"
    force_view_description = true
    feature_on_main_page   = true
    notification           = true
    notification_subject   = "Profile Available"
    notification_message   = "Install the new accessibility profile"
    categories = [
      { id = 10, display_in = true, feature_in = true }
    ]
  }
}
