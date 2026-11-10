# What's Training? (`esES`)

**Prioridad:** Baja  
**Autor upstream:** `Fusionpit`  
**Metodología:** Método A — Inyección de tabla de localización

### Reglas técnicas:
1. Los nombres de hechizos y habilidades son cargados directamente en español por la API del cliente de WoW.
2. Solo se traducen las categorías de la interfaz mediante inyección condicional:
```lua
if GetLocale() == "esES" then
    WT_L["Available Now"] = "Disponible ahora"
    WT_L["Available soon"] = "Disponible pronto"
    WT_L["Missing Requirements"] = "Requisitos pendientes"
    WT_L["Already Known"] = "Ya aprendido"
end
```
3. **Codificación:** Guardar obligatoriamente en **UTF-8 sin BOM**.
