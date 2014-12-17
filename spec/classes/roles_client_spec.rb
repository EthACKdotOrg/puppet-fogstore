require 'spec_helper'

os_facts = @os_facts

os_facts.each do |osfamily, facts|
  describe 'fogstore::roles::client' do
    let :facts do
      facts
    end

    context 'Client: missing admin_password' do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          cred_key        => 'credential.key',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => true,
          mrc_ca          => 'mrc-ca.pem',
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end
      it {
        should_not compile.with_all_deps
      }
    end

    context 'working' do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          admin_password  => 'foobarbaz',
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          cred_key        => 'credential.key',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => true,
          mrc_ca          => 'mrc-ca.pem',
          mounts          => {
            '/mnt/test1' => {
              'ensure'   => 'mounted',
              'volume'   => 'test1',
            },
            '/mnt/test2' => {
              'ensure'   => 'absent',
              'volume'   => 'test2',
            }
          },
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
          volumes         => {
            'test1'    => {
              'ensure' => 'present',
            },
            'test2'    => {
              'ensure' => 'absent',
            }
          },
        }
        "
      end

      it {
        should compile.with_all_deps
      }
      it {
        should contain_class('fogstore::user')
      }
      it {
        should contain_user('xtreemfs')
      }

      it {
        should contain_fogstore__ssl__credential('client')
        .with('client_ca'       => false)
        .with('cred_cert'       => 'credential.pem')
        .with('cred_key'        => 'credential.key')
        .with('cred_password'   => 'abcdefg')
        .with('destination_dir' => '/etc/ssl/certs')
        .with('dir_ca'          => 'dir-ca.pem')
        .with('mrc_ca'          => 'mrc-ca.pem')
        .with('osd_ca'          => 'osd-ca.pem')
        .with('role'            => 'client')
        .with('ssl_source_dir'  => 'file://.')
      }
      it {
        should contain_class('xtreemfs::settings')
        .with('add_repo' => false)
      }
      it {
        should contain_xtreemfs__volume('test1')
        .with('ensure'        => 'present')
        .with('dir_host'      => nil)
        .with('dir_port'      => nil)
        .with('dir_protocol'  => nil)
        .with('options'       => {
          'admin_password'    => 'foobarbaz',
          'pkcs12-file-path'  => '/etc/ssl/certs/client.p12',
          'pkcs12-passphrase' => 'abcdefg',
        })
      }
      it {
        should contain_xtreemfs__volume('test2')
        .with('ensure'        => 'absent')
        .with('dir_host'      => nil)
        .with('dir_port'      => nil)
        .with('dir_protocol'  => nil)
        .with('options'       => {
          'admin_password'    => 'foobarbaz',
          'pkcs12-file-path'  => '/etc/ssl/certs/client.p12',
          'pkcs12-passphrase' => 'abcdefg',
        })
      }
    end

    describe 'working with repository' do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => true,
          admin_password  => 'foobarbaz',
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          cred_key        => 'credential.key',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => true,
          mrc_ca          => 'mrc-ca.pem',
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end

      it {
        should contain_class('xtreemfs::settings')
        .with('add_repo' => true)
      }
      it {
        should contain_apt__source('xtreemfs')
        .with('location' => 'http://download.opensuse.org/repositories/home:/xtreemfs/Debian_8.0')
      }
    end

  end
end
