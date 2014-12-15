require 'spec_helper'

os_facts = @os_facts
roles = @trusted_roles

os_facts.each do |osfamily, facts|
  describe 'fogstore::ssl::trusted' do

    roles.each do |role|

      let :facts do
        facts
      end

      context "#{role} without password" do
        let(:title) { role }
        let(:params) {{
          :client_ca        => 'client-ca.pem',
          :dir_ca           => 'dir-ca.pem',
          :mrc_ca           => 'mrc-ca.pem',
          :osd_ca           => 'osd-ca.pem',
          :ssl_source_dir   => 'file://.',
        }}
        it {
          should_not compile.with_all_deps
        }
      end

      context "#{role} missing ca" do
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
        it {
          should_not compile.with_all_deps
        }
      end

    end

    context "DIR: working" do
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

    context 'Introducer: working' do
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

    context "MRC: working" do
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

    context "OSD: working" do
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
