# Bugfixes

Details zu behobenen Fehlern. `CHANGELOG.md` nennt nur eine Zeile pro Änderung.

## 2.2.2

### Pausenstatus der Soft-Zielerfassung wurde nicht zurückgesetzt
- **Datei:** `ForeverLootSparkles_Coloring/Sparkles.lua`
- **Ursache:** `local paused` war erst nach `ApplyCVars` und `RestoreCVars` deklariert. Beide Funktionen schrieben deshalb eine globale Variable `paused` statt der lokalen; der lokale Pausenstatus blieb nach dem Zurücksetzen erhalten.
- **Folge:** Nach dem Aus-/Einschalten des Funkelns oder „Sicheres Selbstzaubern“ konnte eine alte Pause (z. B. „unit“) hängen bleiben, sodass `Pause()` früh zurückkehrte. Zusätzlich landete `paused` im globalen Namensraum.
- **Fix:** Deklaration vor `ApplyCVars` verschoben. Gefunden durch luacheck.
- **Status:** nur per luacheck geprüft, im Spiel ungetestet.
