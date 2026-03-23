# Changelog

## [0.1.1]

### Changed
- Add legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, legion-transport as runtime dependencies
- Update spec_helper to require sub-gem helpers before loading extension

## [0.1.0]

### Added
- Initial release
- Runners: Workspaces, Runs, Plans, Applies, Variables, VariableSets, Projects, Organizations, StateVersions, PolicySets
- Standalone Client class with configurable url, token, and read_only
- Read-only mode support via ReadOnlyError on mutating operations
- Bearer token authentication
- JSON:API content type support
