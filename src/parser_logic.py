import re
from typing import Dict

class ArtifactParser:
    @staticmethod
    def normalize_path(file_path: str) -> str:
        """Нормализует путь для WSL без проверки platform.system()"""
        if file_path.startswith('/mnt/c/'):
            return 'C:' + file_path[6:].replace('/', '\\')
        if re.match(r'/mnt/[a-z]/', file_path):
            drive_letter = file_path[5].upper()
            return f'{drive_letter}:' + file_path[6:].replace('/', '\\')
        return file_path
