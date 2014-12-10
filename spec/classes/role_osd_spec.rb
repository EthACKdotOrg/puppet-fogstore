require 'spec_helper'

describe 'fogstore::roles::osd' do
  let(:params) {{
    :add_repo       => 'false',
    :cred_format    => 'pkcs12',
    :credential     => 'osd.pem',
    :properties     => {},
    :ssl_source_dir => '.',
    :trusted_format => 'jks',
    :trusted        => 'osd.jks',
  }}

  describe "should contain xtreemfs::role::storage" do
    should contain_class('xtreemfs::role::storage')
    .with('add_repo'                => 'false')
    .with('dir_service'             => '')
    .with('properties'              => {
      'ssl.enable'                  => true,
      'ssl.service_cred'            => '',
      'ssl.service_cred.container'  => 'pkcs12',
      'ssl.service_cred.pw'         => '',
      'ssl.trusted_certs'           => '',
      'ssl.trusted_certs.container' => 'jks',
      'ssl.trusted_certs.pw'        => '',
    })
  end

  describe "should push credential file" do
    should contain_file('')
  end
end
