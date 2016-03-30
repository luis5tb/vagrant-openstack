stack=`screen -ls | grep Detached | xargs | cut -d" " -f1`

screen -X -S $stack -p n-cpu stuff "^C"

screen -X -S $stack -p n-cpu stuff "sg libvirtd '/usr/bin/nova-compute --config-file /etc/nova/nova.conf' & echo $! >/opt/stack/status/stack/n-cpu.pid; fg || echo \"n-cpu failed to start\" | tee \"/opt/stack/status/stack/n-cpu.failure\"$(printf \\r)"

