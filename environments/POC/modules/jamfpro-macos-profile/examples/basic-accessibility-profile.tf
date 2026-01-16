# ============================================================================
# Example 1: Basic Accessibility Profile
# ============================================================================
# This example demonstrates the simplest usage of the module with minimal
# configuration for accessibility settings.

module "accessibility_profile" {
  source = "../../modules/jamfpro-macos-profile"
  
  # Required Variables
  profile_name = "Base Accessibility Settings"
  
  # Basic Configuration
  profile_description = "Essential accessibility configurations for vision impaired users"
  version_number      = "1.0"
  
  # Scope - Target specific computer group
  scope_computer_group_ids = [78]
  
  # Payload Configuration
  payload_content_type         = "com.apple.universalaccess"
  payload_content_display_name = "Accessibility"
  payload_content_organization = "Deployment Theory"
  
  payload_content_configurations = [
    { key = "closeViewFarPoint", value = 2 },
    { key = "closeViewHotkeysEnabled", value = true },
    { key = "closeViewNearPoint", value = 10 },
    { key = "closeViewScrollWheelToggle", value = true },
    { key = "closeViewShowPreview", value = true },
    { key = "closeViewSmoothImages", value = true },
    { key = "contrast", value = 0 },
    { key = "flashScreen", value = false },
    { key = "grayscale", value = false },
    { key = "mouseDriver", value = false },
    { key = "mouseDriverCursorSize", value = 3 },
    { key = "mouseDriverIgnoreTrackpad", value = false },
    { key = "mouseDriverInitialDelay", value = 1.0 },
    { key = "mouseDriverMaxSpeed", value = 3 },
    { key = "slowKey", value = false },
    { key = "slowKeyBeepOn", value = false },
    { key = "slowKeyDelay", value = 0 },
    { key = "stereoAsMono", value = false },
    { key = "stickyKey", value = false },
    { key = "stickyKeyBeepOnModifier", value = false },
    { key = "stickyKeyShowWindow", value = false },
    { key = "voiceOverOnOffKey", value = true },
    { key = "whiteOnBlack", value = false }
  ]
}

# Output important information
output "accessibility_profile_id" {
  description = "ID of the accessibility profile"
  value       = module.accessibility_profile.profile_id
}

output "accessibility_profile_name" {
  description = "Name of the accessibility profile"
  value       = module.accessibility_profile.profile_name
}

output "deployment_targets" {
  description = "Number of deployment targets"
  value       = module.accessibility_profile.deployment_targets
}