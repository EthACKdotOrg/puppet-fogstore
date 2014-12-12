require 'spec_helper'

os_facts = @os_facts


describe 'client' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
    end

    describe 'Global' do
      it { should compile }
    end

    describe 'Dependencies' do
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

    describe 'Credentials' do
      it {
        should contain_fogstore__ssl__credential('client')
      }

      it {
        should contain_file('/etc/ssl/certs/xtreemfs-credentials-client.pem')
        .with('source' => [
          "file://./credential.pem",
          "file://./dir-ca.pem",
          "file://./mrc-ca.pem",
          "file://./osd-ca.pem",
        ])
      } 
      it {
        should contain_openssl__export__pkcs12('xtreemfs-credentials-client')
        .with('basedir'  => '/etc/ssl/certs')
        .with('cert'     => '/etc/ssl/certs/xtreemfs-credentials-client.pem')
        .with('pkey'     => 'file://./credential.key')
        .with('out_pass' => 'credential-password')
      }
    end

    describe 'Volumes' do
      it {
        should contain_xtreemfs__volume('test1')
        .with('ensure'        => 'present')
        .with('dir_host'      => nil)
        .with('dir_port'      => nil)
        .with('dir_protocol'  => nil)
        .with('options'       => {
          'admin_password'    => 'fooBar',
          'pkcs12-file-path'  => '/etc/ssl/certs/client.p12',
          'pkcs12-passphrase' => 'credential-password',
        })
      }
      it {
        should contain_xtreemfs__volume('test2')
        .with('ensure'        => 'absent')
        .with('dir_host'      => nil)
        .with('dir_port'      => nil)
        .with('dir_protocol'  => nil)
        .with('options'       => {
          'admin_password'    => 'fooBar',
          'pkcs12-file-path'  => '/etc/ssl/certs/client.p12',
          'pkcs12-passphrase' => 'credential-password',
        })
      }
    end

  end
end
