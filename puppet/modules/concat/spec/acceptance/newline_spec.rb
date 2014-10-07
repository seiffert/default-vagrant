require 'spec_helper_acceptance'

describe 'concat ensure_newline parameter', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  basedir = default.tmpdir('concat')
  context '=> false' do
    pp = <<-EOS
      include concat::setup
      concat { '#{basedir}/file':
        ensure_newline => false,
      }
      concat::fragment { '1':
        target  => '#{basedir}/file',
        content => '1',
      }
      concat::fragment { '2':
        target  => '#{basedir}/file',
        content => '2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      expect(apply_manifest(pp, :catch_failures => true).stderr).to eq("")
      expect(apply_manifest(pp, :catch_changes => true).stderr).to eq("")
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      it { should contain '12' }
    end
  end

  #context '=> true' do
  #  pp = <<-EOS
  #    include concat::setup
  #    concat { '#{basedir}/file':
  #      ensure_newline => true,
  #    }
  #    concat::fragment { '1':
  #      target  => '#{basedir}/file',
  #      content => '1',
  #    }
  #    concat::fragment { '2':
  #      target  => '#{basedir}/file',
  #      content => '2',
  #    }
  #  EOS

  #  it 'applies the manifest twice with no stderr' do
  #    expect(apply_manifest(pp, :catch_failures => true).stderr).to eq("")
  #    expect(apply_manifest(pp, :catch_changes  => true).stderr).to eq("")
  #    #XXX ensure_newline => true causes changes on every run because the files
  #    #are modified in place.
  #  end

  #  describe file("#{basedir}/file") do
  #    it { should be_file }
  #    it { should contain "1\n2\n" }
  #  end
  #end
end
