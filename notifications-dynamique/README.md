# 📬 Notifications Dynamiques Alexa - Home Assistant

Un système intelligent de notifications vocales via Alexa qui s'adapte automatiquement à votre présence et diffuse sur les bons appareils Echo selon les pièces occupées, avec exemple concret d'intégration IA pour messages personnalisés.

## 🌟 Fonctionnalités

- ✅ **Détection automatique de présence** dans chaque pièce
- ✅ **Sélection intelligente** de l'Echo le plus pertinent
- ✅ **Diffusion multi-Echo** sur toutes les pièces occupées (version 02)
- ✅ **Gestion intelligente de la musique** (pause/reprise automatique)
- ✅ **Ajustement automatique du volume** avec restauration
- ✅ **Logique d'exclusion avancée** (SdB avec conditions spécifiques)
- ✅ **Calcul adaptatif** de la durée des messages
- ✅ **Modes jour/nuit** avec conditions de présence
- ✅ **Exemple IA intégrée** : Messages générés par Google AI avec ton personnalisé

## 📦 Contenu du projet

```
notifications-dynamique/
├── README.md            # Cette documentation
├── template.yaml        # Sensor de présence intelligent
├── scripts.yaml         # Version 1 - Echo principal
├── scripts_02.yaml      # Version 2 - Multi-Echo
└── automatisations.yaml # Exemple concret cafetière avec IA
```

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
- **Version 1** (`scripts.yaml`) : Diffusion sur l'Echo principal de la pièce prioritaire
- **Version 2** (`scripts_02.yaml`) : Diffusion simultanée sur tous les Echo des pièces occupées

## 📋 Prérequis

- Home Assistant avec intégration Alexa Media Player
- Capteurs de présence ESP configurés dans chaque pièce
- Appareils Echo configurés et accessibles
- Input boolean `pause_musique` pour la gestion musicale
- Input text `jour_nuit` pour les conditions temporelles
- Person `canabang` pour la détection de présence à domicile
- **Optionnel** : Intégration Google Generative AI pour messages IA

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

### 4. Exemple automatisation (optionnel)

Copier le contenu de `automatisations.yaml` comme nouvelle automatisation pour voir un cas d'usage avec IA intégrée.

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

## 🤖 Exemple complet : Cafetière avec IA

### Fonctionnement de l'exemple

L'automatisation fournie (`automatisations.yaml`) démontre un cas d'usage avancé :

1. **Déclencheur** : Allumage du switch `priscafe` 
2. **Temporisation** : Attente de 4 minutes (temps de préparation)
3. **Actions parallèles** :
   - Extinction automatique du switch
   - **Génération message IA** avec Google Generative AI
   - Diffusion via le script de notifications

### Configuration du message IA

```yaml
# Extrait de automatisations.yaml - Prompt pour l'IA
prompt: >+
  Génère un message vocal pour prévenir que le café est prêt.
  
  Le ton doit être court, factuel, avec une touche d'humour ou de 
  sarcasme léger, dans le style d'un droïde reprogrammé façon K-2SO.
  
  Tu peux glisser une référence geek ou pop culture si c'est pertinent.
  
  Exemples de ton attendu :
  « Le café est prêt. Vous avez survécu jusque-là, autant continuer. »
  « Café disponible. Taux de réveil cérébral à suivre… »
  « Mission accomplie : café prêt. J'espère que c'est assez fort. »
```

### Résultat

- **Message varié** : L'IA génère un message différent à chaque fois
- **Ton personnalisé** : Style K-2SO avec humour et références geek
- **Diffusion intelligente** : Sur l'Echo de la pièce occupée
- **Gestion automatique** : Volume, musique, timing

### Exemples de messages générés

L'IA peut générer des messages comme :
- *"Café prêt. Protocole réveil humain activé."*
- *"Mission cafetière accomplie. Résistance inutile."*  
- *"Café disponible. Niveau caféine critique détecté."*
- *"Breuvage noir prêt à consommation. Bonne chance."*

## 📱 Utilisation

### Déclenchement manuel simple
```yaml
action: script.notification_alexa
data:
  message: "Votre message ici"
```

### Avec message IA dynamique
```yaml
action: google_generative_ai_conversation.generate_content
data:
  prompt: |
    Génère un message pour dire que {{ trigger.entity_id }} a changé d'état.
    Ton humoristique style droïde K-2SO.
response_variable: ai_message
  
action: script.notification_alexa
data:
  message: "{{ ai_message.text }}"
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

### Avec messages aléatoires sans IA
```yaml
action: script.notification_alexa
data:
  message: >
    {% set messages = [
      "Le portail est ouvert",
      "Détection d'ouverture du portail",  
      "Accès détecté au portail"
    ] %}
    {{ messages | random }}
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

## 🎨 Adaptations de l'exemple

### Personnaliser le prompt IA

```yaml
# Modifier le style du message
prompt: >
  Génère un message pour dire que le café est prêt.
  
  Style : Robot majordome britannique très poli
  Ton : Formel et courtois avec une pointe d'ironie
  
  Exemples attendus :
  "Monsieur, votre café est prêt. J'ose espérer qu'il sera à votre goût."
  "Le café a l'honneur d'être prêt, Monsieur."
```

### Adapter pour d'autres appareils

```yaml
# Exemple pour lave-linge
triggers:
  - entity_id: sensor.lave_linge_etat
    to: 'Terminé'
    trigger: state

# Modifier le prompt
prompt: >
  Génère un message pour dire que le lave-linge a terminé.
  Style K-2SO avec sarcasme léger.
```

### Ajouter des conditions

```yaml
# Seulement en journée et si présent
conditions:
  - condition: state
    entity_id: person.canabang
    state: home
  - condition: time
    after: "08:00:00"
    before: "22:00:00"
```

### Messages IA contextuels

```yaml
# Prompt avec contexte temporel
prompt: >
  Génère un message pour dire que le café est prêt.
  
  Contexte : Il est {{ now().strftime('%H:%M') }}
  {% if now().hour < 10 %}
  C'est le matin, premier café de la journée.
  {% elif now().hour > 20 %}
  C'est le soir, café tardif.
  {% endif %}
  
  Adapte le message selon le contexte.
  Style K-2SO humoristique.
```

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
duree_message: "{{ ((message | length / 12) + 3) | round(0) }}"
# 12 = caractères par seconde, 3 = délai fixe
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

### Configuration IA avancée

```yaml
# Plusieurs styles selon l'heure
prompt: >
  {% if now().hour < 12 %}
    Style : Optimiste et énergique pour le matin
  {% elif now().hour < 18 %}
    Style : Neutre et informatif pour l'après-midi  
  {% else %}
    Style : Détendu et apaisant pour le soir
  {% endif %}
  
  Génère un message pour dire que {{ trigger.entity_id | replace('_', ' ') }}.
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

### Messages IA non générés
1. Vérifier l'intégration Google Generative AI
2. Tester le service manuellement dans Developer Tools
3. Vérifier les quotas et limites API
4. Contrôler la variable `response_variable`

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

## 💡 Exemples d'usage avancés

### Notification météo matinale avec IA
```yaml
alias: "Météo du matin IA"
trigger:
  - platform: time
    at: "07:30:00"
action:
  - action: google_generative_ai_conversation.generate_content
    data:
      prompt: >
        Génère une annonce météo matinale.
        
        Données : {{ states('sensor.temperature_exterieure') }}°C, 
        {{ states('weather.home') }}
        
        Style : Présentateur météo sarcastique mais informatif
        Ton : Humour noir léger, références possibles à la galère matinale
        
        Format : Court, 1-2 phrases maximum
    response_variable: meteo_ia
  - action: script.notification_alexa
    data:
      message: "{{ meteo_ia.text }}"
```

### Alerte sécurité avec urgence
```yaml
alias: "Alerte intrusion IA"
trigger:
  - platform: state
    entity_id: binary_sensor.detecteur_mouvement_jardin
    to: 'on'
conditions:
  - condition: state
    entity_id: alarm_control_panel.alarme
    state: 'armed_away'
action:
  - action: google_generative_ai_conversation.generate_content
    data:
      prompt: >
        Génère une alerte de sécurité pour mouvement détecté dans le jardin.
        
        Style : Urgent mais pas paniqué
        Ton : Informatif et rassurant
        
        Message doit être clair et inciter à la vérification
    response_variable: alerte_ia
  - action: script.notification_alexa
    data:
      message: "{{ alerte_ia.text }}"
```

### Rappels personnalisés contextuels
```yaml
alias: "Rappel médicament IA"
trigger:
  - platform: time
    at: "20:00:00"
action:
  - action: google_generative_ai_conversation.generate_content
    data:
      prompt: >
        Génère un rappel pour prendre les médicaments du soir.
        
        Contexte : {{ now().strftime('%A %d %B') }}
        
        Style : Bienveillant mais ferme
        Ton : Comme un assistant personnel qui veille sur la santé
        
        Peut inclure encouragement ou motivation légère
    response_variable: rappel_ia
  - action: script.notification_alexa
    data:
      message: "{{ rappel_ia.text }}"
```

## ⚡ Différences entre les versions

| Fonctionnalité | Version 1 | Version 2 |
|----------------|-----------|-----------|
| **Diffusion** | Echo principal uniquement | Tous les Echo des pièces occupées |
| **Volume** | Gestion simple | Gestion individuelle par Echo |
| **Performance** | Rapide et léger | Plus complexe mais exhaustif |
| **Usage** | Notifications ponctuelles | Annonces importantes |
| **Fiabilité** | Très stable | Nécessite plus de ressources |
| **IA intégrée** | Compatible avec les deux versions | Compatible avec les deux versions |

## 🎯 Cas d'usage IA recommandés

### Notifications quotidiennes
- **Réveil** : Messages motivants personnalisés
- **Météo** : Annonces contextuelles avec humour
- **Rappels** : Médicaments, tâches avec encouragement

### Alertes système  
- **Sécurité** : Alertes claires sans panique
- **Technique** : Pannes expliquées simplement
- **Maintenance** : Rappels avec instructions

### Événements automatisés
- **Électroménager** : Fin de cycle avec humour
- **Éclairage** : Changements expliqués
- **Température** : Confort avec conseils

## 📚 Ressources

- [Intégration Alexa Media Player](https://github.com/custom-components/alexa_media_player)
- [Google Generative AI](https://www.home-assistant.io/integrations/google_generative_ai_conversation/)
- [Templates Home Assistant](https://www.home-assistant.io/docs/configuration/templating/)
- [Scripts Home Assistant](https://www.home-assistant.io/docs/scripts/)

---

*Un système de notifications intelligent qui s'adapte à votre vie quotidienne avec l'IA pour des messages personnalisés, garantissant que les informations importantes sont entendues au bon endroit, au bon moment, avec le bon ton. 🗣️🤖🏠*
