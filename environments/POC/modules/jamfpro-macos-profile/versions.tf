# ============================================================================
# Jamf Pro macOS Configuration Profile Module - Version Constraints
# ============================================================================

terraform {
  required_providers {
    jamfpro = {
      source  = "deploymenttheory/jamfpro"
      version = ">= 0.30.0"
    }
  }
  required_version = ">= 1.13.0"
}