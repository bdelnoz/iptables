<!--
Document : README.md (iptables firewall + service SystemD)
Auteur : Bruno DELNOZ
Email : bruno.delnoz@protonmail.com
Version : v1.1.0
Date : 2026-03-17 00:00
-->
# iptables - Installation du Firewall avec SystemD

Ce dépôt fournit un pare-feu `iptables` strict et un service SystemD qui applique automatiquement les règles au démarrage.

## Contenu du dépôt

1. `fw.sh` : script principal qui applique les règles firewall.
2. `iptables-fw.service` : unité SystemD lancée au boot.
3. `install_fw.sh` : script d'installation/mise à jour (copie, permissions, activation, redémarrage du service).
4. `CHANGELOG.md` et `CHANGELOG_en.md` : historique des versions.

## Prérequis

- Linux avec `systemd`
- `iptables`
- `sudo` / privilèges root
- Dépendances utilisées par `fw.sh` : `jq`, `curl`, `dig`

## Correctif important (bug service)

Le service SystemD est désormais aligné avec le chemin d'installation réel du script :

- **Chemin exécuté par SystemD** : `/usr/local/bin/fw.sh`
- **Chemin d'installation par `install_fw.sh`** : `/usr/local/bin/fw.sh`

Cela évite l'erreur précédente liée à un décalage de chemin (`/root/fw.sh`).

## Installation / mise à jour

Depuis le dossier du dépôt :

```bash
chmod +x install_fw.sh
sudo ./install_fw.sh
```

Le script :

- synchronise `fw.sh` et `iptables-fw.service` si le contenu local a changé,
- applique les permissions,
- recharge SystemD,
- active le service au démarrage,
- redémarre le service immédiatement.

## Vérifications après installation

```bash
systemctl status iptables-fw.service
systemctl cat iptables-fw.service
journalctl -u iptables-fw.service -n 100 --no-pager
```

Vérifier en particulier :

- `ExecStart=/usr/local/bin/fw.sh`
- état du service : `active (exited)`

## Exécution manuelle (debug)

Pour tester le script sans passer par SystemD :

```bash
sudo /usr/local/bin/fw.sh
```

## Fichiers installés

- Script : `/usr/local/bin/fw.sh`
- Service : `/etc/systemd/system/iptables-fw.service`
- Logs firewall (selon `fw.sh`) : `/var/log/firewall/iptables-fw.log`

## Notes

- Le script firewall applique une politique restrictive ; valider l'accès distant avant déploiement sur une machine de production.
- En cas de modification du service, toujours faire :

```bash
sudo systemctl daemon-reload
sudo systemctl restart iptables-fw.service
```
