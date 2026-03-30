# frozen_string_literal: true

require 'legion/extensions/tfe/helpers/client'

module Legion
  module Extensions
    module Tfe
      module Runners
        module StateVersions
          include Legion::Extensions::Tfe::Helpers::Client

          def list_state_versions(workspace_id:, url: nil, token: nil, **)
            params = { 'filter[workspace][name]' => workspace_id }
            resp = connection(url: url, token: token).get('/api/v2/state-versions', params)
            resp.body
          end

          def get_state_version(state_version_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/state-versions/#{state_version_id}")
            resp.body
          end

          def get_current_state_version(workspace_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/workspaces/#{workspace_id}/current-state-version")
            resp.body
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
