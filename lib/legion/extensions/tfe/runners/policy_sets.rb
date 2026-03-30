# frozen_string_literal: true

require 'legion/extensions/tfe/helpers/client'

module Legion
  module Extensions
    module Tfe
      module Runners
        module PolicySets
          include Legion::Extensions::Tfe::Helpers::Client

          def list_policy_sets(organization:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/organizations/#{organization}/policy-sets")
            resp.body
          end

          def get_policy_set(policy_set_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/policy-sets/#{policy_set_id}")
            resp.body
          end

          def list_workspace_policy_sets(workspace_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/workspaces/#{workspace_id}/relationships/policy-sets")
            resp.body
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
