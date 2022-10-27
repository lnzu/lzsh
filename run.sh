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
arch=`uname -m`
# 获取系统发行版
distributor=`cat /etc/issue | awk -F " " '{print $1}'`

# 输出提示信息
echo -e "\n---------------------------------"
echo -e '''* 本脚本私人使用,输入数字进行操作'''
# echo_red "* 注意：当前系统架构 ${arch} 发行版 ${distributor}"
echo -e "* 注意：当前系统架构 \e[34m${arch}\e[0m 发行版 \e[34m${distributor}\e[0m"


echo "* 输入对应数字进行操作"
echo -e "---------------------------------"
echo_blue "1.v2raya"

echo -e "\n"




# read -p "请输入数字：" input

# if [ $input = 1 ]; then

    



#     # version=`curl https://api.github.com/repos/v2rayA/v2rayA/releases/latest | grep tag_name | awk -F ":" '{print $2}' | head -n 2 | sed 's/\"//g;s/,//g;s/ //g;s/v//g'`
#     # v2raya_source="https://github.com/v2rayA/v2rayA/releases/download/v${version}/v2raya_linux_arm64_${version}"

#     # echo "正在从 $v2raya_source 下载v2raya二进制文件 "

#     # wget $v2raya_source

    
# fi

wget https://ghproxy.com/raw.githubusercontent.com/v2rayA/v2rayA/feat_v5/Dockerfile