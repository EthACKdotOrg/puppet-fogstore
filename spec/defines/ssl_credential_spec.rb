require 'spec_helper'

os_facts = @os_facts

describe 'fogstore::ssl::credential' do
  os_facts.each do |osfamily, facts|

    let :facts do
      facts
    end

    let(:path) { '/bin:/sbin:/usr/bin:/usr/sbin' }

    describe 'Role: Client' do
      let(:title) { 'client' }
      let(:params) {{
        :client_ca       => 'client-ca.pem',
        :cred_cert       => 'client-credential.pem',
        :cred_key        => 'client-credential.key',
        :cred_password   => 'client-credential',
        :destination_dir => '/etc/ssl/certs',
        :dir_ca          => 'dir-ca.pem',
        :mrc_ca          => 'mrc-ca.pem',
        :osd_ca          => 'osd-ca.pem',
        :role            => 'client',
        :ssl_source_dir  => 'file://.',
      }}
      it {
        should contain_file('/etc/ssl/certs/xtreemfs-credentials-client.pem')
        .with('source' => [
          "file://./client-credential.pem",
          "file://./dir-ca.pem",
          "file://./mrc-ca.pem",
          "file://./osd-ca.pem",
        ])
      } 
      it {
        should contain_openssl__export__pkcs12('xtreemfs-credentials-client')
        .with('basedir'  => '/etc/ssl/certs')
        .with('cert'     => '/etc/ssl/certs/xtreemfs-credentials-client.pem')
        .with('pkey'     => 'file://./client-credential.key')
        .with('out_pass' => 'client-credential')
      }
    end

    describe 'Role: Dir' do
      let(:title) { 'dir' }
      let(:params) {{
        :client_ca       => 'client-ca.pem',
        :cred_cert       => 'dir-credential.pem',
        :cred_key        => 'dir-credential.key',
        :cred_password   => 'dir-credential',
        :destination_dir => '/etc/ssl/certs',
        :dir_ca          => 'dir-ca.pem',
        :mrc_ca          => 'mrc-ca.pem',
        :osd_ca          => 'osd-ca.pem',
        :role            => 'dir',
        :ssl_source_dir  => 'file://.',
      }}
      it {
        should contain_file('/etc/ssl/certs/xtreemfs-credentials-dir.pem')
        .with('source' => [
          "file://./dir-credential.pem",
          "file://./client-ca.pem",
          "file://./mrc-ca.pem",
          "file://./osd-ca.pem",
        ])
      } 
      it {
        should contain_openssl__export__pkcs12('xtreemfs-credentials-dir')
        .with('basedir'  => '/etc/ssl/certs')
        .with('cert'     => '/etc/ssl/certs/xtreemfs-credentials-dir.pem')
        .with('pkey'     => 'file://./dir-credential.key')
        .with('out_pass' => 'dir-credential')
      }
    end

    describe 'Role: MRC' do
      let(:title) { 'mrc' }
      let(:params) {{
        :client_ca       => 'client-ca.pem',
        :cred_cert       => 'mrc-credential.pem',
        :cred_key        => 'mrc-credential.key',
        :cred_password   => 'mrc-credential',
        :destination_dir => '/etc/ssl/certs',
        :dir_ca          => 'dir-ca.pem',
        :mrc_ca          => 'mrc-ca.pem',
        :osd_ca          => 'osd-ca.pem',
        :role            => 'mrc',
        :ssl_source_dir  => 'file://.',
      }}
      it {
        should contain_file('/etc/ssl/certs/xtreemfs-credentials-mrc.pem')
        .with('source' => [
          "file://./mrc-credential.pem",
          "file://./client-ca.pem",
          "file://./dir-ca.pem",
          "file://./osd-ca.pem",
        ])
      } 
      it {
        should contain_openssl__export__pkcs12('xtreemfs-credentials-mrc')
        .with('basedir'  => '/etc/ssl/certs')
        .with('cert'     => '/etc/ssl/certs/xtreemfs-credentials-mrc.pem')
        .with('pkey'     => 'file://./mrc-credential.key')
        .with('out_pass' => 'mrc-credential')
      }
    end

    describe 'Role: OSD' do
      let(:title) { 'osd' }
      let(:params) {{
        :client_ca       => 'client-ca.pem',
        :cred_cert       => 'osd-credential.pem',
        :cred_key        => 'osd-credential.key',
        :cred_password   => 'osd-credential',
        :destination_dir => '/etc/ssl/certs',
        :dir_ca          => 'dir-ca.pem',
        :mrc_ca          => 'mrc-ca.pem',
        :osd_ca          => 'osd-ca.pem',
        :role            => 'osd',
        :ssl_source_dir  => 'file://.',
      }}
      it {
        should contain_file('/etc/ssl/certs/xtreemfs-credentials-osd.pem')
        .with('source' => [
          "file://./osd-credential.pem",
          "file://./client-ca.pem",
          "file://./dir-ca.pem",
          "file://./mrc-ca.pem",
        ])
      } 
      it {
        should contain_openssl__export__pkcs12('xtreemfs-credentials-osd')
        .with('basedir'  => '/etc/ssl/certs')
        .with('cert'     => '/etc/ssl/certs/xtreemfs-credentials-osd.pem')
        .with('pkey'     => 'file://./osd-credential.key')
        .with('out_pass' => 'osd-credential')
      }
    end

  end
end
