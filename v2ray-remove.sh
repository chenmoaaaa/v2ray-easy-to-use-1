#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Make sure only root can run our script
function rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root,please run 'sudo su' first." 1>&2
	   rm v2ray-remove.sh -rf
       exit 1
    fi

}
 
 
function checkos(){
    if [ -f /etc/redhat-release ];then
        OS='centos'
    elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS='debian'
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS='ubuntu'
    else
        echo "Not support OS, Please change OS and retry!"
		rm v2ray-remove.sh -rf
        exit 1
    fi
}


function remove_v2ray(){
    rootness
    checkos
    service v2ray stop
    curl https://www.v2ray-install.ml/install-release.sh && bash install-release.sh --remove
    rm "/etc/v2ray/config.json" -rf 
    service caddy stop
    curl https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh && bash caddy_install.sh uninstall
    rm /usr/local/caddy/Caddyfile -rf
    rm -rf /www
    echo -e "Uninstall is completed, thank you for your use!" 
    rm v2ray-remove.sh -rf
}
    remove_v2ray
