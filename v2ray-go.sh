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
			yum install wget unzip vim -y
		else
		    apt-get -y update
			apt-get -y install wget unzip vim
		fi
}
 

function install_v2ray(){
	rootness
	checkos
	checkenv
	curl https://v2ray-install.netlify.com/install-release.sh && bash install-release.sh
	rm "/etc/v2ray/config.json" -rf 
	wget -qO /etc/v2ray/config.json "https://v2ray-install.netlify.com/config.json" 
	service v2ray restart
	curl https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh && bash caddy_install.sh
	wget -qO /usr/local/caddy/Caddyfile "https://v2ray-install.netlify.com/Caddyfile" 
        cd / && mkdir www && cd www && mkdir wwwroot && cd wwwroot
	wget https://v2ray-install.netlify.com/webpage.zip
	unzip webpage.zip
	rm webpage.zip -rf 
	let PORT=$RANDOM+10000 && UUID=$(cat /proc/sys/kernel/random/uuid) && hostname=$(hostname) && sed -i "s/10000/${PORT}/g" "/etc/v2ray/config.json" && sed -i "s/3922f464-d02d-4124-82bf-ad350c19aacf/${UUID}/g" "/etc/v2ray/config.json" && sed -i "s/10000/${PORT}/g" "/usr/local/caddy/Caddyfile"
	vim /usr/local/caddy/Caddyfile
	service v2ray restart && service caddy restart
	Address=$(sed -n '1p' "/usr/local/caddy/Caddyfile") 
	echo "这是您的连接信息：" 
	echo "别名(Remarks)：${hostname}" 
	echo "地址(Address)：${Address}"
	echo "端口(Port):443"
	echo "用户ID(ID):${UUID}"
	echo "额外ID(AlterID):64"
	echo "加密方式(Security)：none"
	echo "伪装类型(Type）：none"
	echo "伪装域名/其他项：/liping"
	echo "底层传输安全(TLS)：tls"
}
    install_v2ray
