<#
.SYNOPSIS
    Restaure une sauvegarde precedemment creee par backup.ps1.

.DESCRIPTION
    Liste les sauvegardes disponibles dans .\Backups, demande a l'utilisateur
    laquelle restaurer, puis copie son contenu vers un dossier de restauration
    (par securite, ne remplace jamais directement les fichiers originaux).

.USAGE
    powershell -ExecutionPolicy Bypass -File .\restore.ps1
#>

param(
    [string]$BackupsRoot = ".\Backups",
    [string]$RestoreTo = ".\Restored"
)

if (-not (Test-Path $BackupsRoot)) {
    Write-Host "Aucun dossier de sauvegarde trouve ($BackupsRoot)."
    exit 1
}

$backups = Get-ChildItem -Path $BackupsRoot -Directory | Sort-Object LastWriteTime -Descending

if ($backups.Count -eq 0) {
    Write-Host "Aucune sauvegarde disponible pour le moment."
    exit 1
}

Write-Host "Sauvegardes disponibles :"
for ($i = 0; $i -lt $backups.Count; $i++) {
    Write-Host "  [$i] $($backups[$i].Name)  (modifie le $($backups[$i].LastWriteTime))"
}

$choice = Read-Host "Numero de la sauvegarde a restaurer"
$index = 0
if (-not [int]::TryParse($choice, [ref]$index) -or $index -lt 0 -or $index -ge $backups.Count) {
    Write-Host "Choix invalide."
    exit 1
}

$selected = $backups[$index]
$destination = Join-Path $RestoreTo $selected.Name

New-Item -ItemType Directory -Path $destination -Force | Out-Null
Copy-Item -Path (Join-Path $selected.FullName "*") -Destination $destination -Recurse -Force

Write-Host "Restauration terminee. Fichiers disponibles dans : $destination"
Write-Host "Verifie le contenu avant de le recopier manuellement vers l'emplacement d'origine."
