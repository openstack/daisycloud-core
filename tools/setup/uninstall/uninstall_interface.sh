#!/bin/bash
# 
if [ ! "$_UNINSTALL_INTERFACE_FILE" ];then
_UNINSTALL_INTERFACE_DIR=`pwd`
cd $_UNINSTALL_INTERFACE_DIR/../common
.  daisy_common_func.sh
.  daisy_global_var.sh

cd $_UNINSTALL_INTERFACE_DIR
.  uninstall_func.sh


function uninstall_daisy
{
    echo "Will uninstall daisy rpm which has been install in the machines"
    echo "clean all hosts discovery information..." 
    pxe_os_install_clean all
    echo "stop all service..."
    stop_service_all
    remove_rpms_by_yum "python-django-horizon  daisy-dashboard"
    remove_rpms_by_yum "daisy python-daisyclient  python-daisy"
    remove_rpms_by_yum "openstack-ironic-discoverd python-ironic-discoverd"
    rpm -e  pxe_server_install
    for i in `ps -elf | grep daisy-api |grep -v grep | awk -F ' ' '{print $4}'`;do kill -9 $i;done 
    for j in `ps -elf | grep daisy-registry |grep -v grep | awk -F ' ' '{print $4}'`;do kill -9 $j;done 
    for j in `ps -elf | grep rabbitmq |grep -v grep | awk -F ' ' '{print $4}'`;do kill -9 $j;done 
    for j in `ps -elf | grep ironic-api |grep -v grep | awk -F ' ' '{print $4}'`;do kill -9 $j;done
    for j in `ps -elf | grep ironic-conductor |grep -v grep | awk -F ' ' '{print $4}'`;do kill -9 $j;done
    for j in `ps -elf | grep ironic-discoverd |grep -v grep | awk -F ' ' '{print $4}'`;do kill -9 $j;done
    rm -rf /etc/daisy
    rm -rf /etc/ironic-discoverd
    rm -rf /etc/sudoers.d/daisy
    rm -rf /etc/my.cnf.d
    rm -rf /var/lib/daisy
    rm -rf /var/log/mariadb
    rm -rf /var/log/daisy
    rm -rf /var/log/ironic
    rm -rf /var/log/rabbitmq
    rm -rf /root/daisyrc_admin
    # delect ironic database
    local create_ironic_sql="drop database IF EXISTS ironic"
    write_install_log "delect ironic database in mariadb"
    echo ${create_ironic_sql} | mysql
    if [ $? -ne 0 ];then
        echo "Error:create ironic database failed..."
        exit 1
    fi
    # delect keystone database
    local create_keystone_sql="drop database IF EXISTS keystone"
    write_install_log "delect keystone database in mariadb"
    echo ${create_keystone_sql} | mysql
    if [ $? -ne 0 ];then
        echo "Error:create keystone database failed..."
        exit 1
    fi
    # delect daisy database
    local create_daisy_sql="drop database IF EXISTS daisy"
    write_install_log "delect daisy database in mariadb"
    echo ${create_daisy_sql} | mysql
    if [ $? -ne 0 ];then
        echo "Error:create daisy database failed..."
        exit 1
    fi
    echo "Finish clean daisy!"  
}

_UNINSTALL_FUNC="uninstall_func.sh"
fi
