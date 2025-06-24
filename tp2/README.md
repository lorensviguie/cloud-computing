## Projet Infra-as-Code Azure : Déploiement d'une architecture N-tier WordPress

### Description
Ce projet déploie en mode Infra-as-Code (Terraform) une architecture N-tier (3 couches) sur Azure :
- Couche Web : Azure Web App Linux conteneur, utilisant une image Docker WordPress personnalisée stockée dans Azure Container Registry (ACR).
- Couche Data : Azure Database for MySQL Flexible Server, déployée dans un VNet avec Private Endpoint.
- Infrastructure réseau : Virtual Network avec sous-réseaux dédiés à l'intégration du Web App et au Private Endpoint MySQL.

Deux environnements sont prévus : développement (`dev`) et production (`prod`).

### Prérequis
- Compte Azure avec les droits pour créer RG, réseaux, ACR, services PaaS.
- Azure CLI configuré (`az login`), ou authentification via Azure Service Principal.
- Terraform >= 1.0.
- Docker local pour construire l'image WordPress.
- Git pour versionner le code.

### Étapes de déploiement
1. **Personnaliser l'image WordPress**
   - Placer votre thème/données dans `Docker/custom-theme/`.
   - Construire localement l'image :
     ```bash
     cd Docker
     docker build -t <ACR_LOGIN_SERVER>/wordpress-custom:v1.0 .
     ```
   - Se connecter à ACR et pousser l'image :
     ```bash
     az acr login --name <nomACR>
     docker push <ACR_LOGIN_SERVER>/wordpress-custom:v1.0
     ```
2. **Configurer Terraform**
   - Copier `terraform/envs/dev/terraform.tfvars` et ajuster les variables (prefix, credentials MySQL, image_tag). Idem pour prod.
   - (Optionnel) Configurer backend Terraform (Azure Storage) en modifiant `terraform/provider.tf` ou `backend.tf`.
3. **Exécuter Terraform**
   ```bash
   cd terraform/envs/dev
   terraform init
   terraform plan
   terraform apply

Après quelques minutes, les ressources sont déployées.
4. Vérifier l’application

Récupérer l’URL affichée en sortie Terraform (webapp_url) et accéder via navigateur.

Compléter l'installation WordPress (création du site, identifiants admin).

Vérifier que le thème/logo personnalisé est bien appliqué.

5. Répéter pour prod

```sh
cd ../prod
terraform init
terraform plan
terraform apply
```

---

## report.md (court rapport)
```markdown
# Rapport – Choix techniques et problèmes rencontrés

## Choix techniques
1. **Terraform et modularisation**: Chaque ressource (réseau, ACR, MySQL, Web App) est isolée dans un module réutilisable. Permet de déployer plusieurs environnements en réutilisant le même code.
2. **Réseau et Sécurité**: Utilisation d’un Virtual Network avec deux sous-réseaux :
   - Un pour le Private Endpoint de MySQL Flexible Server.
   - Un autre pour l’Azure Web App via VNet Integration (Swift).
   Cela garantit que la base de données n’est pas exposée publiquement et que seule la Web App peut y accéder via réseau privé.
3. **Azure Container Registry & Managed Identity**: Plutôt que de stocker des credentials Docker dans Terraform ou Web App, la Web App utilise une identité managée à qui on attribue le rôle `AcrPull` sur l’ACR.
4. **MySQL Flexible Server**: Choix de MySQL Flexible pour bénéficier de Private Endpoint et d’une gestion PaaS. On peut configurer SKU selon la charge.
5. **WordPress Docker personnalisé**: Build local d’une image WordPress contenant un thème ou logo personnalisé, stocké dans ACR, déployé via Web App for Containers.
6. **Deux environnements (dev/prod)**: Variables Terraform différenciant préfixes, plages d’adresses, credentials, garantissant isolation et indépendance.

## Problèmes rencontrés
- **Complexité de la connexion réseau**: Azure Web App VNet Integration et Private Endpoint demandent une configuration précise des sous-réseaux (délégation, Private DNS Zone). Il a fallu s’assurer que la Private DNS Zone `privatelink.mysql.database.azure.com` est bien liée au VNet pour la résolution du FQDN privé.
- **Ordre de création Terraform**: Les dépendances entre MySQL Flexible Server, Private Endpoint, et Private DNS nécessitent de bien chaîner les ressources (depends_on ou utilisation des sorties) pour éviter des erreurs de résolution.
- **Managed Identity & ACR**: S’assurer que l’identité managée est disponible au moment de l’assignation du rôle AcrPull. Terraform gère cela via dépendances implicites.
- **Gestion des secrets**: Dans ce devoir, les mots de passe MySQL sont fournis en clair dans terraform.tfvars. En production, il faudrait utiliser Azure Key Vault.
- **Testing local vs Azure**: Le build Docker se fait localement; il faut ensuite tester le push dans ACR avant de lancer Terraform, sinon la Web App ne peut pas démarrer si l’image n’existe pas.

## Conclusion
La modularisation permet d’étendre facilement à d’autres services ou environnements. Le déploiement réseau sécurisé via Private Endpoint et VNet Integration garantit une architecture conforme aux bonnes pratiques. Les améliorations futures incluent l’automatisation complète (CI/CD), gestion des secrets, monitoring, scaling auto, et custom domain/TLS.