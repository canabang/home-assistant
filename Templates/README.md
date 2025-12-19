# 🧩 Templates de Capteur

Ce dossier contient les définitions de capteurs virtuels (templates) utilisés pour donner de l'intelligence contextuelle à Home Assistant.

## 🔍 Choix de l'Intelligence

Deux versions du capteur sont disponibles selon votre niveau d'aisance avec YAML :

### 1. [Version Standard (Recommandée)](./presence_piece.yaml)
C'est la version "Pro" utilisée dans le projet complet.
- **Points forts** : Gère les priorités si vous êtes entre deux pièces, exclut la SdB si vous y avez oublié la lumière, et possède des attributs avancés pour les notifications groupées.

### 2. [Version Basique (Pour Débuter)](./presence_piece_basic.yaml)
Une version simplifiée avec une logique `Si / Sinon` très lisible.
- **Points forts** : Très facile à comprendre et à modifier si vous avez peu de capteurs. Idéal pour faire ses premiers pas sans se soucier des cas complexes.

---

## ⚙️ Détails Techniques (Version Pro)
Le capteur déduis la pièce occupée à partir de vos différents détecteurs :
- **Fonctionnement** : Il scrute une carte (`presence_map`) de tous vos capteurs binaires (ESP, Zigbee, etc.).
- **Priorité de conflit** : Si plusieurs pièces détectent du mouvement, il applique une priorité logique (Salon > Cuisine > Chambre > SdB).
- **Exclusion Intelligente** : Il exclut automatiquement la Salle de Bain si la fenêtre est ouverte ou si une certaine lumière est allumée.
- **Attributs Echo** : Il associe chaque pièce à son enceinte Alexa pour que K-2SO vous réponde au bon endroit.

## 📋 Installation
1. Copiez le contenu du fichier dans votre fichier `/config/template.yaml`.
2. Assurez-vous d'avoir `template: !include template.yaml` dans votre `configuration.yaml`.
3. Rechargez les "Entités Template" dans les outils de développement de Home Assistant.
