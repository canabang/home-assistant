# 🤖 K-2SO : Collection d'Intents Personnalisés

Ce projet transforme votre Home Assistant en un assistant vocal avec du caractère, capable de comprendre le contexte sans que vous ayez à préciser la pièce.

## 📂 Guide de Déploiement

| Élément | Source (Dépôt) | Destination A (Entraînement STT) | Destination B (Exécution HA) |
| :--- | :--- | :--- | :--- |
| **Phrases (Sentences)** | `intents/phase_X/*.yaml` | `/share/speech-to-phrase/custom_sentences/fr/` | `/config/custom_sentences/fr/` |
| **Logique (Intents)** | `intents/phase_X/intent_scripts.yaml` | — | `/config/intent_script.yaml` |
| **Scripts (K-2SO & Alexa)** | `k_2so_confirm_action.yaml` <br> `scripts/notification_dynamique_alexa.yaml` | — | **Interface UI** (Scripts) |
| **Capteur Présence** | `templates/presence_piece.yaml` | — | `/config/template.yaml` |

## 🛠️ Configuration de base (configuration.yaml)
Pour que Home Assistant charge tous les composants, votre fichier principal doit inclure ces lignes :
```yaml
intent_script: !include intent_script.yaml
template: !include template.yaml
```

## 🌟 Ce que fait ce projet
- **Intelligence Spatiale** : Il détecte qui parle et où, pour agir au bon endroit (Lumos au salon allume le salon).
- **Personnalité K-2SO** : Toutes les confirmations sont générées par IA avec le ton sarcastique du droïde de Rogue One.
- **Réactivité Instantanée** : Les actions s'exécutent immédiatement, la voix de K-2SO suit en arrière-plan.

## 📂 Les deux étapes du projet

### 1️⃣ [Phase 1 : Test (Le Bac à Sable)](./phase_1/)
**But : Valider la technique.**
Si vous arrivez à dire "Lumos" et que le salon s'allume, votre configuration (Micro, STT, Dossiers) est parfaite. C'est l'étape de démarrage indispensable.

### 2️⃣ [Phase 2 : Production (L'Intelligence)](./phase_2/)
**But : Automatiser partout.**
Une fois la Phase 1 validée, ce module rend votre maison intelligente : les commandes deviennent génériques (Lumières, Volets, Café) et s'adaptent dynamiquement à votre position.

---
*Mission accomplie. Pour l'instant.*
