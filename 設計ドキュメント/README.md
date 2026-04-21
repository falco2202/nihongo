# 設計ドキュメント — フォルダ概要

Cách đọc và viết tài liệu kỹ thuật tại công ty IT Nhật. Tập trung vào 仕様書、設計書、要件定義書 — những tài liệu bắt buộc phải đọc hiểu trong mọi dự án.

## 主なテーマ

| テーマ | 内容 |
|--------|------|
| 要件定義書 | Tài liệu định nghĩa yêu cầu — đọc hiểu và đặt câu hỏi |
| 基本設計書 | High-level design: architecture, module, data flow |
| 詳細設計書 | Low-level design: class, function, DB schema |
| API仕様書 | Đọc và viết API spec bằng tiếng Nhật |
| テスト仕様書 | Test plan, test case viết theo chuẩn Nhật |
| レビューコメント | Cách viết và phản hồi review comment |
| 変更履歴 | Ghi chép lịch sử thay đổi tài liệu |

## 記事一覧

*（記事は順次追加予定）*

## よく出る語彙（N2/N3）

| 単語 | 読み | 意味（英語） | 意味（ベトナム語） |
|------|------|------------|-----------------|
| 要件定義 | ようけんていぎ | requirements definition | định nghĩa yêu cầu |
| 仕様 | しよう | specification | đặc tả |
| 設計書 | せっけいしょ | design document | tài liệu thiết kế |
| 前提条件 | ぜんていじょうけん | preconditions | điều kiện tiên quyết |
| 制約事項 | せいやくじこう | constraints | ràng buộc |
| 想定する | そうていする | to assume, to expect | giả định |
| 考慮する | こうりょする | to consider, to take into account | cân nhắc |
| 対象外 | たいしょうがい | out of scope | ngoài phạm vi |
| 依存関係 | いぞんかんけい | dependency | quan hệ phụ thuộc |
| 整合性 | せいごうせい | consistency | tính nhất quán |
| 冪等性 | べきとうせい | idempotency | tính idempotent |
| スループット | — | throughput | thông lượng |

## ドキュメント構成テンプレート

### 要件定義書
```
## 1. 目的
## 2. 対象範囲（スコープ）
## 3. 対象外
## 4. 前提条件・制約事項
## 5. 機能要件
## 6. 非機能要件（性能・セキュリティ・可用性）
## 7. 用語定義
```

### API仕様書（エンドポイント）
```
### POST /api/v1/○○

**概要**: ○○を登録する

**リクエスト**
| パラメータ | 型 | 必須 | 説明 |
|-----------|-----|------|------|

**レスポンス**
| ステータス | 説明 |
|-----------|------|
| 200 | 正常終了 |
| 400 | バリデーションエラー |
| 500 | サーバーエラー |
```

### レビューコメントの書き方
```
# 指摘（修正必須）
この処理はNullPointerExceptionが発生する可能性があります。
○○の場合を考慮した処理を追加してください。

# 提案（任意）
こちらは○○のように書くと、より可読性が上がるかもしれません。

# 質問
この変数名の意図を教えていただけますか？
```
