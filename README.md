# 🗂️ Backup Tool — Sauvegarde & restauration automatique

Outil en **PowerShell** (Windows) et **Bash** (Linux/Mac) qui automatise la sauvegarde de fichiers ou dossiers de configuration vers un dossier horodaté, avec possibilité de restauration.

Projet réalisé pour mettre en pratique des compétences de **support informatique / administration système** : scripting, gestion de fichiers, journalisation, et bonnes pratiques de sauvegarde.

## ✨ Fonctionnalités

- Sauvegarde de plusieurs chemins (fichiers ou dossiers) définis dans un fichier de configuration
- Nommage automatique des sauvegardes par date/heure (`config-systeme_2026-09-26_143000`)
- Journalisation de chaque exécution (`backup.log`)
- Script de restauration interactif (`restore.ps1`) qui liste les sauvegardes disponibles
- Versionnable avec Git pour garder un historique des configurations sauvegardées

## 📁 Structure du projet

```
backup-tool/
├── backup.ps1            # Script de sauvegarde (Windows / PowerShell)
├── restore.ps1            # Script de restauration (Windows / PowerShell)
├── backup.sh              # Script de sauvegarde équivalent (Linux/Mac / Bash)
├── config.example.json    # Exemple de configuration à copier en config.json
├── .gitignore
└── README.md
```

## 🚀 Utilisation (Windows / PowerShell)

1. Copier `config.example.json` en `config.json` et adapter les chemins à sauvegarder :
   ```powershell
   Copy-Item config.example.json config.json
   notepad config.json
   ```
2. Lancer la sauvegarde :
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\backup.ps1
   ```
3. Une nouvelle sauvegarde horodatée apparaît dans `.\Backups\`.
4. Pour restaurer une sauvegarde :
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\restore.ps1
   ```
   Le script liste les sauvegardes disponibles et copie celle choisie dans `.\Restored\` (les fichiers d'origine ne sont jamais écrasés automatiquement, par sécurité).

## 🚀 Utilisation (Linux/Mac / Bash)

```bash
chmod +x backup.sh
./backup.sh ~/.config/monapp ~/Documents/projet-important
```

## 🔧 Ce que ce projet démontre

- Scripting PowerShell et Bash
- Gestion de fichiers et de chemins de manière robuste (gestion des erreurs, chemins inexistants)
- Journalisation (logging) des opérations
- Réflexion autour de la sécurité des données (dossier de restauration séparé, pas d'écrasement direct)
- Utilisation de Git pour versionner un projet système

## 📌 Pistes d'amélioration

- Compression des sauvegardes en `.zip`
- Envoi automatique vers un espace de stockage distant (OneDrive, cloud, NAS)
- Planification automatique via le **Planificateur de tâches Windows** ou une **tâche cron**
