@echo off
cd /d "C:\Users\a0006235\OneDrive - KION Group\Documents\Obsidian Vault-Backup-2025_08_19-16_43_36"
git add .
git diff --cached --quiet && exit /b 0
git commit -m "auto backup %date% %time%"
git push
