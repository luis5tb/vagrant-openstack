node 'controller.cs.umu.se' {
    class { 'ovs': server_ip => '192.168.5.2'}
}
node 'worker.cs.umu.se' {
    class { 'ovs': server_ip => '192.168.5.3'}
}
