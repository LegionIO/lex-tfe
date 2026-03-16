# frozen_string_literal: true

require 'spec_helper'
require 'faraday'

RSpec.describe Legion::Extensions::Tfe::Runners::Runs do
  let(:runner_class) do
    Class.new do
      include Legion::Extensions::Tfe::Runners::Runs
    end
  end

  let(:runner) { runner_class.new }

  let(:fake_response) do
    resp = double('FaradayResponse')
    allow(resp).to receive(:body).and_return({ 'data' => {} })
    resp
  end

  let(:fake_conn) do
    conn = double('FaradayConnection')
    allow(conn).to receive(:get).and_return(fake_response)
    allow(conn).to receive(:post).and_return(fake_response)
    conn
  end

  before do
    allow(runner).to receive(:connection).and_return(fake_conn)
  end

  describe '#list_runs' do
    it 'calls GET /api/v2/workspaces/:id/runs' do
      runner.list_runs(workspace_id: 'ws-abc')
      expect(fake_conn).to have_received(:get).with('/api/v2/workspaces/ws-abc/runs', anything)
    end

    it 'passes pagination params' do
      runner.list_runs(workspace_id: 'ws-abc', page: 3, per_page: 5)
      expect(fake_conn).to have_received(:get).with(anything, hash_including('page[number]' => 3, 'page[size]' => 5))
    end

    it 'returns the response body' do
      result = runner.list_runs(workspace_id: 'ws-abc')
      expect(result).to eq({ 'data' => {} })
    end
  end

  describe '#get_run' do
    it 'calls GET /api/v2/runs/:id' do
      runner.get_run(run_id: 'run-xyz')
      expect(fake_conn).to have_received(:get).with('/api/v2/runs/run-xyz')
    end

    it 'returns the response body' do
      result = runner.get_run(run_id: 'run-xyz')
      expect(result).to eq({ 'data' => {} })
    end
  end

  describe '#create_run' do
    it 'calls POST /api/v2/runs' do
      runner.create_run(workspace_id: 'ws-abc')
      expect(fake_conn).to have_received(:post).with('/api/v2/runs', anything)
    end

    it 'includes workspace relationship in payload' do
      runner.create_run(workspace_id: 'ws-abc')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(
                                                                 data: hash_including(
                                                                   relationships: hash_including(
                                                                     workspace: { data: { type: 'workspaces', id: 'ws-abc' } }
                                                                   )
                                                                 )
                                                               ))
    end

    it 'includes message when provided' do
      runner.create_run(workspace_id: 'ws-abc', message: 'triggered by CI')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(
                                                                 data: hash_including(
                                                                   attributes: hash_including(message: 'triggered by CI')
                                                                 )
                                                               ))
    end

    it 'defaults auto_apply to false' do
      runner.create_run(workspace_id: 'ws-abc')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(
                                                                 data: hash_including(
                                                                   attributes: hash_including(auto_apply: false)
                                                                 )
                                                               ))
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.create_run(workspace_id: 'ws-abc', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end

  describe '#apply_run' do
    it 'calls POST /api/v2/runs/:id/actions/apply' do
      runner.apply_run(run_id: 'run-xyz')
      expect(fake_conn).to have_received(:post).with('/api/v2/runs/run-xyz/actions/apply', anything)
    end

    it 'includes comment when provided' do
      runner.apply_run(run_id: 'run-xyz', comment: 'LGTM')
      expect(fake_conn).to have_received(:post).with(anything, hash_including(comment: 'LGTM'))
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.apply_run(run_id: 'run-xyz', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end

  describe '#discard_run' do
    it 'calls POST /api/v2/runs/:id/actions/discard' do
      runner.discard_run(run_id: 'run-xyz')
      expect(fake_conn).to have_received(:post).with('/api/v2/runs/run-xyz/actions/discard', anything)
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.discard_run(run_id: 'run-xyz', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end

  describe '#cancel_run' do
    it 'calls POST /api/v2/runs/:id/actions/cancel' do
      runner.cancel_run(run_id: 'run-xyz')
      expect(fake_conn).to have_received(:post).with('/api/v2/runs/run-xyz/actions/cancel', anything)
    end

    it 'raises ReadOnlyError when read_only is true' do
      expect { runner.cancel_run(run_id: 'run-xyz', read_only: true) }
        .to raise_error(Legion::Extensions::Tfe::ReadOnlyError)
    end
  end
end
