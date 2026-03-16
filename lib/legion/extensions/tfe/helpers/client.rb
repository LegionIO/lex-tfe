# frozen_string_literal: true

require 'faraday'

module Legion
  module Extensions
    module Tfe
      module Helpers
        module Client
          def connection(url: 'https://app.terraform.io', token: nil, **_opts)
            Faraday.new(url: url) do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['Authorization'] = "Bearer #{token}" if token
              conn.headers['Content-Type'] = 'application/vnd.api+json'
            end
          end
        end
      end
    end
  end
end
