#!/bin/bash

# Auteur : Bruno DELNOZ
# Email : bruno.delnoz@protonmail.com
# Nom du script : install_fw.sh
# Target usage : Installer et configurer le firewall avec service SystemD
# Version : v1.0.3 – Date : 2026-03-17
# Changelog :
#   v1.0.3 - Correction du déploiement: mise à jour forcée des fichiers pour éviter un service obsolète (ExecStart)
#   v1.0.2 - Ajout de la vérification d'existence avant copie (pas de réécriture si déjà installé)
#   v1.0.1 - Ajout des bonnes permissions et activation du service SystemD
#   v1.0.0 - Première version

set -e

# Définir les chemins où les fichiers doivent être installés
FW_SCRIPT="/usr/local/bin/fw.sh"
SERVICE_FILE="/etc/systemd/system/iptables-fw.service"

# Copier (ou mettre à jour) le script fw.sh
if [ -f "$FW_SCRIPT" ]; then
    echo "Le script fw.sh existe déjà à $FW_SCRIPT : mise à jour du contenu en cours..."
else
    echo "Installation initiale de fw.sh dans $FW_SCRIPT..."
fi
cp ./fw.sh "$FW_SCRIPT"
echo "fw.sh copié avec succès vers $FW_SCRIPT."

# Appliquer les bons droits d'exécution
echo "Définition des droits d'exécution pour $FW_SCRIPT..."
chmod +x "$FW_SCRIPT"

# Changer le propriétaire et le groupe en root
echo "Changement de propriétaire et de groupe pour $FW_SCRIPT..."
chown root:root "$FW_SCRIPT"

# Copier (ou mettre à jour) le service iptables-fw.service
if [ -f "$SERVICE_FILE" ]; then
    echo "Le service iptables-fw.service existe déjà à $SERVICE_FILE : mise à jour du contenu en cours..."
else
    echo "Installation initiale de iptables-fw.service dans $SERVICE_FILE..."
fi
cp ./iptables-fw.service "$SERVICE_FILE"
echo "iptables-fw.service copié avec succès vers $SERVICE_FILE."

# Appliquer les bons droits sur le service
echo "Définition des droits sur le fichier de service..."
chmod 644 "$SERVICE_FILE"

# Changer le propriétaire et le groupe du service
echo "Changement de propriétaire et de groupe pour $SERVICE_FILE..."
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
systemctl status iptables-fw.service --no-pager | grep Active

echo "Installation terminée avec succès !"
