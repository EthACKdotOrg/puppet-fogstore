require 'spec_helper'

describe 'fogstore::roles::osd' do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "add_repo not a bool on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::osd':
          add_repo        => 'blah',
          client_ca        => 'client-ca.pem',
          cred_password    => 'barBaz',
          credential       => 'osd.p12',
          dir_ca           => 'dir-ca.pem',
          object_dir       => '/mnt/xtreemfs',
          properties       => {},
          ssl_source_dir   => 'file://.',
          trusted          => 'osd.jks',
          trusted_format   => 'jks',
          trusted_password => 'fooBar',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /"blah" is not a boolean.  It looks to be a String/i)
      end
    end

    context "Easy working on #{os}" do
      let(:params) {{
        :add_repo         => false,
        :client_ca        => 'client-ca.pem',
        :cred_password    => 'barBaz',
        :credential       => 'osd.p12',
        :dir_ca           => 'dir-ca.pem',
        :object_dir       => '/mnt/xtreemfs',
        :properties       => {},
        :ssl_source_dir   => 'file://.',
        :trusted          => 'osd.jks',
        :trusted_format   => 'jks',
        :trusted_password => 'fooBar',
      }}

      it {
        should compile.with_all_deps
      }

      it {
        should contain_class('xtreemfs::role::storage')
        .with('add_repo'                => false)
        .with('properties'              => {
          "ssl.enabled"                 => true,
          'ssl.service_creds'           => '/etc/ssl/certs/osd.p12',
          'ssl.service_creds.container' => 'pkcs12',
          'ssl.service_creds.pw'        => 'barBaz',
          'ssl.trusted_certs'           => '/etc/xos/xtreemfs/truststore/osd.jks',
          'ssl.trusted_certs.container' => 'jks',
          'ssl.trusted_certs.pw'        => 'fooBar'
        })
      }

      it {
        should contain_class('fogstore::user')
      }

      it {
        should contain_user('xtreemfs')
      }

      it {
        should contain_fogstore__ssl__trusted('osd')
      }

      it {
        should contain_file('/etc/ssl/certs/osd.p12')
        .with('source' => 'file://./osd.p12')
      }
    end

    context "Add properties on #{os}" do
      let(:params) {{
        :add_repo         => false,
        :client_ca        => 'client-ca.pem',
        :cred_password    => 'barBaz',
        :credential       => 'osd.p12',
        :dir_ca           => 'dir-ca.pem',
        :object_dir       => '/mnt/xtreemfs',
        :properties       => {
          'checksums.enabled'   => true,
          'checksums.algorithm' => 'Adler32',
        },
        :ssl_source_dir   => 'file://.',
        :trusted          => 'osd.jks',
        :trusted_format   => 'jks',
        :trusted_password => 'fooBar',
      }}
      it {
        should compile.with_all_deps
      }

      it {
        should contain_class('xtreemfs::role::storage')
        .with('add_repo'                => false)
        .with('properties'              => {
          "ssl.enabled"                 => true,
          'ssl.service_creds'           => '/etc/ssl/certs/osd.p12',
          'ssl.service_creds.container' => 'pkcs12',
          'ssl.service_creds.pw'        => 'barBaz',
          'ssl.trusted_certs'           => '/etc/xos/xtreemfs/truststore/osd.jks',
          'ssl.trusted_certs.container' => 'jks',
          'ssl.trusted_certs.pw'        => 'fooBar',
          'checksums.enabled'           => true,
          'checksums.algorithm'         => 'Adler32',
        })
      }
    end
  end
end
