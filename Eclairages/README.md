# Système d'Éclairage Intelligent - Home Assistant

## 📋 Vue d'ensemble

Ce système d'éclairage intelligent pour Home Assistant gère automatiquement l'éclairage de l'appartement en fonction de la présence, de la luminosité ambiante et des conditions temporelles. Il utilise des capteurs de présence LD2410 et des ampoules Philips Hue.

## 🏠 Pièces couvertes

- **Chambre** : Détection de présence avec gestion spéciale mode "dodo"
- **Salle de bain** : Détection de présence avec conditions particulières (volet, lave-linge)
- **SAM, Cuisine, Salon** : Gestion via allumage manuel uniquement

## 🔧 Architecture du système

### Scripts principaux

#### `script.eclairage_intelligent_multi_pieces`
**Script centralisé** qui détermine la scène d'éclairage appropriée selon :
- État jour/nuit (`input_text.jour_nuit`)
- Position du soleil (`sun.sun`)
- Présence à domicile (`sensor.etat_canabang_et_device_tracker`)
- État actuel de la lumière

**Logique des scènes :**
```
NUIT ou JOUR < 20min → scene.hue_{piece}_1_veilleuse
JOUR + Soleil visible → scene.hue_{piece}_2_stimulation  
JOUR + Soleil couché → scene.hue_{piece}_3_attenue
```

### Automatisations de présence

#### Chambre (`Chambre.yaml`)
- **Déclencheur** : `binary_sensor.esp_chambre_presence` (délai 3s)
- **Conditions spéciales** :
  - Pas active la nuit (`input_text.jour_nuit != nuit`)
  - Scène "dodo" non activée dans les 10 dernières minutes
- **Actions** :
  - Présence ON + Luminosité < 1 lux → Appel script intelligent
  - Présence OFF → Extinction `light.hue_chambre`

#### Salle de bain (`Salle de Bain.yaml`)
- **Déclencheur** : `binary_sensor.esp_sdb_presence`
- **Conditions complexes** :
  - Présence ON + Luminosité < 1 lux
  - Volet pas en mouvement (`cover.volsdb`)
  - Lave-linge pas en cours (logique inversée sur `switch.prismal`)
- **Actions** :
  - Conditions réunies → Appel script intelligent  
  - Présence OFF → Extinction `light.hue_sdb`

### Automatisation d'allumage manuel

#### Gestion conflits (`Éclairage - Gestion allumage lumières`)
Évite les conflits entre allumage manuel et automatisation de présence.

**Stratégie anti-conflit :**
- **Chambre** : N'intervient pas si nuit OU (présence + faible luminosité)
- **SDB** : N'intervient pas si toutes les conditions de présence sont réunies
- **Autres pièces** : Intervention systématique (pas d'automatisation présence)

## 📊 Entités utilisées

### Capteurs de présence
- `binary_sensor.esp_chambre_presence`
- `binary_sensor.esp_sdb_presence`

### Capteurs de luminosité
- `sensor.esp_chambre_lux`
- `sensor.esp_sdb_lux`

### Lumières Hue
- `light.hue_chambre`
- `light.hue_sdb`  
- `light.hue_sam`
- `light.hue_cuisine`
- `light.hue_salon`

### Scènes par pièce
Pour chaque pièce, 3 scènes prédéfinies :
- `scene.hue_{piece}_1_veilleuse` - Éclairage tamisé
- `scene.hue_{piece}_2_stimulation` - Éclairage vif (jour)
- `scene.hue_{piece}_3_attenue` - Éclairage modéré (soir)

### Helpers et états
- `input_text.jour_nuit` - Mode jour/nuit
- `input_datetime.dernier_changement_jour_nuit` - Timestamp changement
- `sensor.etat_canabang_et_device_tracker` - Présence domicile
- `sun.sun` - Position solaire
- `cover.volsdb` - État volet SDB
- `switch.prismal` + `sensor.prismal_power` - Lave-linge

## ⚡ Fonctionnalités clés

### 🌙 Gestion jour/nuit intelligente
- Transition douce lors des changements de mode
- Veilleuse automatique les 20 premières minutes après passage en "jour"

### 🚶 Détection de présence optimisée  
- Délai anti-rebond de 3s en chambre
- Conditions contextuelles (luminosité, volet, appareils)

### 🔄 Anti-conflit sophistiqué
- Détection des allumages manuels vs automatiques
- Prévention des boucles d'automatisation

### 🏠 Adaptation contextuelle
- Respect du mode "dodo" en chambre
- Gestion des appareils électroménagers en SDB
- Prise en compte de la position du soleil

## 🛠️ Configuration requise

### Matériel
- Capteurs de présence LD2410 (ESP32)
- Ampoules Philips Hue
- Capteurs de luminosité intégrés

### Home Assistant
- Intégration Philips Hue
- Helpers input_text et input_datetime configurés
- Device tracker pour détection présence domicile

## 📈 Avantages du système

1. **Économie d'énergie** - Allumage seulement si nécessaire
2. **Confort** - Adaptation automatique selon le contexte
3. **Flexibilité** - Respect des actions manuelles
4. **Robustesse** - Gestion des cas edge et anti-conflits
5. **Maintenabilité** - Architecture centralisée et modulaire

## 🔍 Analyse technique

### Points forts
- **Architecture centralisée** avec le script multi-pièces
- **Gestion fine des conflits** entre automatique et manuel  
- **Conditions contextuelles poussées** (météo, appareils, etc.)
- **Logique anti-rebond** et délais appropriés

### Optimisations possibles
- Ajouter logs pour debugging
- Créer des variables globales pour les seuils (luminosité, délais)
- Considérer une transition plus douce entre les scènes
- Ajouter une détection de mouvement pour différencier présence statique/active

---

*Ce système offre une solution complète et intelligente pour l'éclairage automatisé, équilibrant automatisation et contrôle manuel.*
