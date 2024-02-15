#!/bin/bash

# 检查 expect 是否已安装，如果没有，则安装
if ! command -v expect &> /dev/null
then
    echo "expect 未找到，正在尝试安装..."
    # 添加 -y 参数以自动确认安装
    sudo yum install -y expect
    if [ $? -ne 0 ]; then
        echo "安装 expect 失败，请检查您的 yum 配置或网络连接。"
        exit 1
    fi
fi

# 使用 Heredoc 语法提供 expect 脚本内容
/usr/bin/expect <<'END_EXPECT'
set timeout 300

# 下载安装脚本
spawn wget -N https://gitlab.com/rwkgyg/x-ui-yg/raw/main/install.sh

# 等待下载完成
expect "saved"

# 运行下载的脚本
spawn bash install.sh

# 处理安装脚本的菜单选项
expect "Total download "
send "y\r"

# 处理安装脚本的菜单选项
expect "请输入数字"
send "1\r"

# 是否开放端口，关闭防火墙？
expect "是否开放端口，关闭防火墙？"
send "1\r"

# 等待用户名提示
expect "设置x-ui登录用户"
send "admin1\r"

# 等待密码提示
expect "设置x-ui登录密"
send "admin1\r"

# 端口提示
expect "设置x-ui登录端"
send "54321\r"

# 安装完成后，设置防火墙规则
expect eof
spawn iptables -I INPUT -p tcp --dport 443 -j ACCEPT
expect eof
END_EXPECT