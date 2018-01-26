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


function checkenv(){
		if [[ $OS = "centos" ]]; then
			yum install wget unzip vim -y
		else
		    apt-get -y update
			apt-get -y install wget unzip vim
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
        echo "Not support OS, Please reinstall OS and retry!"
        exit 1
    fi
}

 

function install_v2ray(){
	rootness
	checkos
	checkenv
	wget https://v2ray-install.netlify.com/install-release.sh | bash 
	rm "/etc/v2ray/config.json" -rf 
	wget -qO /etc/v2ray/config.json "https://v2ray-install.netlify.com/config.json" 
	service v2ray restart
	wget https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh | bash 
	wget -qO /usr/local/caddy/Caddyfile "https://v2ray-install.netlify.com/Caddyfile" 
	wget https://v2ray-install.netlify.com/webpage.zip
	unzip webpage.zip
	rm webpage.zip -rf 
	let PORT=$RANDOM+10000 && UUID=$(cat /proc/sys/kernel/random/uuid) && hostname=$(hostname) && sed -i "s/10000/${PORT}/g" "/etc/v2ray/config.json" && sed -i "s/3922f464-d02d-4124-82bf-ad350c19aacf/${UUID}/g" "/etc/v2ray/config.json" && sed -i "s/10000/${PORT}/g" "/usr/local/caddy/Caddyfile"
	vim /usr/local/caddy/Caddyfile
	service v2ray restart && service caddy restart
	Address=$(sed -n '1p' "/usr/local/caddy/Caddyfile") 
	echo "这是您的连接信息：" 
	echo "别名(Remarks)：${hostname}" 
	echo "地址(Address)：${Address}" >> "./v2ray-go/v2info.txt" &&echo "端口(Port):443" >> "./v2ray-go/v2info.txt" &&echo "用户ID(ID):${UUID}" >> "./v2ray-go/v2info.txt" &&echo "额外ID(AlterID):64" >> "./v2ray-go/v2info.txt" &&echo "加密方式(Security)：none" >> "./v2ray-go/v2info.txt" &&	echo "伪装类型(Type）：none" >> "./v2ray-go/v2info.txt" &&echo "伪装域名/其他项：/liping" >> "./v2ray-go/v2info.txt" &&echo "底层传输安全(TLS)：tls" >> "./v2ray-go/v2info.txt" 
	cat "./v2ray-go/v2info.txt" 
	echo "本文件保存在：/root/v2ray-go/v2info.txt"
}
    install_v2ray