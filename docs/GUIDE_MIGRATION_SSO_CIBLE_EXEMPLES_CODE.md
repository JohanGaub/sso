# Exemples de code

Ce document regroupe **tous les exemples de code** extraits de `GUIDE_MIGRATION_SSO_CIBLE.md`.  
Chaque section indique **où réinsérer** les exemples dans le guide d’origine.

---

## 3.1 OIDC – Gestion managée – Autonome – Exemples de code

**Point d’insertion dans `GUIDE_MIGRATION_SSO_CIBLE.md`** :  
Après le tableau de suivi de la section **3.1**, juste avant le bloc « Pièges courants ».

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

---

## 4.1 OIDC – Gestion privée – Autonome – Exemples de code

**Point d’insertion dans `GUIDE_MIGRATION_SSO_CIBLE.md`** :  
Dans la section **4.1**, après le bloc « Schéma de flux (rappel) », avant « Pièges courants ».

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

---

## 5.1 SAML v2 – Gestion managée – Autonome – Exemples de code

**Point d’insertion dans `GUIDE_MIGRATION_SSO_CIBLE.md`** :  
Dans la section **5.1**, après le bloc « Exemple de structure d’attributs dans une Assertion SAML (à titre indicatif) », avant « Pièges courants ».

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

**PHP (bibliothèque SAML générique)** – lecture des attributs côté SP  
```php
// Après traitement de la réponse SAML (ex. OneLogin, simplesamlphp, etc.)
$attributes = $samlResponse->getAttributes();
$email = $attributes['email'][0] ?? null;
$nom = $attributes['nom'][0] ?? null;
$role = $attributes['role'][0] ?? null;
```

**TypeScript (Node, e.g. saml2-js / passport-saml)** – lecture des attributs côté SP  
```typescript
// Après validation de la réponse SAML
const attributes = (profile as any).attributes;
const email = attributes['email']?.[0];
const nom = attributes['nom']?.[0];
const role = attributes['role']?.[0];
```

---

## 6.1 SAML v2 – Gestion privée – Autonome – Exemples de code

**Point d’insertion dans `GUIDE_MIGRATION_SSO_CIBLE.md`** :  
Dans la section **6.1**, après le bloc « Schéma de flux (SP-initiated, simplifié) », avant « Pièges courants ».

**PHP (Symfony avec onelogin/php-saml)**  
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

