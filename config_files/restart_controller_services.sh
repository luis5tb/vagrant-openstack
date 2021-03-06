stack=`su - vagrant -c "screen -ls | grep Detached | xargs | cut -d\" \" -f1"`

su - vagrant -c "screen -X -S $stack -p n-cpu stuff \"^C\""

su - vagrant -c "screen -X -S $stack -p n-cpu stuff \"sg libvirtd '/usr/bin/nova-compute --config-file /etc/nova/nova.conf' & echo $! >/opt/stack/status/stack/n-cpu.pid; fg || echo 'n-cpu failed to start' | tee '/opt/stack/status/stack/n-cpu.failure'$(printf \\r)\""

su - vagrant -c "screen -X -S $stack -p c-vol stuff \"^C\""

su - vagrant -c "screen -X -S $stack -p c-vol stuff \"/usr/bin/cinder-volume --config-file /etc/cinder/cinder.conf & echo $! >/opt/stack/status/stack/c-vol.pid; fg || echo 'c-vol failed to start' | tee '/opt/stack/status/stack/c-vol.failure'$(printf \\r)\""
