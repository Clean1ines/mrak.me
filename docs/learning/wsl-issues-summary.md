## Overview
Систематизация проблем, возникших при разработке в WSL, и создание руководства по их предотвращению в будущих проектах. Документ фиксирует 5 критических проблем с решениями, проверенными в процессе реализации парсера артефактов.

## Detail
### 1. Ключевые проблемы и решения
#### 🔧 Проблема 1: Права доступа к файлам в WSL
**Симптомы**:
- `zsh: permission denied` при редактировании файлов на /mnt/c/ или /mnt/d/
- Невозможность записи в файлы через WSL

**Решение**:
1. Создать файл `.wslconfig` в домашней директории Windows:
   ```ini
   [wsl2]
   kernelCommandLine = sysctl vm.drop_caches=1
   [automount]
   options = metadata,umask=22,fmask=11
   ```
2. Перезапустить WSL: `wsl --shutdown`
3. Альтернатива: работать в нативной файловой системе WSL (`~/projects/` вместо `/mnt/`)

#### 🔧 Проблема 2: Синтаксические ошибки в Python
**Симптомы**:
- `SyntaxError: unexpected character after line continuation character`
- Некорректный синтаксис многострочных строк

**Решение**:
- Использовать `"""` вместо `\"\"\"` для многострочных строк:
  ```python
  # Правильно
  text = """--- ARTIFACT_START ---
  ... содержимое ...
  --- ARTIFACT_END ---"""
  
  # Неправильно
  text = \"\"\"--- ARTIFACT_START ---
  ... содержимое ...
  --- ARTIFACT_END ---\"\"\"
  ```

#### 🔧 Проблема 3: Ошибка импорта модулей
**Симптомы**:
- `ModuleNotFoundError: No module named 'src'`
- pytest не может найти модули

**Решение**:
1. Добавить файлы `__init__.py` в директории `src/` и `tests/`
2. Создать `tests/conftest.py`:
   ```python
   import sys
   from pathlib import Path
   
   project_root = Path(__file__).parent.parent
   sys.path.insert(0, str(project_root))
   ```
3. Использовать структуру проекта:
   ```
   project/
   ├── src/
   │   ├── __init__.py
   │   └── module.py
   ├── tests/
   │   ├── __init__.py
   │   ├── conftest.py
   │   └── test_module.py
   ```

#### 🔧 Проблема 4: Нормализация путей в WSL
**Симптомы**:
- Пути не конвертируются из `/mnt/c/...` в `C:\...`
- Ошибки при работе с файловой системой

**Решение**:
- Упрощенная проверка без `platform.system()`:
  ```python
  @staticmethod
  def normalize_path(file_path: str) -> str:
      if file_path.startswith('/mnt/c/'):
          return 'C:' + file_path[6:].replace('/', '\\')
      if re.match(r'/mnt/[a-z]/', file_path):
          drive_letter = file_path[5].upper()
          return f'{drive_letter}:' + file_path[6:].replace('/', '\\')
      return file_path
  ```

#### 🔧 Проблема 5: Установка Python-пакетов в WSL
**Симптомы**:
- `error: externally-managed-environment`
- Запрет на установку пакетов в системный Python

**Решение**:
- Всегда использовать виртуальное окружение:
  ```bash
  python3 -m venv .venv
  source .venv/bin/activate
  pip install -r requirements.txt
  ```

### 2. Рекомендации для будущих проектов
#### ✅ Best Practices
1. **Работа с файловой системой**:
   - Используйте нативную файловую систему WSL (`~/projects/`) вместо `/mnt/`
   - Если необходимо использовать `/mnt/`, настройте `.wslconfig` с `metadata,umask=22,fmask=11`

2. **Структура Python-проекта**:
   - Всегда добавляйте `__init__.py` в директории
   - Используйте `conftest.py` для настройки импорта в тестах
   - Разделяйте код на модули с четкой иерархией

3. **WSL-специфичные решения**:
   - Не полагайтесь на `platform.system()` для определения ОС в WSL
   - Реализуйте специфичную обработку путей через проверку префикса
   - Всегда используйте виртуальные окружения

## Examples
### Пример .wslconfig для корректной работы с правами
```ini
[wsl2]
kernelCommandLine = sysctl vm.drop_caches=1
[automount]
options = metadata,umask=22,fmask=11
```

### Пример conftest.py для правильного импорта
```python
import sys
from pathlib import Path

# Добавляем корневую директорию проекта в sys.path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))
```

### Пример нормализации путей для WSL
```python
import re

def normalize_path(file_path: str) -> str:
    """Нормализует пути для WSL без проверки platform.system()"""
    if file_path.startswith('/mnt/c/'):
        return 'C:' + file_path[6:].replace('/', '\\')
    if re.match(r'/mnt/[a-z]/', file_path):
        drive_letter = file_path[5].upper()
        return f'{drive_letter}:' + file_path[6:].replace('/', '\\')
    return file_path
```

## Glossary
**WSL Metadata** — Флаг для автоматического управления правами в WSL через `.wslconfig`.  
**Python Virtual Environment** — Изолированное окружение для безопасной установки пакетов.  
**Path Normalization** — Процесс приведения путей к стандартному формату для текущей ОС.  
**Module Import Path** — Путь, по которому Python ищет импортируемые модули.

## Style Rules
- Все рекомендации → снабжены примерами кода
- Примеры кода → с комментариями `<!-- WSL: ... -->`
- Нет предложений длиннее 20 слов (требование "понятно излагаете информацию")
- Все пути → в формате WSL (`/mnt/d/...`)

## PRP Trace
**Intent**: Систематизировать проблемы, возникшие при работе в WSL, и создать руководство по их решению.  
**Actions**:  
1. Анализ всех возникших проблем в проекте  
2. Формулировка решений с примерами кода  
3. Создание рекомендаций для будущих проектов  
4. Проверка решений на практике  

**Constraints**:  
- Решения должны работать в WSL и Windows Terminal  
- Инструкции должны быть понятны без глубоких знаний WSL  
- Соответствие шаблону ARTIFACT_START/END  

## Traceability
**Входные артефакты**:  
- [[Parser-Test-Permissions_v19.2.3]]  
- [[Module-Import-Fix_v19.2.4]]  
- [[Path-Normalization-Fix_v19.2.5]]  

**Выходные зависимости**:  
- [[WSL_Best_Practices_Guide_v1.0]]  
- [[Python_Project_Template_v2.0]]  
- [[.wslconfig_Template_v1.0]]  

**Obsidian Backlinks**:  
[[WSL-Issues-Summary_v19.2.5#Detail]] → [[WSL_Best_Practices_Guide_v1.0#Implementation]]  
[[WSL-Issues-Summary_v19.2.5#Examples]] → [[Python_Project_Template_v2.0#Structure]]
