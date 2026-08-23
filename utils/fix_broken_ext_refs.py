#!/usr/bin/env python3
"""Corrige referencias de path com a extensao dessincronizada (ex:
'main_menu_gd' em vez de 'main_menu.gd'), deixadas por uma renomeacao em
massa anterior que trocava '.' por '_' dentro do nome completo do arquivo,
incluindo a extensao. So aplica a correcao quando o path corrigido de fato
existe em disco, pra nao criar falsos positivos."""

import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKIP_DIRS = {".git", ".godot", ".autoconverted", "dist", "node_modules"}
TEXT_EXTENSIONS = {".gd", ".tscn", ".godot", ".cfg", ".tres", ".import"}
KNOWN_EXTS = [
    "gd",
    "tscn",
    "godot",
    "tres",
    "cfg",
    "png",
    "jpg",
    "jpeg",
    "otf",
    "ttf",
    "ogg",
    "wav",
    "import",
    "uid",
    "svg",
    "webp",
]

PATTERN = re.compile(r"res://[^\"'\s]+")


def collect_files():
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for name in filenames:
            if os.path.splitext(name)[1] in TEXT_EXTENSIONS:
                yield os.path.join(dirpath, name)


def repair_path(res_path: str) -> str | None:
    """res_path e algo tipo 'res://scripts/ui/main_menu_gd'. Se terminar em
    '_<ext>' e a versao com ponto existir em disco, retorna o path
    corrigido."""
    for ext in KNOWN_EXTS:
        suffix = f"_{ext}"
        if res_path.endswith(suffix):
            candidate = res_path[: -len(suffix)] + f".{ext}"
            fs_path = os.path.join(ROOT, candidate[len("res://") :])
            if os.path.exists(fs_path):
                return candidate
    return None


def main() -> int:
    total_fixed = 0
    files_changed = 0

    for filepath in collect_files():
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
        except UnicodeDecodeError:
            continue

        matches = set(PATTERN.findall(content))
        replacements = {}
        for m in matches:
            fixed = repair_path(m)
            if fixed:
                replacements[m] = fixed

        if not replacements:
            continue

        new_content = content
        count = 0
        for old, new in replacements.items():
            occurrences = new_content.count(old)
            count += occurrences
            new_content = new_content.replace(old, new)

        if new_content != content:
            with open(filepath, "w", encoding="utf-8") as f:
                f.write(new_content)
            files_changed += 1
            total_fixed += count
            rel = os.path.relpath(filepath, ROOT)
            print(f"Corrigido: {rel} ({count} ocorrencia(s))")

    print(f"\nTotal: {total_fixed} referencias corrigidas em {files_changed} arquivo(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
