apt-get update && apt-get install wget
wget https://v2ray.liping.ml/install-release.sh && bash install-release.sh
rm /etc/v2ray/config.json && wget -qO /etc/v2ray/config.json "https://v2ray.liping.ml/config.json" && service v2ray restart
wget https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh && chmod +x caddy_install.sh && bash caddy_install.sh
wget -qO /usr/local/caddy/Caddyfile "https://v2ray.liping.ml/Caddyfile"
cd / && mkdir www && cd www && mkdir wwwroot && cd wwwroot && apt-get install unzip && wget --no-check-certificate https://v2ray.liping.ml/webpage.zip && unzip webpage.zip && rm webpage.zip && cd
let PORT=$RANDOM+10000
UUID=$(cat /proc/sys/kernel/random/uuid)
hostname=$(hostname)
sed -i "s/10000/${PORT}/g" "/etc/v2ray/config.json"
sed -i "s/3922f464-d02d-4124-82bf-ad350c19aacf/${UUID}/g" "/etc/v2ray/config.json"
sed -i "s/10000/${PORT}/g" "/usr/local/caddy/Caddyfile"
apt-get install vim && vi /usr/local/caddy/Caddyfile
Address=$(sed -n '1p' "/usr/local/caddy/Caddyfile")
mkdir v2config && cd v2config
echo  "这是您的连接信息："
echo "别名(Remarks)：${hostname}" >> "V2ray配置信息.txt"
echo "地址(Address}：${Address}" >> "V2ray配置信息.txt"
echo "端口(Port):443" >> "V2ray配置信息.txt"
echo "用户ID(ID):${UUID}" >> "V2ray配置信息.txt"
echo "额外ID(AlterID):100" >> "V2ray配置信息.txt"
echo "加密方式(Security)：none" >> "V2ray配置信息.txt"
echo "伪装类型(Type）：none" >> "V2ray配置信息.txt"
echo "伪装域名/其他项：/tmp/video" >> "V2ray配置信息.txt"
echo "底层传输安全(TLS)：tls" >> "V2ray配置信息.txt"
cd
cat "./v2config/V2ray配置信息.txt"