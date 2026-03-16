# frozen_string_literal: true

require 'legion/extensions/tfe/errors'
require 'legion/extensions/tfe/helpers/client'

module Legion
  module Extensions
    module Tfe
      module Runners
        module VariableSets
          include Legion::Extensions::Tfe::Helpers::Client

          def list_variable_sets(organization:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/organizations/#{organization}/varsets")
            resp.body
          end

          def get_variable_set(variable_set_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/varsets/#{variable_set_id}")
            resp.body
          end

          def create_variable_set(organization:, name:, url: nil, token: nil, read_only: false, **attrs)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = { data: { type: 'varsets', attributes: { name: name }.merge(attrs) } }
            resp = connection(url: url, token: token).post("/api/v2/organizations/#{organization}/varsets", payload)
            resp.body
          end

          def update_variable_set(variable_set_id:, url: nil, token: nil, read_only: false, **attrs)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = { data: { type: 'varsets', attributes: attrs } }
            resp = connection(url: url, token: token).patch("/api/v2/varsets/#{variable_set_id}", payload)
            resp.body
          end

          def delete_variable_set(variable_set_id:, url: nil, token: nil, read_only: false, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            connection(url: url, token: token).delete("/api/v2/varsets/#{variable_set_id}")
          end

          def list_varset_variables(variable_set_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/varsets/#{variable_set_id}/relationships/vars")
            resp.body
          end

          def add_varset_variable(variable_set_id:, key:, value:, url: nil, token: nil, read_only: false, **attrs)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            var_attrs = { key: key, value: value, category: 'terraform' }.merge(attrs)
            payload = { data: { type: 'vars', attributes: var_attrs } }
            resp = connection(url: url, token: token).post("/api/v2/varsets/#{variable_set_id}/relationships/vars",
                                                           payload)
            resp.body
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
