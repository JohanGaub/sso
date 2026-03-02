# Guide de migration SSO actuel → SSO cible

Documentation unique pour migrer des applications (PHP, Python, TypeScript, OIDC, SAML) vers un SSO cible, avec parcours adaptés au mode de gestion et au niveau d'autonomie.

---

## 1. Introduction (1 page max)

### Pourquoi migrer ?

- **Sécurité renforcée** : Authentification centralisée, gestion des sessions et des tokens conforme aux bonnes pratiques.
- **Expérience utilisateur** : Connexion unique (SSO) entre plusieurs applications.
- **Maintenabilité** : Un seul point de configuration pour l’identité et les attributs.
- **Conformité** : Alignement avec les standards (OIDC, SAML v2) et les politiques de sécurité.

### À qui s’adresse ce guide ?

- **Développeurs** :
  - Suivre les étapes techniques et les exemples de code (`Symfony`, `CodeIgniter`, `Python`, `TypeScript`).
  - Implémenter les changements sur les attributs ou les flux d’authentification selon la section ciblée.
- **Responsable technique** :
  - En fonction de l’appétence et de la maturité de chaque équipe applicative, **définir le niveau d’autonomie** (autonome / accompagné / délégation).
  - **Sélectionner le bon parcours** à partir de l’arbre de décision (protocole, gestion managée/privée, autonomie).
  - **Valider la conformité** de la migration (sécurité, cohérence des attributs/claims, respect des bonnes pratiques).

#### Rôles clés

- **Administrateur SSO cible** : admin du SSO cible (ex. Entra ID), responsable de la configuration de l’IdP (applications, attributs/claims, métadonnées IdP).
- **Équipe de raccordement applicatif** : équipe chargée d’intégrer le SSO cible dans les applications, en accompagnant chaque responsable d’application selon le niveau d’autonomie choisi (autonome, accompagné, délégué) : lecture des claims, adaptation de la configuration et du code, ou intégration complète à la place de l’équipe applicative.

### Comment utiliser ce document ?

1. **Répondre à 3 questions** dans l’[arbre de décision](#2-arbre-de-décision-visuel) : protocole (OIDC / SAML v2), mode de gestion (managée / privée), niveau d’autonomie (autonome / accompagné / délégué).
2. **Aller à la section correspondant à vos réponses** (ex. 3.1, 5.2) et suivre les étapes du tableau (cocher au fur et à mesure). Vous trouverez en plus des exemples de code et les pièges courants à éviter.
3. **Consulter les annexes** pour le glossaire, la FAQ et les ressources externes.

---

## 2. Arbre de décision visuel

Répondez aux trois questions ci-dessous, puis reportez-vous au **tableau** pour trouver la section à consulter.

**Question 1** : Quel protocole utilisez-vous ? → **OIDC** ou **SAML v2**  
**Question 2** : Votre application est-elle en **gestion managée** (modification des attributs uniquement) ou **gestion privée** (modification du flux d’authentification + attributs) ?  
**Question 3** : Quel est votre niveau d’autonomie ? → **Autonome** / **Accompagné** / **Délégué**

### Tableau de routage

| Protocole | Gestion | Niveau d'autonomie | Section à consulter | Contenu de la section |
|-----------|---------|--------------------|---------------------|------------------------|
| OIDC | Managée | Autonome | **3.1** | Actualiser les claims OIDC (mapping, validation, exemples). |
| OIDC | Managée | Accompagné / Délégué | **3.2** | Actualiser les claims OIDC + consulter la FAQ et les contacts d'accompagnement. |
| OIDC | Privée | Autonome | **4.1** | Reconfigurer le flux OIDC (schéma, code PHP/TypeScript/Python). |
| OIDC | Privée | Accompagné / Délégué | **4.2** | Reconfigurer le flux OIDC + solliciter l'assistance et consulter les exemples avancés. |
| SAML v2 | Managée | Autonome | **5.1** | Actualiser les attributs SAML (ex. XML, validation via outil en ligne). |
| SAML v2 | Managée | Accompagné / Délégué | **5.2** | Actualiser les attributs SAML + consulter la FAQ et les contacts dédiés. |
| SAML v2 | Privée | Autonome | **6.1** | Reconfigurer le flux SAML (diagramme, code PHP/TypeScript). |
| SAML v2 | Privée | Accompagné / Délégué | **6.2** | Reconfigurer le flux SAML + solliciter l'assistance et consulter les exemples avancés. |

---

## 3. OIDC – Gestion managée (modification des attributs)

Le flux OIDC est géré en interne ; seuls les **attributs (claims)** doivent être ajustés.

### 3.1 OIDC – Gestion managée – Autonome

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Responsable d’application | Identifier les nouveaux claims requis (ex. `id`, `email`, `nom`, `role`) et transmettre à l’administrateur SSO cible la liste des claims attendus. | À estimer | [ ] |
| 2 | Administrateur SSO cible | Actualiser la configuration de l’IdP pour que les tokens contiennent ces claims (l’IdP puise les valeurs dans son annuaire) ; vérifier que les attributs sources (id, email, nom, role, etc.) sont bien exposés avec les noms attendus. | À estimer | [ ] |
| 3 | Responsable d’application | Adapter et tester la consommation des claims dans l’application : mettre à jour le code (lecture, validation) puis tester la connexion au SSO cible et vérifier que les claims attendus sont bien reçus et utilisés (connexion OK, valeurs visibles dans l’appli). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 3) | À estimer | [ ] |

**Exemples de code**

**Symfony (PHP)**  
```php
// Dans votre contrôleur ou service
$user = $this->getUser();
$email = $user->getAttribute('email');
$nom = $user->getAttribute('nom');
$role = $user->getAttribute('role');
// Validation optionnelle
if (!in_array($role, ['admin', 'user'], true)) {
    throw new AccessDeniedException('Rôle non autorisé');
}
```

**CodeIgniter (PHP)**  
```php
// Après authentification OIDC, dans un helper ou le contrôleur
$claims = $this->session->userdata('oidc_claims');
$email = $claims['email'] ?? null;
$nom = $claims['nom'] ?? null;
$role = $claims['role'] ?? null;
```

**Python (ex. Flask / Django)**  
```python
# Flask : après récupération du token / userinfo
user_info = request.session.get('oidc_userinfo', {})
email = user_info.get('email')
nom = user_info.get('nom')
role = user_info.get('role')
```

**TypeScript (Node / front)**  
```typescript
// Côté backend après validation du JWT
const payload = decodedToken as { email?: string; nom?: string; role?: string };
const email = payload.email;
const nom = payload.nom;
const role = payload.role;
```

**Pièges courants**

- Oublier de mettre à jour le **schéma de validation** des claims (liste des claims autorisés, types).
- Confusion entre claims **standard** (ex. `id`, `email`, `nom`) et **personnalisés** (ex. `role`) : bien documenter la source (IdP) et le nom exact du claim.
- Ne pas ignorer les erreurs quand l’application lit les claims :
  - **en développement/préproduction** : enregistrer dans les logs ce que le SSO envoie vraiment, pour comprendre pourquoi une valeur manque ou est incorrecte ;
  - **en production** : limiter le détail des logs (pas de données sensibles), mais garder au moins un message clair indiquant qu’un claim attendu est manquant ou invalide.

---

### 3.2 OIDC – Gestion managée – Accompagné / Délégué

Mêmes étapes que la section 3.1. **En accompagné** : l’équipe de raccordement applicatif réalise les étapes « Responsable d’application » avec le responsable. **En délégué** : l’équipe les réalise à sa place. Compléments : [FAQ](#faq), contacts équipe SSO / identité (fournir liste des claims requis, environnement et périmètre en cas de délégation).

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Responsable d’application | Identifier les nouveaux claims requis (ex. `id`, `email`, `nom`, `role`) et transmettre à l’administrateur SSO cible la liste des claims attendus. | À estimer | [ ] |
| 2 | Administrateur SSO cible | Actualiser la configuration de l’IdP pour que les tokens contiennent ces claims (l’IdP puise les valeurs dans son annuaire) ; vérifier que les attributs sources (id, email, nom, role, etc.) sont bien exposés avec les noms attendus. | À estimer | [ ] |
| 3 | Responsable d’application | Adapter et tester la consommation des claims dans l’application : mettre à jour le code (lecture, validation) puis tester la connexion au SSO cible et vérifier que les claims attendus sont bien reçus et utilisés (connexion OK, valeurs visibles dans l’appli). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 3) | À estimer | [ ] |

---

## 4. OIDC – Gestion privée (modification du flux + attributs)

Vous devez **reconfigurer le flux OIDC** (endpoints, redirect_uri, scopes, client) en plus des attributs.

### 4.1 OIDC – Gestion privée – Autonome

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Responsable d’application | Documenter le flux actuel (Authorization Code, PKCE recommandé). | À estimer | [ ] |
| 2 | Administrateur SSO cible | Créer ou mettre à jour le client auprès de l’IdP (Client ID, Secret, Redirect URIs, scopes `openid`, `profile`, `email` + personnalisés). | À estimer | [ ] |
| 3 | Responsable d’application | Mettre à jour la configuration de l’application (URLs, scopes, mapping des claims) et implémenter ou adapter le callback (échange du code contre tokens, récupération userinfo). | À estimer | [ ] |
| 4 | Responsable d’application | Gérer les erreurs (redirect_uri mismatch, invalid_grant, consent refusé) et tester le flux complet (connexion, rafraîchissement, déconnexion si applicable). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 4) | À estimer | [ ] |

**Schéma de flux (rappel)**

```
[App] --> Redirection vers IdP (authorization endpoint)
[IdP] --> Authentification utilisateur
[IdP] --> Redirection vers App (redirect_uri + code)
[App] --> Échange code contre access_token (et id_token)
[App] --> (Optionnel) UserInfo endpoint pour claims supplémentaires
[App] --> Création de session / utilisateur local
```

**Exemples de code**

**Symfony (PHP)** – configuration et récupération des attributs après connexion OIDC  
```php
// config/packages/knpu_oauth2_client.yaml (exemple)
// knpu_oauth2_client:
//     clients:
//         keycloak:
//             type: generic
//             client_id: '%env(OIDC_CLIENT_ID)%'
//             client_secret: '%env(OIDC_CLIENT_SECRET)%'
//             redirect_route: connect_keycloak_check
//             url_authorize: '%env(OIDC_ISSUER)%/protocol/openid-connect/auth'
//             url_access_token: '%env(OIDC_ISSUER)%/protocol/openid-connect/token'
//             url_resource_owner_details: '%env(OIDC_ISSUER)%/protocol/openid-connect/userinfo'

$user = $this->getUser();
$role = $user->getAttribute('role');
```

**TypeScript (Node, express + openid-client)**  
```typescript
import { Issuer, Strategy } from 'openid-client';

const issuer = await Issuer.discover(process.env.OIDC_ISSUER!);
const client = new issuer.Client({
  client_id: process.env.OIDC_CLIENT_ID!,
  client_secret: process.env.OIDC_CLIENT_SECRET!,
  redirect_uris: [process.env.OIDC_REDIRECT_URI!],
});
// Utiliser client.authorizationUrl(), client.callbackParams(), client.callback()
// Puis lire les claims depuis id_token ou userinfo
```

**Python (Flask + authlib)**  
```python
from authlib.integrations.flask_client import OAuth

oauth = OAuth(app)
oauth.register(
    name='oidc',
    server_metadata_url=os.environ['OIDC_ISSUER'].rstrip('/') + '/.well-known/openid-configuration',
    client_kwargs={'scope': 'openid profile email'},
)
# Dans la route callback : token = oauth.oidc.authorize_access_token()
# userinfo = token.get('userinfo') ou décoder id_token
```

**Pièges courants**

- **Redirect URI** : doit être exactement identique (protocole, domaine, port, chemin) entre IdP et application.
- **Scopes** : oublier `openid` rend le flux non conforme OIDC ; les claims personnalisés peuvent nécessiter des scopes ou des claims mapping côté IdP.
- **Secret** : ne pas exposer le client_secret (variables d’environnement, pas de commit).

---

### 4.2 OIDC – Gestion privée – Accompagné / Délégué

Mêmes étapes que la section 4.1. **En accompagné** : l’équipe de raccordement applicatif réalise les étapes « Responsable d’application » avec le responsable. **En délégué** : l’équipe les réalise à sa place. Compléments : assistance technique (revue config, débogage), exemples avancés (reverse proxy, refresh token, déconnexion centralisée), contacts équipe SSO / identité.

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Responsable d’application | Documenter le flux actuel (Authorization Code, PKCE recommandé). | À estimer | [ ] |
| 2 | Administrateur SSO cible | Créer ou mettre à jour le client auprès de l’IdP (Client ID, Secret, Redirect URIs, scopes `openid`, `profile`, `email` + personnalisés). | À estimer | [ ] |
| 3 | Responsable d’application | Mettre à jour la configuration de l’application (URLs, scopes, mapping des claims) et implémenter ou adapter le callback (échange du code contre tokens, récupération userinfo). | À estimer | [ ] |
| 4 | Responsable d’application | Gérer les erreurs (redirect_uri mismatch, invalid_grant, consent refusé) et tester le flux complet (connexion, rafraîchissement, déconnexion si applicable). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 4) | À estimer | [ ] |

---

## 5. SAML v2 – Gestion managée (modification des attributs)

Le flux SAML est géré en interne ; seuls les **attributs SAML** doivent être mis à jour (côté IdP et éventuellement SP).

### 5.1 SAML v2 – Gestion managée – Autonome

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Responsable d’application | Identifier les attributs SAML requis (ex. id, email, nom, role) et transmettre la liste à l’administrateur SSO cible. | À estimer | [ ] |
| 2 | Administrateur SSO cible | Configurer l’IdP pour envoyer ces attributs dans l’Assertion SAML (noms et format attendus). | À estimer | [ ] |
| 3 | Responsable d’application | Vérifier la réception des attributs côté SP (logs, outil de validation SAML si besoin) et adapter l’application pour les lire et les utiliser (lecture, validation, accès). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 3) | À estimer | [ ] |

**Exemple de structure d’attributs dans une Assertion SAML (à titre indicatif)**

```xml
<saml:AttributeStatement>
  <saml:Attribute Name="email" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
    <saml:AttributeValue xsi:type="xs:string">martin@entreprise.fr</saml:AttributeValue>
  </saml:Attribute>
  <saml:Attribute Name="nom" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
    <saml:AttributeValue xsi:type="xs:string">Martin</saml:AttributeValue>
  </saml:Attribute>
  <saml:Attribute Name="role" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
    <saml:AttributeValue xsi:type="xs:string">admin</saml:AttributeValue>
  </saml:Attribute>
</saml:AttributeStatement>
```

**Validation** : Utiliser un outil en ligne de décodage/validation SAML (ou un validateur local) pour vérifier la présence et le format des attributs dans l’Assertion reçue.

**Exemples de code (lecture des attributs côté SP)**

**PHP (bibliothèque SAML générique)**  
```php
// Après traitement de la réponse SAML (ex. OneLogin, simplesamlphp, etc.)
$attributes = $samlResponse->getAttributes();
$email = $attributes['email'][0] ?? null;
$nom = $attributes['nom'][0] ?? null;
$role = $attributes['role'][0] ?? null;
```

**TypeScript (Node, e.g. saml2-js / passport-saml)**  
```typescript
// Après validation de la réponse SAML
const attributes = (profile as any).attributes;
const email = attributes['email']?.[0];
const nom = attributes['nom']?.[0];
const role = attributes['role']?.[0];
```

**Pièges courants**

- **Noms d’attributs** : différence entre URI, basic, unspecified ; s’assurer que l’IdP et l’SP utilisent le même nom (ou un mapping explicite).
- **Multiples valeurs** : les attributs SAML sont souvent des tableaux ; prendre la première valeur ou gérer la liste selon la sémantique.
- **Signature et chiffrement** : ne pas désactiver la vérification de signature en production.

---

### 5.2 SAML v2 – Gestion managée – Accompagné / Délégué

Suivre les **étapes de la section 5.1**, plus : [FAQ](#faq), contacts équipe SSO / identité (mapping attributs IdP, validation Assertion, délégation).

---

## 6. SAML v2 – Gestion privée (modification du flux + attributs)

Vous devez **reconfigurer le flux SAML** (métadonnées SP/IdP, endpoints, binding, attributs) en plus des attributs.

### 6.1 SAML v2 – Gestion privée – Autonome

**Suivi des étapes à réaliser (cocher étape lorsque réalisée)**

| Étape | Acteur | Action | Durée | Étape réalisée |
|-------|--------|--------|-------|------------------|
| 1 | Responsable d’application | Documenter le flux actuel (SP-initiated ou IdP-initiated, HTTP-POST/Redirect). | À estimer | [ ] |
| 2 | Responsable d’application | Générer ou mettre à jour les métadonnées SP (EntityID, ACS, SLO, certificats). | À estimer | [ ] |
| 3 | Administrateur SSO cible | Enregistrer les métadonnées SP chez l’IdP et fournir les métadonnées IdP. | À estimer | [ ] |
| 4 | Responsable d’application | Configurer l’application (bibliothèque SAML, URLs IdP, certificats, mapping attributs), implémenter le callback ACS (réception Response SAML, vérification signature, lecture des attributs) et tester le flux complet (connexion, attributs, déconnexion SLO si applicable). | À estimer | [ ] |
| **Total** | — | Durée totale (somme des étapes 1 à 4) | À estimer | [ ] |

**Schéma de flux (SP-initiated, simplifié)**

```
[App/SP] --> Génère AuthnRequest --> Redirection vers IdP
[IdP] --> Authentification utilisateur
[IdP] --> Envoi Response SAML (POST vers ACS)
[SP] --> Vérification signature, lecture NameID + attributs
[SP] --> Création de session
```

**Exemples de code**

**PHP (Symfony avec one login php-saml)**  
```php
// Configuration SP : IdP entity ID, SSO URL, x509 cert, etc.
// Après réception du POST ACS :
$auth = new OneLogin\Saml2\Auth($settings);
$auth->processResponse();
$attributes = $auth->getAttributes();
$role = $attributes['role'][0] ?? null;
```

**TypeScript (Node, passport-saml)**  
```typescript
// Strategy config : entryPoint, cert, callbackUrl, etc.
// Dans la callback après validation :
(req: Request, res: Response) => {
  const profile = (req as any).user;
  const attributes = profile.attributes;
  const role = attributes?.role?.[0];
}
```

**Pièges courants**

- **Métadonnées** : EntityID et ACS doivent être cohérents entre SP et IdP ; attention aux environnements (dev/preprod/prod).
- **Certificats** : expiration, bon certificat (signature vs chiffrement) selon la config IdP.
- **Binding** : HTTP-POST vs HTTP-Redirect pour Request/Response ; adapter la bibliothèque et l’IdP.

---

### 6.2 SAML v2 – Gestion privée – Accompagné / Délégué

Suivre les **étapes de la section 6.1**, plus : assistance technique (revue métadonnées, débogage erreurs IdP/SP), exemples avancés (SLO, IdP-initiated, multiples IdPs), contacts équipe SSO / identité pour accompagnement ou délégation.

---

## 7. Annexes

### Glossaire

| Terme | Définition |
|-------|------------|
| **OIDC** | OpenID Connect – couche d’identité sur OAuth 2.0 (id_token, userinfo, scopes `openid`). |
| **SAML v2** | Security Assertion Markup Language 2.0 – protocole d’échange d’assertions d’identité (XML). |
| **Claims** | Informations sur l’utilisateur fournies par le SSO, sous forme **clé–valeur** (ex. `id`, `email`, `nom`, `role` : `nom : Martin`, `email : martin@entreprise.fr`, `role : admin`). L’application les lit dans le token pour identifier l’utilisateur et gérer les droits. |
| **Attributs SAML** | Éléments dans l’Assertion SAML décrivant l’utilisateur (rôles, groupes, etc.). |
| **IdP** | Identity Provider – fournisseur d’identité (authentification). |
| **SP** | Service Provider – application qui consomme l’authentification (SAML). |
| **Gestion managée** | Seuls les attributs/claims sont modifiés ; le flux est géré en interne. |
| **Gestion privée** | Modification du flux d’authentification (client, métadonnées, endpoints) et des attributs. |
| **ACS** | Assertion Consumer Service – endpoint SP qui reçoit la Response SAML. |
| **JWT** | JSON Web Token – format courant pour id_token et access_token en OIDC. |

### FAQ

- **Comment tester en local ?**  
  Utiliser un redirect_uri autorisé pour l’environnement local (ex. `http://localhost:8000/login/check/oidc`) et un client IdP dédié dev si possible. Pour SAML, enregistrer les métadonnées SP avec l’URL locale (HTTP si accepté par l’IdP).

- **Où configurer les nouveaux claims/attributs ?**  
  Côté IdP (mapping des attributs / claims depuis la source d’identité). L’application ne fait qu’autoriser et consommer ; en gestion managée, pas de changement de flux.

- **Que faire en cas d’erreur « redirect_uri mismatch » (OIDC) ?**  
  Vérifier que l’URI utilisée par l’application (protocole, host, port, path) est exactement une de celles enregistrées pour le client dans l’IdP.

- **Que faire si les attributs SAML n’arrivent pas au SP ?**  
  Vérifier la configuration des attributs côté IdP (release policy), le nom des attributs dans l’Assertion (logs ou outil de décodage), et le mapping côté SP (noms d’attributs).

- **Autonome vs accompagné vs délégué ?**  
  **Autonome** : vous suivez ce guide et les exemples seuls. **Accompagné** : vous faites la mise en œuvre avec revue et aide de l’équipe SSO. **Délégué** : vous fournissez les exigences (claims/attributs, environnement) et l’équipe SSO réalise la configuration ou une partie.

### Ressources externes

- [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)
- [OAuth 2.0 RFC 6749](https://tools.ietf.org/html/rfc6749)
- [SAML 2.0 Core](http://docs.oasis-open.org/security/saml/v2.0/saml-core-2.0-os.pdf)
- [Symfony Security](https://symfony.com/doc/current/security.html)
- [KnpU OAuth2 Client Bundle](https://github.com/knpuniversity/oauth2-client-bundle)

---

*Document conçu pour réduire la charge cognitive (parcours par cas d’usage), s’adapter au niveau d’autonomie et centraliser les bonnes pratiques et pièges courants.*
