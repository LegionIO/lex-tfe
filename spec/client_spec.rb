# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::Tfe::Client do
  describe '#initialize' do
    it 'stores default url' do
      client = described_class.new
      expect(client.opts[:url]).to eq('https://app.terraform.io')
    end

    it 'stores provided url' do
      client = described_class.new(url: 'https://terraform.uhg.com')
      expect(client.opts[:url]).to eq('https://terraform.uhg.com')
    end

    it 'stores token' do
      client = described_class.new(token: 'tok-abc')
      expect(client.opts[:token]).to eq('tok-abc')
    end

    it 'defaults read_only to false' do
      client = described_class.new
      expect(client.opts[:read_only]).to be(false)
    end

    it 'stores read_only: true when provided' do
      client = described_class.new(read_only: true)
      expect(client.opts[:read_only]).to be(true)
    end

    it 'stores extra keyword arguments' do
      client = described_class.new(custom_key: 'value')
      expect(client.opts[:custom_key]).to eq('value')
    end
  end

  describe '#connection' do
    it 'builds a Faraday connection' do
      client = described_class.new(url: 'https://app.terraform.io')
      conn = client.connection
      expect(conn).to be_a(Faraday::Connection)
    end

    it 'does not raise with nil token' do
      client = described_class.new
      expect { client.connection }.not_to raise_error
    end

    it 'merges per-call url override' do
      client = described_class.new(url: 'https://app.terraform.io')
      conn = client.connection(url: 'https://tfe-arc.uhg.com')
      expect(conn.url_prefix.to_s).to include('tfe-arc.uhg.com')
    end
  end

  describe 'runner method availability' do
    let(:client) { described_class.new }

    it 'responds to workspace methods' do
      expect(client).to respond_to(:list, :get, :create, :update, :delete, :lock, :unlock)
    end

    it 'responds to run methods' do
      expect(client).to respond_to(:list_runs, :get_run, :create_run, :apply_run, :discard_run, :cancel_run)
    end

    it 'responds to plan methods' do
      expect(client).to respond_to(:get_plan, :get_plan_json_output, :get_plan_log)
    end

    it 'responds to apply methods' do
      expect(client).to respond_to(:get_apply, :get_apply_log)
    end

    it 'responds to variable methods' do
      expect(client).to respond_to(:list_variables, :create_variable, :update_variable, :delete_variable)
    end

    it 'responds to variable set methods' do
      expect(client).to respond_to(:list_variable_sets, :get_variable_set, :create_variable_set,
                                   :update_variable_set, :delete_variable_set,
                                   :list_varset_variables, :add_varset_variable)
    end

    it 'responds to project methods' do
      expect(client).to respond_to(:list_projects, :get_project, :create_project, :update_project, :delete_project)
    end

    it 'responds to organization methods' do
      expect(client).to respond_to(:list_organizations, :get_organization)
    end

    it 'responds to state version methods' do
      expect(client).to respond_to(:list_state_versions, :get_state_version, :get_current_state_version)
    end

    it 'responds to policy set methods' do
      expect(client).to respond_to(:list_policy_sets, :get_policy_set, :list_workspace_policy_sets)
    end
  end
end
