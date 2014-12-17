require 'spec_helper'

roles = @trusted_roles

describe 'fogstore::ssl::trusted' do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end


    roles.each do |role|

      context "#{role} without password on #{os}" do
        let(:title) { role }
        let(:params) {{
          :client_ca        => 'client-ca.pem',
          :dir_ca           => 'dir-ca.pem',
          :mrc_ca           => 'mrc-ca.pem',
          :osd_ca           => 'osd-ca.pem',
          :ssl_source_dir   => 'file://.',
        }}
        case role
        when 'introducer'
        it 'should fail' do
          should raise_error(Puppet::Error, /Need dir_jks_password for introducer role/i)
        end
        else
        it 'should fail' do
          should raise_error(Puppet::Error, /Need #{role}_jks_password for #{role} role/i)
        end
        end
      end

      context "#{role} missing ca on #{os}" do
        let(:title) { role }
        let(:params) {{
          :dir_ca           => 'dir-ca.pem',
          :dir_jks_password => 'dir-jks-password',
          :mrc_ca           => 'mrc-ca.pem',
          :mrc_jks_password => 'mrc-jks-password',
          :osd_ca           => 'osd-ca.pem',
          :osd_jks_password => 'osd-jks-password',
          :ssl_source_dir   => 'file://.',
        }}
        case role
        when 'dir'
          it 'should fail' do
            should raise_error(Puppet::Error, /Need client, mrc and osd CAs for Dir role/i)
          end
        when 'introducer'
          it 'should fail' do
            should raise_error(Puppet::Error, /Need client, mrc and osd CAs for Introducer role/i)
          end
        when 'mrc'
          it 'should fail' do
            should raise_error(Puppet::Error, /Need client and dir CAs for MRC role/i)
          end
        when 'osd'
          it 'should fail' do
            should raise_error(Puppet::Error, /Need client and dir CAs for OSD role/i)
          end
        end
      end

    end

    context "DIR: working on #{os}" do
      let(:title) { 'dir' }
      let(:params) {{
        :client_ca        => 'client-ca.pem',
        :dir_ca           => 'dir-ca.pem',
        :dir_jks_password => 'dir-jks-password',
        :mrc_ca           => 'mrc-ca.pem',
        :osd_ca           => 'osd-ca.pem',
        :ssl_source_dir   => 'file://.',
      }}
      it {
        should compile.with_all_deps
      }
      it {
        should contain_java_ks('dir_client_ca')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./client-ca.pem')
        .with('target'      => '/etc/xos/xtreemfs/truststore/dir.jks')
        .with('password'    => 'dir-jks-password')
      }
      it {
        should contain_java_ks('dir_mrc_ca:/etc/xos/xtreemfs/truststore/dir.jks')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./mrc-ca.pem')
      }
      it {
        should contain_java_ks('dir_osd_ca:/etc/xos/xtreemfs/truststore/dir.jks')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./osd-ca.pem')
      }
    end

    context "Introducer: working on #{os}" do
      let(:title) { 'introducer' }
      let(:params) {{
        :client_ca        => 'client-ca.pem',
        :dir_ca           => 'dir-ca.pem',
        :dir_jks_password => 'dir-jks-password',
        :mrc_ca           => 'mrc-ca.pem',
        :mrc_jks_password => 'mrc-jks-password',
        :osd_ca           => 'osd-ca.pem',
        :ssl_source_dir   => 'file://.',
      }}
      it {
        should compile.with_all_deps
      }
      it {
        should contain_java_ks('dir_client_ca')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./client-ca.pem')
        .with('target'      => '/etc/xos/xtreemfs/truststore/dir.jks')
        .with('password'    => 'dir-jks-password')
      }
      it {
        should contain_java_ks('dir_mrc_ca:/etc/xos/xtreemfs/truststore/dir.jks')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./mrc-ca.pem')
      }
      it {
        should contain_java_ks('dir_osd_ca:/etc/xos/xtreemfs/truststore/dir.jks')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./osd-ca.pem')
      }
      it {
        should contain_java_ks('mrc_client_ca')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./client-ca.pem')
        .with('target'      => '/etc/xos/xtreemfs/truststore/mrc.jks')
        .with('password'    => 'mrc-jks-password')
      }
      it {
        should contain_java_ks('mrc_dir_ca:/etc/xos/xtreemfs/truststore/mrc.jks')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./dir-ca.pem')
        .with('password'    => 'mrc-jks-password')
      }
    end

    context "MRC: working on #{os}" do
      let(:title) { 'mrc' }
      let(:params) {{
        :client_ca        => 'client-ca.pem',
        :dir_ca           => 'dir-ca.pem',
        :mrc_jks_password => 'mrc-jks-password',
        :ssl_source_dir   => 'file://.',
      }}
      it {
        should compile.with_all_deps
      }
      it {
        should contain_java_ks('mrc_client_ca')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./client-ca.pem')
        .with('target'      => '/etc/xos/xtreemfs/truststore/mrc.jks')
        .with('password'    => 'mrc-jks-password')
      }
      it {
        should contain_java_ks('mrc_dir_ca:/etc/xos/xtreemfs/truststore/mrc.jks')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./dir-ca.pem')
        .with('password'    => 'mrc-jks-password')
      }
    end

    context "OSD: working on #{os}" do
      let(:title) { 'osd' }
      let(:params) {{
        :client_ca        => 'client-ca.pem',
        :dir_ca           => 'dir-ca.pem',
        :osd_jks_password => 'osd-jks-password',
        :ssl_source_dir   => 'file://.',
      }}
      it {
        should compile.with_all_deps
      }
      it {
        should contain_java_ks('osd_client_ca')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./client-ca.pem')
        .with('target'      => '/etc/xos/xtreemfs/truststore/osd.jks')
        .with('password'    => 'osd-jks-password')
      }
      it {
        should contain_java_ks('osd_dir_ca:/etc/xos/xtreemfs/truststore/osd.jks')
        .with('ensure'      => 'latest')
        .with('certificate' => 'file://./dir-ca.pem')
        .with('password'    => 'osd-jks-password')
      }
    end
  end
end
