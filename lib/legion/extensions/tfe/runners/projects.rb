# frozen_string_literal: true

require 'legion/extensions/tfe/errors'
require 'legion/extensions/tfe/helpers/client'

module Legion
  module Extensions
    module Tfe
      module Runners
        module Projects
          include Legion::Extensions::Tfe::Helpers::Client

          def list_projects(organization:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/organizations/#{organization}/projects")
            resp.body
          end

          def get_project(project_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/projects/#{project_id}")
            resp.body
          end

          def create_project(organization:, name:, url: nil, token: nil, read_only: false, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = { data: { type: 'projects', attributes: { name: name } } }
            resp = connection(url: url, token: token).post("/api/v2/organizations/#{organization}/projects", payload)
            resp.body
          end

          def update_project(project_id:, url: nil, token: nil, read_only: false, **attrs)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            payload = { data: { type: 'projects', attributes: attrs } }
            resp = connection(url: url, token: token).patch("/api/v2/projects/#{project_id}", payload)
            resp.body
          end

          def delete_project(project_id:, url: nil, token: nil, read_only: false, **)
            raise ReadOnlyError, 'Write operations disabled (read_only mode)' if read_only

            connection(url: url, token: token).delete("/api/v2/projects/#{project_id}")
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
