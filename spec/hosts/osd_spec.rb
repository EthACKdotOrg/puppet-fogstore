require 'spec_helper'

os_facts = @os_facts


describe 'osd' do
  os_facts.each do |osfamily, facts|
    let :facts do
      facts
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
    end
    
    describe 'should add source' do
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
    
    describe 'should create trust store directory' do
      it {
        should contain_file('/etc/xos/xtreemfs/truststore')
        .with('ensure' => 'directory')
        .with('group'  => 'xtreemfs')
        .with('mode'   => '0750')
        .with('owner'  => 'root')
      }
    end

    describe 'should include fogstore::roles::osd' do
      it {
        should contain_class('fogstore::roles::osd')
      }
    end

  end
end
