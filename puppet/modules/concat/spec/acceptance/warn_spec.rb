require 'spec_helper_acceptance'

describe 'concat warn =>', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  basedir = default.tmpdir('concat')
  context 'true should enable default warning message' do
    pp = <<-EOS
      include concat::setup
      concat { '#{basedir}/file':
        warn  => true,
      }

      concat::fragment { '1':
        target  => '#{basedir}/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '#{basedir}/file',
        content => '2',
        order   => '02',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp, :catch_changes => true).stderr).to eq("")
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      it { should contain '# This file is managed by Puppet. DO NOT EDIT.' }
      it { should contain '1' }
      it { should contain '2' }
    end
  end
  context 'false should not enable default warning message' do
    pp = <<-EOS
      include concat::setup
      concat { '#{basedir}/file':
        warn  => false,
      }

      concat::fragment { '1':
        target  => '#{basedir}/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '#{basedir}/file',
        content => '2',
        order   => '02',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp, :catch_changes => true).stderr).to eq("")
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      it { should_not contain '# This file is managed by Puppet. DO NOT EDIT.' }
      it { should contain '1' }
      it { should contain '2' }
    end
  end
  context '# foo should overide default warning message' do
    pp = <<-EOS
      include concat::setup
      concat { '#{basedir}/file':
        warn  => '# foo',
      }

      concat::fragment { '1':
        target  => '#{basedir}/file',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => '#{basedir}/file',
        content => '2',
        order   => '02',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp, :catch_changes => true).stderr).to eq("")
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      it { should contain '# foo' }
      it { should contain '1' }
      it { should contain '2' }
    end
  end
end
