# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |global_config|

  global_config.vm.box = 'ubuntu-server-10044-x64-fusion503'
  global_config.vm.box_url = 'https://s3-us-west-1.amazonaws.com/vagaries/ubuntu-server-10044-x64-fusion503.box'

  vms = {
    :nodejs => {
      :ip => '10.80.80.8'
    }
  }

  def bool_to_on_off(val)
    if val
      return 'on'
    else
      return 'off'
    end
  end

  vms.each_pair do |vm_name, vm_settings|
    global_config.vm.define vm_name do |config|

      ###########
      # Params  #
      ###########
      ram           = vm_settings.fetch(:ram,         '2048')
      cpus          = vm_settings.fetch(:cpus,        '2')
      enable_gui    = vm_settings.fetch(:enable_gui,  false)
      enable_usb    = vm_settings.fetch(:enable_usb,  false)
      forward_ssh   = vm_settings.fetch(:forward_ssh, false)
      debug         = vm_settings.fetch(:debug,       false)

      config.ssh.forward_agent  = forward_ssh
      config.vm.hostname        = vm_name
      config.vm.network :private_network, ip: vm_settings[:ip]

      ###############
      # VirtualBox  #
      ###############
      config.vm.provider :virtualbox do |vb|
        vb.gui = enable_gui

        vb.customize [
          'modifyvm',     :id,
          '--memory',     ram,
          '--cpus',       cpus,
          '--acpi',       'on',
          '--hwvirtex',   'on',
          '--largepages', 'on',
          '--audio',      'none',
          '--usb',        bool_to_on_off(enable_usb)]

        if enable_gui
          vb.customize [
            'modifyvm',        :id,
            '--vram',          '64',
            '--accelerate3d',  'on']
        end
      end

      ##################
      # VMWare Fusion  #
      ##################
      config.vm.provider :vmware_fusion do |vf|
        vf.gui = enable_gui

        # http://www.sanbarrow.com/vmx.html
        vf.vmx['memsize']       = ram
        vf.vmx['numvcpus']      = cpus
        vf.vmx['usb.present']   = enable_usb
        vf.vmx['sound.present'] = false
        vf.vmx['displayName']   = vm_name
      end

      ###########
      # Puppet  #
      ###########
      config.vm.provision :puppet do |puppet|
        puppet.module_path    = '..'
        puppet.manifests_path = './tests'
        puppet.manifest_file  = "#{vm_name}.pp"
        if debug
          puppet.options = "--verbose --debug"
        end
      end
    end
  end
end
