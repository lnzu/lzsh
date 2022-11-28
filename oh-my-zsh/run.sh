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
if [ -f "/usr/share/oh-my-zsh/oh-my-zsh.sh" ]; then
    echo -e "已安装 on-my-zsh"
else
    echo_red "未安装 on-my-zsh"
fi

echo_blue "1.安装"
echo_blue "2.卸载"
echo "--------------------"
read -p "请输入数字：" input

if [ "$input" = 1 ]; then
    wget https://ghproxy.com/raw.githubusercontent.com/lnzu/lzsh/main/oh-my-zsh/oh-my-zsh.tar.gz
    tar -zxvf oh-my-zsh.tar.gz -C /usr/share/
    echo "you should copy the \"/usr/share/oh-my-zsh/zshrc\" to your home \".zshrc\""
    echo_green "安装完毕"
elif [ "$input" = 2 ]; then
    rm -rf /usr/share/oh-my-zsh/
    echo_green '卸载完成'
fi