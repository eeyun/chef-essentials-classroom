#
# Cookbook Name:: guacamole
# Spec:: default
#
# Copyright (c) 2015 Matt Stratton, All Rights Reserved.

require 'spec_helper'

describe 'guacamole::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
