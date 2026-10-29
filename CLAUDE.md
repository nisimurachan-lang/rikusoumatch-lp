# CLAUDE.md — rikusoumatch-lp

「陸送マッチ」の静的ランディングページ（HTML/CSS、CoreServerへ手動アップロード）。

## 基本方針（Adness AI Integration & Business Automation）

- **Giant Killing**: 少人数／ソロで100人規模のアウトプットを出す。AIワークフローと自動化を前提に考える。
- **内製化・マニュアル化**: ノウハウは構造化したマニュアル（`docs/`）と自動化テンプレートに残す。
- **スピードと実行**: ワンクリック実行・摩擦の排除を優先。3回繰り返した作業は自動化候補。
- 自動化・仕組み化・マニュアル化の依頼では `.claude/skills/adness-ai-automation` スキルの手順とテンプレートに従う。
- 外部送信・公開・削除・本番反映など取り消しにくい操作は、必ずユーザーの承認を得てから行う。

## このリポジトリのルール

- 本番ページは `index.html` / `thanks.html`。`index_*.html`・`*.backup-*`・`production_current.html` はバックアップ／比較用なので、指示がない限り編集しない。
- 公開前チェックは `README_公開前に必ず確認.txt` に従う（GTM ID、canonical/og:url、OGP画像、Jotformのリダイレクト先、コンバージョン計測）。
- `thanks.html` は Google広告のコンバージョン計測ページ。計測タグを壊さない。
- 変更後はブラウザ（Playwright可）でPC幅・スマホ幅の表示を確認する。
- サーバーへのアップロード・公開はユーザーが行う。代行する場合は必ず事前に確認する。
