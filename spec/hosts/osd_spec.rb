require 'spec_helper'

describe 'osd' do
  on_supported_os.each do |osfamily, facts|
    let :facts do
      facts
    end

    it { should compile }

    it {
      should contain_class('xtreemfs::internal::workflow')
    }

    it { 
      should contain_apt__conf('ignore-suggests')
      .with('content' => 'APT::Install-Suggests "0";')
    }
    it {
      should contain_apt__pin('nox')
      .with('packages' => 'xserver-xorg-core')
      .with('origin'   => 'Debian')
      .with('priority' => '-1')
    }
    it {
      should contain_apt__source('xtreemfs')
      .with('ensure'      => 'present')
      .with('include_src' => 'false')
      .with('key'         => '07D6EA4F2FA7E736')
      .with('key_source'  => 'http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.10//Release.key')
      .with('location'    => 'http://download.opensuse.org/repositories/home:/xtreemfs/xUbuntu_14.10/')
      .with('release'     => '')
      .with('repos'       => './')
    }
  
    it {
      should contain_file('/etc/xos/xtreemfs/truststore')
      .with('ensure' => 'directory')
      .with('group'  => 'xtreemfs')
      .with('mode'   => '0750')
      .with('owner'  => 'root')
    }
    it {
      should contain_fogstore__ssl__trusted('osd')
        .with('client_ca'        => 'client-ca.pem')
        .with('dir_ca'           => 'dir-ca.pem')
        .with('mrc_ca'           => false)
        .with('osd_ca'           => false)
        .with('osd_jks_password' => 'osd-jks')
        .with('ssl_source_dir'   => 'file://.')
    }
    it {
      should contain_java_ks('osd_client_ca')
      .with('certificate' => 'file://./client-ca.pem')
      .with('target'      => '/etc/xos/xtreemfs/truststore/osd.jks')
      .with('password'    => 'osd-jks')
    }
    it {
      should contain_java_ks('osd_dir_ca:/etc/xos/xtreemfs/truststore/osd.jks')
      .with('certificate' => 'file://./dir-ca.pem')
      .with('password'    => 'osd-jks')
    }

    it {
      should contain_fogstore__ssl__credential('osd')
    }

    it {
      should contain_file('/etc/ssl/certs/xtreemfs-credentials-osd.pem')
      .with('source' => [
        "file://./credential.pem",
        "file://./client-ca.pem",
        "file://./dir-ca.pem",
      ])
    } 
    it {
      should contain_openssl__export__pkcs12('xtreemfs-credentials-osd')
      .with('basedir'  => '/etc/ssl/certs')
      .with('cert'     => '/etc/ssl/certs/xtreemfs-credentials-osd.pem')
      .with('pkey'     => 'file://./credential.key')
      .with('out_pass' => 'credential-password')
    }

    it {
      should contain_class('fogstore::roles::osd')
    }

    it {
      should contain_package('xtreemfs-server')
    }
    it {
      should contain_class('xtreemfs::internal::configure::storage')
    }
    it {
      should contain_class('fogstore::roles::osd')
        .with('add_repo'         => false)
        .with('cred_format'      => 'pkcs12')
        .with('cred_password'    => 'credential-password')
        .with('credential'       => 'credential.pem')
        .with('ssl_source_dir'   => 'file://.')
        .with('trust_store'      => 'osd.jks')
        .with('trusted_format'   => 'jks')
        .with('trusted_password' => 'osd-jks')
    }
  end
end
