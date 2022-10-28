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

proxy="https://ghproxy.com"
# 先获取系统架构“arch”
arch=$(uname -m)
# 获取系统发行版
distributor=$(cat /etc/issue | awk -F " " '{print $1}')
# -----------------------------------------------------------

echo "------ v2raya ------"
if [ -f "/usr/local/bin/v2raya" ] && [ -f "/usr/local/bin/xray" ]; then
    v2_version=$(v2raya --version)
    xray_version=$(xray -version | awk -F " " '{print $2}' | sed "2s/.//g")
    echo -e "已安装 v2raya: \e[32m${v2_version}\e[0m"
    echo -e "已安装 xray: \e[32m${xray_version}\e[0m"
else
    echo_red "未安装 v2raya xray"
fi

echo_blue "1.升级安装"
echo_blue "2.卸载"
echo "--------------------"
read -p "请输入数字：" input

if [ "$input" = 1 ]; then
    # -------- 安装 v2raya ----------#
    v2raya_source=""
    v2raya_file=""
    # 先获取v2raya版本号
    v2raya_v=$(curl https://api.github.com/repos/v2rayA/v2rayA/releases/latest | grep tag_name | awk -F ":" '{print $2}' | head -n 2 | sed 's/\"//g;s/,//g;s/ //g;s/v//g')
    echo_green "找到 v2raya 最新到版本 ${v2raya_v}"
    if [ $arch = "x86_64" ] || [ $arch = "amd64" ]; then
        v2raya_source="${proxy}/github.com/v2rayA/v2rayA/releases/download/v${v2raya_v}/v2raya_linux_x64_${v2raya_v}"
        v2raya_file=v2raya_linux_x64_${v2raya_v}
    elif [ $arch = "aarch64" ]; then
        v2raya_source="${proxy}/github.com/v2rayA/v2rayA/releases/download/v${v2raya_v}/v2raya_linux_arm64_${v2raya_v}"
        v2raya_file=v2raya_linux_arm64_${v2raya_v}
    fi
    # 判断下载的v2raya二进制文件是否存在，不存在则下载
    if [ ! -f "$v2raya_file" ]; then
        wget $v2raya_source
    fi
    mv ${v2raya_file} /usr/local/bin/v2raya
    # 若有服务文件先停止服务
    if [ -f "/etc/systemd/system/v2raya.service" ]; then
        systemctl stop v2raya
        systemctl disable v2raya
    fi
    # 写入启动文件
    cat >/etc/systemd/system/v2raya.service <<EOF
[Unit]
After=default.target
[Service]
ExecStart=/usr/local/bin/v2raya --address 0.0.0.0:2017
[Install]
WantedBy=default.target
EOF
    echo_green "v2raya 已安装完毕，准备安装 xray-core"
    # -------- 安装 xray-core ----------#
    xray_source=""
    xray_loacal_file=""
    curl https://api.github.com/repos/XTLS/Xray-core/releases/latest >temp
    xray_version=$(grep 'tag_name' temp | awk -F ',' '{print $26}' | awk -F ':' '{print $2}' | sed "s/\"//g")
    echo_green "查询到 xray-core 最新版本 ${xray_version}"
    rm -rf temp
    if [ "$arch" = 'x86_64' ] || [ "$arch" = 'amd64' ]; then
        xray_source="${proxy}/github.com/XTLS/Xray-core/releases/download/${xray_version}/Xray-linux-64.zip"
        xray_loacal_file="Xray-linux-64.zip"
    elif
        [ "$arch" = "aarch64" ]
    then
        xray_source="${proxy}/github.com/XTLS/Xray-core/releases/download/${xray_version}/Xray-linux-arm64-v8a.zip"
        xray_loacal_file="Xray-linux-arm64-v8a.zip"
    fi
    if [ ! -f "$xray_loacal_file" ]; then
        wget $xray_source
    fi
    rm -rf tem/
    mkdir tem/
    unzip $xray_loacal_file -d tem/
    mkdir -p /usr/local/share/xray/
    mv tem/ge* /usr/local/share/xray/
    mv tem/xray /usr/local/bin/
    chmod +x /usr/local/bin/*
    rm -rf tem/ $xray_loacal_file
    ## 此时已安装成功
    ## 开启 v2raya 自启动
    systemctl daemon-reload
    systemctl enable v2raya
    systemctl start v2raya
    echo_green "v2raya xray-core 安装完毕"

elif [ "$input" = 2 ]; then
    systemctl stop v2raya.service
    systemctl disable v2raya.service
    systemctl daemon-reload
    rm -rf /usr/local/bin/v2raya /usr/local/bin/xray /usr/local/share/xray/ /etc/systemd/system/v2raya.service
    rm -rf /etc/v2raya/
    rm -rf /run/user/0/v2raya
    echo_green 'v2raya && xray 卸载完成'
fi