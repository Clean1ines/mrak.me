import pytest
from src.parser_logic import ArtifactParser

def test_path_normalization():
    # Проверка WSL-пути для диска C
    assert ArtifactParser.normalize_path("/mnt/c/Users/haku/file.txt").startswith("C:\\")
    
    # Проверка WSL-пути для диска D
    assert ArtifactParser.normalize_path("/mnt/d/project/file.txt").startswith("D:\\")
    
    # Проверка Windows-пути
    windows_path = "C:\\Users\\haku\\file.txt"
    assert ArtifactParser.normalize_path(windows_path) == windows_path
    
    # Проверка Linux-пути
    linux_path = "/home/haku/file.txt"
    assert ArtifactParser.normalize_path(linux_path) == linux_path
