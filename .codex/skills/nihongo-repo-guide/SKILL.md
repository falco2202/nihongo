---
name: nihongo-repo-guide
description: Work inside this Japanese learning repository for a Vietnamese IT engineer. Use when Codex is asked to create, update, summarize, organize, or extend repo content across 毎日練習, ニュース, テクニカル, クライド技術, AI時代, スキル, ビジネス日本語/BJT, 設計ドキュメント, エラー・障害対応, 面接・転職, or related Markdown lesson files.
---

# Nihongo Repo Guide

## Purpose

Maintain and extend `falco2202/nihongo`, a Japanese learning notebook for a Vietnamese IT engineer targeting practical N2/N3 Japanese for Japanese IT workplaces.

The repo is a Markdown-based Japanese learning notebook. Learning content lives under `documents/`; repo-level automation, prompts, and local Codex skills live at the repository root. Content should feel useful for self-study: Japanese main text, IT/business context, vocabulary with English and Vietnamese, reading questions, and concise grammar or expression notes.

## Core Learner Profile

- Learner: Vietnamese IT engineer.
- Main level: N2/N3; sometimes N4 review or N1/news-style reading.
- Goal: read technical documents, communicate at Japanese companies, handle business Japanese, interviews, design docs, incidents, and AI-era developer topics.
- Default support languages: English and Vietnamese for meanings/explanations; Japanese for main passages.

## Repo Map

Read `references/repo-map.md` when you need a detailed folder summary or destination decision.

High-level content folders under `documents/`:

- `documents/毎日練習/`: daily IT reading practice, usually dated `YYYY-MM-DD.md`.
- `documents/ニュース/`: Japanese news reading, grouped by month.
- `documents/テクニカル/`: technical vocabulary and readings: cloud, CI/CD, security, DB, architecture.
- `documents/クライド技術/`: Claude API, Claude Code, prompt engineering, agent SDK.
- `documents/AI時代/`: AI-era developer skills, tools, career, Japanese IT workplace.
- `documents/スキル/`: workplace Japanese skills for engineers: code review, docs, 報連相, keigo.
- `documents/ビジネス日本語/`: BJT and business Japanese practice, especially BJT 400+.
- `documents/設計ドキュメント/`: requirements, design docs, API specs, test specs, review comments.
- `documents/エラー・障害対応/`: incident response, logs, root cause, postmortems.
- `documents/面接・転職/`: interviews, career history, motivation, salary/condition negotiation.

## Content Rules

- Preserve existing Markdown style.
- Use date filenames only for `documents/毎日練習/YYYY-MM-DD.md` and `documents/ニュース/YYYY-MM/YYYY-MM-DD.md`.
- Use numbered theme filenames for other learning sections: `NN_テーマ.md`.
- Use relative links in README tables.
- For vocabulary tables, prefer columns: `単語 | 読み | 英語 | ベトナム語`.
- Avoid furigana in prose; put readings in dedicated table fields.
- Keep examples realistic for software development or Japanese office work.
- When the user says "today", use the current environment date.

## Common Workflows

### Create a daily IT lesson

Use `documents/毎日練習/YYYY-MM-DD.md`. Follow the format in `references/lesson-formats.md`.

### Create a BJT/business Japanese lesson

Use the next numbered theme file, such as `documents/ビジネス日本語/NN_テーマ.md`. Include BJT-style intent and judgment questions. Update `documents/ビジネス日本語/README.md` learning log.

### Create or update a section README

Summarize the section purpose, theme list, sample or learning log. Keep the README useful as a plain Markdown section index.

### Add news content

Use `documents/ニュース/YYYY-MM/YYYY-MM-DD.md`. Keep it shorter than daily lessons and focus on news vocabulary, reading check, and one useful memo.

## Validation

After edits:

- Read the changed file with UTF-8.
- Check that Japanese text is not mojibake.
- Confirm links in README tables match created paths.
- For requested word/character counts, measure the relevant passage roughly.
- Do not overwrite unrelated user changes.
