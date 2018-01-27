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


function checkenv(){
    if [[ $OS = "centos" ]]; then
       yum update -y
       yum install wget unzip curl vim -y
    else
       apt-get -y update
       apt-get -y install wget curl unzip vim
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
	stty erase '^H' && read -p "请输入您的域名：" url
	echo ""${url#*"://"}"" > /tmp/caddyaddress.txt
	sed -i "s#/##g" "/tmp/caddyaddress.txt"
	Address=$(cat "/tmp/caddyaddress.txt")
	rm -rf /tmp/caddyaddress.txt
	echo -e "您的域名为: ${Address}"
    let PORT=$RANDOM+10000
	sed -i "s/10000/${PORT}/g" "/etc/v2ray/config.json"
    sed -i "s/3922f464-d02d-4124-82bf-ad350c19aacf/${UUID}/g" "/etc/v2ray/config.json"
    sed -i "s/10000/${PORT}/g" "/usr/local/caddy/Caddyfile"
	sed -i "s#V2rayAddress#$https://{Address}#g" "/usr/local/caddy/Caddyfile"
    UUID=$(cat /proc/sys/kernel/random/uuid)
    hostname=$(hostname)
    service v2ray restart && service caddy restart
    echo -e "\n这是您的连接信息：\n别名(Remarks)：${hostname}\n地址(Address)：${Address}\n端口(Port):443\n用户ID(ID):${UUID}\n额外ID(AlterID):100\n加密方式(Security)：none\n伪装类型(Type）：none\n伪装域名/其他项：/tmp/video\n底层传输安全(TLS)：tls\n"
}
    install_v2ray
