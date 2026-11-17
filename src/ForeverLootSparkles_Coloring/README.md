[![Version](https://img.shields.io/github/v/release/N3zr0k/ForeverLootSparkles_Coloring?include_prereleases&label=Version)](https://github.com/N3zr0k/ForeverLootSparkles_Coloring/releases)
[![Last update](https://img.shields.io/github/release-date-pre/N3zr0k/ForeverLootSparkles_Coloring?label=Last%20update)](https://github.com/N3zr0k/ForeverLootSparkles_Coloring/releases)
[![Build](https://img.shields.io/github/actions/workflow/status/N3zr0k/ForeverLootSparkles_Coloring/release.yml?branch=main&label=Build)](https://github.com/N3zr0k/ForeverLootSparkles_Coloring/actions/workflows/release.yml)
![WoW Forever](https://img.shields.io/badge/WoW%20Forever-16001-blue)
![Languages](https://img.shields.io/badge/Languages-11-blue)
![Dependencies](https://img.shields.io/badge/Dependencies-Forever%20Loot%20Sparkles-blue)
[![License](https://img.shields.io/badge/License-GPL--3.0--or--later-blue)](LICENSE)

# Forever Loot Sparkles - Herbs & Ores

Companion addon for **Forever Loot Sparkles** (WoW Forever). The original addon is not modified.

## What it does

### Sparkles on herbs, ore, quest objects, corpses and footlockers
Forever Loot Sparkles 2.0 removed the sparkles on herbs, ore veins, quest objects and corpses with loot. This addon brings them back (taken over from Forever Loot Sparkles 1.3.1) and adds footlockers that rogues can pick open.

- **Safe self-cast** (on): spells cast without a target could land on a player or NPC that soft targeting had picked next to you. Soft targeting is therefore paused in combat and on living units, and switched back on once you have moved a few yards.
- **Hide the nameplate under the sparkle** (on): corpses and objects no longer show an empty nameplate or health bar, only the sparkle.
- With Forever Loot Sparkles 1.x the addon only colors its sparkles.

### A color per category
Herbs, ore veins, quest objects, corpses with loot and footlockers each get their own color. The color swatches sit right next to the checkboxes on the Forever Loot Sparkles options page, with an on/off switch and a reset button below them. Out of reach the sparkle dims, on locked objects it turns grey.

### Hide interaction icons
Optionally hides the game's interaction icon (gear, pickaxe, leaf, hand ...) over objects: all at once, or separately for herbs, ore, quest objects, corpses with loot, other objects and NPCs. The sparkles stay visible.

### Translation
The Forever Loot Sparkles options page is translated into your client language. Supported: English, German, French, Spanish (esES, esMX), Brazilian Portuguese (ptBR), Italian, Russian, Korean and Chinese (zhCN, zhTW).

## Installation

1. Install [Forever Loot Sparkles](https://www.curseforge.com/wow/addons/forever-loot-sparkles) (required).
2. Download the ZIP from the [releases](../../releases) or from CurseForge.
3. Extract the `ForeverLootSparkles_Coloring` folder into `World of Warcraft\_retail_\Interface\AddOns`.

The folder name stays `ForeverLootSparkles_Coloring` so your settings (`ForeverLootSparklesColoringDB`, account-wide) are kept.

## Commands

| Command | Effect |
|---|---|
| `/flscolor` | Opens the options on the Forever Loot Sparkles page |
| `/flscolor target` | Shows in chat what the addon sees on your current interaction target (name, object ID, icon, category), to help with bug reports |
| `/flscolor icons` | Lists what the addon sees on the nameplates around you |

## Limitations

- Only the glints drawn by Forever Loot Sparkles or this addon can be colored. The game's own loot sparkle on quest items is drawn by the engine.
- The "restart the game" chat line and the addon list description of Forever Loot Sparkles stay English (they would need changes to its files).
- The translations match the texts of Forever Loot Sparkles 1.3.1; reworded strings in later versions stay English.

## Repository layout

| Path | Content |
|---|---|
| `ForeverLootSparkles_Coloring/` | The game folder, exactly as it goes into `Interface\AddOns` |
| `.github/workflows/release.yml` | CI: lint, ZIP build, release and CurseForge upload |
| `.pkgmeta` / `.luacheckrc` | Packager and lint configuration |
| `CHANGELOG.md` / `BUGFIX.md` | Game-relevant changes and bugfixes / bugfixes in detail |

## Release process

The version lives only in the TOC (`## Version:`). On a push to `main`:

1. **Lint** (luacheck) has to pass.
2. The addon is built with the BigWigs packager as `ForeverLootSparkles_HerbsOres-<version>.zip` and stored as a workflow artifact (pull requests too).
3. If there is no tag for the TOC version yet, CI creates the tag and a GitHub release:

| TOC version | GitHub | CurseForge |
|---|---|---|
| `x.y.z-alpha.N` | Prerelease | no upload |
| `x.y.z-beta.N` | Release, title marked "(Beta)" | uploaded as beta |
| `x.y.z` | Release | uploaded as release |

The release notes come from the `## <version>` section of `CHANGELOG.md`.

### One-time setup

Under *Settings → Secrets and variables → Actions*:

- **Secret** `CF_API_KEY`: API token from https://legacy.curseforge.com/account/api-tokens
- `CURSEFORGE_PROJECT_ID` (variable or secret, optional): CurseForge project ID; the workflow defaults to this project's ID
- **Variable** `CF_GAME_VERSION` (optional): only needed if CurseForge can't match the TOC's interface version

## License

GPL-3.0-or-later, see [LICENSE](LICENSE). The classification code is adapted from Forever Loot Sparkles.

## Thanks

A big thank you to **conoar**, the author of Forever Loot Sparkles. This addon only adds a little color and a few translations; all the real work of making loot, herbs and ore sparkle is theirs.
