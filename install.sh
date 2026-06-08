#!/usr/bin/env bash
set -e
SKILL_DIR="${HOME}/.claude/skills/company-mode"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Company Mode v3.1 Installer"
mkdir -p "${SKILL_DIR}/docs" "${SKILL_DIR}/templates" "${SKILL_DIR}/learning"
echo "Copying files to ${SKILL_DIR}..."
cp "${SCRIPT_DIR}/SKILL.md" "${SKILL_DIR}/"
cp "${SCRIPT_DIR}/docs/"*.md "${SKILL_DIR}/docs/"
cp "${SCRIPT_DIR}/templates/"*.md "${SKILL_DIR}/templates/"
cp "${SCRIPT_DIR}/learning/"*.md "${SKILL_DIR}/learning/"
echo "Done. Use /company start in Claude Code."
