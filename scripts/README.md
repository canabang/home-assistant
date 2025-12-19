# 📜 Scripts de Support

Ces scripts constituent le "moteur d'exécution" des commandes vocales et de l'automatisation de la maison.

## 🛠️ Contenu du dossier

### 1. [Notification Dynamique Alexa](./notification_dynamique_alexa.yaml)
Ce script gère l'envoi de messages vocaux sur vos enceintes Amazon Echo.
- **Intelligence** : Il mémorise le volume actuel, baisse le son pour parler, et remet le volume initial après le message.
- **Gestion Musique** : Si Spotify est en cours de lecture, il met en pause la musique et la relance automatiquement après la notification.
- **Usage** : Utilisé par K-2SO pour vous répondre de manière asynchrone.

### 2. [Gérer Éclairage](./gerer_eclairage.yaml)
Le cerveau central de toutes vos lumières.
- **Priorité Vocale** : Si vous demandez d'allumer à la voix, il ignore les blocages habituels des détecteurs.
- **Logique Globale** : Gère les transitions jour/nuit, les scènes de stimulation (jour) ou de veilleuse (nuit/réveil récent).
- **Protection** : Évite d'allumer la chambre si quelqu'un est au lit ou la SdB si le mode "Prismal" est actif.

## 📋 Installation
Ces fichiers sont fournis pour référence. Pour les utiliser :
1. Copiez le code YAML de chaque fichier.
2. Allez dans **Paramètres > Automatisations et scènes > Scripts** sur votre Home Assistant.
3. Créez un nouveau script, passez en **Mode YAML** via le menu (3 petits points) et collez le code.
