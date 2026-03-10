#!/bin/bash
set -e

LOG_DIR="/var/log/firewall"
LOG_FILE="/var/log/firewall/iptables-fw.log"
RULES_FILE="/etc/iptables/rules.v4"

DNS_SERVERS=(
  "1.1.1.1"
  "1.0.0.1"
  "8.8.8.8"
  "8.8.4.4"
)

NTP_SERVERS=(
  "91.189.89.198"
  "91.189.89.199"
  "185.125.190.36"
)

mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1 || true
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1 || true

iptables -t filter -F
iptables -t filter -X
iptables -t filter -Z

iptables -t nat -F
iptables -t nat -X

iptables -t mangle -F
iptables -t mangle -X

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A INPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A OUTPUT -p udp --sport 67:68 --dport 67:68 -j ACCEPT
iptables -A INPUT -p udp --sport 67:68 --dport 67:68 -j ACCEPT

for dns in "${DNS_SERVERS[@]}"; do
    iptables -A OUTPUT -p udp -d "$dns" --dport 53 -j ACCEPT
done

iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT

for ntp in "${NTP_SERVERS[@]}"; do
    iptables -A OUTPUT -p udp -d "$ntp" --dport 123 -j ACCEPT
done

iptables -A INPUT -p icmp -j DROP
iptables -A OUTPUT -p icmp -j DROP

iptables -A OUTPUT -p tcp --dport 80 -j DROP
iptables -A OUTPUT -p tcp --dport 22 -j DROP

iptables -A OUTPUT -p tcp --dport 5228 -j DROP
iptables -A OUTPUT -p udp --dport 5228 -j DROP

iptables -N LOGGING_IN 2>/dev/null || true
iptables -N LOGGING_OUT 2>/dev/null || true

iptables -F LOGGING_IN
iptables -F LOGGING_OUT

iptables -A LOGGING_IN -m limit --limit 5/min -j LOG --log-prefix "IPTables-Blocked-IN: "
iptables -A LOGGING_IN -j DROP

iptables -A LOGGING_OUT -m limit --limit 5/min -j LOG --log-prefix "IPTables-Blocked-OUT: "
iptables -A LOGGING_OUT -j DROP

iptables -A INPUT -j LOGGING_IN
iptables -A OUTPUT -j LOGGING_OUT

mkdir -p /etc/iptables
iptables-save > "$RULES_FILE"

echo "Firewall parano applied"
