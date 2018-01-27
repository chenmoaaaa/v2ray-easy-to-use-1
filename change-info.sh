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


function checkos(){
    if [ -f /etc/redhat-release ];then
        OS='centos'
    elif [ ! -z "`cat /etc/issue | grep bian`" ];then
        OS='debian'
    elif [ ! -z "`cat /etc/issue | grep Ubuntu`" ];then
        OS='ubuntu'
    else
        echo "Not support OS, Please change OS and retry!"
        exit 1
    fi
}

 
#  Install v2ray
function change_info(){
	rootness
	checkos
	let PORT=$RANDOM+10000 && UUID=$(cat /proc/sys/kernel/random/uuid) && hostname=$(hostname) && sed -i "s/10000/${PORT}/g" "/etc/v2ray/config.json" && sed -i "s/3922f464-d02d-4124-82bf-ad350c19aacf/${UUID}/g" "/etc/v2ray/config.json" && sed -i "s/10000/${PORT}/g" "/usr/local/caddy/Caddyfile"
	vim /usr/local/caddy/Caddyfile
	service v2ray restart && service caddy restart
	Address0=$(sed -n '1p' "/usr/local/caddy/Caddyfile") 
	Address=${Address0#*"://"}
	mkdir -p /root/v2ray-go/
	cd /root/
	echo  "这是您的连接信息：" 
	echo "别名(Remarks)：${hostname}" 
	echo "地址(Address)：${Address}" >> "./v2ray-go/v2info.txt" &&echo "端口(Port):443" >> "./v2ray-go/v2info.txt" &&echo "用户ID(ID):${UUID}" >> "./v2ray-go/v2info.txt" &&echo "额外ID(AlterID):64" >> "./v2ray-go/v2info.txt" &&echo "加密方式(Security)：none" >> "./v2ray-go/v2info.txt" &&	echo "伪装类型(Type）：none" >> "./v2ray-go/v2info.txt" &&echo "伪装域名/其他项：/liping" >> "./v2ray-go/v2info.txt" &&echo "底层传输安全(TLS)：tls" >> "./v2ray-go/v2info.txt"&&echo "V2ray配置位置(config.json)：/etc/v2ray/config.json" >> "./v2ray-go/v2info.txt"  
	cat "./v2ray-go/v2info.txt" 
	echo "本文件保存在：/root/v2ray-go/v2info.txt"

}
    change_info
