require 'spec_helper'

os_facts = @os_facts

describe 'fogstore::roles::osd' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
    end

    context 'Easy working' do
      let(:params) {{
        :add_repo         => 'false',
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
        .with('add_repo'                => 'false')
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
        should contain_class('fogstore::ssl::trusted')
      }

      it {
        should contain_file('/etc/ssl/certs/osd.p12')
        .with('source' => 'file://./osd.p12')
      }
    end

    context 'Add properties' do
      let(:params) {{
        :add_repo         => 'false',
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
        .with('add_repo'                => 'false')
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
