# iptables
# Installation du Firewall avec SystemD

Ce script permet d'installer et de configurer un firewall strict avec un service SystemD pour gérer les règles de firewall.

### Fichiers inclus
1. **fw.sh** : Le script qui définit les règles de firewall avec `iptables`.
2. **iptables-fw.service** : Le fichier de service SystemD pour gérer l'exécution du script `fw.sh` au démarrage.
3. **install_fw.sh** : Le script d'installation qui copie les fichiers nécessaires, applique les permissions et configure le service.

### Prérequis
- Un système basé sur Linux avec `iptables` installé.
- Un accès `sudo` pour installer et configurer le service.
- Le service `SystemD` doit être activé sur la machine.

### Installation

1. Téléchargez tous les fichiers nécessaires dans un répertoire.
2. Rendez le script `install_fw.sh` exécutable :
   ```bash
   chmod +x install_fw.sh
