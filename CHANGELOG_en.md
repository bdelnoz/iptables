# Changelog

## v1.0.3 (2026-03-17)
- Fixed `ExecStart` path in `iptables-fw.service` (`/usr/local/bin/fw.sh`).
- `install_fw.sh` now updates installed files when local content changes (instead of skipping existing files).
- Switched to `systemctl restart` after synchronization so service updates are applied immediately.

## v1.0.2 (2025-10-08)
- Added existence check before copying (no overwrite if already installed).
- Copied and updated permissions for `fw.sh` and `iptables-fw.service` files.
- Enabled `iptables-fw.service` to start automatically on boot.

## v1.0.1 (2025-09-30)
- Added permissions management for `fw.sh` and `iptables-fw.service` files.
- Enabled the service with `systemctl enable`.
- Started the service immediately after installation.

## v1.0.0 (2025-09-25)
- Initial stable version of the firewall installation script.
- Integrated SystemD service to manage firewall startup on boot.
