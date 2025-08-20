#!/bin/bash
# <!-- WSL: Полная поддержка Windows Terminal -->
# Исправленный скрипт для создания парсера артефактов

# Цвета для Windows Terminal
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Создание парсера артефактов...${NC}"

# Автоопределение путей в WSL
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  PROJECT_PATH=$(wslpath -a "$(pwd)")
  SRC_PATH="$PROJECT_PATH/src"
  TESTS_PATH="$PROJECT_PATH/tests"
  GITHUB_PATH="$PROJECT_PATH/.github/workflows"
else
  PROJECT_PATH=$(pwd)
  SRC_PATH="$PROJECT_PATH/src"
  TESTS_PATH="$PROJECT_PATH/tests"
  GITHUB_PATH="$PROJECT_PATH/.github/workflows"
fi

# Создаем структуру проекта
mkdir -p "$SRC_PATH"
mkdir -p "$TESTS_PATH"
mkdir -p "$GITHUB_PATH"

# Создаем парсер
cat << 'EOF' > "$SRC_PATH/parser_logic.py"
import re
import platform
from typing import Dict, List, Optional

# Константы для валидации
META_REQUIRED_KEYS = ["project", "type", "name", "version", "status", "owner", "model", "audience", "scope", "stability", "validated"]
VERSION_PATTERN = r'^v\d+\.\d+(\.\d+)?$'

class ArtifactParser:
    """Парсер артефактов SLOS с поддержкой YFM и строгой валидацией."""
    
    @staticmethod
    def parse_meta(artifact_text: str) -> Dict[str, str]:
        """
        Извлекает и валидирует META-заголовок из текста артефакта.
        
        Args:
            artifact_text: Текст артефакта
            
        Returns:
            Словарь с метаданными
            
        Raises:
            ValueError: При ошибках парсинга или валидации
        """
        # Поиск META-заголовка
        meta_match = re.search(r'---META:(.*?)---', artifact_text, re.DOTALL)
        if not meta_match:
            raise ValueError("META-заголовок не найден")
            
        meta_string = meta_match.group(1).strip()
        if not meta_string:
            raise ValueError("Пустой META-заголовок")
            
        # Проверка на соответствие YFM (одна строка)
        if '\n' in meta_string:
            raise ValueError("META должен быть в одной строке (YFM-требование)")
            
        # Парсинг пар ключ=значение
        metadata = {}
        for pair in meta_string.split(';'):
            if '=' not in pair:
                continue
                
            key, value = pair.split('=', 1)
            key = key.strip()
            value = value.strip()
            metadata[key] = value
            
        # Валидация обязательных полей
        for key in META_REQUIRED_KEYS:
            if key not in metadata:
                raise KeyError(f"Отсутствует обязательное поле: {key}")
                
        # Валидация формата версии
        if not re.match(VERSION_PATTERN, metadata["version"]):
            raise ValueError(f"Некорректный формат версии: {metadata['version']}")
            
        return metadata
        
    @staticmethod
    def is_valid_artifact(artifact_text: str) -> bool:
        """Проверяет, является ли текст корректным артефактом SLOS."""
        try:
            # Проверка наличия стартового маркера
            if not re.search(r'---\s*ARTIFACT_START\s*---', artifact_text, re.IGNORECASE):
                return False
                
            # Проверка META
            ArtifactParser.parse_meta(artifact_text)
            
            # Проверка YFM-специфики
            if re.search(r'```[a-z]*', artifact_text):
                return False
                
            return True
        except Exception:
            return False
            
    @staticmethod
    def normalize_path(file_path: str) -> str:
        """
        Нормализует путь для текущей ОС с поддержкой WSL.
        
        Для WSL конвертирует /mnt/c/... в C:\...
        """
        if platform.system() == "Windows" and file_path.startswith('/mnt/c/'):
            return 'C:' + file_path[6:].replace('/', '\\')
        return file_path
EOF

echo -e "${GREEN}✅ Парсер создан: $SRC_PATH/parser_logic.py${NC}"

# Создаем тесты
cat << 'EOF' > "$TESTS_PATH/parser_test.py"
import pytest
from src.parser_logic import ArtifactParser

def test_parse_valid_meta():
    """Тест парсинга корректного META."""
    text = \"\"\"--- ARTIFACT_START ---
---META:project=SLOS;type=test;name=valid;version=v1.0.0;status=production;owner=haku;model=qwen;audience=dev;scope=test;stability=stable;validated=true---
## Overview
Test artifact
--- ARTIFACT_END ---\"\"\"
    
    meta = ArtifactParser.parse_meta(text)
    assert meta["project"] == "SLOS"
    assert meta["version"] == "v1.0.0"
    assert meta["status"] == "production"

def test_parse_missing_required_field():
    """Тест отсутствия обязательного поля."""
    text = \"\"\"--- ARTIFACT_START ---
---META:project=SLOS;type=test;name=invalid;version=v1.0.0;status=production;owner=haku;model=qwen;audience=dev;scope=test;stability=stable;validated=true---
## Overview
Test artifact
--- ARTIFACT_END ---\"\"\"
    
    # Удаляем одно обязательное поле
    text = text.replace("validated=true", "")
    
    with pytest.raises(KeyError):
        ArtifactParser.parse_meta(text)

def test_parse_invalid_version():
    """Тест некорректного формата версии."""
    text = \"\"\"--- ARTIFACT_START ---
---META:project=SLOS;type=test;name=invalid;version=1.0.0;status=production;owner=haku;model=qwen;audience=dev;scope=test;stability=stable;validated=true---
## Overview
Test artifact
--- ARTIFACT_END ---\"\"\"
    
    with pytest.raises(ValueError):
        ArtifactParser.parse_meta(text)

def test_yfm_compliance():
    """Тест соответствия YFM."""
    # Корректный YFM
    yfm_compliant = \"\"\"--- ARTIFACT_START ---
---META:project=SLOS;type=test;name=yfm;version=v1.0.0;status=production;owner=haku;model=qwen;audience=dev;scope=test;stability=stable;validated=true---
## Overview
::: python
print("Hello YFM")
:::
--- ARTIFACT_END ---\"\"\"
    assert ArtifactParser.is_valid_artifact(yfm_compliant)
    
    # Некорректный YFM (использует ``` вместо :::)
    non_yfm = \"\"\"--- ARTIFACT_START ---
---META:project=SLOS;type=test;name=non-yfm;version=v1.0.0;status=production;owner=haku;model=qwen;audience=dev;scope=test;stability=stable;validated=true---
## Overview
```python
print("Hello Markdown")
```
--- ARTIFACT_END ---\"\"\"
    assert not ArtifactParser.is_valid_artifact(non_yfm)
    
def test_path_normalization():
    """Тест нормализации путей для WSL."""
    # Проверка WSL-пути
    wsl_path = "/mnt/c/Users/haku/project/README.md"
    normalized = ArtifactParser.normalize_path(wsl_path)
    assert normalized.startswith("C:\\") or normalized.startswith("C:/")
    
    # Проверка обычного Windows-пути
    windows_path = "C:\\Users\\haku\\project\\README.md"
    assert ArtifactParser.normalize_path(windows_path) == windows_path
    
    # Проверка Linux-пути
    linux_path = "/home/haku/project/README.md"
    assert ArtifactParser.normalize_path(linux_path) == linux_path
EOF

echo -e "${GREEN}✅ Тесты созданы: $TESTS_PATH/parser_test.py${NC}"

# Создаем GitHub Actions workflow
cat << 'EOF' > "$GITHUB_PATH/parser-validation.yml"
name: Parser Validation
on: [push]
jobs:
  validate-parser:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
          
      - name: Create and activate virtual environment
        run: |
          python -m venv .venv
          source .venv/bin/activate
          
      - name: Install dependencies
        run: |
          pip install --upgrade pip
          pip install jsonschema pytest
      
      - name: Run parser tests
        run: |
          source .venv/bin/activate
          pytest tests/parser_test.py --verbose
          
      - name: Validate YFM compliance
        run: |
          # Проверка использования ::: вместо ```
          if grep -q "```" docs/**/*.md; then
            echo "❌ Найдены блоки с ```. Требуется использовать ::: для YFM"
            exit 1
          fi
          
          # Проверка формата META
          if grep -qE "---META:.*(\n|\r\n).*---" docs/**/*.md; then
            echo "❌ META должен быть в одной строке (YFM-требование)"
            exit 1
          fi
          
          echo "✅ Все файлы соответствуют YFM"
EOF

echo -e "${GREEN}✅ GitHub Actions workflow создан: $GITHUB_PATH/parser-validation.yml${NC}"

# Создаем скрипт для запуска тестов
cat << 'EOF' > scripts/run-parser-tests.sh
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
EOF

chmod +x scripts/run-parser-tests.sh
echo -e "${GREEN}✅ Скрипт тестов создан: ./scripts/run-parser-tests.sh${NC}"
echo -e "${GREEN}👉 Для запуска тестов выполните: ./scripts/run-parser-tests.sh${NC}"
