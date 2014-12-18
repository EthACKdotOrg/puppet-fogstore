require 'spec_helper'

good_password = 'ua4Sua6IGhi0'

describe 'fogstore::roles::dir' do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "missing admin_password on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::dir':
          add_repo         => false,
          client_ca        => 'client-ca.pem',
          cred_password    => 'credential-password',
          credential       => 'dir.p12',
          mrc_ca           => 'mrc-ca.pem',
          osd_ca           => 'osd-ca.pem',
          properties       => {},
          ssl_source_dir   => 'file://.',
          trusted          => 'dir.jks',
          trusted_password => 'dir-jks-password',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /validate_slength/)
      end
    end

    context "short admin_password on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::dir':
          add_repo        => false,
          admin_password  => 'foobarbaz',
          client_ca        => 'client-ca.pem',
          cred_password    => 'credential-password',
          credential       => 'dir.p12',
          mrc_ca           => 'mrc-ca.pem',
          osd_ca           => 'osd-ca.pem',
          properties       => {},
          ssl_source_dir   => 'file://.',
          trusted          => 'dir.jks',
          trusted_password => 'dir-jks-password',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /validate_slength/)
      end
    end

    context "long admin_password on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::dir':
          add_repo        => false,
          admin_password  => 'taeBafee8oov7eish6yiihakaexeu1eechuch6eighuam4Ib2ohxei0haifuTob2u',
          client_ca        => 'client-ca.pem',
          cred_password    => 'credential-password',
          credential       => 'dir.p12',
          mrc_ca           => 'mrc-ca.pem',
          osd_ca           => 'osd-ca.pem',
          properties       => {},
          ssl_source_dir   => 'file://.',
          trusted          => 'dir.jks',
          trusted_password => 'dir-jks-password',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /validate_slength/)
      end
    end

    context "add_repo not a bool on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::dir':
          add_repo        => 'blah',
          admin_password  => '#{good_password}',
          client_ca        => 'client-ca.pem',
          cred_password    => 'credential-password',
          credential       => 'dir.p12',
          mrc_ca           => 'mrc-ca.pem',
          osd_ca           => 'osd-ca.pem',
          properties       => {},
          ssl_source_dir   => 'file://.',
          trusted          => 'dir.jks',
          trusted_password => 'dir-jks-password',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /"blah" is not a boolean.  It looks to be a String/i)
      end
    end

    context "Simple install on #{os}" do
      let(:pre_condition) do
        "class {'::fogstore::roles::dir':
          add_repo         => false,
          admin_password   => '#{good_password}',
          client_ca        => 'client-ca.pem',
          cred_password    => 'credential-password',
          credential       => 'dir.p12',
          mrc_ca           => 'mrc-ca.pem',
          osd_ca           => 'osd-ca.pem',
          properties       => {},
          ssl_source_dir   => 'file://.',
          trusted          => 'dir.jks',
          trusted_password => 'dir-jks-password',
        }"
      end

      it {
        should compile.with_all_deps
      }

      it {
        should contain_fogstore__ssl__trusted('dir')
      }

      it {
        should contain_file('/etc/ssl/certs/dir.p12')
        .with('source' => 'file://./dir.p12')
      }

      it {
        should contain_class('xtreemfs::role::directory')
      }

      it {
        should contain_package('xtreemfs-server')
      }
      it {
        should contain_class('fogstore::user')
      }
      it {
        should contain_user('xtreemfs')
      }
    end

    context "Add properties on #{os}" do
      let(:pre_condition) do
        "class {'::fogstore::roles::dir':
          add_repo         => false,
          admin_password   => '#{good_password}',
          client_ca        => 'client-ca.pem',
          cred_password    => 'credential-password',
          credential       => 'dir.p12',
          mrc_ca           => 'mrc-ca.pem',
          osd_ca           => 'osd-ca.pem',
          properties       => {
            discover       => true,
            'listen.address' => '127.0.0.1',
          },
          ssl_source_dir   => 'file://.',
          trusted          => 'dir.jks',
          trusted_password => 'dir-jks-password',
        }"
      end

      it {
        should compile.with_all_deps
      }
      it {
        should contain_class('xtreemfs::role::directory')
        .with_properties({
          'admin_password'              => good_password,
          'ssl.enabled'                 => true,
          'ssl.service_creds'           => '/etc/ssl/certs/dir.p12',
          'ssl.service_creds.container' => 'pkcs12',
          'ssl.service_creds.pw'        => 'credential-password',
          'ssl.trusted_certs'           => '/etc/xos/xtreemfs/truststore/dir.jks',
          'ssl.trusted_certs.container' => 'jks',
          'ssl.trusted_certs.pw'        => 'dir-jks-password',
          'discover'                    => true,
          'listen.address'              => '127.0.0.1',
        })
      }
    end
  end
end
