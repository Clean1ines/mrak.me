#!/bin/bash
# <!-- WSL: Полная поддержка Windows Terminal -->
# Скрипт для запуска тестов парсера

# Цвета для Windows Terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Запуск тестов парсера...${NC}"

# Создаем виртуальное окружение, если не существует
if [ ! -d ".venv" ]; then
    echo -e "${YELLOW}Создание виртуального окружения...${NC}"
    python3 -m venv .venv
fi

# Активируем виртуальное окружение
source .venv/bin/activate

# Установка зависимостей
if ! pip show pytest > /dev/null 2>&1; then
    echo -e "${YELLOW}Установка зависимостей...${NC}"
    pip install --upgrade pip
    pip install jsonschema pytest
fi

# Запуск тестов
pytest tests/parser_test.py --verbose

# Проверка результата
if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✅ Все тесты пройдены успешно${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Один или несколько тестов провалены${NC}"
    exit 1
fi
