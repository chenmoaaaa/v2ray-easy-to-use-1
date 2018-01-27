#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Make sure only root can run our script
function rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root,please run 'sudo su' first." 1>&2
       exit 1
    fi
}


function checkenv(){
    if [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS='debian'
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS='ubuntu'
    else
        echo "Not support OS, Please reinstall OS and retry!"
        exit 1
    fi
}

function change_configs(){
    rootness
	checkenv
	let PORT=$RANDOM+10000
	UUID=$(cat /proc/sys/kernel/random/uuid)
	hostname=$(hostname) && sed -i "s/10000/${PORT}/g" "/etc/v2ray/config.json"
	sed -i "s/3922f464-d02d-4124-82bf-ad350c19aacf/${UUID}/g" "/etc/v2ray/config.json"
	sed -i "s/10000/${PORT}/g" "/usr/local/caddy/Caddyfile"
	vim /usr/local/caddy/Caddyfile
	service v2ray restart && service caddy restart
	Address=$(sed -n '1p' "/usr/local/caddy/Caddyfile") 
	echo -e "这是您的连接信息：\n" 
	echo -e "别名(Remarks)：${hostname}\n" 
	echo -e "地址(Address)：${Address}\n"
	echo -e "端口(Port):443\n"
	echo -e "用户ID(ID):${UUID}\n"
	echo -e "额外ID(AlterID):100\n"
	echo -e "加密方式(Security)：none\n"
	echo -e "伪装类型(Type）：none\n"
	echo -e "伪装域名/其他项：/tmp/video\n"
	echo -e "底层传输安全(TLS)：tls\n"
}
    change_configs
