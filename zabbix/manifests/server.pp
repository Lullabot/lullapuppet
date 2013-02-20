class zabbix::server {

    service { 'zabbix-server':
        ensure  => running,
        enable  => true,
    }

}
