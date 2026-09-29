# 旅のしおり

旅行を計画するたびに、旅のしおりを積み重ねていくサイトです。

- 公開URL: https://sakanayuki.github.io/cc_travelplan/
- 検索エンジンには載せない設定（noindex）です。URLを知っている人だけが見る想定です。

## 旅の一覧

| 日程 | 旅 |
| --- | --- |
| 2026.9.30 – 10.1 | [淡路島 家族旅行](trips/2026-09-30-awaji/) |

## 仕組み

- 旅ごとに `trips/YYYY-MM-DD-場所/` に完成済みのHTMLを置くだけで、ビルド工程はありません。
- `main` に push されると、GitHub Actions（`.github/workflows/pages.yml`）が `scripts/check.sh` で検査したうえで Pages にデプロイします。
- PR では検査だけが走ります。
- 追加手順と守るルールは [CLAUDE.md](CLAUDE.md) にあります。Claude Code にしおりを渡して「追加して」と頼めば、そのルールで追加されます。

## 初回だけ必要な設定

リポジトリの **Settings → Pages → Build and deployment → Source** を **GitHub Actions** にしてください。
設定後、Actions タブから「Deploy to GitHub Pages」を再実行（または `main` に push）すると公開されます。

## ローカルで確認する

```sh
python3 -m http.server 8000   # http://localhost:8000/
./scripts/check.sh            # 公開前の検査
```
