---
name: codex-login
description: クラウドの Claude Code セッションで Codex CLI に ChatGPT ログインし、codex プラグイン（/codex:review 等）と codex-image プラグイン（/codex-image:generate 等）を使える状態にする。ChatGPT ログインはコンテナ内にしか保存されないため、新しいセッションごとに必要。「Codexログイン」「codex:setup」「codex-image 使いたい」「画像生成したい」「Not logged in」などで使う。
---

# Codex ログイン（ChatGPT・セッションごと）

## 前提（なぜ毎回必要か）

- クラウドセッションのコンテナは一時的。`codex login` の認証情報（`~/.codex/`）はコンテナ内にしか残らず、**新しいセッションでは消える**。
- そのため ChatGPT ログインは **セッション開始ごとにデバイスコード入力が1回必要**。
- 次のものは自動化済みで、毎回やらなくてよい:
  - プラグイン有効化: 各リポジトリの `.claude/settings.json`（`codex@openai-codex` / `codex-image@codex-image-in-cc`）
  - Codex CLI のインストール: 環境「デフォルト」のセットアップスクリプト（`npm install -g @openai/codex`）
  - 通信許可: 環境の許可ホスト `auth.openai.com` / `chatgpt.com` / `api.openai.com`

## 手順（ワンクリック）

1. ログインスクリプトを実行する（冪等。ログイン済みなら何もしない）:
   ```bash
   bash .claude/skills/codex-login/scripts/codex-login.sh
   ```
2. 表示された URL（`https://auth.openai.com/codex/device`）とワンタイムコード（例 `XXXX-XXXXX`、15分有効）を**そのままユーザーに伝え**、ブラウザでサインイン→コード入力してもらう。コードは本人以外に渡さない。
3. ユーザーが「ログインした」と言ったら確認する:
   ```bash
   codex login status   # "Logged in using ChatGPT" ならOK
   ```
4. 動作確認: `/codex:setup`（`ready: true`）または `/codex-image:status`。

## つまずいたとき

| 症状 | 原因 | 対処 |
|---|---|---|
| `error sending request for url (https://auth.openai.com/...)` / `CONNECT tunnel failed, response 403` | 環境の許可ホスト不足 | `get_environment` → `update_environment` で上記3ホストを追加（ユーザー承認が出る） |
| `codex: command not found` | セットアップスクリプト未実行（再開セッション等） | スクリプトが自動で `npm install -g @openai/codex` する |
| コード期限切れ | 15分経過 | スクリプトを再実行（古いログイン待ちは自動で止める） |
| プラグインのコマンドが出ない | プラグイン未インストール | `claude plugin install codex@openai-codex` / `claude plugin install codex-image@codex-image-in-cc` |

## 改善メモ（自動化へのフィードバック）

- 毎回のコード入力が負担になったら（3回目が目安）、**API キー方式**に切り替える。`request_credential`（host: `api.openai.com`）で環境に保存すれば、セッションをまたいでもログイン不要になる（ChatGPT サブスク枠ではなく API 従量課金になる点に注意）。
- 手順を変えたらこのファイルを更新し、変更点を運用ログに残す。
