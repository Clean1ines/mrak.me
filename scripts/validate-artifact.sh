#!/bin/bash
if [ -z "$1" ]; then echo "Использование: $0 <путь-к-артефакту>"; exit 1; fi

CONTENT=$(cat "$1")
if [[ "$CONTENT" =~ ---META:.*--- ]]; then
    echo "✅ META-заголовок найден в $1"
    # Проверка обязательных полей
    if [[ "$CONTENT" =~ project= && "$CONTENT" =~ type= && "$CONTENT" =~ name= ]]; then
        echo "✅ Обязательные поля project, type, name на месте."
    else
        echo "❌ Отсутствуют обязательные поля в META."
        exit 1
    fi
else
    echo "❌ META-заголовок не найден в $1"
    exit 1
fi
