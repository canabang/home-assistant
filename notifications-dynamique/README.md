# 📬 Notifications Dynamiques Alexa - Home Assistant

Un système intelligent de notifications vocales via Alexa qui s'adapte automatiquement à votre présence et diffuse sur les bons appareils Echo selon les pièces occupées.

## 🌟 Fonctionnalités

- ✅ **Détection automatique de présence** dans chaque pièce
- ✅ **Sélection intelligente** de l'Echo le plus pertinent
- ✅ **Diffusion multi-Echo** sur toutes les pièces occupées (version 02)
- ✅ **Gestion intelligente de la musique** (pause/reprise automatique)
- ✅ **Ajustement automatique du volume** avec restauration
- ✅ **Logique d'exclusion avancée** (SdB avec conditions spécifiques)
- ✅ **Calcul adaptatif** de la durée des messages
- ✅ **Modes jour/nuit** avec conditions de présence

## 🏗️ Architecture

### Capteurs de présence
Le système utilise des capteurs ESP dans chaque pièce :
- **Salon** : `esp_salon_presence` + `esp_multi_capteur_presence`
- **Cuisine** : `esp_cuisine_presence`
- **Chambre** : `esp_chambre_presence`
- **Salle de bain** : `esp_sdb_presence`

### Template sensor intelligent
Le sensor `presence_piece` analyse en temps réel :
- Les pièces occupées selon les capteurs
- La priorité de diffusion (Salon > Cuisine > Chambre > SdB)
- Les conditions d'exclusion (SdB avec fenêtre ouverte ou switch prismal)
- Le mapping vers les Echo correspondants

### Scripts de notification
Deux versions disponibles :
- **Version 1** : Diffusion sur l'Echo principal de la pièce prioritaire
- **Version 2** : Diffusion simultanée sur tous les Echo des pièces occupées

## 📋 Prérequis

- Home Assistant avec intégration Alexa Media Player
- Capteurs de présence ESP configurés dans chaque pièce
- Appareils Echo configurés et accessibles
- Input boolean `pause_musique` pour la gestion musicale
- Input text `jour_nuit` pour les conditions temporelles
- Person `canabang` pour la détection de présence à domicile

## 🚀 Installation

### 1. Configuration des templates

Ajouter le contenu de `template.yaml` dans votre configuration :

```yaml
# Dans configuration.yaml
template: !include template.yaml

# Ou directement dans configuration.yaml
template:
  # [Contenu du template.yaml]
```

### 2. Installation des scripts

Choisir une version selon vos besoins :

**Version 1 - Echo principal :**
```yaml
# Dans scripts.yaml
script:
  notification_alexa:
    # [Contenu de scripts.yaml]
```

**Version 2 - Multi-Echo :**
```yaml
# Dans scripts.yaml
script:
  notification_alexa:
    # [Contenu de scripts_02.yaml]
```

### 3. Configuration des entités requises

Créer les entités helper nécessaires :

```yaml
# input_boolean.yaml
pause_musique:
  name: "Pause Musique"
  initial: false

# input_text.yaml
jour_nuit:
  name: "Mode Jour/Nuit"
  options:
    - jour
    - nuit
  initial: jour
```

## ⚙️ Configuration

### Mapping des Echo
Personnalisez les appareils Echo dans le template :

```yaml
echo_map:
  'Salon': 'media_player.echo_studio_d'
  'Cuisine': 'media_player.echo_show_cuisine'
  'Chambre': 'media_player.echo_show_chambre'
  'SdB': 'media_player.echo_sdb'
```

### Capteurs de présence
Adaptez les capteurs selon votre installation :

```yaml
presence_map:
  'Salon': ['binary_sensor.esp_salon_presence', 'binary_sensor.esp_multi_capteur_presence']
  'Cuisine': ['binary_sensor.esp_cuisine_presence']
  # ... autres pièces
```

### Conditions d'exclusion SdB
Le système exclut automatiquement la salle de bain si :
- La fenêtre est ouverte (`binary_sensor.ouvfenetsdb_contact`)
- OU le switch prismal est allumé (`switch.prismal`)

## 📱 Utilisation

### Déclenchement manuel
```yaml
action: script.notification_alexa
data:
  message: "Votre message ici"
```

### Intégration dans une automatisation
```yaml
alias: "Notification portail ouvert"
trigger:
  - platform: state
    entity_id: binary_sensor.portail
    to: 'on'
action:
  - action: script.notification_alexa
    data:
      message: "Le portail a été ouvert"
```

### Avec conditions avancées
```yaml
action: script.notification_alexa
data:
  message: >
    {% if is_state('weather.home', 'rainy') %}
      Il pleut, n'oubliez pas votre parapluie
    {% else %}
      Bonne journée !
    {% endif %}
```

## 🎯 Logique intelligente

### Sélection de l'Echo (Version 1)
1. **Aucune présence** : Pas de notification
2. **Une pièce** : Echo de cette pièce
3. **Plusieurs pièces** : Priorité Salon > Cuisine > Chambre > SdB
4. **SdB avec exclusion** : Passe à la pièce suivante dans la priorité

### Diffusion multi-Echo (Version 2)
1. Identifie toutes les pièces occupées
2. Exclut la SdB si conditions remplies
3. Diffuse sur tous les Echo restants simultanément
4. Gère les volumes individuellement

### Gestion de la musique
- **Détection automatique** si Spotify est en lecture
- **Pause temporaire** pendant la notification
- **Reprise automatique** après le message
- **Calcul de durée** basé sur la longueur du texte

### Ajustement du volume
- **Sauvegarde** du volume actuel
- **Volume uniforme** à 30% pendant la notification
- **Restauration** du volume original après diffusion

## 🔧 Personnalisation avancée

### Modifier les priorités
```yaml
# Dans le template, changer l'ordre :
{% if 'Cuisine' in pieces_candidates %}    # Cuisine en priorité
  Cuisine
{% elif 'Salon' in pieces_candidates %}    # Salon en second
  Salon
```

### Ajuster le calcul de durée
```yaml
# Dans le script, modifier la formule :
duree_message: "{{ ((message | length / 15) + 4) | round(0) }}"
# 15 = caractères par seconde, 4 = délai fixe
```

### Conditions de diffusion personnalisées
```yaml
# Ajouter d'autres conditions :
conditions:
  - condition: state
    entity_id: person.canabang
    state: home
  - condition: state
    state: jour
    entity_id: input_text.jour_nuit
  - condition: state
    entity_id: input_boolean.notifications_actives
    state: 'on'
```

## 📊 Attributs du sensor

Le sensor `presence_piece` expose plusieurs attributs utiles :

- `echo` : Echo principal sélectionné
- `pieces_occupees` : Liste des pièces détectées
- `nombre_pieces_occupees` : Nombre de pièces occupées
- `sdb_exclue` : Si la SdB est exclue par les conditions
- `fenetre_sdb_ouverte` : État de la fenêtre SdB
- `switch_prismal_on` : État du switch prismal

## 🐛 Dépannage

### Notifications ne fonctionnent pas
1. Vérifier l'intégration Alexa Media Player
2. Tester manuellement : `media_player.speak` sur un Echo
3. Vérifier les conditions (présence, jour/nuit)

### Echo incorrect sélectionné
1. Vérifier les capteurs de présence dans Developer Tools
2. Tester le template sensor `presence_piece`
3. Ajuster les conditions d'exclusion

### Volume non restauré
1. Vérifier que `state_attr(echo, 'volume_level')` retourne une valeur
2. Ajouter une valeur par défaut : `| default(0.5)`
3. Tester les commandes `media_player.volume_set`

### Musique non reprise
1. Vérifier l'état de `input_boolean.pause_musique`
2. Tester manuellement `media_player.media_play_pause`
3. Vérifier l'intégration SpotifyPlus

## 💡 Exemples d'usage

### Notification météo matinale
```yaml
alias: "Météo du matin"
trigger:
  - platform: time
    at: "07:30:00"
condition:
  - condition: state
    entity_id: binary_sensor.workday_sensor
    state: 'on'
action:
  - action: script.notification_alexa
    data:
      message: >
        Bonjour ! Aujourd'hui il fait {{ states('sensor.temperature_exterieure') }}°C 
        avec {{ states('weather.home') }}. Bonne journée !
```

### Alerte sécurité
```yaml
alias: "Alerte intrusion"
trigger:
  - platform: state
    entity_id: binary_sensor.detecteur_mouvement_jardin
    to: 'on'
condition:
  - condition: state
    entity_id: alarm_control_panel.alarme
    state: 'armed_away'
action:
  - action: script.notification_alexa
    data:
      message: "Attention ! Mouvement détecté dans le jardin !"
```

### Rappel personnalisé
```yaml
alias: "Rappel médicament"
trigger:
  - platform: time
    at: "20:00:00"
action:
  - action: script.notification_alexa
    data:
      message: "N'oubliez pas de prendre vos médicaments du soir"
```

## ⚡ Différences entre les versions

| Fonctionnalité | Version 1 | Version 2 |
|----------------|-----------|-----------|
| **Diffusion** | Echo principal uniquement | Tous les Echo des pièces occupées |
| **Volume** | Gestion simple | Gestion individuelle par Echo |
| **Performance** | Rapide et léger | Plus complexe mais exhaustif |
| **Usage** | Notifications ponctuelles | Annonces importantes |
| **Fiabilité** | Très stable | Nécessite plus de ressources |

## 📚 Ressources

- [Intégration Alexa Media Player](https://github.com/custom-components/alexa_media_player)
- [Templates Home Assistant](https://www.home-assistant.io/docs/configuration/templating/)
- [Scripts Home Assistant](https://www.home-assistant.io/docs/scripts/)

---

*Un système de notifications intelligent qui s'adapte à votre vie quotidienne et garantit que les messages importants sont entendus au bon endroit, au bon moment. 🗣️🏠*
