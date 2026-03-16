# frozen_string_literal: true

require 'legion/extensions/tfe/helpers/client'
require 'legion/extensions/tfe/runners/workspaces'
require 'legion/extensions/tfe/runners/runs'
require 'legion/extensions/tfe/runners/plans'
require 'legion/extensions/tfe/runners/applies'
require 'legion/extensions/tfe/runners/variables'
require 'legion/extensions/tfe/runners/variable_sets'
require 'legion/extensions/tfe/runners/projects'
require 'legion/extensions/tfe/runners/organizations'
require 'legion/extensions/tfe/runners/state_versions'
require 'legion/extensions/tfe/runners/policy_sets'

module Legion
  module Extensions
    module Tfe
      class Client
        include Helpers::Client
        include Runners::Workspaces
        include Runners::Runs
        include Runners::Plans
        include Runners::Applies
        include Runners::Variables
        include Runners::VariableSets
        include Runners::Projects
        include Runners::Organizations
        include Runners::StateVersions
        include Runners::PolicySets

        attr_reader :opts

        def initialize(url: 'https://app.terraform.io', token: nil, read_only: false, **extra)
          @opts = { url: url, token: token, read_only: read_only, **extra }
        end

        def connection(**override)
          super(**@opts.merge(override.compact))
        end
      end
    end
  end
end
