#!/bin/bash

FW_SCRIPT="/usr/local/bin/fw.parano.min.sh"
SERVICE_FILE="/etc/systemd/system/iptables-fw.parano.service"

cp ./fw.parano.min.sh "$FW_SCRIPT"

chmod +x "$FW_SCRIPT"
chown root:root "$FW_SCRIPT"

cp ./iptables-fw.parano.service "$SERVICE_FILE"

chmod 644 "$SERVICE_FILE"
chown root:root "$SERVICE_FILE"

systemctl daemon-reload
systemctl enable iptables-fw.parano.service
systemctl start iptables-fw.parano.service

systemctl is-active iptables-fw.parano.service
