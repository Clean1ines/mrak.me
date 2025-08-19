## Настройка окружения для разработки в WSL (Ubuntu)

### Шаг 1: Установка и настройка WSL
1. Откройте PowerShell от имени администратора и выполните:
   \`wsl --install\`
2. Перезагрузите компьютер.
3. Установите Ubuntu из Microsoft Store.

### Шаг 2: Установка Python 3.11 и Git
Откройте терминал Ubuntu и выполните команды:
\`\`\`bash
sudo apt update
sudo apt install python3.11 python3-pip python3.11-venv git -y
\`\`\`

### Шаг 3: Установка VS Code и расширения WSL
1. Установите [Visual Studio Code](https://code.visualstudio.com/) на Windows.
2. В VS Code установите расширение **WSL** от Microsoft.
3. Откройте проект в WSL через VS Code, выполнив в терминале Ubuntu: \`code .\`

### Шаг 4: Проверка
Выполните скрипт проверки, чтобы убедиться, что все настроено корректно:
\`\`\`bash
./scripts/check-environment.sh
\`\`\`
