<!--
Document : WHY.codex.md
Author : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.0.0
Date : 2026-05-04 05:07
-->

# Why this project exists

This repository exists to keep reusable firewall scripts and matching systemd service files together so that a Linux host can install and apply predefined iptables policies in a repeatable way.

The main script appears to be `fw.sh`, because `install_fw.sh` installs it into `/usr/local/bin/fw.sh` and `iptables-fw.service` starts it through systemd. Its purpose is to build a strict firewall, preserve selected connectivity, log execution, and persist the resulting rules.

The repository also contains a smaller alternative, `fw.parano.min.sh`, with its own installer and service. A second large script, `fw.mitm.sh`, is also present and is identical to `fw.sh` at the time of inspection, but its distinct operational role is unclear from repository content alone.

---

## Main goals

- Apply a predefined iptables firewall configuration on a Linux system.
- Make firewall activation repeatable through shell scripts.
- Persist firewall startup through systemd services.
- Save resulting iptables rules to `/etc/iptables/rules.v4`.
- Log firewall execution activity under `/var/log/firewall/`.
- Support at least one strict firewall profile and one smaller paranoid profile.
- Preserve specific network paths that are explicitly encoded in the scripts, including DNS, NTP, DHCP, forwarding, NAT, and Tailscale-related traffic.

---

## Operational value

The repository provides operational value by turning firewall setup into files that can be inspected, rerun, and installed again.

It improves repeatability because the same scripts can be used to reapply the same rules instead of entering iptables commands manually.

It improves traceability because the main firewall script writes to a dedicated log file and because the repository includes changelog files and version headers in at least part of the content.

It improves automation because installation scripts copy the firewall assets into system locations, reload systemd, enable the service at boot, and start it immediately.

It has system administration and security value because it centralizes firewall policy, default-drop behavior, IPv6 disabling, service startup behavior, and saved rules persistence in one repository.

It has diagnostic value because the main script records execution events and contains connectivity checks with fallbacks for GitHub and NTP IP handling.

---

## Design intent

The repository is structured around executable shell scripts plus systemd unit files.

The visible separation is:

- main firewall logic in `fw.sh`;
- an additional large firewall script in `fw.mitm.sh`;
- a smaller firewall profile in `fw.parano.min.sh`;
- installation wrappers in `install_fw.sh` and `install_fw.parano.sh`;
- boot-time execution definitions in `iptables-fw.service` and `iptables-fw.parano.service`.

This layout suggests an intent to separate rule definition from installation and service management.

Log and output paths are explicit in the scripts:

- `/var/log/firewall/iptables-fw.log`
- `/etc/iptables/rules.v4`

No dry-run or simulation mode was identified from the inspected repository content.

Visible safety controls include explicit logging, fallback behavior for some network lookups, and saved rule persistence. The repository also contains very strong system-level actions, so these controls reduce uncertainty only partially.

---

## Safety rationale

This repository includes privileged and potentially disruptive behavior:

- It alters active firewall rules.
- It flushes existing iptables tables and chains.
- It enforces default `DROP` policies.
- It disables IPv6 through `sysctl`.
- It enables and starts systemd services.
- It writes into `/usr/local/bin/`, `/etc/systemd/system/`, `/etc/iptables/`, and `/var/log/firewall/`.
- It contains forwarding and NAT rules.
- It includes traffic allowances for DNS, DHCP, NTP, GitHub SSH ranges, and Tailscale-related traffic.

The apparent rationale is to keep these risky operations scripted and consistent rather than manual.

---

## Current scope

The repository currently covers iptables-based firewall application and installation on Linux through shell scripts and systemd unit files.

It currently includes:

- one main strict firewall script used by the standard installer;
- one smaller paranoid firewall script used by a dedicated installer;
- one additional large firewall script whose distinct role is unclear from repository content alone;
- minimal existing README and changelog files.

The repository is not empty, but its documentation is still limited compared with the amount of shell logic present.

---

## Non-goals

No explicit non-goals were identified from the inspected repository content.
