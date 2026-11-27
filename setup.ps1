# Installation des outils du projet sur un poste Windows (à lancer une seule fois)
$ErrorActionPreference = "Stop"

Write-Host "== Vérification de Docker" -ForegroundColor Cyan
docker version --format "Docker {{.Server.Version}}"

Write-Host "== Installation des outils (winget)" -ForegroundColor Cyan
$tools = @("Sigstore.Cosign", "EclipseAdoptium.Temurin.21.JDK", "OpenJS.NodeJS.LTS", "Python.Python.3.12")
foreach ($t in $tools) {
    winget install --id $t -e --accept-source-agreements --accept-package-agreements --silent
}

Write-Host "== Fichier .env" -ForegroundColor Cyan
if (-not (Test-Path .env)) {
    Copy-Item .env.example .env
    Write-Host "Fichier .env créé : remplis POSTGRES_PASSWORD avant de lancer le projet." -ForegroundColor Yellow
} else {
    Write-Host ".env déjà présent"
}

Write-Host "== Terminé. Rouvre PowerShell pour charger les nouveaux outils dans le PATH." -ForegroundColor Green
