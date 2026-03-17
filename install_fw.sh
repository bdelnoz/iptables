#!/bin/bash

# Auteur : Bruno DELNOZ
# Email : bruno.delnoz@protonmail.com
# Nom du script : install_fw.sh
# Target usage : Installer et configurer le firewall avec service SystemD
# Version : v1.0.3 – Date : 2026-03-17
# Changelog :
#   v1.0.3 - Correction de synchronisation des fichiers installés (mise à jour si le contenu local change), correction bug de chemin ExecStart via le service installé
#   v1.0.2 - Ajout de la vérification d'existence avant copie (pas de réécriture si déjà installé)
#   v1.0.1 - Ajout des bonnes permissions et activation du service SystemD
#   v1.0.0 - Première version

set -e

# Définir les chemins où les fichiers doivent être installés
FW_SCRIPT="/usr/local/bin/fw.sh"
SERVICE_FILE="/etc/systemd/system/iptables-fw.service"

sync_file() {
    local src="$1"
    local dst="$2"
    local label="$3"

    if [ ! -f "$src" ]; then
        echo "Erreur : fichier source manquant: $src"
        exit 1
    fi

    if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
        echo "$label déjà à jour dans $dst."
    else
        echo "Mise à jour de $label vers $dst..."
        cp "$src" "$dst"
        echo "$label synchronisé avec succès."
    fi
}

# Synchroniser le script firewall
sync_file ./fw.sh "$FW_SCRIPT" "Le script fw.sh"

# Appliquer les bons droits d'exécution
chmod +x "$FW_SCRIPT"
chown root:root "$FW_SCRIPT"

# Synchroniser le fichier service
sync_file ./iptables-fw.service "$SERVICE_FILE" "Le service iptables-fw.service"

# Appliquer les bons droits sur le service
chmod 644 "$SERVICE_FILE"
chown root:root "$SERVICE_FILE"

# Recharger les fichiers de configuration SystemD
echo "Rechargement des fichiers de configuration SystemD..."
systemctl daemon-reload

# Activer le service pour qu'il se lance au démarrage
echo "Activation du service iptables-fw.service au démarrage..."
systemctl enable iptables-fw.service

# Démarrer (ou redémarrer) le service immédiatement
echo "Redémarrage du service iptables-fw.service..."
systemctl restart iptables-fw.service

# Vérification de l'état du service
echo "Vérification de l'état du service iptables-fw..."
systemctl status iptables-fw.service | grep Active

echo "Installation terminée avec succès !"
