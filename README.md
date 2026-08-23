# Essentials

Template base para projetos Godot 4.4+ (GL Compatibility). Traz a estrutura
de UI e os sistemas essenciais que praticamente todo jogo precisa — menu
principal, pausa, configurações, save/settings persistente e um console de
debug — sem nenhuma mecânica de gameplay específica, pra servir de ponto de
partida limpo.

## Sistemas incluídos

- **Menus**: principal, pausa, opções e confirmação de saída.
- **Configurações**: áudio, vídeo (incluindo overlay de correção de gama),
  idioma e mapeamento de controles, todas persistidas via `SettingsManager`.
- **Áudio**: música e efeitos sonoros via o addon [SoundSys](addons/sound_system),
  com biblioteca de SFX/música já inclusa.
- **Internacionalização**: 15 locales prontos em `i18n/` (`pt_br`, `en_us`,
  `es_es`, `fr`, `de`, `ja`, `ko`, `ru`, chinês simplificado/tradicional,
  entre outros).
- **Componentes de UI reutilizáveis**: tooltip, popover, toast e coachmark
  (`scenes/ui/components/`).
- **Console de debug** (`singletons/scenes/debug_console.tscn`), acionável em
  jogo para inspecionar sinais e eventos globais.

## Autoloads

| Nome              | Responsabilidade                                                    |
| ----------------- | ------------------------------------------------------------------- |
| `SettingsManager` | Persistência de configurações do jogador.                           |
| `GlobalEvents`    | Barramento de eventos globais.                                      |
| `GameManager`     | Estado geral do jogo.                                               |
| `DebugConsole`    | Console de debug em tempo de execução.                              |
| `SoundSys`        | Autoload de áudio (ver [addons/sound_system](addons/sound_system)). |

## Estrutura

```
scenes/         Cenas de UI (menus, configurações, componentes)
scripts/        Scripts das cenas de UI
singletons/     Autoloads (scripts + cenas)
assets/         Fontes e sprites
resources/      Recursos compartilhados (ex: bus layout de áudio)
i18n/           Arquivos de tradução (.po)
addons/         Plugins, incluindo o SoundSys
```

## Requisitos

Godot **4.4+**, perfil de renderização GL Compatibility.

## Licença

MIT — veja [LICENSE](LICENSE).
