stack=`screen -ls | grep Detached | xargs | cut -d" " -f1`

screen -X -S $stack -p c-vol stuff "^C"

screen -X -S $stack -p c-vol stuff "/usr/bin/cinder-volume --config-file /etc/cinder/cinder.conf & echo $! >/opt/stack/status/stack/c-vol.pid; fg || echo \"c-vol failed to start\" | tee \"/opt/stack/status/stack/c-vol.failure\"$(printf \\r)"

