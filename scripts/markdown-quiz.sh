#!/bin/bash
# Интерактивный квиз для проверки знаний Markdown

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'
SCORE=0

echo -e "${YELLOW}--- Markdown Квиз ---${NC}"

# Вопрос 1
echo "Вопрос 1: Как создать заголовок второго уровня?"
echo "a) **Заголовок**"
echo "b) ## Заголовок"
echo "c) H2: Заголовок"
read -p "Ваш ответ (a/b/c): " answer
if [[ "$answer" == "b" ]]; then
    SCORE=$((SCORE + 1))
    echo -e "${GREEN}Верно!${NC}"
else
    echo -e "${RED}Неверно. Правильный ответ: b) ## Заголовок${NC}"
fi

# Вопрос 2
echo -e "\nВопрос 2: Как выделить блок кода на Python?"
echo "a) <py>...</py>"
echo "b) \`\`\`python... \`\`\`"
echo "c) ---python... ---"
read -p "Ваш ответ (a/b/c): " answer
if [[ "$answer" == "b" ]]; then
    SCORE=$((SCORE + 1))
    echo -e "${GREEN}Верно!${NC}"
else
    echo -e "${RED}Неверно. Правильный ответ: b) \`\`\`python... \`\`\`${NC}"
fi

echo -e "\n${YELLOW}--- Результаты ---${NC}"
echo "Вы набрали $SCORE из 2 баллов."
if [ $SCORE -eq 2 ]; then
    echo -e "${GREEN}Отлично! Вы готовы писать документацию.${NC}"
else
    echo -e "${RED}Рекомендуем перечитать docs/learning/markdown-basics.md${NC}"
fi
