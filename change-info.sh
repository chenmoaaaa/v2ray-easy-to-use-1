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


function change_info(){
    rootness
    checkos
    let PORT=$RANDOM+10000
    UUID=$(cat /proc/sys/kernel/random/uuid)
    hostname=$(hostname)
    sed -i "s/10000/${PORT}/g" "/etc/v2ray/config.json"
    sed -i "s/3922f464-d02d-4124-82bf-ad350c19aacf/${UUID}/g" "/etc/v2ray/config.json"
    sed -i "s/10000/${PORT}/g" "/usr/local/caddy/Caddyfile"
    stty erase '^H' && read -p "请输入您的域名：" url
    echo ""${url#*"://"}"" > /tmp/caddyaddress.txt
    sed -i "s#/##g" "/tmp/caddyaddress.txt"
    Address=$(cat "/tmp/caddyaddress.txt")
    rm -rf /tmp/caddyaddress.txt
    echo -e "您的域名为: ${Address}"
    sed -i "s#V2rayAddress#https://${Address}#g" "/usr/local/caddy/Caddyfile"
    service v2ray restart && service caddy restart
    echo -e "\n这是您的连接信息：\n别名(Remarks)：${hostname}\n地址(Address)：${Address}\n端口(Port):443\n用户ID(ID):${UUID}\n额外ID(AlterID):100\n加密方式(Security)：none\n伪装类型(Type）：none\n伪装域名/其他项：/tmp/video\n底层传输安全(TLS)：tls\n"
}
    change_info
