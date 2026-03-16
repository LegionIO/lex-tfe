# lex-tfe

LegionIO Extension for Terraform Enterprise (TFE) and HCP Terraform. Provides runners for managing workspaces, runs, plans, applies, variables, variable sets, projects, organizations, state versions, and policy sets via the TFE REST API v2.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-tfe'
```

Or install directly:

```bash
gem install lex-tfe
```

## Configuration

Settings are read from `Legion::Settings[:extensions][:tfe]` when running inside the LegionIO framework:

| Setting    | Description                                           | Default                        |
|------------|-------------------------------------------------------|--------------------------------|
| `url`      | TFE/HCP Terraform base URL                            | `https://app.terraform.io`     |
| `token`    | API token (Bearer auth)                               | `nil`                          |
| `read_only`| Prevent create/update/delete operations               | `false`                        |

Supported base URLs:
- `https://app.terraform.io` — HCP Terraform (SaaS)
- `https://terraform.uhg.com` — UHG app team TFE cluster
- `https://tfe-arc.uhg.com` — UHG Grid platform TFE cluster
- Any custom TFE instance

## Standalone Client Usage

```ruby
require 'lex-tfe'

client = Legion::Extensions::Tfe::Client.new(
  url:       'https://terraform.uhg.com',
  token:     'your-api-token',
  read_only: false
)

# List workspaces in an organization
client.list(organization: 'my-org')

# Get a specific workspace
client.get(workspace_id: 'ws-abc123')

# Create a workspace
client.create(organization: 'my-org', name: 'new-workspace', auto_apply: true)

# Trigger a run
client.create_run(workspace_id: 'ws-abc123', message: 'triggered by CI', auto_apply: true)

# List variables
client.list_variables(workspace_id: 'ws-abc123')

# Create a variable
client.create_variable(
  workspace_id: 'ws-abc123',
  key:          'AWS_REGION',
  value:        'us-east-2',
  category:     'env'
)
```

### Read-only mode

```ruby
client = Legion::Extensions::Tfe::Client.new(
  url:       'https://terraform.uhg.com',
  token:     'read-only-token',
  read_only: true
)

# Safe - read operations work normally
client.list(organization: 'my-org')

# Raises Legion::Extensions::Tfe::ReadOnlyError
client.create(organization: 'my-org', name: 'ws', read_only: client.opts[:read_only])
```

## Runners

### Workspaces

| Method      | Description                            |
|-------------|----------------------------------------|
| `list`      | List workspaces in an organization     |
| `get`       | Get a workspace by ID                  |
| `create`    | Create a workspace                     |
| `update`    | Update a workspace                     |
| `delete`    | Delete a workspace                     |
| `lock`      | Lock a workspace                       |
| `unlock`    | Unlock a workspace                     |

### Runs

| Method        | Description                     |
|---------------|---------------------------------|
| `list_runs`   | List runs for a workspace       |
| `get_run`     | Get a run by ID                 |
| `create_run`  | Queue a new run                 |
| `apply_run`   | Apply a run                     |
| `discard_run` | Discard a run                   |
| `cancel_run`  | Cancel a run                    |

### Plans

| Method                 | Description                  |
|------------------------|------------------------------|
| `get_plan`             | Get a plan by ID             |
| `get_plan_json_output` | Get the plan JSON output     |
| `get_plan_log`         | Get the plan log             |

### Applies

| Method          | Description             |
|-----------------|-------------------------|
| `get_apply`     | Get an apply by ID      |
| `get_apply_log` | Get the apply log       |

### Variables

| Method             | Description                       |
|--------------------|-----------------------------------|
| `list_variables`   | List workspace variables          |
| `create_variable`  | Create a workspace variable       |
| `update_variable`  | Update a workspace variable       |
| `delete_variable`  | Delete a workspace variable       |

### Variable Sets

| Method                  | Description                              |
|-------------------------|------------------------------------------|
| `list_variable_sets`    | List variable sets in an organization    |
| `get_variable_set`      | Get a variable set by ID                 |
| `create_variable_set`   | Create a variable set                    |
| `update_variable_set`   | Update a variable set                    |
| `delete_variable_set`   | Delete a variable set                    |
| `list_varset_variables` | List variables in a variable set         |
| `add_varset_variable`   | Add a variable to a variable set         |

### Projects

| Method           | Description                          |
|------------------|--------------------------------------|
| `list_projects`  | List projects in an organization     |
| `get_project`    | Get a project by ID                  |
| `create_project` | Create a project                     |
| `update_project` | Update a project                     |
| `delete_project` | Delete a project                     |

### Organizations

| Method               | Description              |
|----------------------|--------------------------|
| `list_organizations` | List all organizations   |
| `get_organization`   | Get an organization      |

### State Versions

| Method                    | Description                             |
|---------------------------|-----------------------------------------|
| `list_state_versions`     | List state versions for a workspace     |
| `get_state_version`       | Get a state version by ID               |
| `get_current_state_version` | Get the current state version         |

### Policy Sets

| Method                      | Description                                 |
|-----------------------------|---------------------------------------------|
| `list_policy_sets`          | List policy sets in an organization         |
| `get_policy_set`            | Get a policy set by ID                      |
| `list_workspace_policy_sets`| List policy sets attached to a workspace    |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```
