#!/bin/bash

# Auteur : Bruno DELNOZ
# Email : bruno.delnoz@protonmail.com
# Nom du script : install_fw.sh
# Target usage : Installer et configurer le firewall avec service SystemD
# Version : v1.0.2 – Date : 2025-10-08
# Changelog :
#   v1.0.2 - Ajout de la vérification d'existence avant copie (pas de réécriture si déjà installé)
#   v1.0.1 - Ajout des bonnes permissions et activation du service SystemD
#   v1.0.0 - Première version

# Définir les chemins où les fichiers doivent être installés
FW_SCRIPT="/usr/local/bin/fw.sh"
SERVICE_FILE="/etc/systemd/system/iptables-fw.service"

# Vérifier si le fichier fw.sh existe déjà
if [ -f "$FW_SCRIPT" ]; then
    echo "Le script fw.sh existe déjà à l'emplacement $FW_SCRIPT. Aucune action n'est nécessaire."
else
    # Copier le script fw.sh au bon endroit
    echo "Copie du script fw.sh dans $FW_SCRIPT..."
    cp ./fw.sh $FW_SCRIPT
    if [ $? -eq 0 ]; then
        echo "fw.sh copié avec succès à $FW_SCRIPT."
    else
        echo "Erreur lors de la copie de fw.sh. Abandon."
        exit 1
    fi
fi

# Appliquer les bons droits d'exécution
echo "Définition des droits d'exécution pour $FW_SCRIPT..."
chmod +x $FW_SCRIPT

# Changer le propriétaire et le groupe en root (si nécessaire)
echo "Changement de propriétaire et de groupe pour $FW_SCRIPT..."
chown root:root $FW_SCRIPT

# Vérifier si le service existe déjà
if [ -f "$SERVICE_FILE" ]; then
    echo "Le service iptables-fw.service est déjà présent à $SERVICE_FILE. Aucune action n'est nécessaire."
else
    # Copier le service iptables-fw.service
    echo "Copie du service iptables-fw.service dans $SERVICE_FILE..."
    cp ./iptables-fw.service $SERVICE_FILE
    if [ $? -eq 0 ]; then
        echo "iptables-fw.service copié avec succès à $SERVICE_FILE."
    else
        echo "Erreur lors de la copie du service iptables-fw.service. Abandon."
        exit 1
    fi
fi

# Appliquer les bons droits sur le service
echo "Définition des droits sur le fichier de service..."
chmod 644 $SERVICE_FILE

# Changer le propriétaire et le groupe du service en root (si nécessaire)
echo "Changement de propriétaire et de groupe pour $SERVICE_FILE..."
chown root:root $SERVICE_FILE

# Recharger les fichiers de configuration SystemD
echo "Rechargement des fichiers de configuration SystemD..."
systemctl daemon-reload

# Activer le service pour qu'il se lance au démarrage
echo "Activation du service iptables-fw.service au démarrage..."
systemctl enable iptables-fw.service

# Démarrer le service immédiatement
echo "Démarrage du service iptables-fw.service..."
systemctl start iptables-fw.service

# Vérification de l'état du service
echo "Vérification de l'état du service iptables-fw..."
systemctl status iptables-fw.service | grep Active

echo "Installation terminée avec succès !"
