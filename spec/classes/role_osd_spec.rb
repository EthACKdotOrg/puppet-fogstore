require 'spec_helper'

describe 'fogstore::roles::osd' do
  let(:params) {{
    :add_repo         => 'false',
    :cred_format      => 'pkcs12',
    :cred_password    => 'barBaz',
    :credential       => 'osd.p12',
    :properties       => {},
    :ssl_source_dir   => '.',
    :trusted          => 'osd.jks',
    :trusted_format   => 'jks',
    :trusted_password => 'fooBar',
  }}

  let(:facts) {{
    'lsbdistid'              => 'Debian',
    'lsbdistcodename'        => 'jessie',
    'operatingsystem'        => 'Debian',
    'operatingsystemrelease' => '8.0',
    'osfamily'               => 'Debian',
  }}


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
      should contain_file('/etc/xos/xtreemfs/truststore/osd.jks')
      .with('source' => './osd.p12')
    }
  end
end
