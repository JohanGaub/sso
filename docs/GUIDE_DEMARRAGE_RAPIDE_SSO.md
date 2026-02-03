# Guide de Démarrage Rapide : Intégration SSO OAuth2/OpenID Connect

## 🚀 Pour Commencer Maintenant

Guide rapide pour intégrer SSO OAuth2/OpenID Connect dans Symfony.

**Temps estimé :** ~2 heures

---

## 📋 Checklist Rapide

### Étape 1 : Configuration du Provider SSO (30-45 min)

1. **Créer l'application OAuth** : Consultez `EXEMPLES_PROVIDERS.md` pour votre provider
2. **Copier le Client ID et le Client Secret** (⚠️ le secret ne sera plus visible après fermeture)
3. **Dans `.env`, ajouter** :
   ```env
   ###> SSO Google ###
   GOOGLE_CLIENT_ID=xxxxx.apps.googleusercontent.com
   GOOGLE_CLIENT_SECRET=votre-secret-ici
   ###< SSO Google ###
   ```

### Étape 2 : Configuration Symfony (30-45 min)

#### 2.1 Installation du Bundle OAuth2

- [X] **Installer le bundle principal** :
  ```bash
  task console php
  composer require knpuniversity/oauth2-client-bundle
  ```

- [X] **Installer le provider** (exemple Google) :
  ```bash
  composer require league/oauth2-google
  ```
  > 💡 Voir `EXEMPLES_PROVIDERS.md` pour d'autres providers

#### 2.2 Configuration

- [X] **Dans `config/packages/knpu_oauth2_client.yaml`, remplacer par** :
  ```yaml
  knpu_oauth2_client:
      clients:
          google:
              type: google
              client_id: '%env(GOOGLE_CLIENT_ID)%'
              client_secret: '%env(GOOGLE_CLIENT_SECRET)%'
              redirect_route: connect_google_check
  ```

- [X] **Vérifier** : `task cc`

#### 2.3 Suite de la Configuration

- [ ] Créer `src/Security/SSOAuthenticator.php`
- [ ] Créer `src/Security/SSOUserProvider.php`
- [ ] Créer les routes
- [ ] Créer le contrôleur de login
- [ ] `task cc`

### Étape 3 : Test (15 min)

- [ ] Accéder à `https://votre-domaine.docker.localhost/login`
- [ ] Vérifier la redirection vers le provider et le retour après connexion

---

## 🔗 Liens Utiles

- **Documentation complète** : `GUIDE_SSO_GENERIQUE.md`
- **Exemples par provider** : `EXEMPLES_PROVIDERS.md`

---

## ⚠️ Points d'Attention

1. **Secret Client** : Copiez-le immédiatement (ne sera plus visible)
2. **URI de Redirection** : Doivent correspondre **exactement** entre provider et Symfony
3. **Cache** : `task cc` après chaque modification de configuration

---

## 🆘 Besoin d'Aide ?

Consultez `GUIDE_SSO_GENERIQUE.md` → section "Dépannage"

---

---

## 🎯 Que Faire Après le Test Réussi ?

Vous avez deux options :

### Option 1 : Test Rapide Terminé ✅

Si le test rapide suffit, c'est terminé.

### Option 2 : Implémentation Complète 🚀

> **➡️ Basculer vers `PHASE_1_MVP.md`**  
> ⚠️ **Important** : Une fois sur PHASE_1_MVP.md, suivez-le jusqu'au bout.

**Contenu de PHASE_1_MVP.md :**
- Modèle de données (entité User)
- Authentification OAuth2 complète
- Compte Juste-à-Temps (création auto)
- Gestion des Rôles
- Tests

**Temps estimé :** 1 semaine

