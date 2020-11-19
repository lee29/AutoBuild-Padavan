#!/bin/sh
#from hiboy
killall frpc frps
mkdir -p /tmp/frp
#启动frp功能后会运行以下脚本
#frp项目地址教程: https://github.com/fatedier/frp/blob/master/README_zh.md
#请自行修改 token 用于对客户端连接进行身份验证
# IP查询： http://119.29.29.29/d?dn=github.com

cat > "/tmp/frp/myfrpc.ini" <<-\EOF
# ==========客户端配置：==========
[common]
server_addr = lee29.ml
server_port = 5443
token = a10086

#log_file = /dev/null
#log_level = info
#log_max_days = 3

[web]
remote_port = 6000
type = http
local_ip = 192.168.0.1
local_port = 80
subdomain = luyouqi
#host_header_rewrite = 实际你内网访问的域名，可以供公网的域名不一致，如果一致可以不写

[luyouqi-web]
remote_port = 6001
type = http
local_ip = 192.168.0.1
local_port = 19998
subdomain = web
#host_header_rewrite = 实际你内网访问的域名，可以供公网的域名不一致，如果一致可以不写

[luyouqi-web2]
remote_port = 6002
type = http
local_ip = 192.168.0.1
local_port = 19999
subdomain = web2
#host_header_rewrite = 实际你内网访问的域名，可以供公网的域名不一致，如果一致可以不写

[kms]
type = tcp
local_ip = 192.168.0.1
local_port = 1688
remote_port = 1688
subdomain = kms

[wayos]
type = http
local_ip = 10.198.1.1
local_port = 80
subdomain = wayos
#host_header_rewrite = 实际你内网访问的域名，可以供公网的域名不一致，如果一致可以不写

[nas]
type = http
local_ip = 192.168.0.29
local_port = 5000
subdomain = nas
#host_header_rewrite = 实际你内网访问的域名，可以供公网的域名不一致，如果一致可以不写

[nas-web]
type = http
local_ip = 192.168.0.29
local_port = 8080
subdomain = web
#host_header_rewrite = 实际你内网访问的域名，可以供公网的域名不一致，如果一致可以不写

[wol]
type = udp
local_ip = 192.168.0.29
local_port = 9
remote_port = 9
subdomain = wol

[youtube-download]
type = http
local_ip = 192.168.0.29
local_port = 328
remote_port = 328
subdomain = youtube

[ftp]
privilege_mode = true
type = tcp
local_ip = 192.168.0.29
local_port = 21
remote_port = 2121

[ftp1]
privilege_mode = true
type = tcp
local_ip = 192.168.0.29
local_port = 8815
remote_port = 8815

[ftp2]
privilege_mode = true
type = tcp
local_ip = 192.168.0.29
local_port = 8816
remote_port = 8816

[ftp3]
privilege_mode = true
type = tcp
local_ip = 192.168.0.29
local_port = 8817
remote_port = 8817

[ftp4]
privilege_mode = true
type = tcp
local_ip = 192.168.0.29
local_port = 8818
remote_port = 8818

[http_transmission]
type = http
local_ip = 192.168.0.29
local_port = 9091
use_compression = true
use_encryption = true
subdomain = tr
#custom_domains = tr.freenat.bid

[jellyfin]
type = http
local_ip = 192.168.0.29
local_port = 8096
use_compression = true
use_encryption = true
subdomain = video

[renrenyingshi]
type = http
local_ip = 192.168.0.29
local_port = 3001
subdomain = renren


[photo]
type = tcp
local_ip = 192.168.0.29
local_port = 6069
remote_port = 6069
use_compression = true
use_encryption = true
subdomain = photo

#host_header_rewrite = 实际你内网访问的域名，可以供公网的域名不一致，如果一致可以不写

# ====================
EOF

#请手动配置【外部网络 (WAN) - 端口转发 (UPnP)】开启 WAN 外网端口
cat > "/tmp/frp/myfrps.ini" <<-\EOF
# ==========服务端配置：==========
[common]
bind_port = 7000
dashboard_port = 7500
# dashboard 用户名密码，默认都为 admin
dashboard_user = admin
dashboard_pwd = admin
vhost_http_port = 88
token = 12345
subdomain_host = frps.com
max_pool_count = 50
#log_file = /dev/null
#log_level = info
#log_max_days = 3
# ====================
EOF

#启动：
frpc_enable=`nvram get frpc_enable`
frps_enable=`nvram get frps_enable`
if [ "$frpc_enable" = "1" ] ; then
    frpc -c /tmp/frp/myfrpc.ini 2>&1 &
fi
if [ "$frps_enable" = "1" ] ; then
    frps -c /tmp/frp/myfrps.ini 2>&1 &
fi
 
