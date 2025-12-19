# 🧩 Templates de Capteur

Ce dossier contient les définitions de capteurs virtuels (templates) utilisés pour donner de l'intelligence contextuelle à Home Assistant.

## 🔍 Capteur Principal : [Presence Piece](./presence_piece.yaml)

Ce capteur déduis la pièce occupée à partir de vos différents détecteurs. C'est lui qui permet aux commandes "Lumos" d'être génériques.

- **Fonctionnement** : Il scrute une carte (`presence_map`) de tous vos capteurs binaires (ESP, Zigbee, etc.).
- **Priorité de conflit** : Si plusieurs pièces détectent du mouvement, il applique une priorité logique (Salon > Cuisine > Chambre > SdB).
- **Exclusion Intelligente** : Il exclut automatiquement la Salle de Bain si la fenêtre est ouverte ou si une certaine lumière est allumée (évite les faux positifs prolongés).
- **Attributs Echo** : Il associe dynamiquement chaque pièce à son enceinte Alexa correspondante pour que les notifications tombent au bon endroit.

## 📋 Installation
1. Copiez le contenu du fichier dans votre fichier `/config/template.yaml`.
2. Assurez-vous d'avoir `template: !include template.yaml` dans votre `configuration.yaml`.
3. Rechargez les "Entités Template" dans les outils de développement de Home Assistant.
