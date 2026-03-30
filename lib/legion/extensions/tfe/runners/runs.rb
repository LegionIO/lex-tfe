# frozen_string_literal: true

require 'legion/extensions/tfe/errors'
require 'legion/extensions/tfe/helpers/client'

module Legion
  module Extensions
    module Tfe
      module Runners
        module Runs
          include Legion::Extensions::Tfe::Helpers::Client

          def list_runs(workspace_id:, url: nil, token: nil, page: 1, per_page: 20, **)
            params = { 'page[number]' => page, 'page[size]' => per_page }
            resp = connection(url: url, token: token).get("/api/v2/workspaces/#{workspace_id}/runs", params)
            resp.body
          end

          def get_run(run_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/runs/#{run_id}")
            resp.body
          end

          def create_run(workspace_id:, url: nil, token: nil, read_only: false, message: nil, auto_apply: false, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            attrs = { auto_apply: auto_apply }
            attrs[:message] = message if message
            payload = {
              data: {
                type:          'runs',
                attributes:    attrs,
                relationships: {
                  workspace: { data: { type: 'workspaces', id: workspace_id } }
                }
              }
            }
            resp = connection(url: url, token: token).post('/api/v2/runs', payload)
            resp.body
          end

          def apply_run(run_id:, url: nil, token: nil, read_only: false, comment: nil, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = comment ? { comment: comment } : {}
            resp = connection(url: url, token: token).post("/api/v2/runs/#{run_id}/actions/apply", payload)
            resp.body
          end

          def discard_run(run_id:, url: nil, token: nil, read_only: false, comment: nil, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = comment ? { comment: comment } : {}
            resp = connection(url: url, token: token).post("/api/v2/runs/#{run_id}/actions/discard", payload)
            resp.body
          end

          def cancel_run(run_id:, url: nil, token: nil, read_only: false, comment: nil, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = comment ? { comment: comment } : {}
            resp = connection(url: url, token: token).post("/api/v2/runs/#{run_id}/actions/cancel", payload)
            resp.body
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
