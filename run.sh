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

    ####### 安装v2raya #######

    v2raya_source=""

    v2raya_file=""

    # 先获取v2raya版本号
    version=$(curl https://api.github.com/repos/v2rayA/v2rayA/releases/latest | grep tag_name | awk -F ":" '{print $2}' | head -n 2 | sed 's/\"//g;s/,//g;s/ //g;s/v//g')

    echo_green "找v2raya最新到版本号为 ${version}"

    if [ $arch = "x86_64" ] || [ $arch = "amd64" ]; then
        v2raya_source="https://ghproxy.com/github.com/v2rayA/v2rayA/releases/download/v${version}/v2raya_linux_x64_${version}"
        v2raya_file=v2raya_linux_x64_${version}
    elif [ $arch = "aarch64" ]; then
        v2raya_source="https://ghproxy.com/github.com/v2rayA/v2rayA/releases/download/v${version}/v2raya_linux_arm64_${version}"
        v2raya_file=v2raya_linux_x64_${version}
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

    ####### 安装 xray-core #######
fi
