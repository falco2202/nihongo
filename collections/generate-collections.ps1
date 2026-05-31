$ErrorActionPreference = 'Stop'

$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$VocabDir = Join-Path $Root 'collections/語彙'
$GrammarDir = Join-Path $Root 'collections/文法'

New-Item -ItemType Directory -Force -Path $VocabDir | Out-Null
New-Item -ItemType Directory -Force -Path $GrammarDir | Out-Null

function Clean-Text([string]$Text) {
    if ($null -eq $Text) { return '' }

    $Value = $Text -replace '<[^>]+>', ''
    $Value = $Value -replace '\*\*', ''
    $Value = $Value -replace '`', ''
    $Value = $Value -replace '^>\s*', ''
    $Value = $Value -replace '^[-*]\s+', ''
    $Value = $Value -replace '\s+', ' '

    return $Value.Trim()
}

function Table-Cell([string]$Text) {
    $Value = Clean-Text $Text
    $Value = $Value -replace '\|', '／'
    return $Value
}

function Get-RelativePath([string]$Path) {
    return $Path.Substring($Root.Length + 1).Replace('\', '/')
}

function Get-SourceLink([string]$RelativePath) {
    $Label = $RelativePath -replace '\|', '／'
    return "[$Label](../../$RelativePath)"
}

function Get-SourceSection([string]$RelativePath) {
    $Parts = $RelativePath -split '/'

    if ($Parts.Count -ge 2 -and $Parts[0] -eq 'documents') {
        return $Parts[1]
    }

    return 'その他'
}

function Get-CollectionCategory([string]$SourceSection, [string]$Context, [string]$RelativePath) {
    $Text = "$SourceSection $Context $RelativePath"

    if ($SourceSection -in @('ビジネス日本語', 'スキル', '面接・転職', '文法トレーニング')) {
        return 'ビジネス'
    }

    if ($SourceSection -in @('テクニカル', 'クライド技術', 'AI時代', 'エラー・障害対応', '設計ドキュメント')) {
        return 'IT'
    }

    if ($Text -match 'BJT|ビジネス|面接|転職|会議|報告|相談|依頼|交渉|敬語|電話|クレーム|日程調整|進捗|社内|顧客|上司|メール|Slack|Teams|コードレビュー') {
        return 'ビジネス'
    }

    if ($Text -match 'IT|AI|テック|クラウド|Claude|API|RAG|LLM|BMAD|TDD|CI/CD|CI-CD|DB|SQL|セキュリティ|脆弱性|バッチ|オンライン|システム|コード|デプロイ|サーバー|ログ|プロンプト|量子|コンピュータ|半導体|生成AI|モデル|データ|アプリ|ソフトウェア|開発|エンジニア|インフラ') {
        return 'IT'
    }

    return '生活'
}

function Get-CollectionFileName([string]$CategoryName) {
    $SafeName = $CategoryName -replace '[<>:"/\\|?*]', '_'
    return "$SafeName.md"
}

function Write-Utf8NoBom([string]$Path, [string[]]$Lines) {
    $Encoding = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllLines($Path, $Lines, $Encoding)
}

function Get-TitleAndTheme([string[]]$Lines) {
    $Title = ''
    $Theme = ''

    foreach ($Line in $Lines) {
        if (-not $Title -and $Line -match '^#\s+(.+)$') {
            $Title = Clean-Text $Matches[1]
        }

        if ($Line -match '^\*\*テーマ：\*\*\s*(.+)$') {
            $Theme = Clean-Text $Matches[1]
        }
    }

    if ($Theme) { return $Theme }
    if ($Title) { return $Title }

    return '記事内の学習項目'
}

function Get-Example([string]$RawContent, [string]$Term) {
    if ([string]::IsNullOrWhiteSpace($Term)) { return '' }

    $WithoutTables = [regex]::Replace($RawContent, '(?m)^\|.*\r?\n?', '')
    $Parts = [regex]::Split($WithoutTables, '(?<=[。！？])\s*|\r?\n+')

    foreach ($Part in $Parts) {
        if ($Part -match '^\s*#{1,6}\s*') { continue }
        if ($Part -match '^\s*\*\*(テーマ|レベル|分野|参考)：') { continue }
        if ($Part -match '^\s*(テーマ|レベル|分野|参考)：') { continue }

        $Cleaned = Clean-Text $Part
        if ($Cleaned.Length -lt 5) { continue }
        if ($Cleaned -match '^(テーマ|レベル|分野|参考)：') { continue }

        if ($Cleaned.Contains($Term)) {
            if ($Cleaned.Length -gt 140) {
                $Cleaned = $Cleaned.Substring(0, 137) + '...'
            }

            return Table-Cell $Cleaned
        }
    }

    return Table-Cell "この文脈では「$Term」という表現を使います。"
}

function Get-UsageFromBlock([string[]]$BlockLines) {
    foreach ($Line in $BlockLines) {
        if ($Line -match '^\s*>') { continue }
        if ($Line -match '^\s*\|') { continue }
        if ($Line -match '^\s*[-*]\s*例') { continue }

        $Cleaned = Clean-Text $Line
        if (-not $Cleaned) { continue }
        if ($Cleaned -match '^例(文)?[:：]') { continue }
        if ($Cleaned -match '接続[:：]') { continue }

        if ($Cleaned -match '意味[:：]\s*(.+)$') {
            return Table-Cell $Matches[1]
        }

        return Table-Cell $Cleaned
    }

    return '使い方は元記事を参照。'
}

function Get-GrammarExampleFromBlock([string[]]$BlockLines, [string]$Pattern) {
    $QuoteFallback = ''

    foreach ($Line in $BlockLines) {
        if ($Line -match '例文[:：]\s*(.+)$') {
            return Table-Cell $Matches[1]
        }

        if ($Line -match '^例[:：]\s*(.+)$') {
            return Table-Cell $Matches[1]
        }

        if ($Line -match '^\s*[-*]\s*(.+。)\s*$') {
            return Table-Cell $Matches[1]
        }

        if (-not $QuoteFallback -and $Line -match '^\s*>\s*(.+)$') {
            $QuoteFallback = Table-Cell $Matches[1]
        }
    }

    if ($QuoteFallback) { return $QuoteFallback }

    foreach ($Line in $BlockLines) {
        $Cleaned = Clean-Text $Line
        if (-not $Cleaned) { continue }
        if ($Cleaned -match '意味[:：]|接続[:：]') { continue }
        if ($Cleaned -match '。$') { return Table-Cell $Cleaned }
    }

    return Table-Cell "この文脈では「$Pattern」を使います。"
}

function Get-GrammarKey([string]$Pattern) {
    $Key = $Pattern -replace '[～~]', '〜'
    $Key = $Key -replace '（[^）]+）', ''
    $Key = $Key -replace '[、,]', ''
    $Key = $Key -replace '\s+', ''

    return $Key.Trim()
}

$Files = Get-ChildItem -Path (Join-Path $Root 'documents') -Recurse -Filter '*.md' | Sort-Object FullName
$VocabMap = @{}
$GrammarMap = @{}
$ScannedSources = [System.Collections.Generic.List[string]]::new()

foreach ($File in $Files) {
    $RelativePath = Get-RelativePath $File.FullName
    $SourceSection = Get-SourceSection $RelativePath
    $RawContent = Get-Content -Path $File.FullName -Raw -Encoding UTF8
    $Lines = $RawContent -split "`r?`n"
    $Theme = Get-TitleAndTheme $Lines
    $HasLearningSection = $false

    $InVocab = $false
    $VocabContext = $Theme
    $LastNewsHeading = ''

    for ($Index = 0; $Index -lt $Lines.Count; $Index++) {
        $Line = $Lines[$Index]

        if ($Line -match '^##\s+(.+)$' -and $Line -notmatch '語彙|文法|読解|問題|解答|例文|練習|メモ|最近|テーマ一覧|参考') {
            $LastNewsHeading = Clean-Text $Matches[1]
        }

        if ($Line -match '^#{2,3}\s+.*(語彙リスト|新出語彙)') {
            $InVocab = $true
            $HasLearningSection = $true

            if ($RelativePath -like 'documents/ニュース/*' -and $LastNewsHeading) {
                $VocabContext = $LastNewsHeading
            } else {
                $VocabContext = $Theme
            }

            continue
        }

        if ($InVocab -and $Line -match '^#{2,3}\s+' -and $Line -notmatch '語彙リスト|新出語彙') {
            $InVocab = $false
        }

        if ($InVocab -and $Line -match '^\|') {
            $Cells = $Line.Trim().Trim('|').Split('|') | ForEach-Object { Table-Cell $_ }

            if ($Cells.Count -lt 2) { continue }
            if (($Cells -join '') -match '^-+$') { continue }

            $Word = $Cells[0]
            if (-not $Word -or $Word -match '^(単語|語彙|[- :]+)$') { continue }

            $Reading = $Cells[1]
            $Meaning = ''

            if ($Cells.Count -ge 6) {
                $Meaning = (($Cells[2], $Cells[3], $Cells[4], $Cells[5]) -join ' / ')
            } elseif ($Cells.Count -ge 5) {
                $Meaning = (($Cells[2], $Cells[3], $Cells[4]) -join ' / ')
            } elseif ($Cells.Count -ge 4) {
                $Meaning = (($Cells[2], $Cells[3]) -join ' / ')
            } elseif ($Cells.Count -ge 3) {
                $Meaning = $Cells[2]
            }

            $Category = Get-CollectionCategory $SourceSection $VocabContext $RelativePath
            $Key = "$Category|$Word|$Reading"

            if (-not $VocabMap.ContainsKey($Key)) {
                $VocabMap[$Key] = [ordered]@{
                    Category = $Category
                    Word = $Word
                    Reading = $Reading
                    Meaning = Table-Cell $Meaning
                    Context = Table-Cell $VocabContext
                    Example = Get-Example $RawContent $Word
                    Sources = [System.Collections.Generic.List[string]]::new()
                }
            }

            if (-not $VocabMap[$Key].Sources.Contains($RelativePath)) {
                $VocabMap[$Key].Sources.Add($RelativePath)
            }
        }
    }

    $InGrammar = $false

    for ($Index = 0; $Index -lt $Lines.Count; $Index++) {
        $Line = $Lines[$Index]
        $IsGrammarSection = $Line -match '^##\s+.*(文法|表現ポイント|新出文法|よく使うビジネス文法)'

        if ($IsGrammarSection) {
            $InGrammar = $true
            $HasLearningSection = $true
            continue
        }

        if ($InGrammar -and $Line -match '^##\s+' -and -not $IsGrammarSection) {
            $InGrammar = $false
        }

        if ($InGrammar -and $Line -match '^###\s+(.+)$') {
            $Pattern = Table-Cell ($Matches[1] -replace '^\d+\.\s*', '')
            if (-not $Pattern) { continue }

            $Block = [System.Collections.Generic.List[string]]::new()

            for ($NextIndex = $Index + 1; $NextIndex -lt $Lines.Count; $NextIndex++) {
                if ($Lines[$NextIndex] -match '^#{2,3}\s+') { break }
                $Block.Add($Lines[$NextIndex])
            }

            $Usage = Get-UsageFromBlock $Block.ToArray()
            $Example = Get-GrammarExampleFromBlock $Block.ToArray() $Pattern
            $Category = Get-CollectionCategory $SourceSection $Theme $RelativePath
            $NormalizedKey = "$Category|$(Get-GrammarKey $Pattern)"

            if (-not $GrammarMap.ContainsKey($NormalizedKey)) {
                $GrammarMap[$NormalizedKey] = [ordered]@{
                    Category = $Category
                    Pattern = $Pattern
                    Usage = $Usage
                    Context = Table-Cell $Theme
                    Example = $Example
                    Sources = [System.Collections.Generic.List[string]]::new()
                }
            }

            if (-not $GrammarMap[$NormalizedKey].Sources.Contains($RelativePath)) {
                $GrammarMap[$NormalizedKey].Sources.Add($RelativePath)
            }
        }
    }

    if ($HasLearningSection -and -not $ScannedSources.Contains($RelativePath)) {
        $ScannedSources.Add($RelativePath)
    }
}

function Add-GrammarCard([string]$Pattern, [string]$Usage, [string]$Context, [string]$Example, [string]$Source) {
    $SourceSection = Get-SourceSection $Source
    $Category = Get-CollectionCategory $SourceSection $Context $Source
    $NormalizedKey = "$Category|$(Get-GrammarKey $Pattern)"

    if (-not $GrammarMap.ContainsKey($NormalizedKey)) {
        $GrammarMap[$NormalizedKey] = [ordered]@{
            Category = $Category
            Pattern = Table-Cell $Pattern
            Usage = Table-Cell $Usage
            Context = Table-Cell $Context
            Example = Table-Cell $Example
            Sources = [System.Collections.Generic.List[string]]::new()
        }
    }

    if (-not $GrammarMap[$NormalizedKey].Sources.Contains($Source)) {
        $GrammarMap[$NormalizedKey].Sources.Add($Source)
    }

    if (-not $ScannedSources.Contains($Source)) {
        $ScannedSources.Add($Source)
    }
}

Add-GrammarCard '動詞グループ' '1・2・3グループを見分けて、活用形を選ぶ。' '動詞活用トレーニング' '確認するは3グループなので、確認します・確認しない・確認してになる。' 'documents/文法トレーニング/01_動詞活用トレーニング.md'
Add-GrammarCard 'ます形・ない形・て形・た形' '基本活用を安定させて、依頼・禁止・報告文を作る。' '動詞活用トレーニング' '設定を確認して、結果を共有します。' 'documents/文法トレーニング/01_動詞活用トレーニング.md'
Add-GrammarCard '可能形' '「できる／できない」を表す。権限や機能の説明でよく使う。' '動詞活用トレーニング' 'この権限ではファイルを削除できません。' 'documents/文法トレーニング/01_動詞活用トレーニング.md'
Add-GrammarCard '自動詞・他動詞' '自然に起きた状態変化か、誰かが行った操作かを分ける。' '自動詞・他動詞トレーニング' 'エラーが出ました。ログを出してください。' 'documents/文法トレーニング/02_自動詞・他動詞トレーニング.md'
Add-GrammarCard '自動詞＋が' '状況説明や原因が未確定の報告で使う。' '自動詞・他動詞トレーニング' '仕様が変わりました。' 'documents/文法トレーニング/02_自動詞・他動詞トレーニング.md'
Add-GrammarCard '他動詞＋を' '作業者や操作内容を明確にしたいときに使う。' '自動詞・他動詞トレーニング' '仕様を変えました。' 'documents/文法トレーニング/02_自動詞・他動詞トレーニング.md'
Add-GrammarCard '受身' '誰かにされたこと、または機能が使われている状態を表す。' '受身・使役・使役受身' 'レビューで変数名を指摘されました。' 'documents/文法トレーニング/03_受身・使役・使役受身.md'
Add-GrammarCard '使役' '誰かに行動させる、または機会を与える表現。' '受身・使役・使役受身' 'リーダーは新人に手順書を読ませました。' 'documents/文法トレーニング/03_受身・使役・使役受身.md'
Add-GrammarCard '使役受身' '自分の意志ではない行動をさせられた負担感を表す。' '受身・使役・使役受身' '深夜にログを確認させられました。' 'documents/文法トレーニング/03_受身・使役・使役受身.md'
Add-GrammarCard '普通文法からビジネス文法へ' '普通文に配慮・責任範囲・依頼のやわらかさを足す。' '普通文法とビジネス文法' 'ログをご確認いただけますでしょうか。' 'documents/文法トレーニング/04_普通文法とビジネス文法.md'

$GeneratedDate = '2026-05-31'

$OldSingleFiles = @(
    (Join-Path $VocabDir 'all-flashcards.md'),
    (Join-Path $GrammarDir 'all-grammar.md')
)

foreach ($OldFile in $OldSingleFiles) {
    if (Test-Path -LiteralPath $OldFile) {
        Remove-Item -LiteralPath $OldFile -Force
    }
}

$CategoryOrder = @('IT', 'ビジネス', '生活')
$VocabGroups = @(
    foreach ($Category in $CategoryOrder) {
        $Cards = @($VocabMap.Values | Where-Object { $_.Category -eq $Category })
        [PSCustomObject]@{
            Name = $Category
            Count = $Cards.Count
            Group = $Cards
        }
    }
)
$GrammarGroups = @(
    foreach ($Category in $CategoryOrder) {
        $Cards = @($GrammarMap.Values | Where-Object { $_.Category -eq $Category })
        [PSCustomObject]@{
            Name = $Category
            Count = $Cards.Count
            Group = $Cards
        }
    }
)

$ExpectedVocabFiles = @($VocabGroups | ForEach-Object { Get-CollectionFileName $_.Name }) + @('README.md')
$ExpectedGrammarFiles = @($GrammarGroups | ForEach-Object { Get-CollectionFileName $_.Name }) + @('README.md')

foreach ($StaleFile in (Get-ChildItem -Path $VocabDir -Filter '*.md' -File | Where-Object { $ExpectedVocabFiles -notcontains $_.Name })) {
    try {
        Remove-Item -LiteralPath $StaleFile.FullName -Force
    } catch {
        Write-Warning "stale vocab file could not be removed: $($StaleFile.Name)"
    }
}

foreach ($StaleFile in (Get-ChildItem -Path $GrammarDir -Filter '*.md' -File | Where-Object { $ExpectedGrammarFiles -notcontains $_.Name })) {
    try {
        Remove-Item -LiteralPath $StaleFile.FullName -Force
    } catch {
        Write-Warning "stale grammar file could not be removed: $($StaleFile.Name)"
    }
}

$VocabIndexRows = [System.Collections.Generic.List[string]]::new()
$VocabIndexRows.Add('| ファイル | カード数 | 主な文脈 |')
$VocabIndexRows.Add('|----------|----------|----------|')

foreach ($Group in $VocabGroups) {
    $FileName = Get-CollectionFileName $Group.Name
    $Rows = [System.Collections.Generic.List[string]]::new()
    $Rows.Add("# 語彙: $($Group.Name)")
    $Rows.Add('')
    $Rows.Add("生成日: $GeneratedDate")
    $Rows.Add('')
    $Rows.Add('このファイルは、同じ学習カテゴリの語彙カードを集めたものです。')
    $Rows.Add('')

    if ($Group.Count -eq 0) {
        $Rows.Add('現在、このカテゴリのカードはまだありません。')
        $Rows.Add('')
    }

    $Rows.Add('| 単語 | 読み | 意味メモ | 使う文脈 | 例文 | 元記事 |')
    $Rows.Add('|------|------|----------|----------|------|--------|')

    foreach ($Card in ($Group.Group | Sort-Object Context, Word, Reading)) {
        $SourceCell = ($Card.Sources | ForEach-Object { Get-SourceLink $_ }) -join '<br>'
        $Rows.Add("| $($Card.Word) | $($Card.Reading) | $($Card.Meaning) | $($Card.Context) | $($Card.Example) | $SourceCell |")
    }

    Write-Utf8NoBom -Path (Join-Path $VocabDir $FileName) -Lines $Rows.ToArray()

    $Contexts = @($Group.Group | ForEach-Object { $_.Context } | Sort-Object -Unique | Select-Object -First 3)
    $ContextSummary = ($Contexts -join ' / ')
    if (-not $ContextSummary) { $ContextSummary = '未登録' }
    $VocabIndexRows.Add("| [$($Group.Name)](./$FileName) | $($Group.Count) | $ContextSummary |")
}

$GrammarIndexRows = [System.Collections.Generic.List[string]]::new()
$GrammarIndexRows.Add('| ファイル | カード数 | 主な文脈 |')
$GrammarIndexRows.Add('|----------|----------|----------|')

foreach ($Group in $GrammarGroups) {
    $FileName = Get-CollectionFileName $Group.Name
    $Rows = [System.Collections.Generic.List[string]]::new()
    $Rows.Add("# 文法・表現: $($Group.Name)")
    $Rows.Add('')
    $Rows.Add("生成日: $GeneratedDate")
    $Rows.Add('')
    $Rows.Add('このファイルは、同じ学習カテゴリの文法・表現カードを集めたものです。')
    $Rows.Add('')

    if ($Group.Count -eq 0) {
        $Rows.Add('現在、このカテゴリのカードはまだありません。')
        $Rows.Add('')
    }

    $Rows.Add('| 文法・表現 | 意味・使い方 | 使う文脈 | 例文 | 元記事 |')
    $Rows.Add('|------------|--------------|----------|------|--------|')

    foreach ($Card in ($Group.Group | Sort-Object Context, Pattern)) {
        $SourceCell = ($Card.Sources | ForEach-Object { Get-SourceLink $_ }) -join '<br>'
        $Rows.Add("| $($Card.Pattern) | $($Card.Usage) | $($Card.Context) | $($Card.Example) | $SourceCell |")
    }

    Write-Utf8NoBom -Path (Join-Path $GrammarDir $FileName) -Lines $Rows.ToArray()

    $Contexts = @($Group.Group | ForEach-Object { $_.Context } | Sort-Object -Unique | Select-Object -First 3)
    $ContextSummary = ($Contexts -join ' / ')
    if (-not $ContextSummary) { $ContextSummary = '未登録' }
    $GrammarIndexRows.Add("| [$($Group.Name)](./$FileName) | $($Group.Count) | $ContextSummary |")
}

$CollectionReadme = [System.Collections.Generic.List[string]]::new()
$CollectionReadme.Add('# 学習コレクション')
$CollectionReadme.Add('')
$CollectionReadme.Add('`documents/` の外に置く、全記事横断の復習用フォルダです。語彙と文法を `IT`、`ビジネス`、`生活` の3カテゴリに分けて、1回の復習量を小さくしています。')
$CollectionReadme.Add('')
$CollectionReadme.Add('## フォルダ')
$CollectionReadme.Add('')
$CollectionReadme.Add('| フォルダ | 目的 |')
$CollectionReadme.Add('|----------|------|')
$CollectionReadme.Add('| [語彙](./語彙/) | 単語・読み・意味メモ・使う文脈・例文をカテゴリ別にカード化する |')
$CollectionReadme.Add('| [文法](./文法/) | 文法/表現・使い方・使う文脈・例文をカテゴリ別にカード化する |')
$CollectionReadme.Add('')
$CollectionReadme.Add('## カテゴリ')
$CollectionReadme.Add('')
$CollectionReadme.Add('| カテゴリ | 目安 |')
$CollectionReadme.Add('|----------|------|')
$CollectionReadme.Add('| IT | 技術、AI、クラウド、セキュリティ、設計、障害対応、開発ニュース |')
$CollectionReadme.Add('| ビジネス | メール、会議、報告、相談、交渉、敬語、面接、BJT |')
$CollectionReadme.Add('| 生活 | 生活、社会、健康、科学ニュースなど、仕事以外でも使う表現 |')
$CollectionReadme.Add('')
$CollectionReadme.Add('## 更新ルール')
$CollectionReadme.Add('')
$CollectionReadme.Add('新しい記事を `documents/` に追加したら、次も同じタイミングで更新する。')
$CollectionReadme.Add('')
$CollectionReadme.Add('1. 記事に `語彙リスト` と `文法・表現ポイント` を入れる。')
$CollectionReadme.Add('2. `powershell -ExecutionPolicy Bypass -File collections/generate-collections.ps1` を実行する。')
$CollectionReadme.Add('3. [語彙](./語彙/) と [文法](./文法/) のカテゴリ別ファイルを見て、例文が自然か確認する。')
$CollectionReadme.Add('')
$CollectionReadme.Add('## 今回の取り込み範囲')
$CollectionReadme.Add('')
$CollectionReadme.Add(("- 語彙カード: {0}件 / {1}カテゴリ" -f $VocabMap.Count, $VocabGroups.Count))
$CollectionReadme.Add(("- 文法・表現カード: {0}件 / {1}カテゴリ" -f $GrammarMap.Count, $GrammarGroups.Count))
$CollectionReadme.Add(("- 参照した学習ソース: {0}ファイル" -f $ScannedSources.Count))

Write-Utf8NoBom -Path (Join-Path $Root 'collections/README.md') -Lines $CollectionReadme.ToArray()

$VocabReadme = [System.Collections.Generic.List[string]]::new()
$VocabReadme.Add('# 語彙')
$VocabReadme.Add('')
$VocabReadme.Add('全記事の語彙を、`IT`、`ビジネス`、`生活` のカテゴリ別フラッシュカードに分けてまとめるフォルダです。')
$VocabReadme.Add('')
$VocabReadme.Add('## カテゴリ別ファイル')
$VocabReadme.Add('')
foreach ($Line in $VocabIndexRows) { $VocabReadme.Add($Line) }
$VocabReadme.Add('')
$VocabReadme.Add('## 追加するときの形')
$VocabReadme.Add('')
$VocabReadme.Add('| 単語 | 読み | 意味メモ | 使う文脈 | 例文 | 元記事 |')
$VocabReadme.Add('|------|------|----------|----------|------|--------|')
$VocabReadme.Add('| 影響範囲 | えいきょうはんい | scope of impact / phạm vi ảnh hưởng | 障害対応・仕様変更・顧客報告 | 影響範囲を確認してから、対応方針を決めます。 | 記事リンク |')
$VocabReadme.Add('')
$VocabReadme.Add('## 更新方法')
$VocabReadme.Add('')
$VocabReadme.Add('新しい記事を追加したら、リポジトリの root で次を実行します。')
$VocabReadme.Add('')
$VocabReadme.Add('```powershell')
$VocabReadme.Add('powershell -ExecutionPolicy Bypass -File collections/generate-collections.ps1')
$VocabReadme.Add('```')

Write-Utf8NoBom -Path (Join-Path $VocabDir 'README.md') -Lines $VocabReadme.ToArray()

$GrammarReadme = [System.Collections.Generic.List[string]]::new()
$GrammarReadme.Add('# 文法')
$GrammarReadme.Add('')
$GrammarReadme.Add('全記事の文法・表現ポイントを、`IT`、`ビジネス`、`生活` のカテゴリ別カードに分けてまとめるフォルダです。')
$GrammarReadme.Add('')
$GrammarReadme.Add('## カテゴリ別ファイル')
$GrammarReadme.Add('')
foreach ($Line in $GrammarIndexRows) { $GrammarReadme.Add($Line) }
$GrammarReadme.Add('')
$GrammarReadme.Add('## 追加するときの形')
$GrammarReadme.Add('')
$GrammarReadme.Add('| 文法・表現 | 意味・使い方 | 使う文脈 | 例文 | 元記事 |')
$GrammarReadme.Add('|------------|--------------|----------|------|--------|')
$GrammarReadme.Add('| 〜に基づいて | 根拠・基準を表す。 | 要件定義・設計・ルール説明 | 要件定義書に基づいて、詳細設計を作成します。 | 記事リンク |')
$GrammarReadme.Add('')
$GrammarReadme.Add('## 更新方法')
$GrammarReadme.Add('')
$GrammarReadme.Add('新しい記事を追加したら、リポジトリの root で次を実行します。')
$GrammarReadme.Add('')
$GrammarReadme.Add('```powershell')
$GrammarReadme.Add('powershell -ExecutionPolicy Bypass -File collections/generate-collections.ps1')
$GrammarReadme.Add('```')

Write-Utf8NoBom -Path (Join-Path $GrammarDir 'README.md') -Lines $GrammarReadme.ToArray()

Write-Output "vocab_cards=$($VocabMap.Count)"
Write-Output "vocab_categories=$($VocabGroups.Count)"
Write-Output "grammar_cards=$($GrammarMap.Count)"
Write-Output "grammar_categories=$($GrammarGroups.Count)"
Write-Output "sources=$($ScannedSources.Count)"
