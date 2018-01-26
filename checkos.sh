#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Make sure only root can run our script
function rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root!" 1>&2
       exit 1
    fi
}


function checkos(){
    rootness
    if [ -f /etc/redhat-release ];then
        echo "Your OS type is CentOS."
    elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        echo "Your OS type is Debian."
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        echo "Your OS type is Ubuntu."
    else
        echo "Not support OS, Please change OS and retry!"
        exit 1
    fi
}
    checkos