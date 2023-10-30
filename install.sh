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

# 先获取系统架构“arch”
arch=$(uname -m)
# 获取系统发行版
distributor=$(cat /etc/issue | awk -F " " '{print $1}')

# -----------------------------------------------------------

# 输出提示信息
echo -e "\n---------------------------------"
echo -e '''* 本脚本私人使用,输入数字进行操作'''
# echo_red "* 注意：当前系统架构 ${arch} 发行版 ${distributor}"
echo -e "* 注意：当前系统架构 \e[34m${arch}\e[0m 发行版 \e[34m${distributor}\e[0m"

echo "* 输入对应数字进行操作"
echo -e "---------------------------------" #
echo_blue "1.v2raya"
echo_blue "2.alist"
echo_blue "3.oh-my-zsh"

echo -e "\n"

read -p "请输入数字：" input

########################################## 安装逻辑部分 ###########################################

##### v2raya 相关
if [ "$input" = 1 ]; then
    bash <(curl https://gh-proxy.com/raw.githubusercontent.com/lnzu/lzsh/main/v2raya/run.sh)
elif [ "$input" = 2 ]; then
    bash <(curl https://gh-proxy.com/raw.githubusercontent.com/lnzu/lzsh/main/alist/run.sh)
elif [ "$input" = 3 ] ; then
    bash <(curl https://gh-proxy.com/raw.githubusercontent.com/lnzu/lzsh/main/oh-my-zsh/run.sh)
fi
