require 'spec_helper'

describe 'guacamole::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  describe service('guacd') do
    it { should be_enabled }
    it { should be_running }
  end
end
