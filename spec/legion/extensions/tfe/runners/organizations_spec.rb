# frozen_string_literal: true

require 'spec_helper'
require 'faraday'

RSpec.describe Legion::Extensions::Tfe::Runners::Organizations do
  let(:runner_class) do
    Class.new do
      include Legion::Extensions::Tfe::Runners::Organizations
    end
  end

  let(:runner) { runner_class.new }

  let(:fake_response) do
    resp = double('FaradayResponse')
    allow(resp).to receive(:body).and_return({ 'data' => [] })
    resp
  end

  let(:fake_conn) do
    conn = double('FaradayConnection')
    allow(conn).to receive(:get).and_return(fake_response)
    conn
  end

  before do
    allow(runner).to receive(:connection).and_return(fake_conn)
  end

  describe '#list_organizations' do
    it 'calls GET /api/v2/organizations' do
      runner.list_organizations
      expect(fake_conn).to have_received(:get).with('/api/v2/organizations')
    end

    it 'returns the response body' do
      result = runner.list_organizations
      expect(result).to eq({ 'data' => [] })
    end
  end

  describe '#get_organization' do
    it 'calls GET /api/v2/organizations/:name' do
      runner.get_organization(organization: 'my-org')
      expect(fake_conn).to have_received(:get).with('/api/v2/organizations/my-org')
    end

    it 'returns the response body' do
      result = runner.get_organization(organization: 'my-org')
      expect(result).to eq({ 'data' => [] })
    end
  end
end
