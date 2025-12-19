# Phase 2 : Le Cerveau Contextuel

**Objectif :** Rendre les commandes vocales universelles et intelligentes.

## 🧠 Intelligence Contextuelle et Subtilités Techniques

Le fichier `intent_scripts.yaml` de la Phase 2 utilise plusieurs astuces pour être 100% fiable :

1.  **L'Asynchronisme (Anti-Timeout)** :
    -   Au lieu d'appeler `script.k_2so_confirm_action` directement, on utilise `service: script.turn_on`.
    -   **Pourquoi ?** Cela lance le script en tâche de fond. Home Assistant valide la commande instantanément sans attendre que l'IA Gemini réponde. K-2SO parle dès qu'il est prêt.

2.  **Le Découpage "Hybride"** :
    -   On essaie d'abord d'identifier la pièce par le `satellite_id` (nécessite **un assistant vocal physique par pièce**).
    -   On utilise `device_id | string` comme alternative, car parfois Home Assistant renvoie un objet système au lieu d'un texte simple. Le transformer en `string` débloque l'identification.
    -   En dernier recours, on regarde `sensor.presence_piece`.

3.  **Généricité Totale** :
    -   Les entités sont construites dynamiquement (ex: `cover.vol{{ piece }}`). Cela permet à un seul intent de piloter toute la maison sans aucun nom de pièce dans le code.

4.  **Diagnostic de Secours** :
    -   L'intent "K-2SO Diag" court-circuite tout le système (IA comprise) pour envoyer un rapport brut sur Alexa. Indispensable pour debugger la présence et les IDs en temps réel.

## 🚀 Fonctionnalités avancées
-   **Résilience Quota** : K-2SO dispose d'un message de secours si l'IA Gemini est saturée.
-   **Support Étendu** : Lumières, Volets, Machine à café (Switch), Mode Dodo (Automatisations).

## ❓ Ça sert à quoi ?
À ne plus jamais avoir à dire "allume la cuisine" quand on est déjà dans la cuisine. L'assistant devient conscient de votre position.

## 🛠️ Ce que ça fait concrètement
-   **Lumières** : "Lumos" allume la pièce où vous êtes.
-   **Volets** : "Ferme le volet" descend le volet de la pièce actuelle.
-   **Raccourcis** : "Kawa" lance le café, "Dodo" éteint tout et active votre scène de nuit.
-   **Asynchronisme** : L'action est immédiate. K-2SO réagit après, sans ralentir la domotique.
-   **Résilience** : Si l'IA Gemini est indisponible, K-2SO bascule sur un message de secours.

## 📋 Plan de Déploiement (Double Copie)
*Appliquer aux fichiers : `contextual_lights, contextual_covers, shortcuts`*

1. Copie vers `/share/speech-to-phrase/custom_sentences/fr/` (STT).
2. Copie vers `/config/custom_sentences/fr/` (HA).
3. Fusionner `intent_scripts.yaml` dans `/config/intent_script.yaml`.
### 3. Fichier /config/template.yaml
Le contenu de `presence_piece.yaml` doit être ajouté dans votre fichier de templates :
- `/config/template.yaml` (nécessite `template: !include template.yaml` dans votre configuration.yaml)

### 4. Interface UI (Scripts)
Le contenu des fichiers suivants doit être ajouté via **Paramètres > Automatisations et scènes > Scripts** (en mode YAML) :
- `k_2so_confirm_action.yaml` (Phase 2)
- `notification_dynamique_alexa.yaml` (Scripts)
- `gerer_eclairage.yaml` (Scripts)
