#!/bin/bash
# Скрипт для проверки README.md на соответствие стандартам

README_FILE="README.md"
ERRORS=0

# Цвета для вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function check_section {
    if grep -q "$1" "$README_FILE"; then
        echo -e "✅ ${GREEN}Секция '$2' найдена.${NC}"
    else
        echo -e "❌ ${RED}Секция '$2' не найдена (ожидался паттерн '$1').${NC}"
        ERRORS=$((ERRORS + 1))
    fi
}

echo "--- Проверка $README_FILE ---"
check_section "## Основные принципы" "Основные принципы"
check_section "## Как начать" "Как начать"
check_section "## Структура проекта" "Структура проекта"
check_section "## Ключевая документация" "Ключевая документация"

if [ $ERRORS -eq 0 ]; then
    echo -e "\n${GREEN}🎉 README.md полностью соответствует требованиям!${NC}"
    exit 0
else
    echo -e "\n${RED}Найдены ошибки: $ERRORS. Исправьте их перед коммитом.${NC}"
    exit 1
fi
