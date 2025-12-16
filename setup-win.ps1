# Vérifie si Docker est installé
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
    Write-Host "[INFO] Docker non trouvé."
    Write-Host "👉 Ouverture de la page officielle Docker Desktop..."
    Start-Process "https://www.docker.com/get-started/"
    exit
}

# Vérifie Docker Compose (plugin)
$composeOk = docker compose version 2>$null
if (-not $composeOk) {
    Write-Host "[ERROR] Le plugin 'docker compose' est requis. Vérifie que tu n’utilises pas l'ancien 'docker-compose'."
    exit
}

# Création du fichier .env si absent
if (-not (Test-Path ".env")) {
    Write-Host "[INFO] Création du fichier .env..."
    $rand = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object { [char]$_ })
    $envContent = @"
POSTGRES_USER=admin_user_db
POSTGRES_PASSWORD=$rand
POSTGRES_DB=n8n_database

DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=db
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n_database
DB_POSTGRESDB_USER=admin_user_db
DB_POSTGRESDB_PASSWORD=$rand

N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=n8n_admin_user
N8N_BASIC_AUTH_PASSWORD=$rand
N8N_ENCRYPTION_KEY=$rand

N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http

N8N_RUNNERS_ENABLED=true
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
"@
    $envContent | Set-Content -Encoding UTF8 ".env"
    Write-Host "[INFO] .env généré."
} else {
    Write-Host "[INFO] Le fichier .env existe déjà."
}

# Pull & up
Write-Host "[INFO] Pull des images Docker..."
docker compose pull

Write-Host "[INFO] Lancement du stack..."
docker compose up -d --build

# Affichage des informations
Write-Host ""
Write-Host "✅ PostgreSQL : port 5432"
Write-Host "✅ Ollama     : port 11434"
Write-Host "✅ N8N        : port 5678"
Write-Host "👉 👉 👉 Accès à l'interface N8N : http://localhost:5678"

# Téléchargement des modèles Ollama
if (Get-Command "ollama" -ErrorAction SilentlyContinue) {
    Write-Host "[INFO] Téléchargement des modèles Ollama..."

    try {
        ollama pull llama3.2:1b
        ollama pull mistral:instruct
        Write-Host "[✅] Modèles Ollama téléchargés avec succès."
    } catch {
        Write-Host "[WARN] Échec lors du téléchargement d'un ou plusieurs modèles Ollama."
    }
} else {
    Write-Host "[WARN] Commande 'ollama' non trouvée. Télécharge les modèles manuellement."
    Write-Host "       Exemple : ollama pull mistral:instruct"
}
