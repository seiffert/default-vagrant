require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

unless ENV['RS_PROVISION'] == 'no'
  hosts.each do |host|
    if host['platform'] =~ /debian/
      on host, 'echo \'export PATH=/var/lib/gems/1.8/bin/:${PATH}\' >> ~/.bashrc'
    end
    if host.is_pe?
      install_pe
    else
      # Install Puppet
      install_package host, 'rubygems'
      on host, 'gem install puppet --no-ri --no-rdoc'
      on host, "mkdir -p #{host['distmoduledir']}"
    end
  end
end

UNSUPPORTED_PLATFORMS = ['windows']

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'concat')
    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    end
  end

  c.before(:all) do
    shell('mkdir -p /tmp/concat')
  end
  c.after(:all) do
    shell("rm -rf /tmp/concat #{default.puppet['vardir']}/concat")
  end

  c.treat_symbols_as_metadata_keys_with_true_values = true
end
