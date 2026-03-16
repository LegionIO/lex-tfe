# frozen_string_literal: true

require 'legion/extensions/tfe/helpers/client'

module Legion
  module Extensions
    module Tfe
      module Runners
        module Organizations
          include Legion::Extensions::Tfe::Helpers::Client

          def list_organizations(url: nil, token: nil, **)
            resp = connection(url: url, token: token).get('/api/v2/organizations')
            resp.body
          end

          def get_organization(organization:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/organizations/#{organization}")
            resp.body
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
