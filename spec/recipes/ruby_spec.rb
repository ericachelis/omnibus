require 'spec_helper'

describe 'omnibus::_ruby' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  context 'on non-windows' do
    it 'includes _bash' do
      expect(chef_run).to include_recipe('omnibus::_bash')
    end

    it 'includes _cacerts' do
      expect(chef_run).to include_recipe('omnibus::_cacerts')
    end

    it 'includes _compile' do
      expect(chef_run).to include_recipe('omnibus::_compile')
    end

    it 'includes _openssl' do
      expect(chef_run).to include_recipe('omnibus::_openssl')
    end

    it 'includes _xml' do
      expect(chef_run).to include_recipe('omnibus::_xml')
    end

    it 'includes _yaml' do
      expect(chef_run).to include_recipe('omnibus::_yaml')
    end

    context 'on rhel' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'redhat', version: '7.0')
        .converge(described_recipe)
      end

      it 'installs bzip2' do
        expect(chef_run).to install_package('bzip2')
      end
    end

    it 'installs ruby-install' do
      allow_any_instance_of(Chef::Resource).to receive(:installed_at_version?)

      expect(chef_run).to install_remote_install('ruby-install')
        .with_source('https://codeload.github.com/postmodern/ruby-install/tar.gz/v0.4.1')
        .with_checksum('1b35d2b6dbc1e75f03fff4e8521cab72a51ad67e32afd135ddc4532f443b730e')
        .with_version('0.4.1')
        .with_install_command('make -j 2 install')
    end

    it 'installs ruby' do
      expect(chef_run).to install_ruby_install('2.1.5')
    end

    it 'installs bundler' do
      expect(chef_run).to install_ruby_gem('bundler')
    end
  end
end
