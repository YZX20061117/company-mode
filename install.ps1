$ErrorActionPreference = "Stop"
$SkillDir = "$env:USERPROFILE\.claude\skills\company-mode"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "Company Mode v3.1 Installer" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$SkillDir\docs" | Out-Null
New-Item -ItemType Directory -Force -Path "$SkillDir	emplates" | Out-Null
New-Item -ItemType Directory -Force -Path "$SkillDir\learning" | Out-Null
Write-Host "Copying files to $SkillDir..."
Copy-Item "$ScriptDir\SKILL.md" -Destination "$SkillDir\" -Force
Copy-Item "$ScriptDir\docs\*.md" -Destination "$SkillDir\docs\" -Force
Copy-Item "$ScriptDir	emplates\*.md" -Destination "$SkillDir	emplates\" -Force
Copy-Item "$ScriptDir\learning\*.md" -Destination "$SkillDir\learning\" -Force
Write-Host "Done. Use /company start <project> in Claude Code." -ForegroundColor Green
