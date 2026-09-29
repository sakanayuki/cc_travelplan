#!/usr/bin/env bash
# 公開前の軽量ルール検査。違反があれば非0で終了し、デプロイを止める。
set -uo pipefail
cd "$(dirname "$0")/.."
fail=0
err() { echo "::error::$*"; fail=1; }

# 1. 公開するすべてのHTMLに noindex が入っていること
while IFS= read -r f; do
  grep -qiE '<meta name="robots" content="[^"]*noindex' "$f" || err "noindex がありません: $f"
done < <(find index.html trips -name '*.html')

# 2. trips/ 配下に 1MB を超える画像を置かないこと（WebP化・サムネ化を忘れていないか）
while IFS= read -r f; do
  err "1MB を超える画像です（WebPに変換してください）: $f"
done < <(find trips -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' -o -iname '*.gif' \) -size +1024k)

# 3. トップページからのリンク・画像が存在すること
while IFS= read -r ref; do
  path="${ref%/}"; [ -d "$path" ] && path="$path/index.html"
  [ -e "$path" ] || err "トップページの参照先がありません: $ref"
done < <(grep -oE '(href|src)="trips/[^"]*"' index.html | sed -E 's/^(href|src)="//; s/"$//')

# 4. すべての旅フォルダがトップページに載っていること
for d in trips/*/; do
  grep -q "href=\"$d\"" index.html || err "トップページにカードがありません: $d"
done

[ "$fail" -eq 0 ] && echo "OK: all checks passed"
exit "$fail"
