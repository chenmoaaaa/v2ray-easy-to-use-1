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
		if [[ $OS = "centos" ]]; then
			yum install wget unzip curl vim -y
		else
		    apt-get -y update
			apt-get -y install wget curl unzip vim
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


function install_v2ray(){
	rootness
	checkos
	checkenv
	curl https://www.v2ray-install.ml/install-release.sh | bash
	rm "/etc/v2ray/config.json" -rf 
	wget -qO /etc/v2ray/config.json "https://www.v2ray-install.ml/config.json" 
	service v2ray restart
	curl https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh | bash
	wget -qO /usr/local/caddy/Caddyfile "https://www.v2ray-install.ml/Caddyfile" 
        cd / && mkdir www && cd www && mkdir wwwroot && cd wwwroot
	wget https://www.v2ray-install.ml/webpage.zip
	unzip webpage.zip
	rm webpage.zip -rf 
	let PORT=$RANDOM+10000
	UUID=$(cat /proc/sys/kernel/random/uuid)
	hostname=$(hostname)
	sed -i "s/10000/${PORT}/g" "/etc/v2ray/config.json"
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
    install_v2ray
