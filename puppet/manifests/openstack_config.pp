node 'controller.cs.umu.se' {
    include libvirt
    include iptables
    include nova
    include cinder 
    include nets
}
node 'worker.cs.umu.se' {
    include libvirt
    include iptables
    class { 'nova' : worker => 'TRUE'}
}
