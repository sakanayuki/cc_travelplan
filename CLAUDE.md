# 旅のしおり リポジトリ

旅行を計画するたびに、完成した「旅のしおり」（静的HTML）を1つずつ積み重ねていくリポジトリ。
GitHub Actions 経由で GitHub Pages に公開する。公開URL: https://sakanayuki.github.io/cc_travelplan/

## 構成

```
index.html                     旅の一覧（手書き。カードを新しい順に並べる）
trips/YYYY-MM-DD-場所/          旅ごとのフォルダ（出発日＋英小文字の場所名、ハイフン区切り）
  index.html                   しおり本体（CSSはインライン、ビルドなし）
  hero.webp                    ヒーロー画像（横1536px程度, WebP）
  thumb.webp                   一覧用サムネ（600x400, WebP）
  og.jpg                       OGP画像（1200x630, JPEG。LINE等のプレビュー互換のため）
scripts/check.sh               公開前の軽量ルール検査（CIでも実行）
.github/workflows/pages.yml    検査 → _site 組み立て → Pages デプロイ
```

- ビルド工程は持たない。静的ファイルをそのまま公開する。
- 公開されるのは `index.html` と `trips/` のみ（ワークフローが `_site/` に組み立てる）。

## 新しい旅を追加する手順

ユーザーから完成済みのしおり（zip等）を受け取ったら:

1. `trips/YYYY-MM-DD-場所/` を作り、HTMLを `index.html` として置く。
2. 画像を変換する。元のPNG等はリポジトリに入れない。
   - `hero.webp`（quality 80前後, 数百KB）/ `thumb.webp`（600x400）/ `og.jpg`（1200x630）
   - HTML内の画像参照を `hero.webp` に差し替える。
3. 個人情報をぼかす（下記ルール）。
4. しおり本体に標準機能を入れる:
   - `<meta name="robots" content="noindex,nofollow">`
   - OGP（og:title / og:description / og:url / og:image は `og.jpg` の絶対URL）
   - フッターに `<a href="../../">← 旅のしおり一覧</a>`
   - チェックリストがあれば localStorage 保存（キー `shiori:<フォルダ名>:checks`。既存の旅の `<script>` を参考に）
5. ルートの `index.html` の目印コメント直下（先頭）にカードを1枚追加する。
6. `./scripts/check.sh` が通ることを確認する。
7. 作業ブランチにコミット・push し、main へのPRを作る。マージされると自動デプロイされる。

## 守るルール

- **個人情報のぼかし**（リポジトリもサイトも public）
  - 出発地・自宅の地名 → 「自宅」などに置き換える（例: 「○○市を出発」→「自宅を出発」）。
  - 子どもの月齢・年齢 → 「赤ちゃん」「上の子」などに置き換える。
  - 宿名・旅行日付は残してよい（しおりとしての実用性を優先）。
  - 家族の実写写真は載せない。
- **noindex**: 公開するすべてのHTMLに入れる。robots.txt は置かない（プロジェクトサイトでは効かず、クロール拒否すると noindex も読まれない）。
- **画像**: trips/ 配下に 1MB を超える画像を置かない。
- **旅のあと**: 計画の内容は書き換えずに残す。希望があれば末尾に「ふりかえり」セクションを追記する。
- しおりのデザインは旅ごとに自由。共通化のための書き換えはしない。
