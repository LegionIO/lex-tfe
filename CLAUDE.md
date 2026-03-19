# lex-tfe: Terraform Enterprise / HCP Terraform Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent (Level 2)**: `/Users/miverso2/rubymine/legion/extensions/CLAUDE.md`
- **Parent (Level 1)**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Terraform Enterprise (TFE) and HCP Terraform. Provides runners for managing workspaces, runs, plans, applies, variables, variable sets, projects, organizations, state versions, and policy sets via the TFE REST API v2.

**GitHub**: https://github.com/LegionIO/lex-tfe
**License**: MIT
**Version**: 0.1.0

## Architecture

```
Legion::Extensions::Tfe
├── Runners/
│   ├── Workspaces      # list, get, create, update, delete, lock, unlock
│   ├── Runs            # list_runs, get_run, create_run, apply_run, discard_run, cancel_run
│   ├── Plans           # get_plan, get_plan_json_output, get_plan_log
│   ├── Applies         # get_apply, get_apply_log
│   ├── Variables       # list_variables, create_variable, update_variable, delete_variable
│   ├── VariableSets    # list_variable_sets, get_variable_set, create_variable_set, update_variable_set,
│   │                   #   delete_variable_set, list_varset_variables, add_varset_variable
│   ├── Projects        # list_projects, get_project, create_project, update_project, delete_project
│   ├── Organizations   # list_organizations, get_organization
│   ├── StateVersions   # list_state_versions, get_state_version, get_current_state_version
│   └── PolicySets      # list_policy_sets, get_policy_set, list_workspace_policy_sets
├── Helpers/
│   └── Client          # Faraday connection builder (Bearer token auth)
├── Errors              # ReadOnlyError raised on write ops when read_only: true
└── Client              # Standalone client class (includes all runners)
```

## Key Files

| Path | Purpose |
|------|---------|
| `lib/legion/extensions/tfe.rb` | Entry point, extension registration |
| `lib/legion/extensions/tfe/version.rb` | Version constant (0.1.0) |
| `lib/legion/extensions/tfe/helpers/client.rb` | Faraday connection builder with Bearer token auth |
| `lib/legion/extensions/tfe/errors.rb` | `ReadOnlyError` for read-only guard |
| `lib/legion/extensions/tfe/client.rb` | Standalone `Client` class |
| `lib/legion/extensions/tfe/runners/workspaces.rb` | Workspace CRUD + lock/unlock |
| `lib/legion/extensions/tfe/runners/runs.rb` | Run lifecycle management |
| `lib/legion/extensions/tfe/runners/plans.rb` | Plan retrieval and log streaming |
| `lib/legion/extensions/tfe/runners/applies.rb` | Apply retrieval and log streaming |
| `lib/legion/extensions/tfe/runners/variables.rb` | Workspace variable management |
| `lib/legion/extensions/tfe/runners/variable_sets.rb` | Variable set management |
| `lib/legion/extensions/tfe/runners/projects.rb` | Project CRUD |
| `lib/legion/extensions/tfe/runners/organizations.rb` | Organization list/get |
| `lib/legion/extensions/tfe/runners/state_versions.rb` | State version retrieval |
| `lib/legion/extensions/tfe/runners/policy_sets.rb` | Policy set list/get |

## Connection

`Helpers::Client` builds a Faraday connection with `Authorization: Bearer <token>` header. The `url:` parameter accepts any TFE instance base URL (defaults to `https://app.terraform.io`). Supports both HCP Terraform SaaS and self-hosted TFE.

Common target URLs:
- `https://app.terraform.io` — HCP Terraform (SaaS)
- `https://terraform.uhg.com` — UHG app team TFE cluster
- `https://tfe-arc.uhg.com` — UHG Grid platform TFE cluster

## Read-Only Guard

`Helpers::Client` accepts a `read_only:` boolean. When `true`, any runner method that performs a write operation (create, update, delete, lock, unlock, apply, discard, cancel) raises `Legion::Extensions::Tfe::ReadOnlyError` before making any API call.

## Settings Reference

```json
{
  "extensions": {
    "tfe": {
      "url": "https://app.terraform.io",
      "token": "vault://secret/tfe/api_token#value",
      "read_only": false
    }
  }
}
```

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` (>= 2.0) | HTTP client for TFE REST API v2 |

## Testing

72 specs across 5 spec files.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
