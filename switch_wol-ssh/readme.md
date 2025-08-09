# Switch Wake-on-LAN + SSH Shutdown pour Home Assistant

Ce projet permet de créer un switch dans Home Assistant pour allumer (Wake-on-LAN) et éteindre (SSH shutdown) une machine Linux distante.

## 📋 Prérequis

### Sur la machine Linux cible :
- Wake-on-LAN activé dans le BIOS/UEFI
- Wake-on-LAN activé sur l'interface réseau
- SSH activé et configuré
- Utilisateur avec droits sudo pour shutdown (ou utilisation de root)

### Sur Home Assistant :
- Add-on Terminal & SSH installé
- Accès au répertoire `/config/`

## 🔧 Installation

### 1. Configuration SSH

#### Générer une paire de clés SSH (si nécessaire)
```bash
# Sur Home Assistant, via Terminal & SSH
ssh-keygen -t rsa -b 4096 -f /config/.ssh/id_rsa
```

#### Copier la clé publique vers la machine cible
```bash
# Copier la clé publique vers la machine Linux
ssh-copy-id -i /config/.ssh/id_rsa.pub root@IP_MACHINE_LINUX
```

#### Vérifier la connexion SSH
```bash
ssh -i /config/.ssh/id_rsa root@IP_MACHINE_LINUX
```

### 2. Configuration des fichiers

#### Créer le script de shutdown
Créer le fichier `/config/shutdown_linux.sh` :

```bash
#!/bin/bash
/usr/bin/ssh -i /config/.ssh/id_rsa -o StrictHostKeyChecking=no -o ConnectTimeout=10 root@IP_MACHINE_LINUX'/sbin/shutdown -h now'
```

Rendre le script exécutable :
```bash
chmod +x /config/shutdown_linux.sh
```

#### Configuration des fichiers YAML

Deux options sont disponibles :

##### Option 1 : Configuration dans configuration.yaml
Ajouter directement dans `/config/configuration.yaml` :

```yaml
# Switch ON/OFF pour machine Linux (Wake-on-LAN + SSH shutdown)
switch:
  - platform: wake_on_lan
    mac: "XX:XX:XX:XX:XX:XX"  # Adresse MAC de votre machine Linux
    name: "Linux Server"
    host: "192.XXX.XXX.XXX"     # Adresse IP de votre machine Linux
    broadcast_address: "192.XXX.XXX.255"  # Adresse broadcast de votre réseau
    turn_off:
      service: shell_command.shutdown_linux

# Commande shell pour éteindre la machine Linux via SSH
shell_command:
  shutdown_linux: bash /config/shutdown_linux.sh
```

##### Option 2 : Fichiers séparés (recommandé)

**configuration.yaml :**
```yaml
# Inclusion des fichiers de configuration
switch: !include switch.yaml
shell_command: !include shell_command.yaml
```

**switch.yaml :**
```yaml
# Switch ON/OFF pour machine Linux (Wake-on-LAN + SSH shutdown)
- platform: wake_on_lan
  mac: "XX:XX:XX:XX:XX:XX"  # Adresse MAC de votre machine Linux
  name: "Linux Server"
  host: "192.168.1.XXX"     # Adresse IP de votre machine Linux
  broadcast_address: "192.XXX.XXX.255"  # Adresse broadcast de votre réseau
  turn_off:
    service: shell_command.shutdown_linux
```

**shell_command.yaml :**
```yaml
# Commande shell pour éteindre la machine Linux via SSH
shutdown_linux: bash /config/shutdown_linux.sh
```

### 3. Configuration personnalisée

Modifier les valeurs suivantes dans vos fichiers :

- `XX:XX:XX:XX:XX:XX` : Adresse MAC de votre machine Linux
- `192.XXX.XXX.XXX` : Adresse IP de votre machine Linux
- `192.XXX.XXX.255` : Adresse broadcast de votre réseau
- `root@192.XXX.XXX.XXX` : Utilisateur et IP dans le script shutdown

## 🚀 Utilisation

1. Redémarrer Home Assistant après la configuration
2. Le switch "Linux Server" apparaîtra dans l'interface
3. **ON** : Envoie un packet Wake-on-LAN
4. **OFF** : Exécute la commande SSH shutdown

## 🔒 Sécurité

### Pourquoi utiliser /config/.ssh/ ?

- Le répertoire `/config/` est persistant lors des mises à jour de Home Assistant
- Le répertoire `/root/` peut être réinitialisé lors des mises à jour
- Les clés SSH restent disponibles après les redémarrages et mises à jour

### Permissions des fichiers SSH

```bash
# Définir les bonnes permissions
chmod 700 /config/.ssh
chmod 600 /config/.ssh/id_rsa
chmod 644 /config/.ssh/id_rsa.pub
```

## 🐛 Dépannage

### Problèmes courants

1. **SSH ne fonctionne pas :**
   - Vérifier que la clé publique est bien installée sur la machine cible
   - Tester la connexion SSH manuellement
   - Vérifier les permissions des fichiers SSH

2. **Wake-on-LAN ne fonctionne pas :**
   - Vérifier que WOL est activé dans le BIOS
   - Vérifier que WOL est activé sur l'interface réseau
   - Tester avec `wakeonlan` en ligne de commande

3. **Switch n'apparaît pas :**
   - Vérifier la syntaxe YAML
   - Redémarrer Home Assistant
   - Consulter les logs d'erreur

### Logs utiles

```bash
# Voir les logs de Home Assistant
journalctl -u homeassistant.service -f

# Tester le script manuellement
bash /config/shutdown_linux.sh
```

## 📁 Structure des fichiers

```
/config/
├── configuration.yaml
├── switch.yaml (optionnel)
├── shell_command.yaml (optionnel)
├── shutdown_linux.sh
└── .ssh/
    ├── id_rsa
    ├── id_rsa.pub
    └── known_hosts
```

## ⚡ Commandes utiles

```bash
# Générer les clés SSH
ssh-keygen -t rsa -b 4096 -f /config/.ssh/id_rsa

# Copier la clé publique
ssh-copy-id -i /config/.ssh/id_rsa.pub user@ip_machine

# Tester la connexion SSH
ssh -i /config/.ssh/id_rsa user@ip_machine

# Rendre le script exécutable
chmod +x /config/shutdown_linux.sh

# Définir les permissions SSH
chmod 700 /config/.ssh
chmod 600 /config/.ssh/id_rsa
```
