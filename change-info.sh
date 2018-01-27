#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
 
function change_info(){
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
    sed -i "s#V2rayAddress#https://${Address}#g" "/usr/local/caddy/Caddyfile"
    UUID=$(cat /proc/sys/kernel/random/uuid)
    hostname=$(hostname)
    service v2ray restart && service caddy restart
    echo -e "\n这是您的连接信息：\n别名(Remarks)：${hostname}\n地址(Address)：${Address}\n端口(Port):443\n用户ID(ID):${UUID}\n额外ID(AlterID):100\n加密方式(Security)：none\n伪装类型(Type）：none\n伪装域名/其他项：/tmp/video\n底层传输安全(TLS)：tls\n"
}
    change_info
