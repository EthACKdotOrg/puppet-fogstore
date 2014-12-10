require 'spec_helper'

os_facts = @os_facts

os_facts.each do |osfamily, facts|
  describe 'fogstore::roles::osd' do
    let(:params) {{
      :add_repo         => 'false',
      :cred_format      => 'pkcs12',
      :cred_password    => 'barBaz',
      :credential       => 'osd.p12',
      :properties       => {},
      :manage_jks       => false,
      :ssl_source_dir   => '.',
      :trusted          => 'osd.jks',
      :trusted_format   => 'jks',
      :trusted_password => 'fooBar',
    }}
    let :facts do
      facts
    end


    describe "should contain xtreemfs::role::storage" do
      it {
        should contain_class('xtreemfs::role::storage')
        .with('add_repo'                => 'false')
        .with('dir_host'                => 'localhost')
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
    end

    describe "should push credential file" do
      it {
        should contain_file('/etc/ssl/certs/osd.p12')
        .with('source' => './osd.p12')
      }
    end
  end
end
