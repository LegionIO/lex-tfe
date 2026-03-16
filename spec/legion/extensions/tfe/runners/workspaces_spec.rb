# frozen_string_literal: true

require 'spec_helper'
require 'faraday'

RSpec.describe Legion::Extensions::Tfe::Runners::Workspaces do
  let(:runner_class) do
    Class.new do
      include Legion::Extensions::Tfe::Runners::Workspaces
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

  describe '#list' do
    it 'calls GET /api/v2/organizations/:org/workspaces' do
      runner.list(organization: 'my-org')
      expect(fake_conn).to have_received(:get).with('/api/v2/organizations/my-org/workspaces', anything)
    end

    it 'passes pagination params' do
      runner.list(organization: 'my-org', page: 2, per_page: 10)
      expect(fake_conn).to have_received(:get).with(anything, hash_including('page[number]' => 2, 'page[size]' => 10))
    end

    it 'passes search param when provided' do
      runner.list(organization: 'my-org', search: 'staging')
      expect(fake_conn).to have_received(:get).with(anything, hash_including('search[name]' => 'staging'))
    end

    it 'omits search param when not provided' do
      runner.list(organization: 'my-org')
      expect(fake_conn).to have_received(:get).with(anything, hash_excluding('search[name]'))
    end

    it 'returns the response body' do
      result = runner.list(organization: 'my-org')
      expect(result).to eq({ 'data' => [] })
    end
  end

  describe '#get' do
    it 'calls GET /api/v2/workspaces/:id' do
      runner.get(workspace_id: 'ws-abc123')
      expect(fake_conn).to have_received(:get).with('/api/v2/workspaces/ws-abc123')
    end

    it 'returns the response body' do
      result = runner.get(workspace_id: 'ws-abc123')
      expect(result).to eq({ 'data' => [] })
    end
  end

  describe '#create' do
    it 'calls POST /api/v2/organizations/:org/workspaces' do
      runner.create(organization: 'my-org', name: 'my-ws')
      expect(fake_conn).to have_received(:post).with('/api/v2/organizations/my-org/workspaces', anything)
    end

    it 'includes the workspace name in the payload' do
      runner.create(organization: 'my-org', name: 'my-ws')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(
                                                                 data: hash_including(
                                                                   attributes: hash_including(name: 'my-ws')
                                                                 )
                                                               ))
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.create(organization: 'my-org', name: 'my-ws', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end

    it 'returns the response body' do
      result = runner.create(organization: 'my-org', name: 'my-ws')
      expect(result).to eq({ 'data' => [] })
    end
  end

  describe '#update' do
    it 'calls PATCH /api/v2/workspaces/:id' do
      runner.update(workspace_id: 'ws-abc123', description: 'updated')
      expect(fake_conn).to have_received(:patch).with('/api/v2/workspaces/ws-abc123', anything)
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.update(workspace_id: 'ws-abc123', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end

  describe '#delete' do
    it 'calls DELETE /api/v2/workspaces/:id' do
      runner.delete(workspace_id: 'ws-abc123')
      expect(fake_conn).to have_received(:delete).with('/api/v2/workspaces/ws-abc123')
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.delete(workspace_id: 'ws-abc123', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end

  describe '#lock' do
    it 'calls POST /api/v2/workspaces/:id/actions/lock' do
      runner.lock(workspace_id: 'ws-abc123')
      expect(fake_conn).to have_received(:post).with('/api/v2/workspaces/ws-abc123/actions/lock', anything)
    end

    it 'includes reason in payload when provided' do
      runner.lock(workspace_id: 'ws-abc123', reason: 'maintenance')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(reason: 'maintenance'))
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.lock(workspace_id: 'ws-abc123', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end

  describe '#unlock' do
    it 'calls POST /api/v2/workspaces/:id/actions/unlock' do
      runner.unlock(workspace_id: 'ws-abc123')
      expect(fake_conn).to have_received(:post).with('/api/v2/workspaces/ws-abc123/actions/unlock')
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.unlock(workspace_id: 'ws-abc123', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end
end
