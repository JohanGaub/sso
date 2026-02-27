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
2. **Aller à la section correspondant à vos réponses** (ex. 3.1, 5.2) et suivre les étapes, exemples et checklists.
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

Le flux OIDC est géré en interne ; seuls les **attributs (claims)** doivent être ajustés. **Ordre des actions** : 1) Le **responsable d’application** (ou l’équipe de raccordement applicatif) indique à l’**administrateur SSO cible** quels claims l’application attend (ex. id, email, nom). 2) L’administrateur SSO cible actualise la configuration de l’IdP pour que les tokens contiennent ces claims (l’IdP puise les valeurs dans son annuaire). 3) Le responsable d’application adapte le code pour lire et utiliser ces claims.

### 3.1 OIDC – Gestion managée – Autonome

**Étapes clés**

1. Identifier les nouveaux claims requis (ex. `custom_role`, `department`).
2. Vérifier avec l’**administrateur SSO cible** que les attributs sources nécessaires (groupes, rôles, service, etc.) sont bien exposés dans les claims envoyés à l’application, avec les noms attendus (ex. `custom_role`, `department`).
3. Adapter la consommation des claims dans l’application (lecture, validation).
4. Tester la réception des claims (logs, assertions, affichage conditionnel).

**Exemples de code**

**Symfony (PHP)**  
```php
// Dans votre contrôleur ou service
$user = $this->getUser();
$customRole = $user->getAttribute('custom_role');
$department = $user->getAttribute('department');
// Validation optionnelle
if (!in_array($customRole, ['admin', 'user'], true)) {
    throw new AccessDeniedException('Rôle non autorisé');
}
```

**CodeIgniter (PHP)**  
```php
// Après authentification OIDC, dans un helper ou le contrôleur
$claims = $this->session->userdata('oidc_claims');
$custom_role = $claims['custom_role'] ?? null;
$department = $claims['department'] ?? null;
```

**Python (ex. Flask / Django)**  
```python
# Flask : après récupération du token / userinfo
user_info = request.session.get('oidc_userinfo', {})
custom_role = user_info.get('custom_role')
department = user_info.get('department')
```

**TypeScript (Node / front)**  
```typescript
// Côté backend après validation du JWT
const payload = decodedToken as { custom_role?: string; department?: string };
const customRole = payload.custom_role;
const department = payload.department;
```

**Pièges courants**

- Oublier de mettre à jour le **schéma de validation** des claims (liste des claims autorisés, types).
- Confusion entre claims **standard** (e.g. `email`, `sub`) et **personnalisés** (`custom_role`) : bien documenter la source (IdP) et le nom exact du claim.
- Cacher ou ignorer les erreurs de parsing des claims : logger les payloads en dev pour déboguer.

**Checklist de validation**

- [ ] Nouveaux claims configurés côté IdP et présents dans le token / userinfo.
- [ ] Application lit et valide les claims (nom exact, type).
- [ ] Règles d’accès (rôles, départements) utilisent bien ces claims.
- [ ] Test de bout en bout avec un compte de test (au moins un rôle / département).

---

### 3.2 OIDC – Gestion managée – Accompagné / Délégué

**Contexte** : Identique à la section 3.1, avec un besoin d’accompagnement ou de délégation.

**Contenu** : Suivre les **mêmes étapes et exemples que la section 3.1**, plus :

- **FAQ dédiée** : voir [Annexe FAQ](#faq).
- **Contacts** : pour demande d’accompagnement ou de prise en charge (délégation), contacter l’équipe SSO / identité (voir contacts en interne).
- **Demande de délégation** : fournir la liste des claims requis, l’environnement (dev/preprod/prod) et le périmètre (une ou plusieurs applications).

---

## 4. OIDC – Gestion privée (modification du flux + attributs)

Vous devez **reconfigurer le flux OIDC** (endpoints, redirect_uri, scopes, client) en plus des attributs.

### 4.1 OIDC – Gestion privée – Autonome

**Contexte** : Modification du flux d’authentification OIDC (nouveau client, nouveaux scopes, redirect_uri, etc.) et des attributs.

**Étapes clés**

1. Documenter le flux actuel (Authorization Code avec PKCE recommandé).
2. Créer ou mettre à jour l’enregistrement du client auprès de l’IdP (Client ID, Secret, Redirect URIs, scopes `openid`, `profile`, `email` + personnalisés).
3. Mettre à jour la configuration de l’application (URLs, scopes, mapping des claims).
4. Implémenter ou adapter le callback (échange du code contre tokens, récupération userinfo si besoin).
5. Gérer les erreurs (redirect_uri mismatch, invalid_grant, consent refusé).
6. Tester le flux complet (connexion, rafraîchissement, déconnexion si applicable).

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
$customRole = $user->getAttribute('custom_role');
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

**Checklist de validation**

- [ ] Client enregistré chez l’IdP avec les bons redirect_uri et scopes.
- [ ] Application configure les mêmes URLs et scopes.
- [ ] Connexion réussie et id_token / userinfo reçus.
- [ ] Claims utilisés dans l’application (rôles, métadonnées).
- [ ] Gestion des erreurs et logs sans données sensibles en prod.

---

### 4.2 OIDC – Gestion privée – Accompagné / Délégué

**Contexte** : Identique à la section 4.1, avec accompagnement ou délégation.

**Contenu** : Suivre les **mêmes étapes que la section 4.1**, plus :

- **Assistance technique** : revue de configuration (client, redirect_uri, scopes), aide au débogage (logs, erreurs IdP).
- **Exemples avancés** : intégration avec un reverse proxy, gestion du refresh token, déconnexion centralisée (RP-initiated logout si supporté).
- **Contacts** : équipe SSO / identité pour prise en charge partielle ou complète (délégation).

---

## 5. SAML v2 – Gestion managée (modification des attributs)

Le flux SAML est géré en interne ; seuls les **attributs SAML** doivent être mis à jour (côté IdP et éventuellement SP).

### 5.1 SAML v2 – Gestion managée – Autonome

**Contexte** : Le flux SAML est géré en interne. Seuls les attributs SAML (Assertion) doivent être mis à jour.

**Étapes clés**

1. Identifier les attributs SAML requis (noms d’attributs, format URI ou noms courts).
2. Modifier la configuration du fournisseur d’identité (IdP) pour envoyer ces attributs dans l’Assertion.
3. Vérifier la réception des attributs côté SP (logs, décodage de l’Assertion, outil de validation XML/SAML si besoin).
4. Adapter l’application pour lire et valider ces attributs (rôles, groupes, etc.).

**Exemple de structure d’attributs dans une Assertion SAML (à titre indicatif)**

```xml
<saml:AttributeStatement>
  <saml:Attribute Name="urn:oid:1.2.3.4.5" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri">
    <saml:AttributeValue xsi:type="xs:string">custom_role</saml:AttributeValue>
  </saml:Attribute>
  <saml:Attribute Name="department" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
    <saml:AttributeValue xsi:type="xs:string">IT</saml:AttributeValue>
  </saml:Attribute>
</saml:AttributeStatement>
```

**Validation** : Utiliser un outil en ligne de décodage/validation SAML (ou un validateur local) pour vérifier la présence et le format des attributs dans l’Assertion reçue.

**Exemples de code (lecture des attributs côté SP)**

**PHP (bibliothèque SAML générique)**  
```php
// Après traitement de la réponse SAML (ex. OneLogin, simplesamlphp, etc.)
$attributes = $samlResponse->getAttributes();
$customRole = $attributes['urn:oid:1.2.3.4.5'][0] ?? $attributes['custom_role'][0] ?? null;
$department = $attributes['department'][0] ?? null;
```

**TypeScript (Node, e.g. saml2-js / passport-saml)**  
```typescript
// Après validation de la réponse SAML
const attributes = (profile as any).attributes;
const customRole = attributes['urn:oid:1.2.3.4.5']?.[0] ?? attributes['custom_role']?.[0];
const department = attributes['department']?.[0];
```

**Pièges courants**

- **Noms d’attributs** : différence entre URI, basic, unspecified ; s’assurer que l’IdP et l’SP utilisent le même nom (ou un mapping explicite).
- **Multiples valeurs** : les attributs SAML sont souvent des tableaux ; prendre la première valeur ou gérer la liste selon la sémantique.
- **Signature et chiffrement** : ne pas désactiver la vérification de signature en production.

**Checklist de validation**

- [ ] Attributs configurés côté IdP et présents dans l’Assertion.
- [ ] SP reçoit et parse correctement les attributs (vérification via outil ou logs).
- [ ] Application utilise ces attributs pour l’autorisation (rôles, départements).
- [ ] Test avec un utilisateur de test et vérification des valeurs.

---

### 5.2 SAML v2 – Gestion managée – Accompagné / Délégué

**Contexte** : Identique à la section 5.1, avec accompagnement ou délégation.

**Contenu** : Suivre les **mêmes étapes que la section 5.1**, plus :

- **FAQ** : voir [Annexe FAQ](#faq).
- **Contacts dédiés** : équipe SSO / identité pour aide sur le mapping d’attributs IdP, validation XML/Assertion, et prise en charge si délégation.

---

## 6. SAML v2 – Gestion privée (modification du flux + attributs)

Vous devez **reconfigurer le flux SAML** (métadonnées SP/IdP, endpoints, binding, attributs) en plus des attributs.

### 6.1 SAML v2 – Gestion privée – Autonome

**Contexte** : Reconfiguration du flux SAML (nouveau SP, métadonnées, ACS, SLO, attributs).

**Étapes clés**

1. Documenter le flux actuel (SP-initiated ou IdP-initiated, HTTP-POST/Redirect).
2. Générer ou mettre à jour les **métadonnées SP** (EntityID, ACS, SLO, certificats).
3. Enregistrer les métadonnées SP chez l’IdP et récupérer les métadonnées IdP.
4. Configurer l’application (bibliothèque SAML) avec les URLs IdP, certificats, et mapping d’attributs.
5. Implémenter le callback ACS (réception de la Response SAML, vérification signature, lecture des attributs).
6. Tester le flux complet (connexion, attributs, déconnexion SLO si applicable).

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
$customRole = $attributes['custom_role'][0] ?? null;
```

**TypeScript (Node, passport-saml)**  
```typescript
// Strategy config : entryPoint, cert, callbackUrl, etc.
// Dans la callback après validation :
(req: Request, res: Response) => {
  const profile = (req as any).user;
  const attributes = profile.attributes;
  const customRole = attributes?.custom_role?.[0];
}
```

**Pièges courants**

- **Métadonnées** : EntityID et ACS doivent être cohérents entre SP et IdP ; attention aux environnements (dev/preprod/prod).
- **Certificats** : expiration, bon certificat (signature vs chiffrement) selon la config IdP.
- **Binding** : HTTP-POST vs HTTP-Redirect pour Request/Response ; adapter la bibliothèque et l’IdP.

**Checklist de validation**

- [ ] Métadonnées SP à jour et enregistrées chez l’IdP.
- [ ] Flux de connexion SP → IdP → SP fonctionnel.
- [ ] Attributs reçus et utilisés dans l’application.
- [ ] Signature de la Response vérifiée ; pas de désactivation en prod.

---

### 6.2 SAML v2 – Gestion privée – Accompagné / Délégué

**Contexte** : Identique à la section 6.1, avec accompagnement ou délégation.

**Contenu** : Suivre les **mêmes étapes que la section 6.1**, plus :

- **Assistance technique** : revue des métadonnées, débogage des erreurs IdP/SP (invalid response, signature, attributs manquants).
- **Exemples avancés** : SLO, IdP-initiated flow, gestion de multiples IdPs.
- **Contacts** : équipe SSO / identité pour accompagnement ou délégation complète.

---

## 7. Annexes

### Glossaire

| Terme | Définition |
|-------|------------|
| **OIDC** | OpenID Connect – couche d’identité sur OAuth 2.0 (id_token, userinfo, scopes `openid`). |
| **SAML v2** | Security Assertion Markup Language 2.0 – protocole d’échange d’assertions d’identité (XML). |
| **Claims** | Informations sur l’utilisateur fournies par le SSO, sous forme **clé–valeur** (ex. `nom : Martin`, `email : martin@entreprise.fr`, `custom_role : admin`). L’application les lit dans le token pour identifier l’utilisateur et gérer les droits. |
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
