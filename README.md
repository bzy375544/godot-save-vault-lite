# Save Vault Lite — Crash-Safe Saves & Settings Persistence (Godot 4)

A free, zero-dependency starter addon for Godot 4 that gives your prototype **atomic single-slot JSON saving** plus **Master volume and fullscreen persistence** — in about three minutes.

Saves are written to a `.tmp` file and committed with a rename, so a crash or a kill during the write cannot leave a half-written save behind.

Written for Godot 4.3, 100% GDScript, no external dependencies.

## Install

1. Grab the addon folder `addons/save_settings_lite/` (download this repo as a ZIP, or `git clone` it) and copy it into your project's `res://addons/` folder.
   > Also submitted to the **Godot Asset Library** as `Save Vault Lite` — it is currently in review. Once accepted you will also be able to install it straight from the editor's **AssetLib** tab.
2. **Project → Project Settings → Plugins** and enable **Save & Settings Lite**. This registers the `SaveSettingsLite` autoload.

## Usage

```gdscript
# Save and load a dictionary (atomic write, single slot)
SaveSettingsLite.save_game({"coins": 250, "stage": 3})
var state: Dictionary = SaveSettingsLite.load_game()

# Settings
SaveSettingsLite.set_master_volume(0.8)   # 0.0 – 1.0 linear
SaveSettingsLite.set_fullscreen(true)
SaveSettingsLite.save_settings()
SaveSettingsLite.load_settings()
```

| API | What it does |
| :--- | :--- |
| `save_game(data: Dictionary) -> bool` | Serialises to JSON and commits atomically via `.tmp` + rename |
| `load_game() -> Dictionary` | Returns the saved dictionary, or `{}` on first run |
| `set_master_volume(linear_val)` | Applies to the Master audio bus and remembers the value |
| `set_fullscreen(enabled)` | Toggles window mode and remembers the value |
| `save_settings()` / `load_settings()` | Persist / restore the settings block on its own |

## Lite vs. Full kit

| Capability | Lite (free) | Full kit ($7.99) |
| :--- | :---: | :---: |
| Atomic `.tmp` write before commit | Yes | Yes + readback byte verification |
| Named save slots | Single slot | Unlimited (`slot_1..N` + `autosave`) with fast header preview |
| 3-tier rolling `.bak1..3` auto-healing on corruption | — | Yes (`backup_restored` signal) |
| Native Godot type round-trip (`Vector2/3`, `Color`, `Rect2`) | Primitives only | Yes (`SaveSerializer`) |
| HMAC-SHA256 tamper seal + optional AES-256 encryption | — | Yes (pure engine crypto) |
| Schema migrations across updates (`v1 → v2 → v3`) | — | Yes (`SaveMigrator`) |
| Multi-bus mixer (Master / Music / SFX) | Master only | Yes |
| Keyboard, mouse and gamepad remapping UI | — | Yes |

Full kit (HTML5 demo you can play in the browser): **https://bzy375544.itch.io/godot4-save-settings-vault**

This Lite addon on itch.io (one-click download, no signup): **https://bzy375544.itch.io/godot4-save-settings-vault-lite**

## License

MIT — free for commercial use, no attribution required. See [LICENSE](LICENSE).
