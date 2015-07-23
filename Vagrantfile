# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

DOTFILES = ['~/.bash_aliases', '~/.gitconfig', '~/.tmux.conf', '~/.vimrc', '~/.vim', '~/.zshrc']
SETUP_FILES = ['./bootstrap.sh']

VBOX_NAME = 'ubuntu-dev'
ALLOCATED_MEMORY = '4096'
FTDI_VENDORID = '0x0403'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Base box - Ubuntu 14.04.1 LTS Server (32 bit)
  config.vm.box = 'trusty32'
  # Base box location
  config.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box'

  # Use host git credentials via ssh agent forwarding
  config.ssh.forward_agent = true
  # Use X11 for GUI applications (sets $DISPLAY)
    # NOTE: use `vagrant ssh-config` to find port, and use `ssh -X -p port_num vagrant@localhost`
  config.ssh.forward_x11 = true

  # Make shared folder
  config.vm.synced_folder 'shared', '/home/vagrant/shared', create: true

  # Copy over dotfiles
  DOTFILES.each do |f|
    config.vm.provision 'file', source: f, destination: File.basename(f) if File.exist?(File.expand_path(f))
  end

  # Run provisioning script
  SETUP_FILES.each do |f|
    config.vm.provision :shell, :privileged => false, :path => f if File.exist?(File.expand_path(f))
  end

  # VirtualBox-specific settings
  config.vm.provider 'virtualbox' do |vb|

    # Set VM name
    vb.name = VBOX_NAME

    # Set VM RAM
    vb.customize ['modifyvm', :id, '--memory', ALLOCATED_MEMORY]

    # Add USB Controller to VM
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['modifyvm', :id, '--usbehci', 'on']

    # Grant access to specified USB devices
    #vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'FTDI', '--vendorid', FTDI_VENDORID]

  end

end
