# テクニカル — API設計とREST APIの実務ポイント

**テーマ：** API設計とREST APIの実務ポイント

**レベル：** N2/N3

**分野：** Web API / システム設計 / セキュリティ

---

## 📖 読解文（約900字）

API設計では、単にURLを決めるだけでなく、システム間でどのようにデータを受け渡し、エラーや権限をどのように扱うかまで決める必要がある。特にREST APIでは、「注文」「ユーザー」「請求書」のようなリソースを中心に考え、HTTPメソッドを使って操作を表す。たとえば、注文一覧を取得する場合は `GET /orders`、注文を1件取得する場合は `GET /orders/{orderId}`、新しい注文を登録する場合は `POST /orders` のように設計する。

APIの結果は、ステータスコードで明確に表すことが重要である。正常に取得できた場合は `200 OK`、新規作成に成功した場合は `201 Created`、返す本文がない場合は `204 No Content` を使うことが多い。一方、入力値が不正な場合は `400 Bad Request`、ログインしていない場合は `401 Unauthorized`、権限が足りない場合は `403 Forbidden`、対象データが存在しない場合は `404 Not Found` を返す。業務上の競合、たとえば同じ注文番号がすでに存在する場合は `409 Conflict` を使うこともある。

実務で特に注意が必要なのが冪等性である。冪等性とは、同じリクエストを複数回送っても結果が変わらない性質を指す。ネットワークの一時的なエラーでクライアントがリトライした場合、同じ注文が二重に登録されると大きな問題になる。そのため、登録系APIでは、リクエストIDや冪等性キーを受け取り、すでに処理済みかどうかを確認する仕組みを入れることがある。また、DB側で一意制約を設定し、二重登録を防ぐ設計も有効である。

エラー設計では、利用者が原因を理解し、次に何をすればよいか判断できる形にする。エラーレスポンスには、業務エラーコード、利用者向けメッセージ、詳細情報、トレースIDなどを含めると調査しやすい。ただし、スタックトレースや内部テーブル名など、攻撃者にヒントを与える情報を外部に返してはいけない。

認証と認可も分けて考える必要がある。認証は「誰であるか」を確認することで、認可は「その人が何をしてよいか」を確認することである。たとえば、ログイン済みのユーザーであっても、他人の注文情報を参照できるとは限らない。API設計では、アクセストークンの確認だけでなく、データの所有者やロールに応じた権限チェックまで設計することが求められる。

良いAPI設計とは、開発者にとって使いやすく、運用時に調査しやすく、障害や不正アクセスにも強い設計である。URL、メソッド、ステータスコード、冪等性、エラー形式、認証認可を一貫して設計することで、システム間連携の品質を高めることができる。

---

## ❓ 読解問題

1. REST APIでは、何を中心にURLを設計しますか？
2. `201 Created` はどのような場合に使いますか？
3. 冪等性とは、どのような性質ですか？
4. エラーレスポンスに含めると調査しやすい情報を2つ以上答えてください。
5. 認証と認可の違いを説明してください。

<details>
<summary>解答</summary>

1. 「注文」「ユーザー」「請求書」のようなリソースを中心に設計する。
2. 新しいデータやリソースの作成に成功した場合。
3. 同じリクエストを複数回送っても、結果が変わらない性質。
4. 例：業務エラーコード、利用者向けメッセージ、詳細情報、トレースID。
5. 認証は「誰であるか」を確認すること。認可は「その人が何をしてよいか」を確認すること。

</details>

---

## 📝 語彙リスト

| 単語 | 読み | 英語 | ベトナム語 |
|------|------|------|-----------|
| API設計 | えーぴーあいせっけい | API design | thiết kế API |
| REST | れすと | REST | REST |
| リソース | — | resource | tài nguyên |
| エンドポイント | — | endpoint | endpoint / điểm truy cập API |
| HTTPメソッド | えいちてぃーてぃーぴーめそっど | HTTP method | phương thức HTTP |
| ステータスコード | — | status code | mã trạng thái |
| 冪等性 | めきとうせい | idempotency | tính idempotent / không đổi khi gọi lại |
| 重複登録 | ちょうふくとうろく | duplicate registration | đăng ký trùng |
| 一意制約 | いちいやく | unique constraint | ràng buộc duy nhất |
| 入力チェック | にゅうりょくちぇっく | input validation | kiểm tra dữ liệu đầu vào |
| エラーレスポンス | — | error response | phản hồi lỗi |
| トレースID | とれーすあいでぃー | trace ID | mã truy vết |
| 認証 | にんしょう | authentication | xác thực |
| 認可 | にんか | authorization | phân quyền |
| 権限チェック | けんげんちぇっく | permission check | kiểm tra quyền |

---

## 📐 文法・表現ポイント

### 1. 〜だけでなく（N3/N2）
> 単にURLを決めるだけでなく、エラーや権限まで決める必要がある

「AだけではなくBも」という意味。
例：API設計では、正常系だけでなく、異常系も考慮します。

### 2. 〜場合は（N4/N3）
> 入力値が不正な場合は `400 Bad Request` を返す

条件を表す基本表現。技術説明でよく使う。
例：対象データが存在しない場合は、`404 Not Found` を返します。

### 3. 〜ことが求められる（N2）
> 権限チェックまで設計することが求められる

「〜する必要がある」「〜することを期待される」という意味。
例：外部公開APIでは、セキュリティを十分に考慮することが求められます。

---

## 💬 実務で使える表現

| 場面 | 日本語表現 | ベトナム語 |
|------|------------|------------|
| URL設計 | APIのURLは、操作名ではなくリソース名を中心に設計します。 | URL API nên thiết kế theo resource, không theo tên thao tác. |
| ステータスコード | 登録に成功した場合は、`201 Created` を返します。 | Khi tạo thành công thì trả về 201 Created. |
| 入力エラー | 入力値が不正な場合は、`400 Bad Request` とエラー詳細を返します。 | Khi input sai thì trả 400 và chi tiết lỗi. |
| 冪等性 | 同じリクエストが複数回来ても、二重登録されないようにします。 | Dù request đến nhiều lần cũng không đăng ký trùng. |
| 認証認可 | 認証と認可は分けて考える必要があります。 | Cần tách authentication và authorization. |
| 調査 | エラーレスポンスには、調査用のトレースIDを含めます。 | Error response nên có trace ID để điều tra. |

---

## 🎤 面接Q&A：API設計

### Q1. API設計では、どのような項目を決めますか？

**回答例：**
エンドポイント、HTTPメソッド、リクエスト項目、レスポンス項目、ステータスコード、エラー形式、認証認可、冪等性などを決めます。特に外部システムと連携するAPIでは、正常系だけでなく、入力エラー、権限エラー、リトライ時の動きまで明確にします。

**ベトナム語メモ：**
Thiết kế API cần quyết định endpoint, method, request/response, status code, error format, auth/authz, idempotency.

### Q2. REST APIとは何ですか？

**回答例：**
REST APIは、リソースをURLで表し、HTTPメソッドで操作を表すAPI設計の考え方です。たとえば、注文を取得する場合は `GET /orders/{orderId}`、注文を作成する場合は `POST /orders` のように設計します。

**ベトナム語メモ：**
REST API biểu diễn resource bằng URL và thao tác bằng HTTP method.

### Q3. よく使うステータスコードを説明してください。

**回答例：**
正常系では `200 OK`、`201 Created`、`204 No Content` をよく使います。異常系では、入力不正は `400 Bad Request`、未認証は `401 Unauthorized`、権限不足は `403 Forbidden`、対象なしは `404 Not Found`、競合は `409 Conflict` を使います。

**ベトナム語メモ：**
Status code cần dùng đúng ý nghĩa: 400 input sai, 401 chưa xác thực, 403 thiếu quyền, 404 không tồn tại, 409 conflict.

### Q4. 冪等性とは何ですか？

**回答例：**
冪等性とは、同じリクエストを複数回実行しても結果が変わらない性質です。APIでは、ネットワークエラーなどで同じリクエストが再送されることがあります。そのため、登録APIでは冪等性キーや一意制約を使い、二重登録を防ぐ必要があります。

**ベトナム語メモ：**
Idempotency là gọi lại cùng request nhiều lần nhưng kết quả không bị thay đổi hoặc không tạo trùng.

### Q5. エラー設計で注意することは何ですか？

**回答例：**
エラーコード、メッセージ、詳細情報、トレースIDを一貫した形式で返すことです。利用者が原因を理解できる表現にしつつ、内部のスタックトレースやテーブル名など、セキュリティ上危険な情報は返さないようにします。

**ベトナム語メモ：**
Error response cần nhất quán, có code/message/detail/traceId, nhưng không lộ thông tin nội bộ.

### Q6. 認証と認可の違いは何ですか？

**回答例：**
認証は「誰であるか」を確認することです。認可は「その人がその操作をしてよいか」を確認することです。たとえば、ログイン済みでも、他人の注文を参照する権限がなければ、APIはアクセスを拒否する必要があります。

**ベトナム語メモ：**
Authentication xác nhận danh tính. Authorization kiểm tra người đó có quyền thao tác hay không.

### Q7. 注文登録APIを設計する場合、何に注意しますか？

**回答例：**
まず、必須項目や入力チェックを明確にします。次に、登録成功時は `201 Created` を返し、入力不正は `400 Bad Request`、重複や状態不整合は `409 Conflict` を返すようにします。また、同じ注文が二重登録されないように、リクエストIDや一意制約を使って冪等性を考慮します。

**ベトナム語メモ：**
Với API tạo order: validate input, status code rõ ràng, chống duplicate bằng request ID/idempotency key/unique constraint.

### Q8. API設計で運用面を考慮するとは、どういうことですか？

**回答例：**
障害が起きたときに原因を追えるように、ログ、トレースID、エラーコードを設計することです。また、APIの応答時間、リトライ、タイムアウト、監視項目も考慮します。開発時だけでなく、リリース後に調査しやすい設計にすることが重要です。

**ベトナム語メモ：**
Thiết kế API cũng cần nghĩ tới vận hành: log, trace ID, error code, timeout, retry, monitoring.

### Q9. 面接で「API設計の経験を説明してください」と聞かれたら、どう答えますか？

**回答例：**
API設計では、まず要件を確認し、どのリソースをAPIとして公開するかを整理しました。その上で、エンドポイント、HTTPメソッド、リクエスト・レスポンス項目、ステータスコード、エラー形式を設計しました。また、認証認可、冪等性、ログ出力、トレースIDも考慮し、実装後に結合テストで正常系と異常系を確認しました。

**ベトナム語メモ：**
Nói theo quy trình đã làm: xác nhận yêu cầu → resource/endpoint → method/request/response/status/error → auth/idempotency/log → test normal/error cases.

---

## 🗣️ ミニシャドーイング

短い文を何度も声に出して、面接で自然に言えるようにする。

| No. | 日本語フレーズ | ベトナム語 |
|-----|----------------|------------|
| 1 | API設計では、エンドポイントとHTTPメソッドを明確にします。 | Trong thiết kế API, cần làm rõ endpoint và HTTP method. |
| 2 | REST APIでは、リソースを中心にURLを設計します。 | REST API thiết kế URL xoay quanh resource. |
| 3 | 登録成功時は、`201 Created` を返します。 | Khi tạo thành công thì trả 201 Created. |
| 4 | 入力値が不正な場合は、`400 Bad Request` を返します。 | Khi input sai thì trả 400 Bad Request. |
| 5 | 権限が足りない場合は、`403 Forbidden` を返します。 | Khi thiếu quyền thì trả 403 Forbidden. |
| 6 | 同じリクエストが複数回来ても、二重登録されないようにします。 | Dù request đến nhiều lần cũng không tạo trùng. |
| 7 | 冪等性キーを使って、リトライ時の重複を防ぎます。 | Dùng idempotency key để tránh trùng khi retry. |
| 8 | エラー形式はAPI全体で統一します。 | Format lỗi cần thống nhất trong toàn bộ API. |
| 9 | エラーレスポンスには、トレースIDを含めます。 | Error response có trace ID. |
| 10 | 認証は誰であるかを確認することです。 | Authentication là xác nhận danh tính. |
| 11 | 認可は何をしてよいかを確認することです。 | Authorization là kiểm tra được phép làm gì. |
| 12 | APIは実装しやすさだけでなく、運用しやすさも重要です。 | API không chỉ dễ implement mà còn cần dễ vận hành. |

---

## 🧩 今日の練習

次のベトナム語を、自然な日本語に直してください。

1. API này dùng để lấy danh sách đơn hàng.
2. Khi tạo thành công dữ liệu mới, hãy trả về 201 Created.
3. Nếu request giống nhau được gửi nhiều lần, không được tạo dữ liệu trùng.
4. Authentication và authorization cần được thiết kế riêng biệt.
5. Error response nên có error code và trace ID để dễ điều tra.

<details>
<summary>解答例</summary>

1. このAPIは注文一覧を取得するためのものです。
2. 新しいデータの作成に成功した場合は、`201 Created` を返してください。
3. 同じリクエストが複数回送信されても、重複データを作成しないようにします。
4. 認証と認可は分けて設計する必要があります。
5. 調査しやすくするために、エラーレスポンスにはエラーコードとトレースIDを含めるのがよいです。

</details>

---

*テクニカル日本語練習 | falco2202/nihongo*
