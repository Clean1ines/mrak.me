#!/bin/bash
# Квиз для проверки знаний Conventional Commits

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
SCORE=0

echo "Вопрос: Коммит для добавления новой функции в парсер должен начинаться с..."
read -p "Ваш ответ: " answer
if [[ "$answer" == "feat(parser):"* ]]; then
    SCORE=$((SCORE + 1))
    echo -e "${GREEN}Верно!${NC}"
else
    echo -e "${RED}Неверно. Правильный формат: feat(parser): описание${NC}"
fi
# ... (можно добавить еще вопросы)
