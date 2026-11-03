#!/bin/zsh
# usage: shot.sh <url> <out.png> [w] [h] [virtual_time_ms]
URL="$1"; OUT="$2"; W="${3:-1600}"; H="${4:-1000}"; VT="${5:-3000}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
FLAGS="--headless=new --no-sandbox --disable-gpu --use-gl=swiftshader --enable-unsafe-swiftshader --hide-scrollbars"
"$CHROME" $FLAGS --window-size="$W,$H" --virtual-time-budget="$VT" --screenshot="$OUT" "$URL" >/dev/null 2>&1
if [ -f "$OUT" ]; then echo "OK $OUT ($(stat -f%z "$OUT") bytes)"; else echo "FAIL $OUT"; fi
DUMP="${OUT%.png}.dom.html"
"$CHROME" $FLAGS --virtual-time-budget=1200 --dump-dom "$URL" > "$DUMP" 2>/dev/null
E=$(grep -o 'id="errlog"[^>]*>[^<]*' "$DUMP" | sed 's/.*>//' | head -3)
if [ -n "$E" ]; then echo "PAGE-ERR: $E"; else echo "no page errors"; fi
