# 🐾 Pet Feeder - Home Assistant Integration v2.0

<img width="1866" height="1055" alt="Pet Feeder Dashboard" src="https://github.com/user-attachments/assets/f139fa9e-ef1f-4e03-86ec-89e3d6c64390" />

Une solution complète de monitoring intelligent pour distributeur automatique de nourriture avec **analytics historiques avancés**, **prédictions par IA**, et **surveillance santé comportementale**.

## ✨ Fonctionnalités principales

### 🎯 Gestion automatique des portions
- **Calcul intelligent** : Les portions sont automatiquement calculées en fonction du poids unitaire et de l'objectif quotidien
- **Répartition optimisée** : Distribution sur 3 repas (Matin 28%, Midi 32%, Soir 40%)
- **Recalcul automatique** : Mise à jour immédiate lors du changement des paramètres
- **Application automatique** : Les nouvelles portions sont directement envoyées au distributeur via MQTT

### 📊 Suivi de la consommation avancé avec historique long terme
- **Triple méthode de calcul** : Estimation classique, calcul précis basé sur données réelles, ET **prédiction IA avec historique**
- **Analytics historiques** : Moyennes mobiles 7j/30j avec détection automatique de tendances
- **Détection d'anomalies comportementales** : Alertes intelligentes basées sur l'analyse des habitudes alimentaires
- **Monitoring en temps réel** : Suivi du dernier repas distribué et du total quotidien
- **Base de données MariaDB** : Stockage long terme pour analyses prédictives avancées
- **Rapports automatiques** : Génération mensuelle avec recommandations IA

### 💧 Surveillance hydratation intelligente
- **Balance d'eau intégrée** : Capteur HX711 dédié pour mesure précise du niveau fontaine
- **Calcul ratio hydratation** : ml eau / g croquettes avec évaluation santé automatique
- **Analyse comportementale** : Détection d'anomalies d'hydratation avec conseils vétérinaires
- **Historique hydratation** : Moyennes 7 jours avec évolution des habitudes
- **Alertes santé** : Notifications préventives en cas de sur/sous-hydratation

### 🔬 Validation croisée multi-sources
- **Double capteur intelligent** : Balance physique HX711 + estimation logicielle
- **Validation automatique** : 5 niveaux de cohérence (COHERENT → DIVERGENCE_MAJEURE)
- **Synchronisation auto** : Correction des estimations basée sur données physiques fiables
- **Diagnostic système** : Surveillance de l'état des capteurs avec codes d'erreur
- **Mode de secours** : Basculement automatique si défaillance capteur

### 🤖 Intelligence artificielle intégrée
- **Prédictions avancées** : Algorithmes basés sur historique + correction tendancielle
- **Génération de messages** : Alertes personnalisées style K-2SO avec contexte intelligent
- **Détection d'anomalies** : Machine learning pour identifier comportements préoccupants
- **Auto-apprentissage** : Le système devient plus précis avec l'accumulation de données
- **Niveaux de confiance** : Fiabilité calculée selon la quantité de données historiques

### 📈 Analytics et statistiques avancées
- **Tendances long terme** : Analyse évolution consommation avec variation pourcentage
- **Comparaisons temporelles** : Aujourd'hui vs 7j vs 30j vs objectifs
- **Prédictions multiples** : 4 méthodes différentes avec scores de fiabilité
- **Statistiques mensuelles** : Projections et analyse de performance
- **Graphiques historiques** : Visualisation des évolutions avec mini-graph-card

## 🏗️ Architecture technique enrichie

### Capteurs physiques (ESPHome)
- **Balance croquettes** : HX711 → ESP32 (pins 5,18) - Précision ±1g
- **Balance eau** : HX711 → ESP32 (pins 16,4) - Capacité 1,5L
- **Auto-calibration** : 2 points de référence avec recalibration automatique
- **Filtrage avancé** : Médiane + moyenne mobile pour éliminer le bruit
- **État capteur** : Diagnostic temps réel avec codes d'erreur détaillés

### Entités principales

#### Numbers (du distributeur)
- `number.pet_feeder_portion_weight` : **Poids unitaire par portion (g)** - Paramètre clé pour tous les calculs

#### Input Numbers étendus
- `pet_feeder_target_daily_weight` : Objectif quotidien (20-150g, défaut: 85g)
- `pet_feeder_stock_estime` : Stock estimé actuel synchronisé avec balance physique
- `pet_feeder_max_capacity` : Capacité maximale du réservoir (variable selon croquettes)
- `pet_feeder_daily_consumption_counter` : Compteur consommation quotidienne
- `pet_feeder_cumulative_distributed_since_refill` : Poids cumulé depuis dernier remplissage
- `pet_feeder_total_distributed` : Total distribué (cumulatif général)
- `pet_feeder_refill_date` : Timestamp du dernier remplissage
- **NOUVEAU** `pet_water_level_morning` : Niveau eau sauvegardé pour calcul consommation
- **NOUVEAU** `pet_water_max_capacity` : Capacité fontaine (défaut: 1500ml)
- **NOUVEAU** `pet_water_daily_counter` : Compteur consommation eau quotidienne

#### Sensors calculés enrichis
- `portions_calculees_*` : Portions pour chaque repas (matin/midi/soir)
- `total_portions_calculees` : Total des portions programmées avec détails
- `pourcentage_croquette_restant` : Niveau du réservoir en %
- `consommation_quotidienne_moyenne` : Consommation du jour en cours
- `consommation_moyenne_reelle` : Consommation réelle basée sur données cumulatives
- `jours_restants_nourriture` : Prédiction classique avant rupture
- `jours_restants_nourriture_methode_cumulative` : Prédiction précise basée sur consommation réelle
- **NOUVEAU** `consommation_moyenne_7_jours` : Moyenne mobile historique courte
- **NOUVEAU** `consommation_moyenne_30_jours` : Moyenne mobile historique longue
- **NOUVEAU** `tendance_consommation` : Détection HAUSSE/BAISSE/STABLE avec %
- **NOUVEAU** `detection_anomalie_alimentaire` : IA d'analyse comportementale
- **NOUVEAU** `prediction_autonomie_amelioree` : Prédiction IA avec correction tendancielle
- **NOUVEAU** `stats_mensuelles_pet_feeder` : Rapport mensuel automatique
- **NOUVEAU** `validation_stock_multi_sources` : Validation croisée balance/estimation
- **NOUVEAU** `balance_croquettes_en_grammes` : Conversion balance physique en grammes
- **NOUVEAU** `consommation_eau_quotidienne` : ml d'eau consommés dans la journée
- **NOUVEAU** `ratio_hydratation_quotidien` : ml eau / g croquettes avec évaluation santé
- **NOUVEAU** `hydratation_moyenne_7_jours` : Historique hydratation
- **NOUVEAU** `evolution_hydratation` : Détection changements comportement hydrique
- **NOUVEAU** `validation_systeme_complet` : État global eau + croquettes

#### Input Boolean étendus
- `pet_feeder_stock_was_low` : Indicateur technique de stock bas
- `pet_feeder_manual_refill_trigger` : Déclencheur pour initialisation manuelle
- **NOUVEAU** `pet_feeder_force_sync_balance` : Force synchronisation avec balance physique

### Automatisations intelligentes enrichies

1. **Recalcul automatique des portions** *(existant amélioré)*
   - Déclencheur : Changement poids unitaire ou objectif quotidien
   - Action : Recalcul + mise à jour MQTT + logging IA détaillé

2. **Mise à jour compteurs unifiée** *(existant amélioré)*
   - Déclencheur : Nouveau repas distribué
   - Actions : MAJ tous compteurs + validation croisée + détection anomalies

3. **Détection de rechargement automatique** *(existant)*
   - Condition : Passage <300g → >950g
   - Action : Reset compteurs + initialisation nouveau cycle + logging IA

4. **NOUVEAU - Correction automatique divergence majeure**
   - Déclencheur : Divergence >25% entre balance et estimation pendant 2min
   - Conditions : Balance fiable (état capteur OK + niveau >5%)
   - Action : Notification utilisateur + possibilité correction automatique

5. **NOUVEAU - Synchronisation automatique balance**
   - Déclencheur : 6h00 quotidien OU validation COHERENT pendant 5min
   - Conditions : Balance OK + niveau >10%
   - Action : Sync estimation vers balance si cohérent

6. **NOUVEAU - Alerte anomalie historique**
   - Déclencheur : Détection SURCONSOMMATION/SOUS_CONSOMMATION pendant 2h
   - Conditions : Niveau confiance HAUTE ou MOYENNE
   - Action : Message IA + notification persistante + suggestion santé

7. **NOUVEAU - Rapport mensuel automatique**
   - Déclencheur : 1er du mois à 9h00
   - Action : Génération rapport IA avec stats + tendances + recommandations

8. **NOUVEAU - Surveillance hydratation**
   - Déclencheur : Ratio <1.0ml/g ou >6.0ml/g pendant 1-2h
   - Conditions : Données suffisantes (>5g croquettes)
   - Action : Alerte santé + notification persistante + conseil vétérinaire

9. **NOUVEAU - Sauvegarde niveau eau matinal**
   - Déclencheur : 6h00 quotidien
   - Action : Sauvegarde niveau pour calcul consommation quotidienne

10. **NOUVEAU - Alertes multi-sources intelligentes**
    - Déclencheur : Niveau <30% (eau OU croquettes) OU divergence majeure
    - Action : Messages IA contextuels + affichage AWTRIX + escalade selon criticité

## 🗄️ Configuration Base de Données (MariaDB)

### Recorder optimisé pour historique long terme
```yaml
recorder:
  db_url: mysql://user:pass@ip:3306/homeassistant
  purge_keep_days: 365  # 1 an d'historique
  commit_interval: 5
  
  include:
    entities:
      # Capteurs principaux pour analytics
      - input_number.pet_feeder_daily_consumption_counter
      - input_number.pet_feeder_stock_estime
      - sensor.pourcentage_croquette_restant
      - sensor.esp_pet_scales_eau
      - sensor.esp_pet_scales_croquettes
      - sensor.consommation_eau_quotidienne
      - sensor.ratio_hydratation_quotidien
      - sensor.validation_stock_multi_sources
      # ... (voir configuration complète)
```

### Optimisations performance
- **Exclusion capteurs verbeux** : Raw values, diagnostics, états capteurs
- **Commit optimisé** : Équilibre performance/sécurité données
- **Purge intelligente** : Conservation 1 an avec indexes optimisés

## 🚀 Installation v2.0

### Prérequis
- Home Assistant avec Zigbee2MQTT fonctionnel
- **Base MariaDB déportée** configurée et accessible
- ESP32 avec 2x capteurs HX711 (croquettes + eau) - **NOUVEAU**
- Distributeur Pet Feeder compatible Zigbee déjà intégré
- Cartes personnalisées : `mini-graph-card`, `multiple-entity-row`, `bar-card`, `template-entity-row`
- **Intégration Google Generative AI** pour messages intelligents - **NOUVEAU**

### Configuration Hardware (NOUVEAU)

1. **Installation capteurs HX711** :
   ```yaml
   # ESPHome configuration
   sensor:
     - platform: hx711
       name: "Croquettes Raw"
       dout_pin: 5    # Balance croquettes
       clk_pin: 18
     - platform: hx711  
       name: "Eau Raw"
       dout_pin: 16   # Balance eau
       clk_pin: 4
   ```

2. **Calibration balances** :
   - Suivre procédure ESPHome avec poids de référence
   - Utiliser boutons calibration intégrés dans l'interface
   - Vérifier codes d'état capteurs (2.0 = OK)

### Configuration Software

1. **Mise à jour recorder.yaml** :
   ```yaml
   # Ajouter configuration historique long terme
   recorder: !include recorder.yaml
   ```

2. **Copier/Créer les fichiers enrichis** :
   ```yaml
   # Dans configuration.yaml
   input_number: !include input_number.yaml      # Étendu avec eau
   input_boolean: !include input_boolean.yaml    # + force_sync_balance
   template: !include template.yaml              # + 15 nouveaux capteurs
   automation: !include automations.yaml        # + 7 nouvelles automatisations
   ```

3. **Configurer ESPHome** :
   - Déployer `petscales.yaml` sur ESP32
   - Vérifier connectivité des 2 balances
   - Effectuer calibration initiale

4. **Ajouter le dashboard v2.0** :
   - 6 sections enrichies avec analytics historiques
   - Nouvelles cartes : anomalies, hydratation, validation système
   - Graphiques comparatifs des prédictions

### Configuration initiale étendue

1. **Calibration complète** :
   - **Poids unitaire portions** : Crucial pour précision
   - **Capacité réservoir croquettes** : Selon type utilisé
   - **Capacité fontaine eau** : Défaut 1500ml, ajuster selon modèle
   - **Balances physiques** : Procédure tare + poids référence

2. **Initialisation système** :
   - Remplissage complet réservoir + fontaine
   - Activation `pet_feeder_manual_refill_trigger` 
   - Vérification synchronisation balance/estimation
   - Test distribution manuelle + vérification compteurs

3. **Période d'apprentissage** :
   - **48h** : Données partielles, utilisation estimations classiques
   - **7 jours** : Moyennes fiables, activation prédictions IA
   - **30 jours** : Précision maximale, détection anomalies optimale

## 📱 Utilisation v2.0

### Analytics historiques
- **Section dédiée** avec tendances 7j/30j et détection anomalies
- **Graphiques évolution** : Consommation historique vs moyennes mobiles
- **Rapports mensuels** : Statistiques + projections + recommandations IA
- **Comparaison 4 méthodes** : Classique, précis, IA, balance physique

### Surveillance hydratation
- **Calcul automatique** consommation eau quotidienne (niveau matin → soir)
- **Ratio ml/g** avec évaluation santé : Insuffisante → Excellente → Excessive
- **Conseils vétérinaires** automatiques selon ratio détecté
- **Alertes santé** si changement comportemental significatif

### Validation multi-sources
- **Comparaison temps réel** : Balance physique vs estimation logicielle
- **5 niveaux cohérence** : COHERENT (écart <8%) → DIVERGENCE_MAJEURE (>25%)
- **Corrections automatiques** : Sync estimation si balance fiable
- **Diagnostic système** : État capteurs + scores fiabilité globaux

### Prédictions intelligentes
- **4 méthodes simultanées** :
  1. Estimation classique (objectif théorique)
  2. Calcul précis (consommation réelle mesurée)
  3. **Prédiction IA** (historique + correction tendancielle)
  4. **Validation balance** (mesure physique directe)
- **Niveaux confiance** : 70% → 95% selon données disponibles
- **Auto-sélection** méthode la plus fiable selon contexte

## ⚙️ Paramètres configurables v2.0

| Paramètre | Description | Valeur défaut | **Nouveau** |
|-----------|-------------|---------------|-------------|
| **Poids unitaire** | Poids par portion (g) | À calibrer | |
| Objectif quotidien | Quantité cible par jour | 85g | ⬆️ |
| Capacité réservoir | Volume maximum croquettes | 1500g | |
| **Capacité fontaine** | Volume maximum eau | 1500ml | ✅ |
| Seuil stock bas | Niveau d'alerte croquettes | 300g | |
| **Seuil eau faible** | Niveau d'alerte eau | 30% | ✅ |
| Seuil rechargement | Détection remplissage auto | 950g | |
| **Seuils anomalies** | ATTENTION (8%) / MAJEURE (25%) | Variables | ✅ |
| **Purge historique** | Rétention données MariaDB | 365 jours | ✅ |
| Répartition repas | Matin/Midi/Soir | 28%/32%/40% | |

### Nouveaux seuils intelligents

| Seuil Hydratation | Description | Action |
|------------------|-------------|---------|
| < 1.0 ml/g | Hydratation insuffisante | Alerte + conseil véto |
| 1.0-2.0 ml/g | Hydratation faible | Surveillance |
| 2.0-3.5 ml/g | Hydratation correcte | Normal |
| 3.5-5.0 ml/g | Hydratation excellente | Normal |
| > 6.0 ml/g | Très forte hydratation | Alerte santé |

## 🔬 Fonctionnalités avancées v2.0

### Intelligence artificielle intégrée
- **Messages contextuels** : Génération automatique style K-2SO avec données situation
- **Détection anomalies** : Algorithmes adaptatifs basés sur historique personnel
- **Prédictions évolutives** : Correction automatique selon tendances détectées
- **Recommandations santé** : Conseils personnalisés basés sur comportement animal

### Système de validation croisée
```yaml
# Exemple validation multi-sources
COHERENT:         Écart <8%   → Système fiable
ATTENTION:        Écart 8-15% → Surveillance renforcée  
DIVERGENCE_MINEURE: Écart 15-25% → Vérification manuelle
DIVERGENCE_MAJEURE: Écart >25%    → Correction automatique
CAPTEUR_DEFAILLANT: Niveau <5%    → Mode dégradé
```

### Analytics prédictifs
- **Moyennes mobiles** : 7j (réactivité) + 30j (stabilité)
- **Détection tendances** : HAUSSE/BAISSE/STABLE avec variations %
- **Corrections tendancielles** : Prédictions ajustées selon évolution récente
- **Saisonnalité** : Détection patterns récurrents (préparation future)

### Monitoring santé avancé
- **Ratio hydratation** : ml eau / g croquettes avec évaluation médicale
- **Évolution comportementale** : Détection changements habits alimentation/boisson
- **Alertes préventives** : Notifications avant problèmes santé potentiels
- **Rapports vétérinaires** : Exports données pour consultations professionnelles

## 🎨 Interface v2.0 - Dashboard enrichi

### Section 1 : Vue d'ensemble enrichie
- **Gauge dual** : Stock restant + prédiction IA simultanées
- **Carte alertes** : État système global + détection anomalies temps réel
- **Graphique multi-sources** : Balance physique vs estimation vs historique

### Section 2 : Analytics historiques (NOUVELLE)
- **Moyennes temporelles** : 7j/30j vs objectif avec codes couleur
- **Détection tendances** : HAUSSE/BAISSE avec pourcentages variation
- **Prédiction IA** : Autonomie calculée avec niveau confiance affiché
- **Graphique historique** : 7 jours consommation vs moyennes mobiles

### Section 3 : Surveillance santé (ENRICHIE)
- **Analyse comportementale** : Détection anomalies avec seuils adaptatifs
- **Hydratation avancée** : Ratio ml/g + évolution + conseils vétérinaires
- **Comparaisons temporelles** : Aujourd'hui vs moyennes 7j/30j

### Section 4-6 : Sections existantes améliorées
- **Graphiques comparatifs** : 4 méthodes prédiction côte à côte
- **Validation système** : Scores fiabilité + diagnostic capteurs
- **Contrôles analytics** : Actions manuelles sur données historiques

## 📊 Métriques et KPI v2.0

### Indicateurs de performance
- **Score système global** : /10 basé sur état capteurs + cohérence données
- **Précision prédictive** : % fiabilité selon historique disponible
- **Santé comportementale** : Évolution habitudes alimentaires/hydriques
- **Efficacité énergétique** : Optimisation distributions vs gaspillage

### Alertes intelligentes
- **Graduées par criticité** : Info → Attention → Critique → Urgence
- **Contextuelles** : Messages adaptatifs selon situation + historique
- **Multi-canal** : TTS + AWTRIX + notifications persistantes + logs
- **Escalade automatique** : Répétition selon gravité + acquittement

## 🛠️ Troubleshooting v2.0

### Diagnostics automatiques
- **Codes d'état capteurs** : 0.0 (erreur) / 1.0 (hors calibration) / 2.0 (OK)
- **Validation croisée** : Détection incohérences entre sources
- **Santé système** : Score global performance + recommandations
- **Logs enrichis** : Contexte IA pour debug facilité

### Mode dégradé automatique
- **Basculement intelligent** : Si balance HS → estimation seule avec alertes
- **Seuils adaptatifs** : Ajustement automatique si données partielles
- **Notifications proactives** : Prévention avant pannes complètes
- **Recovery automatique** : Retour normal dès capteurs OK

## 🔍 Différences v2.0 vs v1.0

### Nouvelles capacités majeures
✅ **Base MariaDB** : Historique long terme 365j avec analytics avancés  
✅ **IA intégrée** : Prédictions + messages contextuels + détection anomalies  
✅ **Double balance HX711** : Eau + croquettes avec validation croisée  
✅ **Surveillance santé** : Ratio hydratation + conseils vétérinaires  
✅ **Analytics prédictifs** : Moyennes mobiles + tendances + corrections  
✅ **Rapports automatiques** : Mensuels avec recommandations IA  
✅ **Interface enrichie** : 6 sections + graphiques historiques + comparaisons  

### Améliorations techniques
- **Performance optimisée** : Intervals adaptatifs + cache intelligent
- **Résilience système** : Mode dégradé + auto-recovery + watchdog
- **Précision accrue** : 4 méthodes prédiction + validation multi-sources
- **Maintenance facilitée** : Diagnostics auto + logs contextuels IA

## 💡 Roadmap et extensions possibles

### Court terme (1-3 mois)
- **Export données** : CSV/JSON pour analyses externes
- **Mode vacances** : Portions réduites programmables
- **Alertes SMS/Telegram** : Notifications critiques déportées
- **Interface mobile** : Version optimisée smartphone

### Moyen terme (3-6 mois)  
- **Machine Learning avancé** : Détection patterns saisonniers
- **Multi-animaux** : Gestion profils individuels avec reconnaissance
- **API REST** : Intégrations applications tierces
- **Backup automatique** : Sauvegarde configurations + données

### Long terme (6-12 mois)
- **Reconnaissance faciale** : Caméra pour identification individuelle
- **Balance animal** : Suivi poids corporel avec corrélations alimentaires
- **Capteurs environnementaux** : Température/humidité/qualité air
- **Écosystème complet** : Hub centralisant tous aspects santé animal

---

*Ce projet v2.0 représente une solution de **monitoring animal de grade professionnel** avec intelligence artificielle intégrée, analytics prédictifs long terme, et surveillance santé comportementale. L'architecture modulaire permet une évolution continue vers un écosystème complet de bien-être animal. 🐱🐶🤖*
