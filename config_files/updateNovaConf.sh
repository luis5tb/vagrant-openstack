sed -i '/force_config_drive/d' /etc/nova/nova.conf
sed -i 's/qemu+ssh/qemu+tcp/g' /etc/nova/nova.conf

awk '{if ($1=="[libvirt]") print $0 "\nblock_migration_flag=VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE,VIR_MIGRATE_NON_SHARED_INC"; else print $0}' /etc/nova/nova.conf > aux
mv aux /etc/nova/nova.conf
