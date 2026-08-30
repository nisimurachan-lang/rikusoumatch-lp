公開前チェック
1. index.html 内の GTM-XXXXXXX を実際のGTM IDに差し替え
2. canonical / og:url / robots.txt / sitemap.xml の https://www.rikusoumatch.com/ を本番URLに合わせる
3. OGP画像 ogp.jpg をサーバー直下に置く（未作成なら後で作成）
4. Jotformの送信完了後リダイレクトURLを https://本番URL/thanks.html に設定
5. Google広告のコンバージョンは thanks.html 到達で計測
6. CoreServerに index.html, thanks.html, favicon.svg, robots.txt, sitemap.xml, .htaccess をアップロード
