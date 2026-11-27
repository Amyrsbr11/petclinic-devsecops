# petclinic-devsecops

Projet DevSecOps : sécurisation de bout en bout de **Spring PetClinic REST** (API Spring Boot + PostgreSQL).

## Lancer le projet (Windows + Docker Desktop)

```powershell
git clone https://github.com/Amyrsbr11/petclinic-devsecops.git
cd petclinic-devsecops
.\setup.ps1          # une seule fois par poste
notepad .env         # renseigner POSTGRES_PASSWORD
docker compose up -d --build
```

| Service | URL |
| --- | --- |
| API REST (Swagger) | http://localhost:8080/petclinic/swagger-ui/index.html |
| Exemple d'endpoint | http://localhost:8080/petclinic/api/owners |

## Structure

| Dossier / fichier | Contenu |
| --- | --- |
| `api/` | API REST Spring Boot (port 9966 dans le conteneur) |
| `docker-compose.yml` | Services `db` (PostgreSQL) et `api` sur le réseau `backend` |
| `.github/workflows/ci.yml` | Pipeline CI/CD : Gitleaks, build et tests, SonarCloud, Trivy, publication GHCR |

## Origine du code

- `api/` : [spring-petclinic-rest](https://github.com/spring-petclinic/spring-petclinic-rest), commit `3c1dadd3`

Code distribué sous licence Apache 2.0 (voir `api/LICENSE.txt`).