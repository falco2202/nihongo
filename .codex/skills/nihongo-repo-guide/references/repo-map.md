# Repo Map

This repository is a Japanese learning notebook for an IT engineer. It is built as a Just the Docs Jekyll site.

## Site Configuration

- `_config.yml`: Just the Docs configuration.
- Theme: `just-the-docs/just-the-docs`.
- Site title: `日本語学習ノート`.
- Base URL: `/nihongo`.
- Language: Japanese.
- Search enabled.
- `README.md` is the home page.

## Root README

Purpose: ITエンジニア向けの日本語学習記録.

Main learner:

- Vietnamese IT engineer.
- Targets N2/N3 practical Japanese.
- Wants to read Japanese technical documents and communicate in Japanese workplaces.

Root folder overview:

```text
毎日練習/          daily generated IT reading practice
ニュース/          Japanese IT/science/life news readings
テクニカル/        technical vocabulary and docs
クライド技術/      Claude API, Claude Code, agent/prompt topics
AI時代/           AI-era developer career and tools
スキル/            workplace Japanese skills
ビジネス日本語/    BJT and business Japanese practice
設計ドキュメント/  specs, requirements, design docs
エラー・障害対応/  incidents, logs, postmortems
面接・転職/        interviews and job change preparation
```

## Section Details

### 毎日練習

Daily IT reading lessons. README says the standard lesson contains:

- Japanese technical reading passage, around 1000 characters.
- Reading questions.
- Vocabulary list with readings, English, Vietnamese.
- Grammar points with IT-context examples.

Theme rotation includes cloud, Git, security, DB, API, testing, CI/CD, agile, microservices, code review, docs, infrastructure, performance, incidents, AI, TDD.

### ニュース

News reading section for IT, science, society/life. Files live under monthly folders such as `ニュース/2026-04/2026-04-22.md`.

Typical format:

- Headline.
- 150-250 character N2/N3 summary.
- 5-8 vocabulary items.
- 2-3 reading check questions.
- One memo about expression or background.

### テクニカル

Technical Japanese for infrastructure/cloud, CI/CD, security, databases, architecture. Good destination for evergreen technical explanations and sample readings.

### クライド技術

Claude-related learning: Claude API, Claude Code, prompt design, Agent SDK, model selection. Use for Claude or agent development Japanese lessons.

### AI時代

AI-era developer content: AI tools, skills needed in the AI era, Japanese workplace rules for AI, career strategy.

### スキル

Practical workplace Japanese skills for engineers: business Japanese, code review, docs, 報連相, keigo/polite language.

### ビジネス日本語

BJT and business Japanese practice. Current goal: BJTビジネス日本語能力テスト 400点以上.

Prioritize:

- 報連相
- メール
- 会議
- 電話対応
- 敬語
- 依頼・断り方
- クレーム対応
- 進捗報告
- 交渉
- 社内チャット

Create dated lessons here when the user asks for BJT, business Japanese, workplace emails, meetings, keigo, or BJT 400+ preparation.

### 設計ドキュメント

Japanese for requirements definitions, basic/detailed design docs, API specs, test specs, review comments, change history.

### エラー・障害対応

Incident response Japanese: incident reports, log reading, cause investigation, temporary/permanent fixes, prevention, postmortems, internal notices.

### 面接・転職

Japanese for job interviews and career change: self-introduction, project experience, technical interviews, motivation, reverse questions, condition negotiation, resignation/job-change reasons.

## Claude Command

`.claude/commands/nihongo.md` defines a `/nihongo` tutor command. It emphasizes:

- Japanese tutor for Vietnamese IT engineers.
- N2/N3 default.
- No furigana.
- English and Vietnamese translations.
- Developer-realistic examples.
- Modes for vocabulary, grammar, kanji, quiz, scene, email/slack, and reading/doc generation.
