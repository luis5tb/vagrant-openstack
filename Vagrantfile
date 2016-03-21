# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.define "controller" do |controller|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://atlas.hashicorp.com/search.
    controller.vm.box = "centos/7"

    controller.vm.hostname = 'controller'

    # Disable automatic box update checking. If you disable this, then
    # boxes will only be checked for updates when the user runs
    # `vagrant box outdated`. This is not recommended.
    # config.vm.box_check_update = false

    # Create a forwarded port mapping which allows access to a specific port
    # within the machine from a port on the host machine. In the example below,
    # accessing "localhost:8080" will access port 80 on the guest machine.
    #controller.vm.network "forwarded_port", guest: 80, host: 8080

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    controller.vm.network "private_network", ip: "192.168.5.2"
    #controller.vm.network "private_network", ip: "192.168.100.2"
 
    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on
    # your network.
    # config.vm.network "public_network"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:
    #
    controller.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
    #   vb.gui = true
    #
    #   # Customize the amount of memory on the VM:
      vb.customize ['modifyvm', :id, "--nicpromisc2", "allow-all"]
      vb.memory = "6096"
      vb.cpus = 2
    end
    #
    # View the documentation for the provider you are using for more
    # information on available options.
  
    # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
    # such as FTP and Heroku are also available. See the documentation at
    # https://docs.vagrantup.com/v2/push/atlas.html for more information.
    # config.push.define "atlas" do |push|
    #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
    # end

    # Enable provisioning with a shell script. Additional provisioners such as
    # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
    # documentation for more information about their specific syntax and use.
    controller.vm.provision "shell", inline: <<-SHELL
      yum install -y epel-release 
      yum install -y git yum-utils python-pip

      git clone https://git.openstack.org/openstack-dev/devstack
      cp /home/vagrant/sync/config_files/local.conf.Controller /home/vagrant/devstack/local.conf
      chown -R vagrant:vagrant /home/vagrant/devstack

      echo '192.168.5.2 controller' >> /etc/hosts
      echo '192.168.5.3 worker' >> /etc/hosts

      su - vagrant -c './devstack/stack.sh ; true'
    SHELL

    controller.vm.provision "shell", inline: <<-SHELL
      su - vagrant -c './devstack/unstack.sh'
      sudo pip uninstall -y six
      ovs-vsctl --no-wait --may-exist add-br br-eth1
      ovs-vsctl --no-wait --may-exist add-br br-ex
      ovs-vsctl add-port br-eth1 eth1
      ifconfig eth1 0
      ifconfig br-eth1 192.168.5.2/24 up
      su - vagrant -c "./devstack/stack.sh ; true"

      iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited
      iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited

      sed -i 's/#listen_tcp = 1/listen_tcp = 1/g' /etc/libvirt/libvirtd.conf
      sed -i 's/#listen_tls = 0/listen_tls = 0/g' /etc/libvirt/libvirtd.conf
      sed -i 's/#auth_tcp = "sasl"/auth_tcp = "none"/g' /etc/libvirt/libvirtd.conf
      sed -i 's/#LIBVIRTD_ARGS="--listen"/LIBVIRTD_ARGS="--listen"/g' /etc/sysconfig/libvirtd
      systemctl restart libvirtd
    SHELL

    controller.vm.provision "shell", path: "./config_files/updateNovaConf.sh"
    controller.vm.provision "shell", path: "./config_files/updateCinderConf.sh"
    controller.vm.provision "shell", path: "./config_files/cleanup_networks.sh"
    controller.vm.provision "shell", path: "./config_files/create_networks.sh"
  end

  config.vm.define "worker" do |worker|
    worker.vm.box = "centos/7"
    worker.vm.hostname = 'worker'

    worker.vm.network "private_network", ip: "192.168.5.3"
 
    worker.vm.provider "virtualbox" do |vb|
      vb.customize ['modifyvm', :id, "--nicpromisc2", "allow-all"]
      vb.memory = "2048"
      vb.cpus = 2
    end

    worker.vm.provision "shell", inline: <<-SHELL
      yum install -y epel-release 
      yum install -y git yum-utils python-pip

      git clone https://git.openstack.org/openstack-dev/devstack
      cp /home/vagrant/sync/config_files/local.conf.Worker /home/vagrant/devstack/local.conf
      chown -R vagrant:vagrant /home/vagrant/devstack

      echo '192.168.5.2 controller' >> /etc/hosts
      echo '192.168.5.3 worker' >> /etc/hosts

      su - vagrant -c './devstack/stack.sh ; true'
      su - vagrant -c './devstack/unstack.sh ; true'
      sudo pip uninstall -y six
      ovs-vsctl --no-wait --may-exist add-br br-eth1
      su - vagrant -c './devstack/stack.sh'

      iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited
      iptables -D FORWARD -j REJECT --reject-with icmp-host-prohibited

      sed -i 's/#listen_tcp = 1/listen_tcp = 1/g' /etc/libvirt/libvirtd.conf
      sed -i 's/#auth_tcp = "sasl"/auth_tcp = "none"/g' /etc/libvirt/libvirtd.conf
      sed -i 's/#listen_tls = 0/listen_tls = 0/g' /etc/libvirt/libvirtd.conf
      sed -i 's/#LIBVIRTD_ARGS="--listen"/LIBVIRTD_ARGS="--listen"/g' /etc/sysconfig/libvirtd
      systemctl restart libvirtd

      ovs-vsctl add-port br-eth1 eth1
      ifconfig eth1 0
      ifconfig br-eth1 192.168.5.3/24 up
    SHELL
    worker.vm.provision "shell", path: "./config_files/updateNovaConf.sh"
  end
end
