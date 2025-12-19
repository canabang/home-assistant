# 🤖 Custom Intents K-2SO Style

Ce dossier contient la configuration pour les commandes vocales personnalisées de Home Assistant avec une personnalité sarcastique type K-2SO (Star Wars).

## 🏗️ Architecture

Le système repose sur trois piliers :
1. **Phrases (Custom Sentences)** : Définit ce que l'assistant doit écouter.
2. **Intent Scripts** : Associe une phrase à une action et lance la réponse vocale.
3. **Script de Confirmation Account** : Gère la génération dynamique par IA et la diffusion via Alexa.

## 📂 Fichiers et Emplacements

### 1. Reconnaissance Vocale (STT & Assist)
Le fichier `lumiere_salon.yaml` doit être présent à **deux endroits** si vous utilisez `speech-to-phrase` :
- `/share/speech-to-phrase/custom_sentences/fr/lumiere_salon.yaml` (pour l'entraînement du STT)
- `/config/custom_sentences/fr/lumiere_salon.yaml` (pour le matching de l'intent par HA)

### 2. Actions (Intent Scripts)
Le fichier `intent_scripts.yaml` contient la logique de branchement. 
- Emplacement : `/config/intent_scripts.yaml`
- Configuration dans `configuration.yaml` :
  ```yaml
  intent_script: !include intent_scripts.yaml
  ```

### 3. Réponse Dynamique (Script)
Le fichier `k_2so_confirm_action.yaml` gère l'appel à l'IA (`ai_task.generate_data`) pour éviter les timeouts des intents.
- Emplacement recommandé : `/config/scripts.yaml` ou dossier inclus.

## 🚀 Utilisation

Dites simplement une phrase configurée comme :
- *"Banane"* ou *"Lumos"* pour allumer.
- *"Il va faire tout noirs"* ou *"Eteins le salon"* pour éteindre.

L'action sera immédiate, et K-2SO vous répondra quelques secondes plus tard avec une réplique improvisée.

## 🛠️ Debugging

Si une phrase est reconnue par le STT mais ne déclenche rien :
1. Vérifiez que le fichier est bien dans `/config/custom_sentences/fr/`.
2. Rechargez les **Phrases de Assist** dans les outils de développement.
3. Testez la phrase manuellement dans l'outil **Assist** de Home Assistant.
