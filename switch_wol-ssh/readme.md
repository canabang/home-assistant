# Contrôle d'une machine Linux depuis Home Assistant

## Vue d'ensemble

Configuration pour contrôler une machine Linux depuis Home Assistant avec :
- **Allumage** : Wake-on-LAN (WOL)
- **Extinction** : SSH avec commande shutdown
- **Interface** : Switch unique ON/OFF dans Home Assistant

## Prérequis

### Sur la machine Linux cible
- SSH activé et accessible
- Wake-on-LAN activé sur la carte réseau (voir section configuration WOL)
- Utilisateur avec droits sudo
- **Authentication par clé publique activée** dans la configuration SSH

### Sur Home Assistant
- Add-on SSH & Web Terminal installé
- Accès réseau vers votre machine linux

## Informations nécessaires

Avant de commencer, récupérez ces informations :
- **Adresse MAC** de votre machine Linux : `ip link show` ou `ifconfig`
- **Adresse IP** de votre machine Linux : `ip addr` ou `ifconfig`
- **Nom d'utilisateur** avec droits sudo sur la machine Linux

## Configuration

### 0. Configuration Wake-on-LAN sur Linux

#### Vérifier la compatibilité WOL :
```bash
# Connectez-vous à la machine Linux en SSH
ssh USERNAME@IP_LINUX

# Identifier l'interface réseau
ip link show

# Vérifier le support WOL (remplacer eth0 par votre interface)
sudo ethtool eth0 | grep -i wake
```

Vous devriez voir quelque chose comme :
```
Supports Wake-on: pumbg
Wake-on: d
```

#### Activer WOL temporairement :
```bash
# Activer WOL sur l'interface (remplacer eth0)
sudo ethtool -s eth0 wol g

# Vérifier l'activation
sudo ethtool eth0 | grep -i wake
# Doit afficher : Wake-on: g
```

#### Activer WOL de manière permanente :

**Méthode 1 - Service systemd (recommandée) :**
```bash
# Créer le service
sudo nano /etc/systemd/system/wol.service
```

Contenu du fichier :
```ini
[Unit]
Description=Enable Wake-on-LAN
After=network.target

[Service]
Type=oneshot
ExecStart=/sbin/ethtool -s eth0 wol g
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

```bash
# Activer le service
sudo systemctl enable wol.service
sudo systemctl start wol.service
```

**Méthode 2 - Fichier de configuration réseau :**

Pour Debian/Ubuntu :
```bash
# Éditer le fichier interfaces
sudo nano /etc/network/interfaces

# Ajouter après la configuration de l'interface :
post-up /sbin/ethtool -s eth0 wol g
```

#### Configuration BIOS/UEFI :
Sur la machine Linux, vérifiez dans le BIOS :
- **Power Management** → **Wake-on-LAN** : **Enabled**
- **Advanced** → **APM Configuration** → **Power On By PCI-E** : **Enabled**

### 2. Configuration SSH sans mot de passe

#### Sur Home Assistant (via SSH) :
```bash
# Générer la paire de clés
ssh-keygen -t rsa -b 4096
# Appuyer sur ENTRÉE pour tous les choix (pas de passphrase)

# Copier la clé vers la machine Linux (remplacer USERNAME et IP_LINUX)
ssh-copy-id USERNAME@IP_LINUX
```

#### Sur la machine Linux :
```bash
# Éditer la configuration SSH
sudo nano /etc/ssh/sshd_config

# Vérifier/ajouter ces lignes :
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

# Redémarrer SSH
sudo systemctl restart ssh
```

#### Test :
```bash
# Depuis Home Assistant - ne doit plus demander de mot de passe
ssh USERNAME@IP_LINUX 'whoami'
```

### 3. Configuration Home Assistant

#### Option 1 : Configuration dans configuration.yaml

Ajouter dans `configuration.yaml` :

```yaml
# Switch ON/OFF pour machine Linux (Wake-on-LAN + SSH shutdown)
switch:
  - platform: wake_on_lan
    mac: "XX:XX:XX:XX:XX:XX"  # Adresse MAC de votre machine Linux
    name: "Linux Server"
    host: "192.XXX.XXX.XXX"     # Adresse IP de votre machine Linux
    broadcast_address: "192.XXX.XXX.XXX"  # Adresse broadcast de votre réseau
    turn_off:
      service: shell_command.shutdown_linux

# Commande shell pour éteindre la machine Linux via SSH
shell_command:
  shutdown_linux: "ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 USERNAME@IP_LINUX 'sudo shutdown -h now'"
```

#### Option 2 : Configuration avec fichier séparé (recommandée)

**Dans `configuration.yaml`, ajouter :**
```yaml
# Inclusion des fichiers de configuration
switch: !include switch.yaml
shell_command: !include shell_command.yaml
```

**Créer le fichier `switch.yaml` :**
```yaml
# Switch ON/OFF pour machine Linux (Wake-on-LAN + SSH shutdown)
- platform: wake_on_lan
  mac: "XX:XX:XX:XX:XX:XX"  # Adresse MAC de votre machine Linux
  name: "Linux Server"
  host: "192.XXX.XXX.XXX"     # Adresse IP de votre machine Linux
  broadcast_address: "192.XXX.XXX.XXX"  # Adresse broadcast de votre réseau
  turn_off:
    service: shell_command.shutdown_linux
```

**Créer le fichier `shell_command.yaml` :**
```yaml
# Commande shell pour éteindre la machine Linux via SSH
shutdown_linux: "ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 USERNAME@IP_LINUX 'sudo shutdown -h now'"
```

**Remplacer :**
- `XX:XX:XX:XX:XX:XX` par l'adresse MAC de votre machine Linux
- `192.XXX.XXX.XXX` par l'adresse IP de votre machine Linux
- `USERNAME` par votre nom d'utilisateur Linux
- `IP_LINUX` par l'adresse IP de votre machine Linux

### 4. Redémarrer Home Assistant

Après modification de `configuration.yaml`, redémarrer Home Assistant.

## Utilisation

Dans l'interface Home Assistant :
- **Switch ON** : Allume la machine Linux via Wake-on-LAN
- **Switch OFF** : Éteint la machine Linux via SSH
- **État automatique** : Détection par ping de l'IP

## Dépannage

### SSH demande encore un mot de passe
1. Vérifier que `PubkeyAuthentication yes` est dans `/etc/ssh/sshd_config`
2. Redémarrer le service SSH sur OMV
3. Vérifier les permissions sur OMV :
   ```bash
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/authorized_keys
   ```

### Wake-on-LAN ne fonctionne pas
1. **Vérifier l'état WOL** :
   ```bash
   sudo ethtool eth0 | grep -i wake
   # Doit afficher : Wake-on: g
   ```

2. **Réactiver WOL** :
   ```bash
   sudo ethtool -s eth0 wol g
   ```

3. **Vérifier la configuration réseau de la carte mère/BIOS**
4. **Tester manuellement** : `wakeonlan XX:XX:XX:XX:XX:XX`
5. **Vérifier le service systemd** :
   ```bash
   sudo systemctl status wol.service
   ```

### Commandes utiles

```bash
# Récupérer l'adresse MAC
ip link show

# Récupérer l'adresse IP
ip addr

# Tester Wake-on-LAN manuellement
wakeonlan XX:XX:XX:XX:XX:XX

# Tester SSH sans mot de passe
ssh USERNAME@IP_LINUX 'whoami'

# Tester l'extinction
ssh USERNAME@IP_LINUX 'sudo reboot'  # Pour test (redémarre au lieu d'éteindre)

# Vérifier l'état WOL
sudo ethtool eth0 | grep -i wake

# Activer WOL manuellement
sudo ethtool -s eth0 wol g
```
