# 🤖 Assistant Vocal K-2SO pour Home Assistant

Configuration complète d'un assistant vocal avec la personnalité sarcastique mais bienveillante du droïde K-2SO de Star Wars.

## 📋 Vue d'ensemble

Cet assistant vocal offre un contrôle naturel de votre installation domotique avec :
- **Reconnaissance vocale française** avec variantes et synonymes
- **Personnalité K-2SO** : sarcastique, geek, bienveillant
- **Couverture complète** des équipements Home Assistant
- **Gestion contextuelle** par pièces et zones

## 🏠 Équipements supportés

### 💡 Éclairage
- **Lumières individuelles** : Salon, Cuisine, Salle à Manger, Chambre, Salle de Bain
- **LED Plan de travail cuisine** 
- **Scènes d'ambiance** : Attenue, Lumineux, Stimulation, Veilleuse (par pièce)
- **Contrôle global** : "Allume/Éteins tout"

### 🪟 Volets
- **Volets individuels** : Salon, Salle à Manger, Cuisine, Salle de Bain
- **Contrôle global** : "Ferme/Ouvre tous les volets"
- **Par zone** : "Ferme/Ouvre le salon"

### 🔌 Interrupteurs & Équipements
- **Machine à café** (Cuisine)
- **Lave-linge** (Salle de Bain)
- **TV** (Chambre + Salon)
- **Chargeurs téléphone** (Chambre + Salon)

### 🌡️ Chauffage & Climat
- **Thermostats** : Salle de Bain, Séjour/Salon
- **Contrôle température** par zone ou global
- **Capteurs température** : Toutes pièces + extérieur

### 🤖 Robot Aspirateur
- **Suckbot** : Démarrage, arrêt, retour base
- Ton collègue droïde préféré !

### 🏠 Automatisations
- **Café vocal** : Préparation automatique du café
- **Je suis réveillé** : Routine matinale
- **Mode dodo** : Routine nocturne

### 📊 Capteurs & Informations
- **Météo Pompey** : Température extérieure, prévisions
- **Températures intérieures** par pièce
- **Température frigo/congélateur**
- **État portes/fenêtres** : Vérification sécurité

## 📁 Structure des fichiers

```
intents/
├── areas.yaml              # Définition des pièces et alias
├── light.yaml             # Contrôle éclairage
├── covers.yaml            # Contrôle volets
├── scenes.yaml            # Scènes d'ambiance
├── switches.yaml          # Interrupteurs (TV, café, etc.)
├── climate.yaml           # Chauffage et température
├── vacuum.yaml            # Robot aspirateur Suckbot
├── automation.yaml        # Automatisations prédéfinies
├── weather_sensors.yaml   # Météo et capteurs
├── areas_improved.yaml    # Version étendue des pièces
└── prompt.yaml            # Configuration personnalité K-2SO
```

## 🎯 Intents disponibles

### Éclairage
- `TurnOnLight` / `TurnOffLight` : Contrôle individuel
- `TurnOnLightInArea` / `TurnOffLightInArea` : Par pièce
- `TurnOnAllLights` / `TurnOffAllLights` : Global
- `TurnOnAllLightsInArea` / `TurnOffAllLightsInArea` : Toutes lumières d'une pièce

### Volets
- `OpenCover` / `CloseCover` : Contrôle individuel
- `OpenCoverInArea` / `CloseCoverInArea` : Par pièce
- `OpenAllCovers` / `CloseAllCovers` : Global

### Scènes
- `ActivateScene` : Scène globale
- `ActivateSceneInArea` : Scène par pièce

### Interrupteurs
- `TurnOnSwitch` / `TurnOffSwitch` : Contrôle individuel
- `TurnOnSwitchInArea` / `TurnOffSwitchInArea` : Par pièce (TV, chargeurs)

### Chauffage
- `SetTemperature` / `SetTemperatureInArea` : Réglage température
- `TurnOnHeating` / `TurnOffHeating` : Marche/Arrêt
- `TurnOnHeatingInArea` / `TurnOffHeatingInArea` : Par pièce

### Aspirateur
- `StartVacuum` : Démarrer nettoyage
- `StopVacuum` : Arrêter
- `ReturnVacuum` : Retour base

### Automatisations
- `TriggerAutomation` : Déclencher automatisations prédéfinies

### Informations
- `GetWeather` : Météo Pompey
- `GetTemperature` / `GetTemperatureInArea` : Températures
- `GetFridgeTemperature` : Température frigo/congél
- `GetDoorWindowStatus` : État portes/fenêtres

## 🗣️ Exemples de commandes

### Éclairage
```
"Allume la lumière du salon"
"Éteins toutes les lumières"
"Mets l'ambiance atténuée dans la chambre"
"Il fait sombre" (contexte automatique)
```

### Volets
```
"Ferme le volet de la cuisine"
"Ouvre tous les volets"
"Mode bunker" (ferme tout)
"J'ai besoin de lumière naturelle"
```

### Équipements
```
"Lance le café"
"Allume la télé du salon"
"Démarre Suckbot"
"Active le chargeur de la chambre"
```

### Climat
```
"Mets le chauffage à 21 degrés"
"Température du salon"
"Quel temps fait-il ?"
"Combien fait-il dans le frigo ?"
```

### Automatisations
```
"Café vocal"
"Je suis réveillé"
"Mode dodo"
"Bonne nuit"
```

## 🎭 Personnalité K-2SO

### Caractéristiques
- **Ton sarcastique mais bienveillant**
- **Références Star Wars et pop culture**
- **Réponses courtes adaptées au TTS**
- **Humour de droïde reprogrammé**

### Exemples de réponses
```
"Lumières allumées. Mission accomplie."
"Suckbot lancé. Au moins, lui ne discute pas mes ordres."
"Tous les volets fermés. Mode bunker activé."
"Ordre exécuté, sans protester... cette fois."
"Il semblerait que [device] fasse sa crise d'adolescence."
```

### Règles spécifiques
- Prononce "Jedi" → "djédaï"
- Plus enjoué le matin
- Plus discret le soir/nuit
- Mode furtif pour actions nocturnes

## 🏷️ Zones et alias

### Pièces supportées
- **Salon** : salon, séjour, living, salle de séjour
- **Cuisine** : cuisine, kitchenette
- **Chambre** : chambre, chambre à coucher, bedroom
- **Salle à Manger** : salle à manger, sam, dining room
- **Salle de Bain** : salle de bain, sdb, toilettes, wc, bathroom

### Variations linguistiques
Chaque pièce accepte les variantes :
- Avec/sans article : "salon" / "le salon"
- Avec préposition : "dans le salon" / "au salon"
- Équivalents FR/EN : "salle de bain" / "bathroom"

## ⚙️ Installation

1. **Copier les fichiers YAML** dans votre dossier `intents/`
2. **Configurer Home Assistant** avec les entity_id correspondants
3. **Adapter les alias** dans `areas.yaml` selon vos préférences
4. **Tester les commandes vocales** progressivement
5. **Personnaliser les réponses** dans `prompt.yaml`

## 🔧 Personnalisation

### Ajouter des équipements
1. Modifier le fichier intent correspondant
2. Ajouter les alias dans les sections `speech.text`
3. Mettre à jour `prompt.yaml` avec les nouveaux équipements

### Modifier la personnalité
Éditer `prompt.yaml` :
- Exemples de réponses
- Références culturelles
- Ton et style

### Ajouter des pièces
1. Compléter `areas.yaml` avec la nouvelle zone
2. Ajouter les intents `*InArea` correspondants
3. Mettre à jour les équipements par pièce

## 📝 Notes techniques

- **Météo** : Configurée pour Pompey, France
- **TTS** : Réponses optimisées pour synthèse vocale
- **Contextuel** : Comprend les commandes sans précision de pièce
- **Extensible** : Structure modulaire facile à étendre

## 🐛 Résolution de problèmes

### Device ne répond pas
L'assistant utilise son humour K-2SO pour signaler les problèmes :
- "Il semblerait que [device] fasse sa crise d'adolescence."
- "[Device] ne répond pas. Peut-être en pause café ?"

### Commande non reconnue
- Vérifier les alias dans les fichiers YAML
- Contrôler les entity_id Home Assistant
- Tester avec des variantes de la commande

### Personnalité trop/pas assez sarcastique
- Ajuster les exemples dans `prompt.yaml`
- Modifier les réponses selon vos goûts
- Adapter les références culturelles

---

**May the Force be with your smart home!** 🌟
