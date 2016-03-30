# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.define "controller" do |controller|
    controller.vm.box = "centos/7"
    controller.vm.hostname = 'controller.cs.umu.se'

    controller.vm.network "private_network", ip: "192.168.5.2"
    controller.vm.provider "virtualbox" do |vb|
      vb.customize ['modifyvm', :id, "--nicpromisc2", "allow-all"]
      vb.memory = "6096"
      vb.cpus = 2
    end
    
    controller.vm.provision "shell", inline: <<-SHELL
      echo '192.168.5.2 controller.cs.umu.se' >> /etc/hosts
      echo '192.168.5.3 worker.cs.umu.se' >> /etc/hosts

      yum install -y epel-release 
      yum install -y yum-utils python-pip
      yum install -y puppet

      puppet apply --modulepath=sync/puppet/modules sync/puppet/manifests/devstack.pp
      su - vagrant -c "./devstack/stack.sh ; true"
      
      puppet apply --modulepath=sync/puppet/modules sync/puppet/manifests/network.pp
      sudo pip uninstall -y six
      su - vagrant -c './devstack/unstack.sh ; true'
      su - vagrant -c "./devstack/stack.sh"
      
      puppet apply --modulepath=sync/puppet/modules sync/puppet/manifests/openstack_config.pp

    SHELL
  end

 config.vm.define "worker" do |worker|
    worker.vm.box = "centos/7"
    worker.vm.hostname = 'worker.cs.umu.se'

    worker.vm.network "private_network", ip: "192.168.5.3"

    worker.vm.provider "virtualbox" do |vb|
      vb.customize ['modifyvm', :id, "--nicpromisc2", "allow-all"]
      vb.memory = "2048"
      vb.cpus = 2
    end

    worker.vm.provision "shell", inline: <<-SHELL
      echo '192.168.5.3 worker.cs.umu.se' >> /etc/hosts
      echo '192.168.5.2 controller.cs.umu.se' >> /etc/hosts

      yum install -y epel-release
      yum install -y yum-utils python-pip
      yum install -y puppet

      puppet apply --modulepath=sync/puppet/modules sync/puppet/manifests/devstack.pp
      su - vagrant -c './devstack/stack.sh ; true'

      ovs-vsctl --no-wait --may-exist add-br br-eth1
      sudo pip uninstall -y six
      su - vagrant -c './devstack/unstack.sh ; true'
      su - vagrant -c './devstack/stack.sh'

      puppet apply --modulepath=sync/puppet/modules sync/puppet/manifests/network.pp
      puppet apply --modulepath=sync/puppet/modules sync/puppet/manifests/openstack_config.pp

    SHELL
  end

end
