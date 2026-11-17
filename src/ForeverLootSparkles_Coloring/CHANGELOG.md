# Changelog

## 2.2.3

- Less CPU use: whether an object belongs to a quest is now remembered until your quest log changes, instead of being looked up several times a second for every nameplate.

## 2.2.2

- Fixed: soft targeting pause state was not reset when sparkles or safe self-cast were toggled (see BUGFIX.md).

## 2.2.1

- New `/flscolor target`: shows in chat what the addon sees on your current interaction target (name, object ID, cursor icon, category), to help with bug reports.

## 2.2.0

- New sparkle category: **Footlockers (lockpicking)**. Waterlogged, Battered, Dented, Scarlet, Rockjaw and Syndicate Footlockers sparkle as you approach them, in rogue yellow by default, with their own color swatch. Like other nodes they turn grey when your lockpicking skill is too low. On by default.

## 2.1.0

- New languages: Spanish (esES, esMX), Brazilian Portuguese (ptBR), Italian (itIT), Russian (ruRU), Korean (koKR) and Chinese (zhCN, zhTW), on top of English, German and French. The language follows your game client automatically.

## 2.0.3

- The color swatches now use the same frame and size as the checkboxes next to them.

## 2.0.2

- `/flscolor` opens the options again, on the Forever Loot Sparkles page, without the blocked function. If the game refuses, it tells you in chat where to find them.

## 2.0.1

- Fixed: `/flscolor` raised "ADDON_ACTION_BLOCKED ... OpenSettingsPanel()". The game no longer lets addons open the options window, so `/flscolor` now tells you in chat where to find the options.

## 2.0.0

- New name: "Forever Loot Sparkles - Herbs & Ores". The folder stays ForeverLootSparkles_Coloring, so your settings are kept; just replace the folder.
- Forever Loot Sparkles 2.0 removed the sparkles on herbs, ore veins, quest objects and corpses with loot. This addon now brings them back itself, with the same four checkboxes on the Forever Loot Sparkles options page and your colors.
- New "Safe self-cast" (on): spells cast without a target could land on a player or NPC that soft targeting had picked next to you. Soft targeting is now switched off in combat and whenever it picks a living unit, and back on once you have moved a few yards. Nodes and corpses keep sparkling.
- New "Hide the nameplate under the sparkle" (on): corpses and objects no longer show an empty nameplate or health bar, only the sparkle.
- Waits until Forever Loot Sparkles 2.0 has put back its old soft targeting settings after login, so the two addons don't fight over them.
- Still works with Forever Loot Sparkles 1.x: then it only colors its sparkles, as before.

## 1.2.4

- Fixed: NPCs without a nameplate (e.g. vendors and trainers) kept their interaction icon. The game draws that icon itself, so "NPCs" and "Hide all" now also switch off the game's setting for NPC interact icons. Your previous value is put back when you untick them.

## 1.2.3

- While "Hide all" is ticked, the greyed out icon checkboxes show a tick too. Your single choices are kept and come back when you untick "Hide all".
- `/flscolor icons` shows more detail.

## 1.2.2

- Fixed: with "Hide all" ticked, icons stayed visible over some NPCs (e.g. fishing supply vendors). "Hide all" now hides the icon on every nameplate, also when the game doesn't say what the unit is, and keeps it hidden when the game fades it in again.
- While "Hide all" is ticked, the single icon checkboxes are greyed out.
- `/flscolor icons` lists what the addon sees on the nameplates around you, to help with bug reports.

## 1.2.1

- "Hide interaction icons" now also covers NPCs such as vendors, trainers and quest givers: new checkbox "NPCs", and "Hide all" includes them.

## 1.2.0

- New section "Hide interaction icons": hide the game's interaction icon (gear, pickaxe, leaf, hand ...) over objects, either all at once or separately for herbs, ore veins, quest objects, corpses with loot and other objects such as fishing bobbers or chests.
- Forever Loot Sparkles needs these icons switched on for its sparkles, so they are only made invisible. The sparkles stay.

## 1.1.0

First release.

- Choose your own sparkle color for herbs, ore veins, quest objects and corpses with loot.
- The color swatches sit right next to the checkboxes on the Forever Loot Sparkles options page. Click one to open the game's color picker.
- New "Colors" section on the same page with a switch to turn coloring on or off and a "Reset colors" button.
- The sparkles still dim out of reach, brighten in reach and turn grey when an object can't be used.
- German (deDE) and French (frFR) translations of the Forever Loot Sparkles options, picked automatically from your client language.
- `/flscolor` opens the options.
- Requires Forever Loot Sparkles 1.3.1 or later. Its files are not changed.
