# Phase 1 : Test et Validation (Salon)

**Objectif :** S'assurer que votre voix arrive bien jusqu'à Home Assistant dans une pièce fixe.

## ❓ Ça sert à quoi ?
La Phase 1 est une "preuve de concept". Elle sert à éliminer les problèmes techniques (micro bouché, dossier mal placé, STT non entraîné) dans un environnement simple : le **Salon**.

## 🛠️ Ce que ça fait concrètement
- Vous dites **"Lumos"** ou **"Banane"**.
- Home Assistant ordonne au script du salon de s'allumer.
- K-2SO vous confirme l'action sur votre enceinte Alexa.

## 📋 Plan de Déploiement (Double Copie)
Pour que l'entraînement STT ET l'exécution HA fonctionnent :
1. Copier `lumiere_salon.yaml` dans `/share/speech-to-phrase/custom_sentences/fr/`
2. Copier `lumiere_salon.yaml` dans `/config/custom_sentences/fr/`
3. **Actions** : Ajoutez le contenu de `intent_scripts.yaml` dans votre fichier `/config/intent_script.yaml`.
4. **Confirmation (K-2SO)** : Copiez le contenu de `k_2so_confirm_action.yaml` via **l'interface UI** (Scripts YAML) pour activer la voix sarcastique.
5. **Validation** : Redémarrez l'addon Speech-to-Phrase (pour l'entraînement) ET rechargez les intents dans HA pour tester "Banane".
