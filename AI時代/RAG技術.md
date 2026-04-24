# RAG（検索拡張生成）— AI時代の実装技術

**テーマ：** RAGを活用した社内ナレッジ検索システムの構築  
**レベル：** N2/N3  
**参考：** https://zenn.dev/ml_bear/books/d1f060a3f166a5/viewer/rag

---

## 📖 読解文（約500字）

RAG（Retrieval-Augmented Generation）とは、大規模言語モデルに外部の知識ベースを組み合わせた技術であり、近年多くの企業で導入が進んでいる。従来の言語モデルは、学習済みの知識のみに基づいて回答を生成するため、最新情報や社内固有のドキュメントには対応できないという限界があった。RAGはこの課題を解決するアプローチとして注目されている。

仕組みとしては、まずユーザーの質問に対して意味的に近いドキュメントをベクトル検索で取得し、その内容をプロンプトに付加した上でモデルに送信する。これにより、モデルは社内マニュアルや技術仕様書など、学習データに含まれない情報を参照しながら回答を生成することができる。

実装においては、ドキュメントのチャンク分割方法や埋め込みモデルの選定が精度に大きく影響する。また、取得されたコンテキストの関連性をどう評価するかという、いわゆる「リランキング」の工夫も重要な課題だ。

日本のIT企業では、社内ナレッジの属人化を防ぐ手段としてRAGシステムへの期待が高まっており、Confluenceや社内Wikiと連携した導入事例も増えている。

---

## ❓ 読解問題

1. 従来の言語モデルにはどのような限界がありましたか？
2. RAGの仕組みを順番に説明してください。
3. 日本のIT企業がRAGシステムに期待している理由は何ですか？

<details>
<summary>解答</summary>

1. 学習済みの知識のみに基づいて回答を生成するため、最新情報や社内固有のドキュメントに対応できないという限界があった。
2. ①ユーザーの質問に対してベクトル検索で関連ドキュメントを取得 → ②その内容をプロンプトに付加 → ③モデルが参照しながら回答を生成する。
3. 社内ナレッジの属人化を防ぐ手段として期待されているため。

</details>

---

## 📝 語彙リスト

| 単語 | 読み | 英語 | ベトナム語 |
|------|------|------|-----------|
| 知識ベース | ちしきベース | knowledge base | cơ sở tri thức |
| 限界 | げんかい | limit, limitation | giới hạn |
| 取得する | しゅとくする | to retrieve, to obtain | lấy, truy xuất |
| 付加する | ふかする | to add, to append | thêm vào |
| 仕様書 | しようしょ | specification document | tài liệu đặc tả |
| 分割 | ぶんかつ | division, splitting | phân chia |
| 精度 | せいど | accuracy, precision | độ chính xác |
| 属人化 | ぞくじんか | knowledge siloing (dependent on specific person) | phụ thuộc cá nhân |
| 連携する | れんけいする | to integrate, to collaborate | tích hợp, liên kết |
| 導入事例 | どうにゅうじれい | implementation case study | trường hợp triển khai |

---

## 📐 文法ポイント

### 1. 〜に基づいて（N2）
> 学習済みの知識のみ**に基づいて**回答を生成する

「〜に基づいて」= "based on ~" / "dựa trên ~"（根拠・基準）  
ビジネス文書や技術仕様書で頻出。  
例：要件定義に基づいて実装を進める。

### 2. 〜た上で（N2）
> その内容をプロンプトに付加し**た上で**モデルに送信する

「〜た上で」= "after doing ~ / having done ~, then..."（前提条件）  
例：テストを完了した上で、本番環境にデプロイする。

### 3. 〜として〜が高まっている（N2）
> 社内ナレッジの属人化を防ぐ手段**として**RAGシステムへの期待**が高まっている**

「〜として」= "as ~ / in the capacity of ~"（役割・立場）  
「期待が高まる」= expectations are growing  
例：セキュリティ対策として、二要素認証の導入が求められている。

---

## 💬 職場で使えるフレーズ

| 場面 | 日本語 | 意味 |
|------|--------|------|
| 提案時 | RAGを導入することで、回答精度を向上させられると思います。 | By introducing RAG, I think we can improve response accuracy. |
| 懸念を伝える | チャンクの分割方法によって精度が大きく変わる可能性があります。 | Accuracy may vary significantly depending on how chunks are split. |
| 進捗報告 | ベクトル検索の実装が完了し、現在リランキングの調整を進めています。 | Vector search implementation is complete; we're currently fine-tuning the reranking. |

---

*作成日: 2026-04-24 | レベル: N2/N3 | ジャンル: AI技術・RAG | falco2202/nihongo*
