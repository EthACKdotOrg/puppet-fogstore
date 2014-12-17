require 'spec_helper'

describe 'fogstore::roles::mrc' do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "Easy working on #{os}" do
      let(:params) {{
        :add_repo         => false,
        :client_ca        => 'client-ca.pem',
        :cred_password    => 'credential-password',
        :credential       => 'mrc.p12',
        :dir_ca           => 'dir-ca.pem',
        :ssl_source_dir   => 'file://.',
        :trusted          => 'mrc.jks',
        :trusted_password => 'mrc-jks-password',
      }}
      it {
        should compile.with_all_deps
      }
      it {
        should contain_class('xtreemfs::role::metadata')
      }
      it {
        should contain_fogstore__ssl__trusted('mrc')
      }
      it {
        should contain_file('/etc/ssl/certs/mrc.p12')
        .with_source('file://./mrc.p12')
      }
    end
  end
end
