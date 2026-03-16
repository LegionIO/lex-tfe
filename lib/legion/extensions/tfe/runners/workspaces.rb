# frozen_string_literal: true

require 'legion/extensions/tfe/errors'
require 'legion/extensions/tfe/helpers/client'

module Legion
  module Extensions
    module Tfe
      module Runners
        module Workspaces
          include Legion::Extensions::Tfe::Helpers::Client

          def list(organization:, url: nil, token: nil, page: 1, per_page: 20, search: nil, **)
            params = { 'page[number]' => page, 'page[size]' => per_page }
            params['search[name]'] = search if search
            resp = connection(url: url, token: token).get("/api/v2/organizations/#{organization}/workspaces", params)
            resp.body
          end

          def get(workspace_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/workspaces/#{workspace_id}")
            resp.body
          end

          def create(organization:, name:, url: nil, token: nil, read_only: false, **attrs)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = { data: { type: 'workspaces', attributes: { name: name }.merge(attrs) } }
            resp = connection(url: url, token: token).post("/api/v2/organizations/#{organization}/workspaces", payload)
            resp.body
          end

          def update(workspace_id:, url: nil, token: nil, read_only: false, **attrs)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = { data: { type: 'workspaces', attributes: attrs } }
            resp = connection(url: url, token: token).patch("/api/v2/workspaces/#{workspace_id}", payload)
            resp.body
          end

          def delete(workspace_id:, url: nil, token: nil, read_only: false, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            connection(url: url, token: token).delete("/api/v2/workspaces/#{workspace_id}")
          end

          def lock(workspace_id:, reason: nil, url: nil, token: nil, read_only: false, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = reason ? { reason: reason } : {}
            resp = connection(url: url, token: token).post("/api/v2/workspaces/#{workspace_id}/actions/lock", payload)
            resp.body
          end

          def unlock(workspace_id:, url: nil, token: nil, read_only: false, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            resp = connection(url: url, token: token).post("/api/v2/workspaces/#{workspace_id}/actions/unlock")
            resp.body
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
