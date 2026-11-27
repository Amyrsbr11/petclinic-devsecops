# Déploiement sécurisé : l'image n'est lancée que si sa signature Cosign
# et son SBOM signé prouvent qu'elle vient du pipeline CI de la branche main.
param([string]$Tag = "latest")

$Image    = "ghcr.io/amyrsbr11/petclinic-api:$Tag"
$Cosign   = "ghcr.io/sigstore/cosign/cosign:v3.1.6"
$Identity = '(?i)^https://github\.com/amyrsbr11/petclinic-devsecops/\.github/workflows/ci\.yml@refs/heads/main$'
$Issuer   = "https://token.actions.githubusercontent.com"

function Fail($msg) { Write-Host "`n[REFUSE] $msg - deploiement annule." -ForegroundColor Red; exit 1 }

Write-Host "[1/4] Recuperation de l'image $Image" -ForegroundColor Cyan
docker pull -q $Image | Out-Null
if ($LASTEXITCODE -ne 0) { Fail "image introuvable" }
$Ref = docker inspect --format '{{index .RepoDigests 0}}' $Image
Write-Host "      Digest : $Ref"

Write-Host "[2/4] Verification de la signature (Sigstore keyless)" -ForegroundColor Cyan
docker run --rm $Cosign verify $Ref --certificate-identity-regexp $Identity --certificate-oidc-issuer $Issuer | Out-Null
if ($LASTEXITCODE -ne 0) { Fail "signature absente ou emise par une autre identite" }
Write-Host "      OK : signee par ci.yml (Amyrsbr11/petclinic-devsecops, main)" -ForegroundColor Green

Write-Host "[3/4] Verification de l'attestation SBOM (SPDX)" -ForegroundColor Cyan
docker run --rm $Cosign verify-attestation $Ref --type spdxjson --certificate-identity-regexp $Identity --certificate-oidc-issuer $Issuer | Out-Null
if ($LASTEXITCODE -ne 0) { Fail "SBOM signe absent" }
Write-Host "      OK : SBOM signe present" -ForegroundColor Green

Write-Host "[4/4] Deploiement de l'image verifiee (par digest)" -ForegroundColor Cyan
$env:API_IMAGE = $Ref
docker compose up -d --no-build
if ($LASTEXITCODE -ne 0) { Fail "echec docker compose" }
Write-Host "`n[OK] PetClinic deploye : http://localhost:8080/petclinic/swagger-ui/index.html" -ForegroundColor Green