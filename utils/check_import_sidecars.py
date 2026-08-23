#!/usr/bin/env python3
"""Garante que todo arquivo `*.import` tem o arquivo original correspondente
ao lado (ex: `player.png.import` -> `player.png`). Um `.import` orfao
geralmente significa que uma renomeacao dessincronizou o nome do sidecar
do nome do recurso real, o que quebra a importacao no editor da Godot."""

import os
import sys


def main(paths: list[str]) -> int:
    errors = []
    for path in paths:
        if not path.endswith(".import"):
            continue
        original = path[: -len(".import")]

        if not os.path.exists(original):
            errors.append(f"{path}: arquivo original '{original}' nao encontrado")

    if errors:
        print("Sidecars .import orfaos (nome dessincronizado do arquivo original):")
        for error in errors:
            print(f"  - {error}")
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
