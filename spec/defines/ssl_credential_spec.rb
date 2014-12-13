require 'spec_helper'

os_facts = @os_facts
roles = @roles

client_cas = [
  "file://./client-credential.pem",
  "file://./dir-ca.pem",
  "file://./mrc-ca.pem",
  "file://./osd-ca.pem",
]
dir_cas = [
  "file://./dir-credential.pem",
  "file://./client-ca.pem",
  "file://./mrc-ca.pem",
  "file://./osd-ca.pem",
]
mrc_cas = [
  "file://./mrc-credential.pem",
  "file://./client-ca.pem",
  "file://./dir-ca.pem",
  "file://./osd-ca.pem",
]
osd_cas = [
  "file://./osd-credential.pem",
  "file://./client-ca.pem",
  "file://./dir-ca.pem",
  "file://./mrc-ca.pem",
]

describe 'fogstore::ssl::credential' do
  os_facts.each do |osfamily, facts|

    let :facts do
      facts
    end
    let(:path) { '/bin:/sbin:/usr/bin:/usr/sbin' }

    describe 'Unknown role' do
      let(:title) { 'failure' }
      let(:params) {{
        :client_ca       => 'client-ca.pem',
        :cred_cert       => "failure-credential.pem",
        :cred_key        => "failure-credential.key",
        :cred_password   => "failure-credential",
        :destination_dir => '/etc/ssl/certs',
        :dir_ca          => 'dir-ca.pem',
        :mrc_ca          => 'mrc-ca.pem',
        :osd_ca          => 'osd-ca.pem',
        :ssl_source_dir  => 'file://.',
      }}
      it {
        expect {
          should compile.with_all_deps
        }.to raise_error()
      }
    end

    roles.each do |role|

      context "Role: #{role} (failures)" do
        let(:title) { role }
        let(:params) {{
          :client_ca => false,
        }}
        it {
          expect {
            should compile.with_all_deps
          }.to raise_error()
        }
        case role
        when 'dir'
          let(:params) {{
            :client_ca => 'client-ca.pem',
          }}
          it {
            expect {
              should compile.with_all_deps
            }.to raise_error()
          }
          let(:params) {{
            :client_ca => 'client-ca.pem',
            :mrc_ca    => 'mrc-ca.pem',
          }}
          it {
            expect {
              should compile.with_all_deps
            }.to raise_error()
          }
          let(:params) {{
            :client_ca => 'client-ca.pem',
            :mrc_ca    => 'mrc-ca.pem',
            :osd_ca    => 'osd-ca.pem',
          }}
          it {
            expect {
              should compile.with_all_deps
            }.to raise_error()
          }
        when 'mrc'
          let(:params) {{
            :client_ca => 'client-ca.pem',
          }}
          it {
            expect {
              should compile.with_all_deps
            }.to raise_error()
          }
          let(:params) {{
            :client_ca => 'client-ca.pem',
            :dir_ca    => 'dir-ca.pem',
          }}
          it {
            expect {
              should compile.with_all_deps
            }.to raise_error()
          }
        when 'osd'
          let(:params) {{
            :client_ca => 'client-ca.pem',
          }}
          it {
            expect {
              should compile.with_all_deps
            }.to raise_error()
          }
          let(:params) {{
            :client_ca => 'client-ca.pem',
            :dir_ca    => 'dir-ca.pem',
          }}
          it {
            expect {
              should compile.with_all_deps
            }.to raise_error()
          }
          let(:params) {{
            :client_ca => 'client-ca.pem',
            :dir_ca    => 'dir-ca.pem',
            :mrc_ca    => 'mrc-ca.pem',
          }}
          it {
            expect {
              should compile.with_all_deps
            }.to raise_error()
          }
        end
      end

      context "Role: #{role} (working)" do
        let(:title) { role }
        let(:params) {{
          :client_ca       => 'client-ca.pem',
          :cred_cert       => "#{role}-credential.pem",
          :cred_key        => "#{role}-credential.key",
          :cred_password   => "#{role}-credential",
          :destination_dir => '/etc/ssl/certs',
          :dir_ca          => 'dir-ca.pem',
          :mrc_ca          => 'mrc-ca.pem',
          :osd_ca          => 'osd-ca.pem',
          :ssl_source_dir  => 'file://.',
        }}
        case role
        when 'client'
          it {
            should contain_file('/etc/ssl/certs/xtreemfs-credentials-client.pem')
            .with('source' => client_cas)
          }
        when 'dir'
          it {
            should contain_file('/etc/ssl/certs/xtreemfs-credentials-dir.pem')
            .with('source' => dir_cas)
          }
        when 'mrc'
          it {
            should contain_file('/etc/ssl/certs/xtreemfs-credentials-mrc.pem')
            .with('source' => mrc_cas)
          }
        when 'osd'
          it {
            should contain_file('/etc/ssl/certs/xtreemfs-credentials-osd.pem')
            .with('source' => osd_cas)
          }
        end

        it {
          should contain_openssl__export__pkcs12("xtreemfs-credentials-#{role}")
          .with('basedir'  => '/etc/ssl/certs')
          .with('cert'     => "/etc/ssl/certs/xtreemfs-credentials-#{role}.pem")
          .with('pkey'     => "file://./#{role}-credential.key")
          .with('out_pass' => "#{role}-credential")
        }
      end
    end

  end
end
