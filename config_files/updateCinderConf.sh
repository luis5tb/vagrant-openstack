awk '{if ($1=="[DEFAULT]") print $0 "\nmy_ip=192.168.5.2"; else print $0}' /etc/cinder/cinder.conf > aux
mv aux /etc/cinder/cinder.conf
