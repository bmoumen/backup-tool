<#
.SYNOPSIS
    Sauvegarde automatique de fichiers/dossiers de configuration vers un dossier horodate.

.DESCRIPTION
    Lit la liste des chemins a sauvegarder dans config.json, copie chaque element
    dans un nouveau dossier horodate sous .\Backups, et enregistre le resultat
    dans backup.log. Pense a lancer "git add . && git commit" apres chaque
    sauvegarde reussie si tu veux versionner l'historique des configs.

.USAGE
    powershell -ExecutionPolicy Bypass -File .\backup.ps1
#>

param(
    [string]$ConfigPath = ".\config.json"
)

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$timestamp] $Message"
    Write-Host $line
    Add-Content -Path ".\backup.log" -Value $line
}

if (-not (Test-Path $ConfigPath)) {
    Write-Log "ERREUR : fichier de configuration introuvable ($ConfigPath). Copie config.example.json vers config.json et adapte les chemins."
    exit 1
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

$stamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$destination = Join-Path $config.destinationRoot "$($config.backupName)_$stamp"

Write-Log "Debut de la sauvegarde vers $destination"
New-Item -ItemType Directory -Path $destination -Force | Out-Null

$successCount = 0
$failCount = 0

foreach ($source in $config.sourcePaths) {
    if (-not (Test-Path $source)) {
        Write-Log "IGNORE : le chemin source n'existe pas -> $source"
        $failCount++
        continue
    }

    $itemName = Split-Path $source -Leaf
    $target = Join-Path $destination $itemName

    try {
        Copy-Item -Path $source -Destination $target -Recurse -Force -ErrorAction Stop
        Write-Log "OK : $source -> $target"
        $successCount++
    }
    catch {
        Write-Log "ECHEC : $source ($($_.Exception.Message))"
        $failCount++
    }
}

Write-Log "Sauvegarde terminee : $successCount reussite(s), $failCount echec(s)."

if ($failCount -eq 0) {
    Write-Log "Toutes les sources ont ete sauvegardees avec succes."
}
