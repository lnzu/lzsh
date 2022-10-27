#!/bin/bash
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

# 输出提示信息
echo -e "\n---------------------------------"
echo -e '''* 本脚本私人使用,输入数字进行操作'''
# echo_red "* 注意：当前系统架构 ${arch} 发行版 ${distributor}"
echo -e "* 注意：当前系统架构 \e[34m${arch}\e[0m 发行版 \e[34m${distributor}\e[0m"

echo "* 输入对应数字进行操作"
echo -e "---------------------------------"
echo_blue "1.v2raya"

echo -e "\n"

read -p "请输入数字：" input

if [ $input = 1 ]; then

    # -------- 安装 v2raya ----------#

    v2raya_source=""

    v2raya_file=""

    # 先获取v2raya版本号
    v2raya_v=$(curl https://api.github.com/repos/v2rayA/v2rayA/releases/latest | grep tag_name | awk -F ":" '{print $2}' | head -n 2 | sed 's/\"//g;s/,//g;s/ //g;s/v//g')

    echo_green "找v2raya最新到版本号为 ${v2raya_v}"

    if [ $arch = "x86_64" ] || [ $arch = "amd64" ]; then
        v2raya_source="${proxy}/github.com/v2rayA/v2rayA/releases/download/v${v2raya_v}/v2raya_linux_x64_${v2raya_v}"
        v2raya_file=v2raya_linux_x64_${v2raya_v}
    elif [ $arch = "aarch64" ]; then
        v2raya_source="${proxy}/github.com/v2rayA/v2rayA/releases/download/v${v2raya_v}/v2raya_linux_arm64_${v2raya_v}"
        v2raya_file=v2raya_linux_x64_${v2raya_v}
    fi

    # 判断下载的v2raya二进制文件是否存在，不存在则下载
    if [ ! -f "$v2raya_file" ]; then
        echo -e "下载v2raya二进制文件到 $PWD/${v2raya_file}"

        wget $v2raya_source
    fi

    mv ./${v2raya_file} /usr/local/bin/v2raya

    # 写入启动文件
    cat >/etc/systemd/system/v2raya.service <<EOF
[Unit]
After=default.target

[Service]
ExecStart=/usr/local/bin/v2raya --address 0.0.0.0:2017

[Install]
WantedBy=default.target
EOF

    chmod +x /usr/local/bin/*

    echo_green "v2raya 已安装，准备安装 xray-core"

    # -------- 安装 xray-core ----------#

    xray_source=""

    xray_loacal_file=""

    xray_version=$(grep 'tag_name' temp | awk -F ',' '{print $26}' | awk -F ':' '{print $2}' | sed "s/\"//g")

    if [ "$arch" = 'x86_64' ] || [ "$arch" = 'amd64' ]; then

        xray_source="${proxy}/https://github.com/XTLS/Xray-core/releases/download/${xray_version}/Xray-linux-64.zip"

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

fi
