# Documentation Frigate - Système de vidéosurveillance IA

## Vue d'ensemble

Frigate analyse en temps réel les flux vidéo d'une caméra IP pour détecter des personnes et des chats. Quand un objet est détecté, une IA (Google Gemini) génère une description en français et envoie des notifications sur Discord et Home Assistant.

## Stack technique

- **Frigate 0.16-1** : Détection d'objets via OpenVINO (CPU)
- **go2rtc** : Streaming WebRTC avec audio bidirectionnel
- **Google Gemini 2.5 Flash** : Descriptions automatiques
- **Home Assistant** : Automatisations et notifications
- **MQTT** : Bus de communication

## Caméra : oeil-de-sauron

### Détection
- **Résolution** : 1920x1080 à 5 FPS
- **Objets** : Personnes (min 75%) et chats (min 70%)
- **Zones** : "entrée" et "appart"

### Fonctionnalités
- **Reconnaissance faciale** : Identifie les personnes connues (seuil 85%)
- **Autotracking PTZ** : Suit automatiquement les objets dans la zone "appart"
- **Audio bidirectionnel** : Écoute + possibilité de parler via la caméra
- **Détection audio** : Bris de verre, sonnette, miaulements, etc.

## Intelligence artificielle

L'IA génère des descriptions contextuelles :
- **Personnes** : Utilise le nom si reconnu, sinon "Personne non identifiée". Décrit les actions (entrer, sortir, objets portés).
- **Chats** : Décrit les mouvements et interactions avec l'environnement.

## Enregistrement

| Type | Durée conservation | Conditions |
|------|-------------------|-----------|
| Continu | 2 jours | Sur mouvement uniquement |
| Alertes | 7 jours | 5s avant/après l'événement |
| Snapshots | 10-14 jours | Selon type d'objet |

## Notifications

Chaque détection avec description IA déclenche :

1. **Discord** : Message avec snapshot, description et liens vidéo
2. **Home Assistant** : Notification persistante

**Identification automatique** :
- 🏠 Nom : Si reconnaissance faciale réussie
- ⚠️ Personne inconnue : Détection sans identification
- 🐱 Chat : Animal détecté

Format des notifications :
```
📷 Caméra: oeil-de-sauron
⏰ Détection: 27/10/25 à 14h30
🤖 Description IA: [texte généré]
[Liens snapshot/vidéo/détails]
```

## Configuration réseau

- **MQTT** : Port 1883
- **WebRTC** : Port 8555
- **RTSP caméra** : Port 554
- **ONVIF** : Port 8000
- **Accélération** : VAAPI (GPU Intel/AMD)

## Interface

- **Fuseau horaire** : Europe/Paris (format 24h)
- **Qualité live** : Maximale (8/8)
- **Recherche sémantique** : Activée (recherche par description texte)

## Modèle de détection

- **Architecture** : SSDLite MobileNet v2 (OpenVINO)
- **Classes** : COCO 91 classes
- **Input** : 300x300 BGR
