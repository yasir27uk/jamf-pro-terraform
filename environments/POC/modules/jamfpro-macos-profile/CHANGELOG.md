# Changelog

All notable changes to the Jamf Pro macOS Configuration Profile Module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of the enhanced Jamf Pro macOS Configuration Profile module
- Comprehensive variable definitions with validation
- Advanced scoping capabilities with limitations and exclusions
- Full self-service integration with categories and notifications
- Flexible payload configuration system
- Production-ready outputs and monitoring
- Complete documentation and examples
- Validation and best practices guide

## [1.0.0] - 2024-01-01

### Added
- Core module structure with main.tf, variables.tf, and outputs.tf
- Support for macOS configuration profile creation
- Basic scoping capabilities
- Self-service configuration options
- Payload management for configuration profiles
- Comprehensive validation rules
- Version management support
- Tag-based organization
- Category and site support

### Features
- Advanced scoping with computer groups, buildings, and departments
- Network segment and iBeacon limitations
- Directory service integration for user targeting
- Comprehensive exclusion capabilities
- Multi-category self-service support
- Rich notification system
- Automatic version naming
- Deployment status monitoring
- Scope summary reporting

### Documentation
- Complete README with usage examples
- Four comprehensive example configurations
- Validation and best practices guide
- Inline code documentation
- Troubleshooting guidance

### Security
- Input validation on all variables
- Secure payload handling
- Scope limitation capabilities
- User removal controls
- Network-based deployment restrictions

## [0.9.0] - 2023-12-15

### Added
- Initial module structure
- Basic profile creation
- Simple scoping
- Documentation framework

---

## Module Versioning Policy

This module follows semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Incompatible changes that require updates to calling code
- **MINOR**: Backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

### Upgrade Guidelines

When upgrading between versions:

1. **0.9.0 → 1.0.0**: First stable release with production-ready features
2. **1.x.x → 1.y.x**: Minor updates with new features (backwards compatible)
3. **1.x.x → 2.0.0**: Major updates with breaking changes

### Breaking Changes

Major version updates may include:
- Variable renaming or restructuring
- Changes to default values
- Modifications to output structure
- Provider version requirement changes

Always review the upgrade notes and test in non-production environments before deploying major updates.

---

## Release Schedule

Releases are planned on a quarterly basis:
- Q1 Release: March
- Q2 Release: June
- Q3 Release: September
- Q4 Release: December

Critical security patches may be released out of cycle as needed.