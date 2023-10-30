#!/bin/bash
# ------------------- 开头配置 ----------------------------
clear
echo_red() {
    echo -e "\e[31m$1\e[0m"
}
echo_green() {
    echo -e "\e[32m$1\e[0m"
}
echo_blue() {
    echo -e "\e[34m$1\e[0m"
}

proxy="https://gh-proxy.com"
# 先获取系统架构“arch”
arch=$(uname -m)
# 获取系统发行版
distributor=$(cat /etc/issue | awk -F " " '{print $1}')
# -----------------------------------------------------------

echo "------ alist ------"
if [ -f "/usr/local/alist/alist" ]; then
    alist_version=$(/usr/local/alist/alist version)
    echo -e "已安装 alist: \e[32m${alist_version}\e[0m"
else
    echo_red "未安装 alist"
fi

echo_blue "1.升级安装"
echo_blue "2.卸载"
echo "--------------------"
read -p "请输入数字：" input

if [ "$input" = 1 ]; then
    # -------- 安装 alist ----------#
    alist_source=""
    alist_file=""
    # 先获取alist版本号
    alist_v=$(curl https://api.github.com/repos/alist-org/alist/releases/latest | grep tag_name | awk -F ":" '{print $2}' | head -n 2 | sed 's/\"//g;s/,//g;s/ //g;s/v//g')
    echo_green "找到 alist 最新到版本 ${alist_v}"
    if [ $arch = "x86_64" ] || [ $arch = "amd64" ]; then

        alist_source="${proxy}/github.com/alist-org/alist/releases/download/v${alist_v}/alist-linux-amd64.tar.gz"

        alist_file=alist-linux-amd64.tar.gz

    elif [ $arch = "aarch64" ]; then
        alist_source="${proxy}/github.com/alist-org/alist/releases/download/v${alist_v}/alist-linux-arm64.tar.gz"

        alist_file=alist-linux-arm64.tar.gz
    fi
    # 判断下载的alist二进制文件是否存在，不存在则下载
    if [ ! -f "$alist_file" ]; then
        wget $alist_source
    fi

    # 若有服务文件先停止服务
    if [ -f "/etc/systemd/system/alist.service" ]; then
        systemctl stop alist
        systemctl disable alist
    fi

    # 写入启动文件
    cat >/etc/systemd/system/alist.service << EOF
[Unit]
Description=alist
After=network.target

[Service]
Type=simple
WorkingDirectory=/usr/local/alist/
ExecStart=bash -c "/usr/local/alist/alist admin && /usr/local/alist/alist server"
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    ## 安装
    mkdir -p /usr/local/alist/
    tar -zxvf ${alist_file} -C /usr/local/alist/
    chmod +x /usr/local/alist/alist
    rm -rf ${alist_file}

    # 开启 alist 自启动
    systemctl daemon-reload
    systemctl enable alist
    systemctl start alist

    echo_green "alist 安装完毕"

elif [ "$input" = 2 ]; then
    systemctl stop alist.service
    systemctl disable alist.service
    rm -rf /usr/local/alist 
    rm -rf /etc/systemd/system/alist.service
    systemctl daemon-reload
    echo_green 'alist 卸载完成'
fi
