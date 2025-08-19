#!/bin/bash
if [ -z "$1" ]; then echo "Использование: $0 <файл-для-проверки>"; exit 1; fi

PASSIVE_VOICE_PATTERNS=("будет создан" "должен быть")
ERRORS=0

for pattern in "${PASSIVE_VOICE_PATTERNS[@]}"; do
    if grep -q "$pattern" "$1"; then
        echo "❌ Обнаружен пассивный залог: '$pattern' в файле $1"
        ERRORS=$((ERRORS + 1))
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "✅ Проверка на пассивный залог пройдена."
else
    exit 1
fi
