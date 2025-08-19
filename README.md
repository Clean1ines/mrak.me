# metamrak - Артефактоцентричная система управления знаниями

Проект metamrak (Meta Artifact System) представляет собой систему управления знаниями, основанную на артефактоцентричном подходе. Система превращает знания в проверяемые и трассируемые артефакты.

## Основные принципы
- **Artifact-first**: Любой шаг выпускает артефакт.
- **Explainable-by-design**: Каждое решение сопровождается "почему" (ADR).
- **Reversible**: Rollback есть всегда.
- **Docs-as-UI**: Документация — интерфейс архитектуры.

## Как начать (WSL/Linux)
1. Установите Python 3.11 и VS Code с расширением WSL.
2. Клонируйте репозиторий: `git clone <repo_url>`
3. Установите зависимости: `pip install -r requirements.txt`
4. Запустите API: `uvicorn src.app:app --reload --port 8000`

## Структура проекта
\`\`\`
metamrak/
├── docs/               # Документация и артефакты
├── src/                # Исходный код
├── tests/              # Тесты
├── .github/            # CI/CD конфигурации
└── requirements.txt    # Зависимости
\`\`\`

## Ключевая документация
- [SLOS_Enterprise_Artefact_Suite_v1.3](docs/SLOS_Enterprise_Artefact_Suite_v1.3.md)
- [Master Prompt v18.1](docs/artifacts/master-prompt-v18.1.md)
