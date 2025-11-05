# Firewall Installation with SystemD

This script installs and configures a strict firewall with a SystemD service to manage the firewall rules.

### Included Files
1. **fw.sh**: The script that defines firewall rules using `iptables`.
2. **iptables-fw.service**: The SystemD service file to manage the execution of `fw.sh` at startup.
3. **install_fw.sh**: The installation script that copies necessary files, applies permissions, and configures the service.

### Prerequisites
- A Linux-based system with `iptables` installed.
- `sudo` access to install and configure the service.
- SystemD service manager must be enabled on the system.

### Installation

1. Download all necessary files into a directory.
2. Make the `install_fw.sh` script executable:
   ```bash
   chmod +x install_fw.sh
