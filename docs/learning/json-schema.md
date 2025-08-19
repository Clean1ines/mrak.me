## JSON Schema: как проверка состава коктейля

Как бармен, я знаю, что перед подачей коктейля нужно проверить его состав. JSON Schema — это похожий инструмент, но для проверки структуры данных.

### Основные понятия
- **Схема**: Как рецепт коктейля, описывающий обязательные ингредиенты
- **Валидация**: Как проверка состава коктейля перед подачей
- **Поля**: Как ингредиенты в коктейле
- **Типы данных**: Как виды ингредиентов (жидкость, сироп, лед)

### Пример схемы для артефакта
::: json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "Artifact",
  "type": "object",
  "required": ["id", "type", "name", "version", "createdAt"],
  "properties": {
    "id": { "type": "string", "pattern": "^[a-z0-9\-]{8,}$" },
    "type": { "type": "string", "enum": ["policy", "process", "spec", "doc", "ops", "gtm", "hr"] },
    "name": { "type": "string", "minLength": 3 },
    "version": { "type": "string", "pattern": "^v\\d+\\.\\d+(\\.\\d+)?$" },
    "content": { "type": "object" },
    "createdAt": { "type": "string", "format": "date-time" }
  }
}
:::

### Аналогия с баром
| Элемент бара | Эквивалент в JSON Schema | Пример |
|--------------|--------------------------|--------|
| Рецепт коктейля | Схема JSON | Описание обязательных полей |
| Проверка состава | Валидация | Проверка на соответствие схеме |
| Ингредиенты | Поля схемы | project, type, name, version |
| Типы ингредиентов | Типы данных | string, number, array |
| Количество ингредиентов | minLength/maxLength | Минимальная длина имени |

### Основные ключевые слова
- **required**: Обязательные поля (как обязательные ингредиенты)
- **enum**: Допустимые значения (как список разрешенных типов)
- **pattern**: Регулярное выражение для проверки формата
- **minLength/maxLength**: Минимальная/максимальная длина строки
- **format**: Специальный формат (date-time, uri и др.)

### Пример валидации
::: python
import json
import jsonschema
from jsonschema import validate

# Загружаем схему
schema = json.load(open("schemas/artifact.json"))

# Пример артефакта
artifact = {
  "id": "a1b2c3d4",
  "type": "doc",
  "name": "example",
  "version": "v1.0.0",
  "content": {
    "metadata": {"project": "metamrak"},
    "body": "Пример артефакта"
  },
  "createdAt": "2024-01-28T12:00:00Z"
}

# Проверяем соответствие схеме
try:
    validate(instance=artifact, schema=schema)
    print("✅ Артефакт соответствует схеме")
except jsonschema.exceptions.ValidationError as e:
    print(f"❌ Ошибка валидации: {e.message}")
:::

### Правила оформления схем
1. Все обязательные поля должны быть в `required`
2. Используйте `pattern` для проверки формата версий
3. Указывайте `minLength` для строковых полей
4. Используйте `enum` для ограниченного набора значений
5. Добавляйте комментарии к сложным частям схемы
