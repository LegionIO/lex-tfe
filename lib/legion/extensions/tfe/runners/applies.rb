# frozen_string_literal: true

require 'legion/extensions/tfe/helpers/client'

module Legion
  module Extensions
    module Tfe
      module Runners
        module Applies
          include Legion::Extensions::Tfe::Helpers::Client

          def get_apply(apply_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/applies/#{apply_id}")
            resp.body
          end

          def get_apply_log(apply_id:, url: nil, token: nil, **)
            resp = connection(url: url, token: token).get("/api/v2/applies/#{apply_id}/log-read")
            resp.body
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
