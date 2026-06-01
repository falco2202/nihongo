# 日本語読解練習 — Claude Codeで既存コードベースを理解する

## 読み物（N2/N3・約650字）

Claude Codeは、ターミナル上で使えるエージェント型のコーディング支援ツールである。単に質問に答えるだけでなく、既存のコードベースを読み、ファイルを編集し、必要に応じてコマンドを実行できる点が特徴だ。新しいプロジェクトに参加したとき、まず全体像をつかむために「このコードベースの概要を説明してください」「主要なアーキテクチャパターンは何ですか」のように依頼すると、構成を理解しやすくなる。

ただし、Claude Codeを効果的に使うには、丸投げではなく、目的を明確に伝えることが重要である。例えば「認証機能について調べてください」よりも、「ログイン処理の流れ、主要なファイル、テストの場所を整理してください」のように依頼したほうが、必要な情報を得やすい。また、広い質問から始めて、分かった内容に基づいて少しずつ質問を絞り込むと、複雑なコードベースでも迷いにくい。

チームでClaude Codeを使う場合は、`CLAUDE.md` のようなメモリファイルに、プロジェクトのルールやよく使うコマンド、設計方針を書いておくとよい。たとえば、テストの実行方法、ブランチ運用、命名規則、レビュー時に注意すべき点などを共有しておけば、毎回同じ説明を繰り返す必要が減る。これは、AIに文脈を渡すだけでなく、人間のチームメンバーにとっても有用なドキュメントになる。

一方で、AIが出した説明や修正案をそのまま信じるのは危険である。特にセキュリティ、データ削除、権限変更、本番環境への影響がある作業では、必ず人間が確認し、必要なら小さな範囲で検証するべきだ。Claude Codeは作業を速くする強力な道具だが、最終的な責任は開発者にある。AIに任せる部分と、人間が判断する部分を分けて使うことが、実務では重要である。

> 参考: [Claude Code overview](https://docs.anthropic.com/en/docs/claude-code/overview), [Common workflows](https://docs.anthropic.com/en/docs/claude-code/tutorials), [Manage Claude's memory](https://docs.anthropic.com/en/docs/claude-code/memory)

---

## 読解チェック

1. Claude Codeの特徴として、本文ではどのような点が挙げられていますか？
2. 「認証機能について調べてください」よりも、具体的に依頼したほうがよい理由は何ですか？
3. `CLAUDE.md` に書いておくとよい情報を二つ答えてください。
4. AIが出した修正案をそのまま信じるのが危険な場面はどのような場面ですか？

<details>
<summary>答えを見る</summary>

1. 既存のコードベースを読み、ファイルを編集し、必要に応じてコマンドを実行できる点。
2. 目的や確認したい範囲が明確になり、必要な情報を得やすくなるため。
3. 例：テストの実行方法、ブランチ運用、命名規則、レビュー時に注意すべき点、設計方針。
4. セキュリティ、データ削除、権限変更、本番環境への影響がある作業。

</details>

---

## 新出語彙

| 単語 | 読み | 品詞 | 意味（英語） | 意味（ベトナム語） | JLPT |
|------|------|------|------------|-----------------|------|
| 既存 | きそん | 名詞 | existing | hiện có | N2 |
| 全体像 | ぜんたいぞう | 名詞 | overall picture | bức tranh tổng thể | N2 |
| 丸投げ | まるなげ | 名詞・動詞 | leaving everything to someone | giao phó toàn bộ | N1/N2 |
| 絞り込む | しぼりこむ | 動詞 | to narrow down | thu hẹp lại | N2 |
| 命名規則 | めいめいきそく | 名詞 | naming convention | quy tắc đặt tên | IT |
| 修正案 | しゅうせいあん | 名詞 | proposed fix | phương án sửa | N2 |
| 権限変更 | けんげんへんこう | 名詞 | permission change | thay đổi quyền | IT |
| 検証 | けんしょう | 名詞・動詞 | verification | kiểm chứng | N2 |
| 最終的 | さいしゅうてき | 形容動詞 | final, ultimate | cuối cùng | N2 |
| 判断 | はんだん | 名詞・動詞 | judgment | phán đoán | N3 |

---

## 新出文法

### 〜だけでなく
- **意味**: not only ~ but also ~ / không chỉ ~ mà còn ~
- **構造**: 動詞普通形・名詞 + だけでなく
- **例文**: Claude Codeは、単に質問に答えるだけでなく、既存のコードベースを読むこともできる。
  - EN: Claude Code can not only answer questions but also read an existing codebase.
  - VI: Claude Code không chỉ trả lời câu hỏi mà còn có thể đọc codebase hiện có.

### 〜に基づいて
- **意味**: based on ~ / dựa trên ~
- **構造**: 名詞 + に基づいて
- **例文**: 分かった内容に基づいて、質問を少しずつ絞り込む。
  - EN: Narrow down your questions based on what you have learned.
  - VI: Thu hẹp câu hỏi dần dựa trên những gì đã hiểu.

### 〜べきだ
- **意味**: should ~ / nên ~
- **構造**: 動詞辞書形 + べきだ
- **例文**: 本番環境への影響がある作業では、必ず人間が確認するべきだ。
  - EN: For work that affects production, a human should always review it.
  - VI: Với công việc ảnh hưởng môi trường production, con người nhất định nên kiểm tra.

---

## 実務で使える依頼例

### 1. コードベースの概要を知りたいとき

```text
このコードベースの全体像を説明してください。
特に、主要なディレクトリ、アプリケーションの入口、テストの場所を整理してください。
```

### 2. 認証機能を調べたいとき

```text
ログイン処理の流れを調べてください。
関連するファイル、使用しているミドルウェア、テストケースの場所を表にまとめてください。
```

### 3. チームルールを共有したいとき

```text
CLAUDE.md に、このプロジェクトでよく使うコマンド、命名規則、レビュー時の注意点をまとめたいです。
既存のREADMEを読んで、下書きを作成してください。
```

---

## 今日の練習

次のベトナム語を、自然な日本語に直してください。

1. Hãy giải thích tổng quan codebase này.
2. Hãy liệt kê các file chính liên quan đến login.
3. Hãy tóm tắt vị trí test và cách chạy test.
4. Tôi muốn ghi các rule của project vào CLAUDE.md.
5. Với thay đổi ảnh hưởng production, con người nên kiểm tra cuối cùng.

<details>
<summary>解答例</summary>

1. このコードベースの全体像を説明してください。
2. ログインに関連する主要なファイルを一覧にしてください。
3. テストの場所と実行方法をまとめてください。
4. プロジェクトのルールをCLAUDE.mdにまとめたいです。
5. 本番環境に影響する変更については、最終的に人間が確認するべきです。

</details>

---
*生成日: 2026-05-05 | レベル: N2/N3 | ジャンル: Claude Code・AI開発支援 | 参考元: Anthropic Docs*
