require 'spec_helper'

describe 'fogstore::ssl::trusted' do
  let(:params) {{
    :client_ca           => 'client-ca.pem',
    :client_jks_password => 'fooBar',
    :dir_ca              => 'dir-ca.pem',
    :dir_jks_password    => 'barBaz',
    :mrc_ca              => 'mrc-ca.pem',
    :mrc_jks_password    => 'abcd',
    :osd_ca              => 'osd-ca.pem',
    :osd_jks_password    => 'efgh',
    :ssl_source_dir      => '.',
  }}

  describe "should create java_ks dir_client_ca" do
    it { 
      should contain_java_ks('dir_client_ca')
      .with('ensure'      => 'latest')
      .with('certificate' => './client-ca.pem')
      .with('target'      => '/etc/xos/xtreemfs/truststore/dir.jks')
      .with('password'    => 'barBaz')
    }
    it { 
      should contain_java_ks('dir_mrc_ca:/etc/xos/xtreemfs/truststore/dir.jks')
      .with('ensure'      => 'latest')
      .with('certificate' => './mrc-ca.pem')
      .with('password'    => 'barBaz')
    }
    it { 
      should contain_java_ks('dir_osd_ca:/etc/xos/xtreemfs/truststore/dir.jks')
      .with('ensure' => 'latest')
      .with('certificate' => './osd-ca.pem')
      .with('target' => '/etc/xos/xtreemfs/truststore/dir.jks')
      .with('password' => 'barBaz')
    }
  end
end
