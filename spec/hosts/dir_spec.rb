require 'spec_helper'

os_facts = @os_facts


describe 'dir' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
    end

    describe 'Global' do
      it { should compile }
    end

    describe 'Dependencies' do
      it {
        should contain_class('xtreemfs::internal::workflow')
      }
    end

    describe 'Configure APT' do
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
    end
    
    describe 'Trust store' do
      it {
        should contain_file('/etc/xos/xtreemfs/truststore')
        .with('ensure' => 'directory')
        .with('group'  => 'xtreemfs')
        .with('mode'   => '0750')
        .with('owner'  => 'root')
      }
      it {
        should contain_class('fogstore::ssl::trusted')
          .with('client_ca'           => 'client-ca.pem')
          .with('dir_ca'              => false)
          .with('dir_jks_password'    => 'dir-jks')
          .with('mrc_ca'              => 'mrc-ca.pem')
          .with('osd_ca'              => 'osd-ca.pem')
          .with('ssl_source_dir'      => 'file://.')
      }
      it {
        should contain_java_ks('dir_client_ca')
        .with('certificate' => 'file://./client-ca.pem')
        .with('target'      => '/etc/xos/xtreemfs/truststore/dir.jks')
        .with('password'    => 'dir-jks')
      }
      it {
        should contain_java_ks('dir_mrc_ca:/etc/xos/xtreemfs/truststore/dir.jks')
        .with('certificate' => 'file://./mrc-ca.pem')
        .with('password'    => 'dir-jks')
      }
      it {
        should contain_java_ks('dir_osd_ca:/etc/xos/xtreemfs/truststore/dir.jks')
        .with('certificate' => 'file://./osd-ca.pem')
        .with('password'    => 'dir-jks')
      }
    end

    describe 'Credentials' do
      it {
        should contain_fogstore__ssl__credential('dir')
      }

      it {
        should contain_file('/etc/ssl/certs/xtreemfs-credentials-dir.pem')
        .with('source' => [
          "file://./credential.pem",
          "file://./client-ca.pem",
          "file://./mrc-ca.pem",
          "file://./osd-ca.pem",
        ])
      } 
      it {
        should contain_openssl__export__pkcs12('xtreemfs-credentials-dir')
        .with('basedir'  => '/etc/ssl/certs')
        .with('cert'     => '/etc/ssl/certs/xtreemfs-credentials-dir.pem')
        .with('pkey'     => 'file://./credential.key')
        .with('out_pass' => 'credential-password')
      }
    end

    describe 'Include fogstore::roles::dir' do
      it {
        should contain_class('fogstore::roles::dir')
      }
    end

    describe 'Install XtreemFS and configure' do
      it {
        should contain_package('xtreemfs-server')
      }
      it {
        should contain_class('xtreemfs::internal::configure::directory')
      }
      it {
        should contain_class('fogstore::roles::dir')
          .with('add_repo'         => false)
          .with('cred_format'      => 'pkcs12')
          .with('cred_password'    => 'credential-password')
          .with('credential'       => 'credential.pem')
          .with('ssl_source_dir'   => 'file://.')
          .with('trusted'          => 'dir.jks')
          .with('trusted_format'   => 'jks')
          .with('trusted_password' => 'dir-jks')
      }
    end
  end
end
