
---

### `CHANGELOG.md` (English)

```markdown
# Changelog

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
