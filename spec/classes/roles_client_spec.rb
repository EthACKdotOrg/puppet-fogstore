require 'spec_helper'

good_password = 'eic1diB5zosu'

describe 'fogstore::roles::client' do
  on_supported_os.each do |os, facts|
    let :facts do
      facts
    end

    context "missing admin_password on #{os}" do
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
      it 'should fail' do
        should raise_error(Puppet::Error, /validate_slength/)
      end
    end

    context "short admin_password on #{os}" do
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
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /validate_slength/)
      end
    end

    context "long admin_password on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          admin_password  => 'taeBafee8oov7eish6yiihakaexeu1eechuch6eighuam4Ib2ohxei0haifuTob2u',
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
      it 'should fail' do
        should raise_error(Puppet::Error, /validate_slength/)
      end
    end

    context "add_repo not a bool on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => 'blah',
          admin_password  => '#{good_password}',
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
      it 'should fail' do
        should raise_error(Puppet::Error, /"blah" is not a boolean.  It looks to be a String/i)
      end
    end

    context "manage_ssl not a bool on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          admin_password  => '#{good_password}',
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          cred_key        => 'credential.key',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => 'blah',
          mrc_ca          => 'mrc-ca.pem',
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /"blah" is not a boolean.  It looks to be a String/i)
      end
    end

    context "missing credential #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          admin_password  => '#{good_password}',
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
      it 'should fail' do
        should raise_error(Puppet::Error, /Need cred_cert, cred_key and cred_password/i)
      end
    end

    context "missing credential password #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          admin_password  => '#{good_password}',
          credential      => 'credential.pem',
          cred_key        => 'credential.key',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => true,
          mrc_ca          => 'mrc-ca.pem',
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /Need cred_cert, cred_key and cred_password/i)
      end
    end

    context "missing credential key #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          admin_password  => '#{good_password}',
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => true,
          mrc_ca          => 'mrc-ca.pem',
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /Need cred_cert, cred_key and cred_password/i)
      end
    end

    context "missing dir_ca #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => true,
          admin_password  => '#{good_password}',
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          cred_key        => 'credential.key',
          manage_ssl      => true,
          mrc_ca          => 'mrc-ca.pem',
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /Need dir_ca, mrc_ca and osd_ca/i)
      end
    end

    context "missing mrc_ca #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => true,
          admin_password  => '#{good_password}',
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          cred_key        => 'credential.key',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => true,
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /Need dir_ca, mrc_ca and osd_ca/i)
      end
    end

    context "missing osd_ca #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => true,
          admin_password  => '#{good_password}',
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          cred_key        => 'credential.key',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => true,
          mrc_ca          => 'mrc-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /Need dir_ca, mrc_ca and osd_ca/i)
      end
    end

    context "working on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          admin_password  => '#{good_password}',
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          cred_key        => 'credential.key',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => true,
          mrc_ca          => 'mrc-ca.pem',
          mounts          => 'foo',
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /Mounts need to ba a hash/i)
      end
    end

    context "volumes not a hash #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          admin_password  => '#{good_password}',
          credential      => 'credential.pem',
          cred_password   => 'abcdefg',
          cred_key        => 'credential.key',
          dir_ca          => 'dir-ca.pem',
          manage_ssl      => true,
          mrc_ca          => 'mrc-ca.pem',
          osd_ca          => 'osd-ca.pem',
          ssl_source_dir  => 'file://.',
          volumes         => 'foo',
        }
        "
      end
      it 'should fail' do
        should raise_error(Puppet::Error, /Volumes need to ba a hash/i)
      end
    end

    context "working on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => false,
          admin_password  => '#{good_password}',
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
          'admin_password'    => good_password,
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
          'admin_password'    => good_password,
          'pkcs12-file-path'  => '/etc/ssl/certs/client.p12',
          'pkcs12-passphrase' => 'abcdefg',
        })
      }
    end

    context "working with repository on #{os}" do
      let :pre_condition do
        "
        class {'fogstore::roles::client':
          add_repo        => true,
          admin_password  => '#{good_password}',
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
      case os
      when 'debian-8'
      it {
        should contain_apt__source('xtreemfs')
        .with('location' => 'http://download.opensuse.org/repositories/home:/xtreemfs/Debian_8.0')
      }
      when 'debian-7'
      it {
        should contain_apt__source('xtreemfs')
        .with('location' => 'http://download.opensuse.org/repositories/home:/xtreemfs/Debian_7.0')
      }
      end
    end

  end
end
