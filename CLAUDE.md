# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Vault Is

Personal knowledge base for a software support/integration engineer at KION Group (Dematic), focused on warehouse automation systems (WCS/MFC). Active projects include Toll Hive, Chilsung, Aldi, Woolworths, and YoungNam sites.

## Vault Structure

```
Daily/YYYY/MM-MMMM/YYYY-MM-DD-dddd.md   ← daily notes (Templater-generated)
Project/<ProjectName>.md                 ← per-project hub notes
Project/Issues/                          ← issue tracking notes
Project/Change/                          ← change request notes
Tools/                                   ← reusable reference snippets (Git, SQL, Linux, VIM, etc.)
temp/Canvases/                           ← work-in-progress canvas diagrams
temp/Sub Note/                           ← supporting notes for canvas diagrams
temp/Template_Daily_note.md             ← daily note template (uses Templater syntax)
Attachments/                             ← all images (pasted screenshots go here)
```

## Note Conventions

**Daily notes** follow the path `Daily/YYYY/MM-MMMM/YYYY-MM-DD-dddd.md` (e.g. `Daily/2026/04-April/2026-04-13-Monday.md`). The template is at `temp/Template_Daily_note.md` and uses Templater + Dataview.

**Canvas diagrams** in `temp/Canvases/` follow an observation/solution naming pattern:
- `<Issue> observation.canvas` — what was observed / log traces
- `<Issue> solution.canvas` — the fix or root cause

**Project hub notes** (e.g. `Project/Toll Hive(2301_P11204).md`) aggregate links to sub-notes, SQL queries, issue threads, and external URLs (Jira, Wiki, SCADA).

**Attachments** are stored in `Attachments/`. Canvas files reference them as `"file":"Attachments/Pasted image XXXXX.png"`. Markdown files use `![[Pasted image XXXXX.png]]` (Obsidian resolves by filename).

## Key Plugins in Use

- **Templater** — daily note creation, file templates
- **Dataview** — queries in daily notes (notes created/modified today)
- **Tasks** — task tracking across notes
- **Omnisearch** — full-text search
- **Calendar** — daily note navigation
- **obsidian-vimrc-support** — Vim keybindings active

## Domain Context

This vault documents **WCS (Warehouse Control System)** software — specifically Dematic MFC systems. Common abbreviations:
- **TM** — Transfer Mission
- **MH** — Material Handling
- **OI** — Operator Interface
- **UQ** — Unit Queue
- **MS / MSAI** — Multi-Shuttle Aisle
- **GTP** — Goods To Person
- **SDA / SAD** — message protocol types
- **TUMI / TUEX / TUMC / TUCA / TUNO / TURP** — DCI message types between WCS and PLCs
