
---

### `CHANGELOG.md`

```markdown
# Changelog

## v1.0.2 (2025-10-08)
- Ajout de la vérification d'existence avant copie (pas de réécriture si déjà installé).
- Copie et mise à jour des permissions des fichiers `fw.sh` et `iptables-fw.service`.
- Activation du service `iptables-fw.service` pour le démarrage automatique au boot.

## v1.0.1 (2025-09-30)
- Ajout de la gestion des droits sur les fichiers (`fw.sh` et `iptables-fw.service`).
- Activation du service avec `systemctl enable`.
- Démarrage immédiat du service après installation.

## v1.0.0 (2025-09-25)
- Première version stable du script d'installation avec le firewall strict.
- Intégration du service `SystemD` pour gérer le lancement du firewall au démarrage.
