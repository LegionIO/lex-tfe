# frozen_string_literal: true

require 'legion/extensions/tfe/errors'
require 'legion/extensions/tfe/helpers/client'

module Legion
  module Extensions
    module Tfe
      module Runners
        module Variables
          include Legion::Extensions::Tfe::Helpers::Client

          def list_variables(workspace_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/workspaces/#{workspace_id}/vars")
            resp.body
          end

          # category: 'terraform' or 'env'
          # sensitive: true/false
          # hcl: true/false
          def create_variable(workspace_id:, key:, value:, url: nil, token: nil, read_only: false, **attrs)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            var_attrs = { key: key, value: value, category: 'terraform', sensitive: false, hcl: false }.merge(attrs)
            payload = {
              data: {
                type:          'vars',
                attributes:    var_attrs,
                relationships: {
                  workspace: { data: { type: 'workspaces', id: workspace_id } }
                }
              }
            }
            resp = connection(url: url, token: token).post('/api/v2/vars', payload)
            resp.body
          end

          def update_variable(variable_id:, url: nil, token: nil, read_only: false, **attrs)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = { data: { type: 'vars', id: variable_id, attributes: attrs } }
            resp = connection(url: url, token: token).patch("/api/v2/vars/#{variable_id}", payload)
            resp.body
          end

          def delete_variable(variable_id:, url: nil, token: nil, read_only: false, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            connection(url: url, token: token).delete("/api/v2/vars/#{variable_id}")
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
