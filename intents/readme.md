# Voice Assistant Home Assistant - Configuration K-2SO Style

## 🎯 Présentation

Cette configuration transforme votre Home Assistant en assistant vocal avec la personnalité sarcastique mais bienveillante de K-2SO (Star Wars). Le système utilise une approche modulaire avec des fichiers YAML séparés pour chaque type de commande.

## 🏗️ Architecture du Système

### Structure des fichiers
```
config/
├── configuration.yaml          # Fichier principal avec includes
├── intent_script.yaml         # Actions à exécuter pour chaque intent
└── intents/                   # Dossier des intents modulaires
    ├── areas.yaml            # Définition des zones/pièces
    ├── automations.yaml      # Déclenchement d'automatisations
    ├── climate.yaml          # Contrôle du chauffage
    ├── covers.yaml           # Contrôle des volets
    ├── light.yaml            # Contrôle de l'éclairage
    ├── scene.yaml            # Activation des scènes
    ├── switch.yaml           # Contrôle des interrupteurs
    ├── vacuum.yaml           # Contrôle de l'aspirateur
    ├── weather_sensors.yaml  # Météo et capteurs
    ├── prompt.yaml           # Configuration du prompt IA
    └── intent_scripts.yaml   # Scripts spécifiques
```

## 🔧 Installation

### 1. Configuration dans `configuration.yaml`

Ajoutez ces lignes dans votre fichier principal :

```yaml
# Voice Assistant Configuration
conversation:
  intents: !include_dir_merge_named intents/

intent_script: !include intents/intent_scripts.yaml
```

### 2. Création de la structure de dossiers

```bash
mkdir config/intents
```

### 3. Copie des fichiers

Copiez tous les fichiers YAML fournis dans le dossier `intents/`.

### 4. Redémarrage

Redémarrez Home Assistant pour prendre en compte la nouvelle configuration.

## 🎮 Fonctionnalités Disponibles

### 🏠 Gestion des Zones (Areas)
Le système reconnaît automatiquement les pièces avec leurs variantes :
- **Salon** : "salon", "le salon", "séjour", "living"
- **Cuisine** : "cuisine", "la cuisine", "kitchenette"
- **Chambre** : "chambre", "chambre à coucher", "bedroom"
- **Salle à manger** : "salle à manger", "sam", "dining room"
- **Salle de bain** : "salle de bain", "sdb", "toilettes", "wc", "bathroom"
- **Partout** : "partout", "toute la maison", "toutes les pièces"

### 💡 Contrôle de l'Éclairage

#### Commandes de base
- `"Allume la lumière"` / `"Éteins la lumière"`
- `"Allume partout"` / `"Éteins partout"`
- `"J'ai besoin de lumière"` / `"Il fait sombre"`

#### Par zone
- `"Allume la lumière dans le salon"`
- `"Éteins toutes les lumières de la chambre"`

### 🪟 Contrôle des Volets

#### Actions globales
- `"Ferme tous les volets"` → Mode bunker
- `"Ouvre tous les volets"` → Réveil matinal
- `"Fermeture générale"` / `"Ouverture générale"`

#### Par zone
- `"Ferme le volet du salon"`
- `"Ouvre la chambre"` (comprend automatiquement les volets)

### 🎭 Scènes d'Éclairage

#### Scènes disponibles
- **Attenuée** : `"Tamise"` / `"Lumière douce"`
- **Lumineux** : `"Éclaire bien"` / `"Pleine puissance"`
- **Stimulation** : `"Boost"` / `"Réveille-moi"`
- **Veilleuse** : `"Mode veilleuse"` / `"Lumière de nuit"`

#### Usage
- `"Active la scène Attenuée dans le salon"`
- `"Veilleuse partout"`

### 🔌 Contrôle des Interrupteurs

#### Équipements spécifiques
- **TV par zone** : `"Allume la télé du salon"`
- **Chargeurs par zone** : `"Active le chargeur de la chambre"`
- **Cafetière** : `"Démarre le café"`
- **Lave-linge** : `"Lance la machine à laver"`

### 🤖 Suckbot (Robot Aspirateur)

- `"Lance Suckbot"` / `"Passe l'aspirateur"`
- `"Arrête Suckbot"` / `"Stop aspirateur"`
- `"Suckbot rentre à la base"`

### 🌡️ Chauffage et Température

#### Contrôle du chauffage
- `"Mets le chauffage à 20 degrés"`
- `"Allume le chauffage dans la chambre"`
- `"J'ai froid"` / `"Il fait froid"`

#### Informations température
- `"Quelle température dans le salon ?"`
- `"Température du frigo"`
- `"Température extérieure"`

### 🌤️ Météo et Capteurs

- `"Quel temps fait-il ?"` → Météo Pompey
- `"Prévisions météo"`
- `"État des portes"` / `"Qu'est-ce qui est ouvert ?"`

### ⚡ Automatisations Spéciales

#### Routines prédéfinies
- **Café vocal** : `"Lance le café"` / `"J'ai besoin de caféine"`
- **Routine matinale** : `"Je suis réveillé"` / `"Bonjour maison"`
- **Mode dodo** : `"Bonne nuit"` / `"Au dodo"`

## 🎭 Personnalité K-2SO

### Ton et Réponses
L'assistant répond avec le style sarcastique de K-2SO :
- `"Lumières allumées. Mission accomplie."`
- `"Suckbot lancé. Au moins, lui ne discute pas mes ordres."`
- `"Volets fermés. Comme un bunker rebelle."`
- `"Mode dodo activé. Que la Force soit avec vous !"`

### Gestion d'erreurs avec humour
- `"Il semblerait que [device] fasse sa crise d'adolescence."`
- `"Cette fois, ce n'est pas de ma faute. [device] fait la sourde oreille."`

## 🔧 Personnalisation

### Adapter les Zones
Modifiez `intents/areas.yaml` pour correspondre à votre logement :

```yaml
bureau:
  aliases:
    - "bureau"
    - "le bureau"
    - "dans le bureau"
    - "office"
```

### Ajouter des Équipements
Dans `intents/switch.yaml`, ajoutez vos propres appareils :

```yaml
# Dans TurnOnSwitch
- "allume {switch_name:name}"
- "démarre le ventilateur"  # Exemple spécifique
```

### Personnaliser le Prompt IA
Le fichier `intents/prompt.yaml` contient toute la configuration de personnalité. Modifiez-le selon vos préférences.

## 🔗 Intégration avec l'IA Générative

### Configuration requise
1. **Conversation Integration** activée
2. **Assistant IA** configuré (OpenAI, Groq, etc.)
3. **Prompt personnalisé** utilisant le contenu de `prompt.yaml`

### Fonctionnement
1. L'utilisateur prononce une commande
2. L'IA reconnaît l'intent via les patterns définis
3. L'action correspondante est exécutée via `intent_scripts.yaml`
4. L'IA répond avec le ton K-2SO

## 🎯 Avantages de cette Architecture

### ✅ Modularité
- Chaque type de commande dans son propre fichier
- Facile à maintenir et étendre

### ✅ Flexibilité
- Multiples façons de dire la même chose
- Support des zones avec alias automatiques
- Gestion contextuelle intelligente

### ✅ Personnalité Unique
- Réponses amusantes et cohérentes
- Références à Star Wars et culture geek
- Ton adapté selon le moment (matin/soir)

### ✅ Robustesse
- Gestion d'erreurs avec humour
- Commandes globales et spécifiques
- Support des équipements par zone

## 🐛 Dépannage

### Commandes non reconnues
1. Vérifiez les logs Home Assistant
2. Testez via `Developer Tools > Services`
3. Validez la syntaxe YAML

### IA qui ne répond pas
1. Vérifiez la configuration de l'assistant IA
2. Contrôlez le prompt dans la configuration
3. Testez les intents individuellement

### Entités non trouvées
1. Vérifiez les noms d'entités dans Home Assistant
2. Adaptez les `entity_id` dans `intent_scripts.yaml`
3. Utilisez les alias pour les noms friendly

## 🚀 Évolutions Possibles

- Ajout de nouveaux intents (media_player, fan, etc.)
- Extension des automatisations saisonnières
- Intégration de notifications vocales
- Support de langues supplémentaires

---

*"Je ne suis qu'un droïde, mais au moins je contrôle bien votre maison !"* - Assistant K-2SO
