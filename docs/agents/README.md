# 業務OSエージェント（builder / reviewer）運用マニュアル

- 目的: ピーラボ株式会社（特殊車両・緊急陸送）の業務書類・Skill・HTMLを「作る役」と「チェックする役」に分け、会社情報の誤記や誇大表現を含む書類が外に出ないようにする
- 頻度 / 所要時間: 書類1件ごと / 依頼文を書く2〜3分 ＋ 自動ループ（目安5〜15分）＋ 人の最終確認
- 担当: 作成＝builder（AI）、採点＝reviewer（AI）、送信・提出の判断＝人

## 構成

| エージェント | ファイル | tools | model | 役割 |
|---|---|---|---|---|
| builder | `.claude/agents/builder.md` | Read, Write, Edit, Glob | sonnet | 作る・直す。採点しない。Bash なし（削除・push・送信ができない） |
| reviewer | `.claude/agents/reviewer.md` | Read, Grep, Glob | opus | 採点と修正指示だけを返す。ファイルは直せない |

- researcher（Web調査）は未作成。調査が必要な業務が出てきたら `tools: WebSearch, WebFetch, Read` で追加する。
- 会社情報の唯一の参照元: `assets/company-profile.md`（HARD GATE）
- 採点基準: `docs/agents/reviewer-rubric.md`（80点以上かつ即不合格条件なしで PASS、差し戻しは最大3回）

## ワンクリック実行

このリポジトリで Claude Code を起動し、次のように頼む（ループはメインセッションが CLAUDE.md に従って回す）。

```
builder→reviewer のループで提案書を作って。
宛先: ○○株式会社 ○○部 御中 / 目的: … / 必須項目: … / 出力先: drafts/proposal/YYYYMMDD-xxx.html
```

単体で呼ぶとき: `@builder …` / `@reviewer drafts/proposal/xxx.html を採点して（依頼文: …）`

## 入力

- 依頼文（宛先・目的・必須項目・期限・出力先）
- `assets/company-profile.md`（事前に人が記入しておく）

## 出力

- `drafts/<種別>/<YYYYMMDD>-<名前>.html`（Git管理外）
- 最終の採点結果（PASS/REJECT と点数）と「人に確認が必要な事項」

## 手順（自動化されていない部分）

1. 初めて使う前に `assets/company-profile.md` の「未記入」を埋める（**未記入のままだと書類に【要確認】が残る**）
2. PASS の書類を人が読み、【要確認】が残っていないかを確認する
3. 送信・提出・印刷は人が行う（エージェントは下書きまで）

## トラブルシュート

| 症状 | 原因 | 対処 |
|---|---|---|
| `Agent type 'builder' not found` | `.claude/agents/` がないディレクトリで起動したセッション | リポジトリ直下で Claude Code を起動し直す（定義はセッション開始時に読み込まれる） |
| 書類に【要確認】が多い | company-profile.md が未記入 | company-profile.md を埋めてから再実行 |
| 何度やっても REJECT | 依頼が company-profile.md と矛盾（例: 根拠のない「No.1」を書けという要望） | 要望を取り下げるか、根拠資料を company-profile.md に追記する |
| 採点基準を変えたい | — | `docs/agents/reviewer-rubric.md` だけを編集し、改善履歴に残す |

## 改善履歴

- 2026-11-04: 初版（builder / reviewer の2体構成、動作テスト1件実施。結果は `docs/agents/test-run/`）
