# エラー・障害対応 — フォルダ概要

Từ vựng và mẫu câu dùng khi xử lý sự cố, đọc log, báo cáo incident, và viết postmortem tại công ty IT Nhật. Đây là tình huống áp lực cao — cần phản xạ ngôn ngữ nhanh.

## 主なテーマ

| テーマ | 内容 |
|--------|------|
| 障害報告 | Báo cáo sự cố lên team/manager kịp thời |
| ログ読解 | Đọc hiểu error log, stack trace bằng tiếng Nhật |
| 原因調査 | Mô tả quá trình điều tra nguyên nhân |
| 暫定対応・恒久対応 | Phân biệt xử lý tạm thời và xử lý triệt để |
| 再発防止 | Viết kế hoạch phòng ngừa tái phát |
| ポストモーテム | Viết báo cáo postmortem chuyên nghiệp |
| 社内連絡 | Thông báo nội bộ trong lúc đang xử lý sự cố |

## 記事一覧

*（記事は順次追加予定）*

## よく出る語彙（N2/N3）

| 単語 | 読み | 意味（英語） | 意味（ベトナム語） |
|------|------|------------|-----------------|
| 障害 | しょうがい | failure, incident | sự cố |
| 不具合 | ふぐあい | defect, bug | lỗi, khiếm khuyết |
| 原因究明 | げんいんきゅうめい | root cause analysis | điều tra nguyên nhân gốc |
| 暫定対応 | ざんていたいおう | temporary fix | xử lý tạm thời |
| 恒久対応 | こうきゅうたいおう | permanent fix | xử lý triệt để |
| 再発防止 | さいはつぼうし | recurrence prevention | phòng ngừa tái phát |
| 影響範囲 | えいきょうはんい | scope of impact | phạm vi ảnh hưởng |
| 復旧 | ふっきゅう | recovery, restoration | khôi phục |
| 切り戻し | きりもどし | rollback | rollback |
| 監視 | かんし | monitoring | giám sát |
| アラート | — | alert | cảnh báo |
| エスカレーション | — | escalation | leo thang xử lý |

## 障害対応フロー

```
検知 → 一次対応 → 原因調査 → 暫定対応 → 恒久対応 → 再発防止
```

## よく使う表現・テンプレート

### 障害発生の第一報（Slack）
```
【障害発生】○○サービスで障害が発生しています。
発生時刻: HH:MM
影響範囲: ○○機能が利用できない状態です。
現在調査中です。続報をお待ちください。
```

### 原因報告
```
原因を調査した結果、○○が原因であることが判明しました。
△△のデプロイ後から発生しており、設定値の誤りが引き金となっています。
```

### 暫定対応の連絡
```
暫定対応として、○○を実施しました。
現在サービスは復旧しています。
恒久対応については別途検討いたします。
```

### ポストモーテム構成
```
## 概要
## タイムライン
## 根本原因
## 対応内容（暫定・恒久）
## 再発防止策
## 振り返り（よかった点・改善点）
```
