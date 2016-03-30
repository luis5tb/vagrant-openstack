node 'controller.cs.umu.se' {
    include git
    class { 'devstack' : controller => 'TRUE'}
}
node 'worker.cs.umu.se' {
    include git
    include devstack
}
