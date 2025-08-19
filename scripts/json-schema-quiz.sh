#!/bin/bash
# <!-- WSL: Полная поддержка Windows Terminal -->
# Расширенный квиз для проверки знаний JSON Schema

# Цвета для Windows Terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Проверка знаний по JSON Schema...${NC}"

# Вопрос 1
echo -e "\n${YELLOW}Вопрос 1: Что означает ключевое слово 'required' в JSON Schema?${NC}"
echo -e "a) Поля, которые могут отсутствовать"
echo -e "b) Поля, которые обязательно должны присутствовать"
echo -e "c) Поля с минимальной длиной"
read -p "Ваш ответ (a/b/c): " answer1

# Вопрос 2
echo -e "\n${YELLOW}Вопрос 2: Как проверить, что версия соответствует формату vX.Y.Z?${NC}"
echo -e "a) Используя pattern: '^v\\\\d+\\\\.\\\\d+(\\\\.\\\\d+)?$'"
echo -e "b) Используя minLength: 5"
echo -e "c) Используя enum: ['v1.0.0', 'v1.1.0']"
read -p "Ваш ответ (a/b/c): " answer2

# Вопрос 3
echo -e "\n${YELLOW}Вопрос 3: Почему важно использовать валидацию через схему?${NC}"
echo -e "a) Для красоты кода"
echo -e "b) Чтобы гарантировать структуру данных и обнаруживать ошибки рано"
echo -e "c) Это требование JSON"
read -p "Ваш ответ (a/b/c): " answer3

# Подсчет результатов
score=0
if [ "$answer1" = "b" ]; then ((score++)); fi
if [ "$answer2" = "a" ]; then ((score++)); fi
if [ "$answer3" = "b" ]; then ((score++)); fi

echo -e "\n${GREEN}Ваш результат: $score из 3${NC}"
if [ $score -eq 3 ]; then
    echo -e "${GREEN}✅ Отлично! Вы готовы к работе с JSON Schema${NC}"
elif [ $score -eq 2 ]; then
    echo -e "${YELLOW}✅ Хорошо! Повторите материал по вопросам, где ошиблись${NC}"
else
    echo -e "${RED}❌ Нужно повторить основы JSON Schema перед продолжением${NC}"
fi
