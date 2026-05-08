<!--
Document : README.codex.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.0.0
Date : 2026-05-04 05:07
-->

# fw.sh

> **Version**: v13.3  
> **Date**: 2026-05-04  
> **Author**: Bruno DELNOZ <bruno.delnoz@protonmail.com>

---

## Description

This repository contains shell scripts and systemd unit files used to apply and install iptables-based firewall configurations on a Linux system.

The main operational script appears to be `fw.sh`. It builds a strict firewall policy, logs execution activity to `/var/log/firewall/iptables-fw.log`, disables IPv6, resolves or falls back to static GitHub SSH and NTP IP ranges, applies many iptables rules, and saves the resulting rules to `/etc/iptables/rules.v4`.

Several related files are also present:

- `fw.sh`: main firewall script referenced by `iptables-fw.service`.
- `fw.mitm.sh`: script present in the repository and identical to `fw.sh` at the time of inspection.
- `fw.parano.min.sh`: smaller "paranoid" firewall variant with a reduced rule set.
- `install_fw.sh`: installer for `fw.sh` and `iptables-fw.service`.
- `install_fw.parano.sh`: installer for `fw.parano.min.sh` and `iptables-fw.parano.service`.
- `iptables-fw.service`: systemd unit that runs `/usr/local/bin/fw.sh`.
- `iptables-fw.parano.service`: systemd unit that runs `/usr/local/bin/fw.parano.min.sh`.

---

## Main workflow

The normal workflow visible from the repository content is:

1. Keep the firewall script and matching systemd unit file in the repository.
2. Run an installation script from the repository directory.
3. Copy the script into `/usr/local/bin/`.
4. Copy the matching service into `/etc/systemd/system/`.
5. Reload systemd.
6. Enable the service at boot.
7. Start the service immediately.
8. Let the firewall script apply iptables rules and save them to `/etc/iptables/rules.v4`.

Two install flows are visible:

- Standard flow: `install_fw.sh` installs `fw.sh` with `iptables-fw.service`.
- Paranoid flow: `install_fw.parano.sh` installs `fw.parano.min.sh` with `iptables-fw.parano.service`.

No mode selector or CLI dispatcher was identified inside the scripts themselves.

---

## Quick start

```bash
chmod +x install_fw.sh
./install_fw.sh

chmod +x install_fw.parano.sh
./install_fw.parano.sh
```

Direct execution of the firewall scripts is also technically visible from repository content:

```bash
chmod +x fw.sh
./fw.sh

chmod +x fw.parano.min.sh
./fw.parano.min.sh
```

---

## CLI arguments

No CLI argument table can be generated from the current repository content.

---

## Generated files

| Artifact | Pattern / Location |
|---|---|
| Firewall log directory | `/var/log/firewall/` |
| Firewall log file | `/var/log/firewall/iptables-fw.log` |
| Saved iptables rules | `/etc/iptables/rules.v4` |
| Installed standard script | `/usr/local/bin/fw.sh` |
| Installed paranoid script | `/usr/local/bin/fw.parano.min.sh` |
| Installed standard service | `/etc/systemd/system/iptables-fw.service` |
| Installed paranoid service | `/etc/systemd/system/iptables-fw.parano.service` |

---

## Repository files

Important files actually present in the repository:

- `fw.sh`
- `fw.mitm.sh`
- `fw.parano.min.sh`
- `install_fw.sh`
- `install_fw.parano.sh`
- `iptables-fw.service`
- `iptables-fw.parano.service`
- `README.md`
- `README_en.md`
- `CHANGELOG.md`
- `CHANGELOG_en.md`
- `.gitignore`
- `AGENTS.md`
- `CLAUDE.md`
- `.codex`

---

## Safety notes

This repository contains privileged and system-modifying behavior:

- It modifies live iptables rules.
- It flushes existing rules and chains in multiple tables.
- It sets default `DROP` policies.
- It disables IPv6 through `sysctl`.
- It writes logs under `/var/log/firewall/`.
- It saves firewall rules to `/etc/iptables/rules.v4`.
- It installs executable scripts into `/usr/local/bin/`.
- It installs and enables systemd services under `/etc/systemd/system/`.
- It starts services immediately with `systemctl start`.
- It performs network-related lookups with `ping`, `curl`, and `dig`.
- It contains rules related to NAT, forwarding, DHCP, DNS, ICMP, GitHub SSH access, NTP, and Tailscale traffic.

---

## Current limitations

- The repository documentation currently visible is minimal and incomplete.
- No dedicated usage/help CLI was found in the scripts.
- No test suite or validation harness was identified from the current repository content.
- `fw.sh` and `fw.mitm.sh` are both present and are identical at the time of inspection, so their intended distinction is unclear from repository content alone.
- Some behavior is host-specific because interface names and addresses are hardcoded, including `eth1`, `wlan0`, `wlan1`, `wlan2`, and `tailscale0`.
- `fw.sh` and `fw.mitm.sh` contain a header version `v13.3`, but also define `VERSION="v3.0"` internally; the repository content does not clarify which version string is authoritative.
- The small installer `install_fw.parano.sh` has no header metadata or internal changelog, unlike `install_fw.sh`.
- Existing `README.md` and `README_en.md` files only document part of the repository and do not cover all present scripts.

---

## Author

Bruno DELNOZ  
bruno.delnoz@protonmail.com
