#!/bin/bash

# 定义目标域名
DOMAIN="nas.oklai.top"

# 定义保存IP地址的文件路径
IP_FILE="/root/${DOMAIN}.txt"

# 定义目标端口
PORT="22"

# 获取当前的IP地址
CURRENT_IP=$(dig +short $DOMAIN)

# 如果保存IP地址的文件不存在，则创建并写入当前IP地址
if [ ! -f $IP_FILE ]; then
    echo $CURRENT_IP > $IP_FILE
fi

# 读取之前保存的IP地址
PREVIOUS_IP=$(cat $IP_FILE)

# 检查当前IP地址是否与之前保存的IP地址相同
if [ "$CURRENT_IP" != "$PREVIOUS_IP" ]; then
    echo "IP地址已更改，旧IP: $PREVIOUS_IP, 新IP: $CURRENT_IP"

    # 从sudo ufw中删除旧的IP规则
    sudo ufw delete allow from $PREVIOUS_IP to any port $PORT comment "$DOMAIN"

    # 添加新的IP规则
    sudo ufw allow from $CURRENT_IP to any port $PORT comment "$DOMAIN"

    # 将新的IP地址写入文件
    echo $CURRENT_IP > $IP_FILE

    echo "已更新IP地址并更新了sudo ufw规则。"
else
    echo "IP地址未更改，无需更新。"
fi
