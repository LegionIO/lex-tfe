# frozen_string_literal: true

require 'spec_helper'
require 'faraday'

RSpec.describe Legion::Extensions::Tfe::Runners::Variables do
  let(:runner_class) do
    Class.new do
      include Legion::Extensions::Tfe::Runners::Variables
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
    allow(conn).to receive(:post).and_return(fake_response)
    allow(conn).to receive(:patch).and_return(fake_response)
    allow(conn).to receive(:delete).and_return(fake_response)
    conn
  end

  before do
    allow(runner).to receive(:connection).and_return(fake_conn)
  end

  describe '#list_variables' do
    it 'calls GET /api/v2/workspaces/:id/vars' do
      runner.list_variables(workspace_id: 'ws-abc')
      expect(fake_conn).to have_received(:get).with('/api/v2/workspaces/ws-abc/vars')
    end

    it 'returns the response body' do
      result = runner.list_variables(workspace_id: 'ws-abc')
      expect(result).to eq({ 'data' => [] })
    end
  end

  describe '#create_variable' do
    it 'calls POST /api/v2/vars' do
      runner.create_variable(workspace_id: 'ws-abc', key: 'AWS_REGION', value: 'us-east-2')
      expect(fake_conn).to have_received(:post).with('/api/v2/vars', anything)
    end

    it 'includes key and value in payload attributes' do
      runner.create_variable(workspace_id: 'ws-abc', key: 'AWS_REGION', value: 'us-east-2')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(
                                                                 data: hash_including(
                                                                   attributes: hash_including(key: 'AWS_REGION', value: 'us-east-2')
                                                                 )
                                                               ))
    end

    it 'defaults category to terraform' do
      runner.create_variable(workspace_id: 'ws-abc', key: 'k', value: 'v')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(
                                                                 data: hash_including(
                                                                   attributes: hash_including(category: 'terraform')
                                                                 )
                                                               ))
    end

    it 'defaults sensitive to false' do
      runner.create_variable(workspace_id: 'ws-abc', key: 'k', value: 'v')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(
                                                                 data: hash_including(
                                                                   attributes: hash_including(sensitive: false)
                                                                 )
                                                               ))
    end

    it 'includes workspace relationship' do
      runner.create_variable(workspace_id: 'ws-abc', key: 'k', value: 'v')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(
                                                                 data: hash_including(
                                                                   relationships: hash_including(
                                                                     workspace: { data: { type: 'workspaces', id: 'ws-abc' } }
                                                                   )
                                                                 )
                                                               ))
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.create_variable(workspace_id: 'ws-abc', key: 'k', value: 'v', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end

  describe '#update_variable' do
    it 'calls PATCH /api/v2/vars/:id' do
      runner.update_variable(variable_id: 'var-xyz', value: 'new-value')
      expect(fake_conn).to have_received(:patch).with('/api/v2/vars/var-xyz', anything)
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.update_variable(variable_id: 'var-xyz', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end

  describe '#delete_variable' do
    it 'calls DELETE /api/v2/vars/:id' do
      runner.delete_variable(variable_id: 'var-xyz')
      expect(fake_conn).to have_received(:delete).with('/api/v2/vars/var-xyz')
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.delete_variable(variable_id: 'var-xyz', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end
end
