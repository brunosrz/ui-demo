#!/usr/bin/env python3
"""Converte e mescla todos os arquivos .po de locale/ em um unico CSV no
formato de traducao que a Godot importa nativamente: primeira coluna com
o cabecalho "keys" (a chave de traducao), colunas seguintes uma por
locale (extraido do header "Language:" de cada .po, sempre em minusculo -
e o que a Godot usa internamente pra resolver locale, e e o que ela usa
pra nomear os *.translation gerados no reimport)."""

import csv
import glob
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PO_DIR = os.path.join(ROOT, "locale")
OUTPUT = os.path.join(PO_DIR, "translations.csv")

LANGUAGE_RE = re.compile(r'"Language:\s*([^\\\n]+)\\n"')
MSGID_RE = re.compile(r'^msgid\s+((?:"(?:[^"\\]|\\.)*"\s*)+)', re.MULTILINE)
MSGSTR_RE = re.compile(r'^msgstr\s+((?:"(?:[^"\\]|\\.)*"\s*)+)', re.MULTILINE)
STRING_PARTS_RE = re.compile(r'"((?:[^"\\]|\\.)*)"')


def unescape_po_string(raw: str) -> str:
    """Concatena as partes entre aspas (podem vir em varias linhas) e
    resolve os escapes basicos do formato .po."""
    joined = "".join(STRING_PARTS_RE.findall(raw))
    return (
        joined.replace("\\n", "\n")
        .replace("\\t", "\t")
        .replace('\\"', '"')
        .replace("\\\\", "\\")
    )


def parse_po(path: str) -> tuple[str, dict[str, str]]:
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    language_match = LANGUAGE_RE.search(content)
    locale = (
        language_match.group(1).strip().lower()
        if language_match
        else os.path.splitext(os.path.basename(path))[0].lower()
    )

    entries: dict[str, str] = {}
    for block in re.split(r"\n\s*\n", content):
        msgid_match = MSGID_RE.search(block)
        msgstr_match = MSGSTR_RE.search(block)
        if not msgid_match or not msgstr_match:
            continue

        msgid = unescape_po_string(msgid_match.group(1))
        if msgid == "":
            continue  # entrada de cabecalho do .po, nao e uma chave real

        entries[msgid] = unescape_po_string(msgstr_match.group(1))

    return locale, entries


def main() -> int:
    po_files = sorted(glob.glob(os.path.join(PO_DIR, "*.po")))
    if not po_files:
        print(f"Nenhum .po encontrado em {PO_DIR}")
        return 1

    locales: list[str] = []
    data: dict[str, dict[str, str]] = {}
    all_keys: list[str] = []
    seen_keys: set[str] = set()

    for path in po_files:
        locale, entries = parse_po(path)
        locales.append(locale)
        data[locale] = entries
        for key in entries:
            if key not in seen_keys:
                seen_keys.add(key)
                all_keys.append(key)

    all_keys.sort()

    with open(OUTPUT, "w", encoding="utf-8", newline="") as f:
        # QUOTE_ALL: toda celula entre aspas, sempre - deixa explicito e
        # inequivoco onde cada campo comeca/termina, mesmo com virgulas,
        # aspas ou quebras de linha dentro do texto traduzido.
        writer = csv.writer(f, quoting=csv.QUOTE_ALL)
        writer.writerow(["keys"] + locales)
        for key in all_keys:
            writer.writerow([key] + [data[locale].get(key, "") for locale in locales])

    print(
        f"Gerado {OUTPUT} com {len(all_keys)} chaves e {len(locales)} locales: {', '.join(locales)}"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
