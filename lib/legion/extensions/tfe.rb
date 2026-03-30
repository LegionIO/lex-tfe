# frozen_string_literal: true

require 'legion/extensions/tfe/version'
require 'legion/extensions/tfe/errors'
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
require 'legion/extensions/tfe/client'

module Legion
  module Extensions
    module Tfe
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core, false
    end
  end
end
