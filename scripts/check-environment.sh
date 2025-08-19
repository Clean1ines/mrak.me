#!/bin/bash
# Скрипт для автоматической проверки окружения разработки

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "--- Проверка окружения ---"

# Проверка Python
if command -v python3.11 &> /dev/null && python3.11 --version | grep -q "3.11"; then
    echo -e "✅ ${GREEN}Python 3.11 найден.${NC}"
else
    echo -e "❌ ${RED}Python 3.11 не найден. Выполните: sudo apt install python3.11${NC}"
fi

# Проверка Git
if command -v git &> /dev/null; then
    echo -e "✅ ${GREEN}Git найден.${NC}"
else
    echo -e "❌ ${RED}Git не найден. Выполните: sudo apt install git${NC}"
fi
