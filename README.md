# Addons-WOW — Hub de Traducción y Mantenimiento (`esES`)

Arquitectura centralizada para la traducción, mantenimiento y sincronización de addons de World of Warcraft hacia Español de España (`esES`), protegiendo el trabajo local frente a las actualizaciones de CurseForge.

---

## 1. Estructura del Proyecto

```text
Addons-WOW/
├── config.json              # Configuración de rutas locales y lista de addons
├── README.md                # Esta guía de uso y arquitectura
├── src/                     # Código fuente y archivos traducidos en esES
│   ├── Journey/             # Journey Guides (Prioridad Alta - Rutas 1-60)
│   ├── BooksOnMapForever/   # Books on Map Forever (Prioridad Media - Notas y pistas)
│   ├── WhatsTraining/       # What's Training? (Prioridad Baja - Encabezados)
│   ├── GearQuestForever/    # GearQuest Forever (Prioridad Baja - Recomendaciones)
│   └── MoveAnything/        # MoveAnything (Opcional)
└── tools/
    ├── Sync-ToGame.ps1      # Despliega las traducciones hacia la carpeta de WoW
    └── Import-FromGame.ps1  # Importa addons nuevos o actualizados desde WoW
```

---

## 2. Flujo de Trabajo

### Paso 1: Configurar la ruta de WoW
Abra `config.json` y asegúrese de que `"wowAddonsPath"` apunte a la carpeta real de AddOns en su disco (por ejemplo: `C:/Program Files (x86)/World of Warcraft/_classic_/Interface/AddOns`).

### Paso 2: Importar addons instalados
Una vez haya instalado los addons en CurseForge:
```powershell
.\tools\Import-FromGame.ps1
```
Esto copiará los archivos base a la carpeta `src/` correspondiente para comenzar a traducir sin tocar directamente el juego.

### Paso 3: Traducir y sincronizar
Edite los archivos dentro de `src/` respetando siempre la codificación **UTF-8 sin BOM**.
Cuando termine o desee probar sus cambios en el juego, ejecute:
```powershell
.\tools\Sync-ToGame.ps1
```
*(Si el juego está en ejecución, simplemente escriba `/reload` en el chat de WoW).*

---

## 3. Blindaje frente a Actualizaciones de CurseForge

1. En la aplicación de CurseForge, haga clic derecho sobre los addons modificados (**Journey Guides**, **Books on Map Forever**, etc.) y seleccione **«Ignorar actualizaciones» (*Ignore Updates*)**.
2. Cuando el autor publique una actualización relevante:
   - Desbloquee y actualice desde CurseForge.
   - Ejecute `.\tools\Import-FromGame.ps1` para incorporar los archivos nuevos.
   - Revise las diferencias con Git (`git diff`), fusionando las novedades sin perder sus traducciones en español.

---

## 4. Métodos de Edición en Lua

* **Método A (Tablas de localización):** Inyección de bloque condicional `if GetLocale() == "esES" then ... end`.
* **Método B (Tablas de datos):** Mantener coordenadas `(x, y)` e identificadores numéricos intactos, traduciendo solo `note` y `description`.
* **Método C (Scripts de ruta):** Mantener intactas las directivas (`.goto`, `.accept`, `.turnin`, etc.) y traducir exclusivamente los textos narrativos de orientación.
