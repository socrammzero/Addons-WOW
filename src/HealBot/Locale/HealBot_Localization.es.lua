-- Spanish localization for HealBot Continued (esES / esMX)

-------------
-- SPANISH --
-------------

function HealBot_Lang_esES()
    HealBot_Lang_esALL()
end

function HealBot_Lang_esMX()
    HealBot_Lang_esALL()
end

function HealBot_Lang_esALL()

    -----------------
    -- Translation --
    -----------------

    HEALBOT_classicABSORBHOT               = "absorción"
    HEALBOT_classicABSORBHOTUP             = "Absorción"
    HEALBOT_enWORD_COLOUR_SUFFIX           = "or"
    HEALBOT_WORDS_CUSTOMNAME               = "Personalizar nombre"

    -- Class
    HEALBOT_DRUID                          = "Druida";
    HEALBOT_HUNTER                         = "Cazador";
    HEALBOT_MAGE                           = "Mago";
    HEALBOT_PALADIN                        = "Paladín";
    HEALBOT_PRIEST                         = "Sacerdote";
    HEALBOT_ROGUE                          = "Pícaro";
    HEALBOT_SHAMAN                         = "Chamán";
    HEALBOT_WARLOCK                        = "Brujo";
    HEALBOT_WARRIOR                        = "Guerrero";
    HEALBOT_DEATHKNIGHT                    = "Caballero de la Muerte";
    HEALBOT_DEMONHUNTER                    = "Cazador de demonios";
    HEALBOT_MONK                           = "Monje";
    HEALBOT_EVOKER                         = "Evocador";

    HEALBOT_BALANCE                        = "Equilibrio"
    HEALBOT_FERAL                          = "Feral"
    HEALBOT_RESTORATION                    = "Restauración"
    HEALBOT_SHAMAN_RESTORATION             = "Restauración"
    HEALBOT_ARCANE                         = "Arcano"
    HEALBOT_FIRE                           = "Fuego"
    HEALBOT_FROST                          = "Escarcha"
    HEALBOT_DISCIPLINE                     = "Disciplina"
    HEALBOT_HOLY                           = "Sagrado"
    HEALBOT_SHADOW                         = "Sombra"
    HEALBOT_ASSASSINATION                  = "Asesinato"
    HEALBOT_COMBAT                         = "Combate"
    HEALBOT_SUBTLETY                       = "Sutileza"
    HEALBOT_ARMS                           = "Armas"
    HEALBOT_FURY                           = "Furia"
    HEALBOT_PROTECTION                     = "Protección"
    HEALBOT_BEASTMASTERY                   = "Bestias"
    HEALBOT_MARKSMANSHIP                   = "Puntería"
    HEALBOT_SURVIVAL                       = "Supervivencia"
    HEALBOT_RETRIBUTION                    = "Reprensión"
    HEALBOT_ELEMENTAL                      = "Elemental"
    HEALBOT_ENHANCEMENT                    = "Mejora"
    HEALBOT_AFFLICTION                     = "Aflicción"
    HEALBOT_DEMONOLOGY                     = "Demonología"
    HEALBOT_DESTRUCTION                    = "Destrucción"
    HEALBOT_BLOOD                          = "Sangre"
    HEALBOT_UNHOLY                         = "Profano"

    HEALBOT_DISEASE                        = "Enfermedad";
    HEALBOT_MAGIC                          = "Magia";
    HEALBOT_CURSE                          = "Maldición";
    HEALBOT_POISON                         = "Veneno";
    HEALBOT_BLEED                          = "Sangrado";
    HEALBOT_SPELL_HOLYWORDCHASTISE         = "Palabra sagrada: condena"
    HEALBOT_SPELL_HOLYWORDSERENITY         = "Palabra sagrada: serenidad"
    HEALBOT_SPELL_HOLYWORDSANCTUARY        = "Palabra sagrada: santuario"

    HB_TOOLTIP_OFFLINE                     = "Desconectado";
    HB_OFFLINE                             = "desconectado";
    HB_ONLINE                              = "conectado";

    HEALBOT_HEALBOT                        = "HealBot";
    HEALBOT_ADDON                          = HEALBOT_HEALBOT .. " " .. HEALBOT_VERSION;
    HEALBOT_LOADED                         = " cargado.";

    HEALBOT_RANK = {[1]="(Rango 1)", [2]="(Rango 2)", [3]="(Rango 3)", [4]="(Rango 4)", [5]="(Rango 5)", [6]="(Rango 6)", [7]="(Rango 7)",
                    [8]="(Rango 8)", [9]="(Rango 9)", [10]="(Rango 10)", [11]="(Rango 11)", [12]="(Rango 12)", [13]="(Rango 13)"}

    HEALBOT_ACTION_OPTIONS                 = "Opciones";
    HEALBOT_ACTION_UNLOCKED                = "Desbloqueado";

    HEALBOT_OPTIONS_TITLE                  = HEALBOT_HEALBOT;
    HEALBOT_OPTIONS_DEFAULTS               = "Valores globales";
    HEALBOT_OPTIONS_UNUSEDDEFAULTS         = "Valores no usados";
    HEALBOT_OPTIONS_LOCALDEFAULTS          = "Valores locales";
    HEALBOT_OPTIONS_CLOSE                  = "Cerrar";
    HEALBOT_OPTIONS_HARDRESET              = "Recargar IU"
    HEALBOT_OPTIONS_SOFTRESET              = "Reiniciar HealBot"
    HEALBOT_OPTIONS_COPY                   = "Copiar";
    HEALBOT_OPTIONS_TAB_GENERAL            = "General";
    HEALBOT_OPTIONS_TAB_SPELLS             = "Hechizos";
    HEALBOT_OPTIONS_ABILITYSELECT          = "Selector de facultad"
    HEALBOT_OPTIONS_TAB_FRAMES             = "Marcos";
    HEALBOT_OPTIONS_TAB_HEALING            = "Sanación";
    HEALBOT_OPTIONS_TAB_SKIN               = "Apariencias";
    HEALBOT_OPTIONS_TAB_TIPS               = "Descripciones";
    HEALBOT_OPTIONS_TAB_DEBUFFS            = "Perjuicios"
    HEALBOT_OPTIONS_TAB_CUSTOM_DEBUFFS     = "Perjuicios personalizados";
    HEALBOT_OPTIONS_TAB_CUSTOM_BUFFS       = "Beneficios personalizados";
    HEALBOT_OPTIONS_CDEBUFFS_DISCORD       = "Los perjuicios personalizados se pueden compartir en Discord en el canal #share";
    HEALBOT_OPTIONS_CBUFFS_DISCORD         = "Los beneficios personalizados se pueden compartir en Discord en el canal #share";
    HEALBOT_OPTIONS_SKINS_DISCORD          = "Las apariencias se pueden compartir en Discord en el canal #share";
    HEALBOT_OPTIONS_SPELLS_DISCORD         = "Los hechizos se pueden compartir en Discord en el canal #share";
    HEALBOT_OPTIONS_PRECOLS_DISCORD        = "Los colores predefinidos se pueden compartir en Discord en el canal #share";
    HEALBOT_OPTIONS_TAB_BUFFS              = "Beneficios"
    HEALBOT_OPTIONS_TAB_GENERALBUFFS       = "Beneficios generales"
    HEALBOT_OPTIONS_TAB_STATETEXT          = "Estado";
    HEALBOT_OPTIONS_TAB_NAMETEXT           = "Nombre";
    HEALBOT_OPTIONS_TAB_OVERRIDES          = "Anulaciones"
    HEALBOT_OPTIONS_TAB_EXTRAS             = "Extras"

    HEALBOT_STRING_MATCH_WELLFED           = "[b|B]ien alimentad[o|a]"
    HEALBOT_STRING_MATCH_RESTOREMANA       = "[m|M]aná durante (%d+) s"
    HEALBOT_STRING_MATCH_EXTRABUFFS        = {"^Frasco", "^Elixir", "^Pergamino", "^Poción", "^Runa"}
    HEALBOT_HEARTY_WELL_FED                = "Bien alimentado copioso"
    HEALBOT_WELL_FED                       = "Bien alimentado"
    HEALBOT_MANA_DRINK                     = "Bebida de maná"
    HEALBOT_MANA_LOWTHRESHOLD              = "Umbral de maná bajo"

    HEALBOT_OPTIONS_GLOBAL                 = "Global"
    HEALBOT_OPTIONS_ALPHA                  = "Opacidad";
    HEALBOT_OPTIONS_MINALPHA               = "Opacidad mínima";
    HEALBOT_OPTIONS_MAXALPHA               = "Opacidad máxima";
    HEALBOT_OPTIONS_MINUNITS               = "N.º mínimo de jugadores";
    HEALBOT_OPTIONS_BARALPHA               = "Opacidad habilitada";
    HEALBOT_OPTIONS_BARALPHAINHEAL         = "Opacidad de sanaciones entrantes";
    HEALBOT_OPTIONS_BARALPHABACK           = "Opacidad de barra de fondo";
    HEALBOT_OPTIONS_BARALPHABOR            = "Opacidad de borde de fondo";
    HEALBOT_OPTIONS_BARALPHAEOR            = "Opacidad fuera de alcance";
    HEALBOT_OPTIONS_ACTIONLOCKED           = "Bloquear marco";
    HEALBOT_OPTIONS_UNITINCOMBAT           = "Miembro del grupo/banda entra en combate"
    HEALBOT_OPTIONS_UNITINCOMBAT01         = "No hacer nada"
    HEALBOT_OPTIONS_UNITINCOMBAT02         = "Mostrar marco de enemigos"
    HEALBOT_OPTIONS_UNITINCOMBAT03         = "Bloquear HealBot"
    HEALBOT_OPTIONS_AUTOSHOW               = "Cerrar automáticamente";
    HEALBOT_OPTIONS_PANELSOUNDS            = "Reproducir sonido al abrir";
    HEALBOT_OPTIONS_FRAMEGLOWSIZE          = "Tamaño del resplandor de barra";
    HEALBOT_OPTIONS_ICONGLOWSIZE           = "Tamaño del resplandor de icono";
    HEALBOT_OPTIONS_ICONLOCK               = "Bloqueo de icono";
    HEALBOT_OPTIONS_HIDEOPTIONS            = "Ocultar botón de opciones";
    HEALBOT_OPTIONS_HIDEUNLOCKEDTAG        = "Ocultar etiqueta de desbloqueado"
    HEALBOT_OPTIONS_PROTECTPVP             = "Evitar JcJ";
    HEALBOT_OPTIONS_HEAL_CHATOPT           = "Opciones de chat";
    HEALBOT_OPTIONS_BLIZZARD_FRAMES        = "Marcos de Blizzard";
    HEALBOT_OPTIONS_TOTALHEALABSORBS       = "Absorciones de sanación totales";

    HEALBOT_OPTIONS_FRAMESCALE             = "Escala del marco"
    HEALBOT_OPTIONS_STICKFRAMEOFFSETH      = "Desplazamiento horizontal de marco adhesivo"
    HEALBOT_OPTIONS_STICKFRAMEOFFSETV      = "Desplazamiento vertical de marco adhesivo"
    HEALBOT_OPTIONS_SKINTEXT               = "Usar apariencia"
    HEALBOT_SKINS_STD                      = "Estándar"
    HEALBOT_OPTIONS_SKINTEXTURE            = "Textura"
    HEALBOT_OPTIONS_SKINTEXTURES           = "Texturas"
    HEALBOT_OPTIONS_SKINHEIGHT             = "Altura"
    HEALBOT_OPTIONS_SKINWIDTH              = "Anchura"
    HEALBOT_OPTIONS_SKINNUMCOLS            = "Número de columnas"
    HEALBOT_OPTIONS_SKINNUMHCOLS           = "Número de grupos por columna"
    HEALBOT_OPTIONS_SKINBRSPACE            = "Espaciado entre filas"
    HEALBOT_OPTIONS_SKINBCSPACE            = "Espaciado entre columnas"
    HEALBOT_OPTIONS_EXTRASORT              = "Orden de barras"
    HEALBOT_SORTBY_NAME                    = "Nombre"
    HEALBOT_SORTBY_CLASS                   = "Clase"
    HEALBOT_SORTBY_GROUP                   = "Grupo"
    HEALBOT_SORTBY_MAXHEALTH               = "Salud máxima"
    HEALBOT_SORTBY_UNITID                  = "ID de unidad"
    HEALBOT_OPTION_INGROUP                 = "En grupo"
    HEALBOT_OPTION_INRAID                  = "En banda"
    HEALBOT_OPTIONS_NEWDEBUFFTEXT          = "Nuevo perjuicio"
    HEALBOT_OPTIONS_NEWHOTBUFFTEXT         = "Nuevo beneficio"
    HEALBOT_OPTIONS_ADDNEWDEBUFFTEXT       = "Añadir nuevo perjuicio"
    HEALBOT_OPTIONS_ADDNEWBUFFTEXT         = "Añadir nuevo beneficio"
    HEALBOT_WORD_TAG                       = "Etiqueta"
    HEALBOT_WORD_MISSING                   = "Faltante"
    HEALBOT_WORD_DISPEL                    = "Disipar"
    HEALBOT_OPTIONS_DELSKIN                = "Eliminar"
    HEALBOT_OPTIONS_NEWSKINTEXT            = "Nueva apariencia"
    HEALBOT_OPTIONS_SAVESKIN               = "Guardar"
    HEALBOT_OPTIONS_SKINBARS               = "Opciones de barras"
    HEALBOT_SKIN_ENTEXT                    = "Habilitado"
    HEALBOT_SKIN_DISTEXT                   = "Deshabilitado"
    HEALBOT_SKIN_DEBTEXT                   = "Perjuicio"
    HEALBOT_SKIN_BACKTEXT                  = "Fondo"
    HEALBOT_SKIN_BORDERTEXT                = "Borde"
    HEALBOT_OPTIONS_SKINFONT               = "Fuente"
    HEALBOT_OPTIONS_SKINFONTS              = "Fuentes"
    HEALBOT_OPTIONS_SKINFHEIGHT            = "Tamaño de fuente"
    HEALBOT_OPTIONS_SKINFOUTLINE           = "Contorno de fuente"
    HEALBOT_OPTIONS_BARALPHADIS            = "Opacidad deshabilitada"
    HEALBOT_OPTIONS_SHOWHEADERS            = "Mostrar cabeceras"
    HEALBOT_OPTIONS_SKINSETTINGS           = "Ajustes de apariencia"
    HEALBOT_OPTIONS_OVERRIDESETTINGS       = "Ajustes de anulación"
    HEALBOT_OPTIONS_PRESETCOLOURBTN        = "*"
    HEALBOT_OPTIONS_PRESET                 = "Preajuste"
    HEALBOT_OPTIONS_ICONPOSITION           = "Posición del icono"
    HEALBOT_OPTIONS_POSITION               = "Posición"
    HEALBOT_OPTIONS_COORDINATES            = "Coordenadas"
    HEALBOT_OPTIONS_COORDINATESFIXED       = "Coordenadas fijas"
    HEALBOT_OPTIONS_ICONANCHOR             = "Anclaje del icono"
    HEALBOT_OPTIONS_PLUGINCOLS             = "Colores de complementos"
    HEALBOT_OPTIONS_DEBUFFCOLS             = "Colores de perjuicios"
    HEALBOT_OPTIONS_BUFFCOLS               = "Colores de beneficios"

    HEALBOT_OPTIONS_ITEMS                  = "Objetos";
    HEALBOT_OPTIONS_ITEM                   = "Objeto";
    HEALBOT_OPTIONS_SPELL                  = "Hechizo";

    HEALBOT_OPTIONS_COMBOCLASS             = "Combinaciones de teclas para";
    HEALBOT_OPTIONS_CLICK                  = "Clic";
    HEALBOT_OPTIONS_SHIFT                  = "Mayús";
    HEALBOT_OPTIONS_CTRL                   = "Ctrl";
    HEALBOT_OPTIONS_ENABLEHEALTHY          = "Siempre habilitado";
    HEALBOT_OPTIONS_FADEONEXPIRE           = "Atenuar al expirar";
    HEALBOT_OPTIONS_FADESTARTTIME          = "Tiempo de inicio de atenuación";
    HEALBOT_OPTIONS_SPELLSTARGETLASTTARGET = "Objetivo automático: tras lanzar, seleccionar último objetivo"

    HEALBOT_OPTIONS_PC                     = "Jugador"
    HEALBOT_OPTIONS_NPC                    = "No jugador"
    HEALBOT_OPTIONS_CASTNOTIFY1            = "Sin mensajes";
    HEALBOT_OPTIONS_CASTNOTIFY2            = "Notificar a uno mismo";
    HEALBOT_OPTIONS_CASTNOTIFY3            = "Notificar al objetivo";
    HEALBOT_OPTIONS_CASTNOTIFY4            = "Notificar al grupo o banda";
    HEALBOT_OPTIONS_CASTNOTIFY5            = "Notificar por decir";
    HEALBOT_OPTIONS_CASTNOTIFY6            = "Notificar por gritar";
    HEALBOT_OPTIONS_CASTNOTIFYRESONLY      = "Notificar solo para resurrección";
    HEALBOT_OPTIONS_EOC_OOM                = "Tras el combate, avisar si queda poco maná"
    HEALBOT_OPTIONS_EOC_OOM_VALUE          = "Cuando el maná sea inferior a"

    HEALBOT_OPTIONS_CDCBARS                = "Colores de barra";
    HEALBOT_OPTIONS_CDCSHOWHBARS           = "Cambiar color de barra de salud";
    HEALBOT_OPTIONS_ALWAYSENABLEBAR        = "Habilitar siempre la barra";
    HEALBOT_OPTIONS_CDCSHOWABARS           = "Cambiar color de barra de amenaza";
    HEALBOT_OPTIONS_CDCWARNINGS            = "Avisos de perjuicios";
    HEALBOT_OPTIONS_BUFFWARNINGS           = "Avisos de beneficios";
    HEALBOT_OPTIONS_EMERGDEBUFFWARNINGS    = "Resplandecer solo cuando sea disipable";
    HEALBOT_OPTIONS_EMERGBUFFWARNINGS      = "Resplandecer solo cuando falte";
    HEALBOT_OPTIONS_BUFFCUSTOM             = "Beneficios personalizados";
    HEALBOT_OPTIONS_ADDBUFFCUSTOM          = "Añadir beneficios personalizados"
    HEALBOT_OPTIONS_ADDBUFFBYNAME          = "Añadir beneficio por nombre o ID de hechizo"
    HEALBOT_OPTIONS_ADDBUFFBYSELF          = "Beneficios lanzados por mí"
    HEALBOT_OPTIONS_ADDBUFFBYHISTORY       = "Beneficios históricos lanzados por aliados"
    HEALBOT_OPTIONS_ADDBUFFBYCLASS         = "Beneficios lanzados por mi clase"
    HEALBOT_OPTIONS_ADDBUFFBYOTHER         = "Beneficios lanzados por otras clases"
    HEALBOT_OPTIONS_DEBUFFCUSTOM           = "Perjuicios personalizados"
    HEALBOT_OPTIONS_ADDDEBUFFCUSTOM        = "Añadir perjuicios personalizados"
    HEALBOT_OPTIONS_ADDDEBUFFBYNAME        = "Añadir perjuicio por nombre o ID de hechizo"
    HEALBOT_OPTIONS_ADDDEBUFFBYHISTORY     = "Perjuicios históricos lanzados por enemigos"
    HEALBOT_OPTIONS_ADDDEBUFFBYSELF        = "Perjuicios lanzados por mí"
    HEALBOT_OPTIONS_ADDDEBUFFBYFRIEND      = "Perjuicios lanzados por aliados"
    HEALBOT_OPTIONS_ADDDEBUFFBYENEMY       = "Perjuicios lanzados por enemigos"
    HEALBOT_OPTIONS_BUFFMISSING            = "Beneficios faltantes";
    HEALBOT_OPTIONS_BUFFEXTRA              = "Beneficios adicionales";
    HEALBOT_OPTIONS_CHECKWELLFED           = "Comprobar bien alimentado";
    HEALBOT_OPTIONS_CHECKLOWMANA           = "Comprobar maná bajo"
    HEALBOT_OPTIONS_DEBUFFDISPELL          = "Perjuicios generales";
    HEALBOT_OPTIONS_SHOWDEBUFFICON         = "Mostrar icono de perjuicio";
    HEALBOT_OPTIONS_SHOWDEBUFFWARNING      = "Mostrar aviso en perjuicio";
    HEALBOT_OPTIONS_SOUNDDEBUFFWARNING     = "Reproducir sonido en perjuicio";
    HEALBOT_OPTIONS_WARNINGDISPELLONLY     = "Solo cuando sea disipable";
    HEALBOT_OPTIONS_WARNINGMISSINGONLY     = "Solo cuando falte";
    HEALBOT_OPTIONS_STATEDEBUFFS           = "Perjuicios disipables"
    HEALBOT_OPTIONS_SHOWBUFFWARNING        = "Mostrar aviso en beneficio";
    HEALBOT_OPTIONS_SOUNDBUFFWARNING       = "Reproducir sonido en beneficio";
    HEALBOT_OPTIONS_SOUND                  = "Sonido"
    HEALBOT_OPTIONS_SOUNDS                 = "Sonidos"
    HEALBOT_OPTIONS_SOUNDCHAN              = "Canal de sonido"
    HEALBOT_OPTIONS_SOUNDCHAN1             = "General"
    HEALBOT_OPTIONS_SOUNDCHAN2             = "Efectos"
    HEALBOT_OPTIONS_SOUNDCHAN3             = "Ambiente"
    HEALBOT_OPTIONS_SOUNDCHAN4             = "Diálogo"
    HEALBOT_OPTIONS_WARN_CLASSCOL          = "No se puede cambiar el color del texto cuando\nla opción «Colorear texto por clase» está activada"

    HEALBOT_OPTIONS_HEAL_BUTTONS           = "Barras de sanación:";
    HEALBOT_OPTIONS_PLAYERVISIBILITY       = "Visibilidad de jugadores y mascotas";
    HEALBOT_OPTIONS_TARGETVISIBILITY       = "Visibilidad de objetivo";
    HEALBOT_OPTIONS_FOCUSVISIBILITY        = "Visibilidad de foco";
    HEALBOT_OPTIONS_PLAYERSORT             = "Orden de jugadores"
    HEALBOT_OPTIONS_VEHICLESORT            = "Orden de vehículos"
    HEALBOT_OPTIONS_PETSORT                = "Orden de mascotas"
    HEALBOT_OPTIONS_ENEMYSORT              = "Orden de enemigos"
    HEALBOT_OPTIONS_SELFHEALS              = "Uno mismo"
    HEALBOT_OPTIONS_PETHEALS               = "Mascotas"
    HEALBOT_WORD_PET                       = "Mascota"
    HEALBOT_WORD_MYPET                     = "Mi mascota"
    HEALBOT_OPTIONS_GROUPHEALS             = "Sanación de grupo";
    HEALBOT_OPTIONS_TANKHEALS              = "Tanques principales";
    HEALBOT_OPTIONS_MAINASSIST             = "Asistente principal";
    HEALBOT_OPTIONS_SINGLE                 = "Individual ";
    HEALBOT_OPTIONS_SINGLETANK             = "Tanque individual";
    HEALBOT_OPTIONS_TANK1                  = "Tanque 1";
    HEALBOT_OPTIONS_TANK2                  = "Tanque 2";
    HEALBOT_OPTIONS_PRIVATETANKS           = "Tanques privados";
    HEALBOT_OPTIONS_SINGLEHEALER           = "Sanador individual";
    HEALBOT_OPTIONS_PRIVATEHEALERS         = "Sanadores privados";
    HEALBOT_OPTIONS_SINGLEDAMAGER          = "Atacante individual";
    HEALBOT_OPTIONS_SINGLECASTER           = "Taumaturgo individual";
    HEALBOT_OPTIONS_PRIVATEDAMAGERS        = "Atacantes privados";
    HEALBOT_OPTIONS_TARGETHEALS            = "Objetivo";
    HEALBOT_OPTIONS_EMERGENCYHEALS         = "Banda";
    HEALBOT_OPTIONS_ALERTLEVEL             = "Nivel de alerta";
    HEALBOT_OPTIONS_ID                     = "ID";
    HEALBOT_OPTIONS_ICONID                 = "ID de icono";
    HEALBOT_OPTIONS_ABILITY                = "Facultad";
    HEALBOT_OPTIONS_HIGHLIGHTSTATE         = "Estado de resaltado";
    HEALBOT_OPTIONS_CONFIG                 = "Configurar"
    HEALBOT_OPTIONS_RAID10                 = HEALBOT_OPTIONS_EMERGENCYHEALS .. " 10";
    HEALBOT_OPTIONS_RAID15                 = HEALBOT_OPTIONS_EMERGENCYHEALS .. " 15";
    HEALBOT_OPTIONS_RAID20                 = HEALBOT_OPTIONS_EMERGENCYHEALS .. " 20";
    HEALBOT_OPTIONS_RAID25                 = HEALBOT_OPTIONS_EMERGENCYHEALS .. " 25";
    HEALBOT_OPTIONS_RAID40                 = HEALBOT_OPTIONS_EMERGENCYHEALS .. " 40";
    HEALBOT_OPTIONS_EMERGFILTER            = "Mostrar barras para";
    HEALBOT_OPTIONS_EMERGFCLASS            = "Configurar clases para";
    HEALBOT_OPTIONS_MODIFIER               = "Tecla modificadora"
    HEALBOT_OPTIONS_MODIFIERKEYS           = "Teclas modificadoras:"
    HEALBOT_OPTIONS_COMBOBUTTON            = "Botón";
    HEALBOT_OPTIONS_BUTTONANY              = "Cualquier botón";
    HEALBOT_OPTIONS_BUTTONLEFT             = "Izquierdo";
    HEALBOT_OPTIONS_BUTTONMIDDLE           = "Central";
    HEALBOT_OPTIONS_BUTTONRIGHT            = "Derecho";
    HEALBOT_OPTIONS_BUTTON4                = "Botón 4";
    HEALBOT_OPTIONS_BUTTON5                = "Botón 5";
    HEALBOT_OPTIONS_BUTTON6                = "Botón 6";
    HEALBOT_OPTIONS_BUTTON7                = "Botón 7";
    HEALBOT_OPTIONS_BUTTON8                = "Botón 8";
    HEALBOT_OPTIONS_BUTTON9                = "Botón 9";
    HEALBOT_OPTIONS_BUTTON10               = "Botón 10";
    HEALBOT_OPTIONS_BUTTON11               = "Botón 11";
    HEALBOT_OPTIONS_BUTTON12               = "Botón 12";
    HEALBOT_OPTIONS_BUTTON13               = "Botón 13";
    HEALBOT_OPTIONS_BUTTON14               = "Botón 14";
    HEALBOT_OPTIONS_BUTTON15               = "Botón 15";
    HEALBOT_OPTIONS_BUTTON16               = "Botón 16";
    HEALBOT_OPTIONS_BUTTON17               = "Botón 17";
    HEALBOT_OPTIONS_BUTTON18               = "Botón 18";
    HEALBOT_OPTIONS_BUTTON19               = "Botón 19";
    HEALBOT_OPTIONS_BUTTON20               = "Botón 20";

    HEALBOT_OPTIONS_BINDKEYTOCLICK         = "Asignar una tecla a un clic de botón"

    HEALBOT_CLASSES_ALL                    = "Todas (sin clase específica)";
    HEALBOT_CLASSES_MELEE                  = "Cuerpo a cuerpo";
    HEALBOT_CLASSES_RANGES                 = "A distancia";
    HEALBOT_CLASSES_HEALERS                = "Sanadores";
    HEALBOT_CLASSES_CUSTOM                 = "Personalizado";

    HEALBOT_OPTIONS_DEBUFFNAME             = "Nombre del perjuicio"
    HEALBOT_OPTIONS_DEBUFFAUTOTOCUSTOM     = "Añadir a lista personalizada"
    HEALBOT_OPTIONS_SHOWTOOLTIP            = "Mostrar descripciones emergentes";
    HEALBOT_OPTIONS_SHOWDETTOOLTIP         = "Mostrar información detallada del hechizo";
    HEALBOT_OPTIONS_SHOWCDTOOLTIP          = "Mostrar reutilización del hechizo";
    HEALBOT_OPTIONS_SHOWICONBINFOTIP       = "Mostrar información del icono de beneficio";
    HEALBOT_OPTIONS_COMPACT                = "Compacto";
    HEALBOT_OPTIONS_SHOWICONDINFOTIP       = "Mostrar información del icono de perjuicio";
    HEALBOT_OPTIONS_COOLDOWNTEXT           = "Texto de reutilización";
    HEALBOT_OPTIONS_COUNTTEXT              = "Texto de acumulaciones";
    HEALBOT_OPTIONS_IGNOREGCDTOOLTIP       = "Ignorar reutilización global del hechizo";
    HEALBOT_OPTIONS_SHOWMOUSEWHEELTOOLTIP  = "Mostrar comandos de la rueda del ratón"
    HEALBOT_OPTIONS_SHOWUNITTOOLTIP        = "Mostrar información del objetivo";
    HEALBOT_OPTIONS_SHOWRECTOOLTIP         = "Mostrar recomendación de sanación en el tiempo";
    HEALBOT_TOOLTIP_POSDEFAULT             = "Ubicación predeterminada";
    HEALBOT_TOOLTIP_POSLEFT                = "A la izquierda del marco";
    HEALBOT_TOOLTIP_POSRIGHT               = "A la derecha del marco";
    HEALBOT_TOOLTIP_POSABOVE               = "Encima del marco";
    HEALBOT_TOOLTIP_POSBELOW               = "Debajo del marco";
    HEALBOT_TOOLTIP_POSCURSOR              = "Junto al cursor";
    HEALBOT_TOOLTIP_RECOMMENDTEXT          = "Recomendación de sanación en el tiempo";
    HEALBOT_TOOLTIP_NONE                   = "ninguna disponible";
    HEALBOT_TOOLTIP_CORPSE                 = "Cadáver de ";
    HEALBOT_TOOLTIP_CD                     = "  (";
    HEALBOT_TOOLTIP_SECS                   = " s)";
    HEALBOT_TOOLTIP_MINS                   = " min)";
    HEALBOT_TOOLTIP_HEADERFONT             = "Fuente de cabecera";
    HEALBOT_TOOLTIP_DETAILFONT             = "Fuente de detalle";
    HEALBOT_TOOLTIP_HEADERFONTSIZE         = "Tamaño de fuente de cabecera";
    HEALBOT_TOOLTIP_DETAILFONTSIZE         = "Tamaño de fuente de detalle";
    HEALBOT_TOOLTIP_SHOWASSIGNEDSPELLS     = "Mostrar hechizos asignados"
    HEALBOT_TOOLTIP_SHOWSPELLEXTRA         = "Mostrar información adicional"
    HEALBOT_TOOLTIP_SHOWHEALTH             = "Mostrar salud"
    HEALBOT_TOOLTIP_SHOWMANA               = "Mostrar maná"
    HEALBOT_TOOLTIP_SHOWLEVEL              = "Mostrar nivel"
    HEALBOT_TOOLTIP_SHOWSPEC               = "Mostrar especialización"
    HEALBOT_WORDS_COOLDOWN                 = "Reutilización"
    HEALBOT_WORDS_TINY                     = "Diminuto"
    HEALBOT_WORDS_SMALL                    = "Pequeño"
    HEALBOT_WORDS_SMALLER                  = "Más pequeño"
    HEALBOT_WORDS_MEDIUM                   = "Mediano"
    HEALBOT_WORDS_LARGE                    = "Grande"
    HEALBOT_WORDS_LARGER                   = "Más grande"
    HEALBOT_WORDS_HUGE                     = "Enorme"
    HEALBOT_WORDS_SHORT                    = "Corto";
    HEALBOT_WORDS_LONG                     = "Largo";
    HEALBOT_WORDS_SEC                      = "s";
    HEALBOT_WORDS_CAST                     = "Lanzamiento";
    HEALBOT_WORDS_UNKNOWN                  = "Desconocido";
    HEALBOT_WORDS_YES                      = "Sí";
    HEALBOT_WORDS_NO                       = "No";
    HEALBOT_WORDS_OK                       = "Aceptar";
    HEALBOT_WORDS_THIN                     = "Fino";
    HEALBOT_WORDS_THICK                    = "Grueso";

    HEALBOT_WORDS_NONE                     = "Ninguno";
    HEALBOT_OPTIONS_ALT                    = "Alt";
    HEALBOT_OPTIONS_LOCKOFF                = "Siempre desbloqueado";
    HEALBOT_OPTIONS_LOCKON                 = "Siempre bloqueado";
    HEALBOT_OPTIONS_LOCKCTRL               = "Desbloquear con Ctrl";
    HEALBOT_OPTIONS_LOCKALT                = "Desbloquear con Alt";
    HEALBOT_OPTIONS_LOCKCTRLALT            = "Desbloquear con Ctrl + Alt";
    HEALBOT_DISABLED_TARGET                = "Objetivo";
    HEALBOT_OPTIONS_SHOWCLASSONBAR         = "Mostrar clase en la barra";
    HEALBOT_OPTIONS_SHOWHEALTHONBAR        = "Mostrar salud en la barra";
    HEALBOT_OPTIONS_HIDEHEALTHONMAX        = "Ocultar salud al máximo";
    HEALBOT_OPTIONS_HEALTHINCPERCENT       = "Incluir porcentaje";
    HEALBOT_OPTIONS_HEALTHINVEHSHOWPLAYER  = "En vehículo, mostrar también al jugador";
    HEALBOT_OPTIONS_SHOWTEXT               = "Mostrar texto";
    HEALBOT_OPTIONS_VERTTEXT               = "Texto vertical";
    HEALBOT_OPTIONS_IGNOREINCOMINGONFULL   = "Con salud al máximo, ignorar sanaciones entrantes y efectos de " .. HEALBOT_classicABSORBHOT;
    HEALBOT_OPTIONS_TEXTONLYTIP            = "Mostrar solo en la descripción emergente";
    HEALBOT_OPTIONS_TEXTSTATENAMEFONT      = "Usar cadena de fuente del nombre";
    HEALBOT_OPTIONS_BARHEALTHINCHEALS      = "Incluir sanaciones entrantes";
    HEALBOT_OPTIONS_BARHEALTHSEPHEALS      = "Separar sanaciones entrantes";
    HEALBOT_OPTIONS_BARHEALTHINCABSORBS    = "Incluir efectos de " .. HEALBOT_classicABSORBHOT
    HEALBOT_OPTIONS_BARHEALTHSEPABSORBS    = "Separar efectos de " .. HEALBOT_classicABSORBHOT
    HEALBOT_OPTIONS_BARHEALTHMYOVERHEALS   = "Mostrar mi sobresanación";
    HEALBOT_OPTIONS_BARHEALTHALLOVERHEALS  = "Mostrar toda la sobresanación";
    HEALBOT_OPTIONS_BARHEALTH1             = "como diferencia";
    HEALBOT_OPTIONS_BARHEALTH2             = "como porcentaje";
    HEALBOT_OPTIONS_TIPTEXT                = "General de descripciones emergentes";
    HEALBOT_OPTIONS_TIPTEXT2               = "Información de unidad en descripción emergente";
    HEALBOT_OPTIONS_TIPTEXT3               = "Información de hechizo en descripción emergente";
    HEALBOT_OPTIONS_POSTOOLTIP             = "Posición de la descripción emergente";
    HEALBOT_OPTIONS_SHOWNAMEONBAR          = "Mostrar nombre en la barra";
    HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR1    = "Colorear texto por clase";
    HEALBOT_OPTIONS_EMERGFILTERGROUPS      = "Incluir grupos";
    HEALBOT_OPTIONS_EMERGFILTERGROUPSRAID  = "Solo grupo de sanación de banda";
    HEALBOT_OPTIONS_PLAYERPET              = "Jugadores y mascotas"

    HEALBOT_ONE                            = "1";
    HEALBOT_TWO                            = "2";
    HEALBOT_THREE                          = "3";
    HEALBOT_FOUR                           = "4";
    HEALBOT_FIVE                           = "5";
    HEALBOT_SIX                            = "6";
    HEALBOT_SEVEN                          = "7";
    HEALBOT_EIGHT                          = "8";

    HEALBOT_OPTIONS_SETDEFAULTS            = "Restablecer valores predeterminados";
    HEALBOT_OPTIONS_SETDEFAULTSMSG         = "Restablecer todas las opciones de todos los personajes\na sus valores predeterminados";
    HEALBOT_OPTIONS_SETLOCALDEFAULTSMSG    = "Restablecer hechizos/beneficios/perjuicios de este personaje\na sus valores predeterminados";
    HEALBOT_OPTIONS_RESETSPELLSMSG         = "Restablecer los hechizos de este personaje a sus valores predeterminados";
    HEALBOT_OPTIONS_RIGHTBOPTIONS          = "El clic derecho abre las opciones";

    HEALBOT_OPTIONS_HEADEROPTTEXT          = "Opciones de cabeceras";
    HEALBOT_OPTIONS_ICONOPTTEXT            = "Opciones de iconos";
    HEALBOT_OPTIONS_BARHEADEROPTTEXT       = "Opciones de cabecera de barras";
    HEALBOT_OPTIONS_FRAMEHEADEROPTTEXT     = "Opciones de cabecera de marco";
    HEALBOT_OPTIONS_ACTIONICONSGENOPTTEXT  = "Opciones generales";
    HEALBOT_OPTIONS_ACTIONICONSGENOPTTEXT2 = "Cada personaje puede tener diferentes ajustes de iconos de acción por apariencia.";
    HEALBOT_OPTIONS_ACTIONICONSOPTTEXT     = "Opciones de iconos";
    HEALBOT_OPTIONS_ACTIONICONSCOPTTEXT    = "Configuración de iconos";
    HEALBOT_OPTIONS_ICONBUFFOPTTEXT        = "Opciones de iconos de beneficios";
    HEALBOT_OPTIONS_ICONDEBUFFOPTTEXT      = "Opciones de iconos de perjuicios";
    HEALBOT_OPTIONS_ICONOPTCLASSROLEBUTTON = "Clase / Rol"
    HEALBOT_OPTIONS_ICONOPTCLASSROLE       = "Opciones de icono de Clase / Rol";
    HEALBOT_OPTIONS_ICONOPTRANKBUTTON      = "Rango"
    HEALBOT_OPTIONS_ICONOPTRAIDTARGETBUTTON= "Objetivo de banda"
    HEALBOT_OPTIONS_ICONOPTRANK            = "Opciones de icono de rango";
    HEALBOT_OPTIONS_ICONOPTRAIDTARGET      = "Opciones de icono de objetivo de banda";
    HEALBOT_OPTIONS_ICONOPTCOMBAT          = "Opciones de icono de combate";
    HEALBOT_OPTIONS_ICONOPTREADYCHECK      = "Opciones de icono de estado";
    HEALBOT_OPTIONS_ICONOPTOORARROW        = "Opciones de flecha fuera de alcance";
    HEALBOT_OPTIONS_ICONOPTOORARROWBUTTON  = "Flecha FdA";
    HEALBOT_OPTIONS_NAMEROLELABELTEXT      = "Texto de etiqueta de rol";
    HEALBOT_OPTIONS_STATEOPTTEXT           = "Opciones de texto de estado";
    HEALBOT_OPTIONS_NAMEOPTTEXT            = "Opciones de texto de nombre";
    HEALBOT_OPTIONS_HEALTHOPTTEXT          = "Opciones de texto de salud";
    HEALBOT_OPTIONS_AGGROOPTTEXT           = "Opciones de texto de amenaza";
    HEALBOT_OPTIONS_EXTRAHOPTOVERHEAL      = "Opciones de sobresanación";
    HEALBOT_OPTIONS_EXTRAHOPTINHEAL        = "Opciones de sanaciones entrantes";
    HEALBOT_OPTIONS_AUXOPTTEXT             = "Opciones de texto auxiliar";
    HEALBOT_OPTIONS_TABNOTAVAIL            = "Pestaña no disponible con el marco actual";
    HEALBOT_OPTIONS_STATEOPTCOLOUR         = "Opciones de color de estado";
    HEALBOT_OPTIONS_NAMEOPTCOLOUR          = "Opciones de color de nombre";
    HEALBOT_OPTIONS_HEALTHOPTCOLOUR        = "Opciones de color de salud";
    HEALBOT_OPTIONS_AGGROOPTCOLOUR         = "Opciones de color de amenaza";
    HEALBOT_OPTIONS_AUXOPTCOLOUR           = "Opciones de color auxiliar";
    HEALBOT_OPTIONS_HEALTHTEXTANCHOR       = "Anclaje de texto de salud";
    HEALBOT_OPTIONS_AGGROTEXTANCHOR        = "Anclaje de texto de amenaza";
    HEALBOT_OPTIONS_STATETEXTANCHOR        = "Anclaje de texto de estado";
    HEALBOT_OPTIONS_AGGROINDTEXT           = "Indicador de amenaza en el nombre";
    HEALBOT_OPTIONS_OVERHEALFORMAT         = "Formato de sobresanación";
    HEALBOT_OPTIONS_OVERHEALCOLOUR         = "Color de sobresanación";
    HEALBOT_OPTIONS_SEPARATEFORMAT         = "Formato separado";
    HEALBOT_OPTIONS_SEPARATECOLOUR         = "Color separado";
    HEALBOT_OPTIONS_PERCENTAGEFORMAT       = "Formato de porcentaje";
    HEALBOT_SKIN_HEADERBARCOL              = "Color de barra";
    HEALBOT_SKIN_HEADERTEXTCOL             = "Color de texto";
    HEALBOT_SKIN_ICONGLOWCOL               = "Color de resplandor"
    HEALBOT_SKIN_ICONGLOWTIMEOUT           = "Tiempo de espera del resplandor"
    HEALBOT_SKIN_GLOWSIZE                  = "Tamaño del resplandor"
    HEALBOT_SKIN_GLOWEFFECT                = "Efecto de resplandor"
    HEALBOT_SKIN_ICONGLOW                  = "Resplandor de icono";
    HEALBOT_SKIN_ICONSET                   = "Conjunto de iconos";
    HEALBOT_SKIN_ICONBUFFSET01             = "Conjunto de iconos de beneficio 1";
    HEALBOT_SKIN_ICONBUFFSET02             = "Conjunto de iconos de beneficio 2";
    HEALBOT_SKIN_ICONBUFFSET03             = "Conjunto de iconos de beneficio 3";
    HEALBOT_SKIN_ICONDEBUFFSET01           = "Conjunto de iconos de perjuicio 1";
    HEALBOT_SKIN_ICONDEBUFFSET02           = "Conjunto de iconos de perjuicio 2";
    HEALBOT_SKIN_ICONDEBUFFSET03           = "Conjunto de iconos de perjuicio 3";
    HEALBOT_OPTIONS_BUFFSTEXT1             = "Hechizo para aplicar beneficio";
    HEALBOT_OPTIONS_BUFFSTEXTWE            = "Encantamientos de arma";
    HEALBOT_OPTIONS_BUFFSTEXTWEMAIN        = "Mano principal / 2M";
    HEALBOT_OPTIONS_BUFFSTEXTWEOFF         = "Mano secundaria";
    HEALBOT_OPTIONS_ITEMNAME               = "Nombre del objeto";
    HEALBOT_OPTIONS_SPELLITEMNAME          = "Nombre del hechizo / Nombre del objeto";
    HEALBOT_OPTIONS_PRIMARYITEM            = "Objeto principal";
    HEALBOT_OPTIONS_BACKUPITEM             = "Objeto de reserva";
    HEALBOT_OPTIONS_BUFFSTEXT2             = "comprobar miembros";
    HEALBOT_OPTIONS_BUFFSTEXT3             = "colores de barra";
    HEALBOT_OPTIONS_EMERGCOLS              = "Colores de emergencia";
    HEALBOT_OPTIONS_EMERGGENERAL           = "General de emergencia";
    HEALBOT_OPTIONS_EMERGSPELLS            = "Hechizos de emergencia";
    HEALBOT_OPTIONS_ICONSCMD               = "Comandos de iconos";
    HEALBOT_OPTIONS_BUFF                   = "Beneficio ";
    HEALBOT_OPTIONS_BUFFSELF               = "en uno mismo";
    HEALBOT_OPTIONS_BUFFPARTY              = "en el grupo";
    HEALBOT_OPTIONS_BUFFRAID               = "en la banda";
    HEALBOT_OPTIONS_MONITORBUFFS           = "Supervisar beneficios";
    HEALBOT_OPTIONS_MONITORBUFFSC          = "también en combate";
    HEALBOT_OPTIONS_MONITORDEBUFFSC        = "también en combate";
    HEALBOT_OPTIONS_MONITORGBUFFSC         = "incluir generales en combate";
    HEALBOT_OPTIONS_MONITORCBUFFSC         = "también en combate";
    HEALBOT_OPTIONS_ENABLESMARTCAST        = "Lanzamiento inteligente fuera de combate";
    HEALBOT_OPTIONS_SMARTCASTSPELLS        = "Incluir hechizos";
    HEALBOT_OPTIONS_SMARTCASTDISPELL       = "Disipar perjuicios";
    HEALBOT_OPTIONS_SMARTCASTBUFF          = "Añadir beneficios";
    HEALBOT_OPTIONS_SMARTCASTHEAL          = "Sanaciones";
    HEALBOT_OPTIONS_BAR2SIZE               = "Tamaño de la barra de poder";
    HEALBOT_OPTIONS_SETSPELLS              = "Configurar hechizos para";
    HEALBOT_OPTIONS_USEICONCMDS            = "Usar comandos de iconos";
    HEALBOT_OPTIONS_ENABLEDBARS            = "Barras de salud - Personajes amistosos";
    HEALBOT_OPTIONS_DISABLEDBARS           = "Barras deshabilitadas";
    HEALBOT_OPTIONS_EMERGBARS              = "Barras de emergencia - Todos los personajes";
    HEALBOT_OPTIONS_ICONS                  = "Iconos: comandos que se pueden usar en iconos";
    HEALBOT_OPTIONS_MONITORDEBUFFS         = "Supervisar perjuicios";
    HEALBOT_OPTIONS_DEBUFFTEXT1            = "Hechizo para disipar perjuicios";

    HEALBOT_OPTIONS_POWER                  = "Poder"
    HEALBOT_OPTIONS_POWERALT               = "Poder alternativo"
    HEALBOT_OPTIONS_CASTBAR                = "Barra de lanzamiento"

    HEALBOT_ASTRALPOWER                    = "Poder astral"
    HEALBOT_ENERGY                         = "Energía"
    HEALBOT_MANA                           = "Maná"
    HEALBOT_RAGE                           = "Ira"
    HEALBOT_RUNES                          = "Runas"
    HEALBOT_RUNICPOWER                     = "Poder rúnico"
    HEALBOT_LIGHTFORCE                     = "Fuerza de la Luz"
    HEALBOT_SOULSHARDS                     = "Fragmentos de alma"
    HEALBOT_ECLIPSE                        = "Eclipse"
    HEALBOT_HOLY_POWER                     = "Poder sagrado"
    HEALBOT_ALTERNATE_POWER                = "Poder alternativo"
    HEALBOT_DARK_FORCE                     = "Fuerza oscura"
    HEALBOT_CHI                            = "Chi"
    HEALBOT_SHADOW_ORB                     = "Orbes de las Sombras"
    HEALBOT_BURNING_EMBERS                 = "Ascuas ardientes"
    HEALBOT_DEMONIC_FURY                   = "Furia demoníaca"
    HEALBOT_ARCANE_CHARGES                 = "Cargas Arcanas"
    HEALBOT_COMBO_POINTS                   = "Puntos de combo"
    HEALBOT_LUNAR_POWER                    = "Poder lunar"
    HEALBOT_MAELSTROM                      = "Vorágine"
    HEALBOT_INSANITY                       = "Demencia"
    HEALBOT_FURY                           = "Furia"
    HEALBOT_PAIN                           = "Dolor"
    HEALBOT_ESSENCE                        = "Esencia"
    HEALBOT_RUNE_BLOOD                     = "Runas de sangre"
    HEALBOT_RUNE_FROST                     = "Runas de escarcha"
    HEALBOT_RUNE_UNHOLY                    = "Runas profanas"
    HEALBOT_ALTERNATE_QUEST                = "Alternativo (misión)"
    HEALBOT_ALTERNATE_ENCOUNTER            = "Alternativo (encuentro)"
    HEALBOT_ALTERNATE_MOUNT                = "Alternativo (montura)"

    HEALBOT_MANAUSER                       = "Usuario de maná"
    HEALBOT_NONMANAUSER                    = "Sin uso de maná"

    HEALBOT_OPTIONS_HLTHTXTANCHORINDL      = "Izquierda independiente"
    HEALBOT_OPTIONS_HLTHTXTANCHORINDC      = "Centro independiente"
    HEALBOT_OPTIONS_HLTHTXTANCHORINDR      = "Derecha independiente"
    HEALBOT_OPTIONS_HLTHTXTANCHORRIGHT     = "A la derecha del nombre"
    HEALBOT_OPTIONS_HLTHTXTANCHORLEFT      = "A la izquierda del nombre"
    HEALBOT_OPTIONS_HLTHTXTANCHORBELOW     = "Debajo del nombre"
    HEALBOT_OPTIONS_HLTHTXTANCHORABOVE     = "Encima del nombre"
    HEALBOT_OPTIONS_STATETXTREPLACENAME    = "Reemplazar nombre cuando esté activo"
    HEALBOT_OPTIONS_STATECOLNOTAVAIL       = "Las opciones de color de estado se heredan del texto del nombre\ncuando " .. HEALBOT_OPTIONS_STATETEXTANCHOR .. " está configurado en " .. HEALBOT_OPTIONS_HLTHTXTANCHORLEFT;

    HEALBOT_OPTIONS_AUXBARANCHOR           = "Anclaje"

    HEALBOT_OPTIONS_ANCHORBOTTOM           = "Abajo"
    HEALBOT_OPTIONS_ANCHORTOP              = "Arriba"
    HEALBOT_OPTIONS_ANCHORLEFT             = "Izquierda"
    HEALBOT_OPTIONS_ANCHORRIGHT            = "Derecha"
    HEALBOT_OPTIONS_ANCHORCENTER           = "Centro"
    HEALBOT_OPTIONS_ANCHORBOTTOMLEFT       = "Abajo a la izquierda"
    HEALBOT_OPTIONS_ANCHORBOTTOMRIGHT      = "Abajo a la derecha"
    HEALBOT_OPTIONS_ANCHORTOPLEFT          = "Arriba a la izquierda"
    HEALBOT_OPTIONS_ANCHORTOPRIGHT         = "Arriba a la derecha"

    HEALBOT_OPTIONS_TOPLEFT                = "Arriba a la izquierda";
    HEALBOT_OPTIONS_BOTTOMLEFT             = "Abajo a la izquierda";
    HEALBOT_OPTIONS_TOPRIGHT               = "Arriba a la derecha";
    HEALBOT_OPTIONS_BOTTOMRIGHT            = "Abajo a la derecha";
    HEALBOT_OPTIONS_TOP                    = "Arriba"
    HEALBOT_OPTIONS_BOTTOM                 = "Abajo"

    HEALBOT_OPTIONS_ICONONBARANCHOR05      = "Abajo al centro, crecer a la izquierda"
    HEALBOT_OPTIONS_ICONONBARANCHOR06      = "Abajo al centro, crecer a la derecha"
    HEALBOT_OPTIONS_ICONONBARANCHOR07      = "Arriba al centro, crecer a la izquierda"
    HEALBOT_OPTIONS_ICONONBARANCHOR08      = "Arriba al centro, crecer a la derecha"

    HEALBOT_OPTIONS_IGNOREDEBUFF           = "Ignorar perjuicios:";
    HEALBOT_OPTIONS_IGNOREDEBUFFCLASS      = "Según la clase";
    HEALBOT_OPTIONS_IGNOREDEBUFFMOVEMENT   = "De ralentización";
    HEALBOT_OPTIONS_IGNOREDEBUFFDURATION   = "De corta duración";
    HEALBOT_OPTIONS_IGNOREDEBUFFNOHARM     = "No dañinos";
    HEALBOT_OPTIONS_IGNOREDEBUFFCOOLDOWN   = "Cuando la reutilización del hechizo de disipación > 2 segundos";
    HEALBOT_OPTIONS_IGNOREDEBUFFFRIEND     = "Cuando el lanzador sea un aliado conocido";
    HEALBOT_OPTIONS_IGNORECANNOTDISPELL    = "Cuando el perjuicio no se pueda disipar";

    HEALBOT_OPTIONS_RANGECHECKFREQ         = "Frecuencia de comprobación de alcance";
    HEALBOT_OPTIONS_OPTIONSOPACITY         = "Opacidad de las opciones";

    HEALBOT_OPTIONS_ALWAYRUNEVENTS         = "Ejecutar eventos siempre";
    HEALBOT_OPTIONS_HIDEPARTYFRAMES        = "Ocultar marcos de grupo";
    HEALBOT_OPTIONS_HIDEPLAYERTARGET       = "Incluir jugador y objetivo";
    HEALBOT_OPTIONS_DISABLEHEALBOT         = "Desactivar HealBot";

    HEALBOT_OPTIONS_STICKYFRAMES           = "Marcos adhesivos"
    HEALBOT_OPTIONS_STICKYSENSITIVITY      = "Sensibilidad de adhesión"
    HEALBOT_WORD_VLOW                      = "Muy baja"
    HEALBOT_WORD_LOW                       = "Baja"
    HEALBOT_WORD_NORMAL                    = "Normal"
    HEALBOT_WORD_HIGH                      = "Alta"
    HEALBOT_WORD_EXTREME                   = "Extrema"
    HEALBOT_WORD_CASTER                    = "Lanzador"
    HEALBOT_WORD_TYPE                      = "Tipo"
    HEALBOT_WORD_FROM                      = "De"

    HEALBOT_ASSIST                         = "Asistir";
    HEALBOT_WORD_FOCUS                     = "Foco";
    HEALBOT_MENU                           = "Menú";
    HEALBOT_MAINTANK                       = "Tanque principal";
    HEALBOT_MAINASSIST                     = "Asistente principal";
    HEALBOT_OFFTANK                        = "Tanque secundario";
    HEALBOT_STOP                           = "Detener";
    HEALBOT_TELL                           = "Susurrar";
    HEALBOT_CANCELPLUGINALERT              = "Cancelar alerta de complemento";
    HEALBOT_MOUSELOOK                      = "Vista con ratón"
    HEALBOT_IGNOREAURAALL                  = "Desactivar - Ignorar en todas las zonas";
    HEALBOT_ICONRAISEPRIO1                 = "Subir prioridad x1";
    HEALBOT_ICONRAISEPRIO3                 = "Subir prioridad x3";
    HEALBOT_ICONLOWERPRIO1                 = "Bajar prioridad x1";
    HEALBOT_ICONLOWERPRIO3                 = "Bajar prioridad x3";
    HEALBOT_ICONRAISESCALE                 = "Aumentar escala";
    HEALBOT_ICONLOWERSCALE                 = "Reducir escala";
    HEALBOT_ICONBARCOLOURON                = "Color de barra activado"
    HEALBOT_ICONBARCOLOUROFF               = "Color de barra desactivado"
    HEALBOT_ICONBARCOLOURCYCLE             = "Alternar color de barra"
    HEALBOT_ICONGLOWON                     = "Resplandor de icono activado"
    HEALBOT_ICONGLOWOFF                    = "Resplandor de icono desactivado"
    HEALBOT_ICONGLOWCYCLE                  = "Alternar resplandor de icono"
    HEALBOT_ICONNEXTSET                    = "Conjunto de iconos siguiente";
    HEALBOT_ICONPREVSET                    = "Conjunto de iconos anterior";

    HEALBOT_OPTIONS_SHOWMINIMAPBUTTON      = "Mostrar icono en el minimapa";
    HEALBOT_OPTIONS_ULTRA                  = "Ultra"
    HEALBOT_OPTIONS_CHILL                  = "Relajado"
    HEALBOT_OPTIONS_BARBUTTONSHOWHOT       = "Mostrar iconos de SeT";
    HEALBOT_OPTIONS_BARBUTTONSHOWRAIDICON  = "Mostrar objetivo de banda";
    HEALBOT_OPTIONS_HOTONBAR               = "En la barra";
    HEALBOT_OPTIONS_HOTOFFBAR              = "Fuera de la barra";
    HEALBOT_OPTIONS_HOTBARRIGHT            = "Lado derecho";
    HEALBOT_OPTIONS_HOTBARLEFT             = "Lado izquierdo";

    if HEALBOT_GAME_VERSION > 7 then
        HEALBOT_ZONE_AB                    = (C_Map.GetMapInfo(93) or {}).name or "Cuenca de Arathi";
        HEALBOT_ZONE_AV                    = (C_Map.GetMapInfo(91) or {}).name or "Valle de Alterac";
        HEALBOT_ZONE_ES                    = (C_Map.GetMapInfo(121) or {}).name or "Ojo de la Tormenta";
        HEALBOT_ZONE_IC                    = (C_Map.GetMapInfo(169) or {}).name or "Isla de la Conquista";
        HEALBOT_ZONE_SA                    = (C_Map.GetMapInfo(128) or {}).name or "Playa de los Ancestros";
    else
        HEALBOT_ZONE_AB                    = "Cuenca de Arathi";
        HEALBOT_ZONE_AV                    = "Valle de Alterac";
        HEALBOT_ZONE_ES                    = "Ojo de la Tormenta";
        HEALBOT_ZONE_IC                    = "Isla de la Conquista";
        HEALBOT_ZONE_SA                    = "Playa de los Ancestros";
    end

    HEALBOT_OPTION_AGGROTRACK              = "Supervisar amenaza"
    HEALBOT_OPTION_AGGROHAZARD             = "Mostrar peligro en el borde al tanquear"
    HEALBOT_OPTION_AGGROTARGETED           = "Establecer nivel máximo de alerta al ser objetivo de un enemigo."
    HEALBOT_OPTION_BOSSONLY                = "Solo en jefes."
    HEALBOT_OPTION_AGGROBAR                = "Barra"
    HEALBOT_OPTION_AGGROTXT                = ">> Texto <<"
    HEALBOT_OPTION_AGGROIND                = "Mostrar indicador"
    HEALBOT_OPTION_MANAONLY                = "Mostrar solo maná"
    HEALBOT_OPTION_HEALERSMANAONLY         = "Solo sanadores"
    HEALBOT_OPTION_BARUPDFREQ              = "Velocidad de refresco"
    HEALBOT_OPTION_USEFLUIDBARS            = "Usar barras fluidas"
    HEALBOT_OPTION_CPUPROFILE              = "Usar perfil de CPU (información de uso de CPU de complementos)"
    HEALBOT_OPTION_POWERALT                = "Poder alternativo"
    HEALBOT_OPTION_HIDEPOWERALT            = "Ocultar poder alternativo"
    HEALBOT_OPTION_FLUIDBARSINCALPHA       = "Incluir color y opacidad"
    HEALBOT_OPTION_HEALTHDROP              = "Caída de salud"
    HEALBOT_OPTION_USEHEALTHDROP           = "Mostrar en la barra de salud"
    HEALBOT_OPTION_ALERTCONDITION          = "Condición de alerta"
    HEALBOT_OPTION_ALERTCONDITIONS         = "Condiciones de alerta"
    HEALBOT_OPTION_ALERTTEXT               = "Texto de alerta"
    HEALBOT_OPTION_BINDTEXT                = "Texto de asignación"
    HEALBOT_OPTION_HEALTHDROPPCT           = "Umbral de alerta "
    HEALBOT_OPTION_HOTBARHEALTHPCT         = "Umbral mín. de Salud+Absorciones "
    HEALBOT_OPTION_HEALTHDROPSPEED         = "Tiempo en segundos"
    HEALBOT_OPTION_HEALTHDROPCANCEL        = "Umbral de cancelación"
    HEALBOT_OPTION_USEFOCUSGROUPS          = "Usar grupos focalizados"
    HEALBOT_OPTION_FOCUSGROUPDIMMING       = "Grupos no focalizados - Reducción de opacidad"
    HEALBOT_OPTION_NONHOTBARSDIMMING       = "Barras no destacadas - Reducción de opacidad"
    HEALBOT_OPTION_NONGHDIMMING            = "Sanación no necesaria - Reducción de opacidad"
    HEALBOT_OPTION_GLOBALDIMMING           = "Ratón fuera de los marcos - Reducción de opacidad"
    HEALBOT_OPTION_FLUIDBARS               = "Barras fluidas"
    HEALBOT_OPTION_GROUPBARS               = "Barras de grupo"
    HEALBOT_OPTION_HEALTHDROPALERT         = "Alerta de caída de salud"
    HEALBOT_OPTION_HOTBARS                 = "Barras destacadas"
    HEALBOT_OPTION_HOTBARSDEBUFFPRIO       = "Umbral de prioridad de perjuicio"
    HEALBOT_OPTIONS_RELOADUIMSG            = "Esta opción requiere recargar la IU, ¿recargar ahora?"
    HEALBOT_OPTIONS_COPYFROMC1             = "Copiar todos los ajustes de iconos de acción\ndesde la apariencia "
    HEALBOT_OPTIONS_COPYFROMC2             = "\n\nEsto sobrescribirá todos los ajustes\nactuales de iconos de acción.\n\n\n¿Está seguro?"
    HEALBOT_OPTIONS_COPYFROMND             = "No existen datos de iconos de acción para la apariencia "
    HEALBOT_OPTION_USE                     = "Usar"
    HEALBOT_OPTION_TOOLTIPSCALE            = "Escala"

    HEALBOT_BUFF_PVP                       = "JcJ"
    HEALBOT_BUFF_PVE                       = "JcE"
    HEALBOT_OPTIONS_ANCHOR                 = "Anclaje del marco"
    HEALBOT_OPTIONS_BARSANCHOR             = "Anclaje de las barras"

    HEALBOT_PANEL_BLACKLIST                = "Lista negra"

    HEALBOT_WORDS_REMOVEFROM               = "Quitar de";
    HEALBOT_WORDS_ADDTO                    = "Añadir a";
    HEALBOT_WORDS_INCLUDE                  = "Incluir";
    HEALBOT_WORDS_UNSET                    = "Sin asignar";
    HEALBOT_OPTIONS_MAXSECS                = "Segundos máximos"
    HEALBOT_WORDS_REQUIRED                 = "Requerido";
    HEALBOT_WORDS_PENDING                  = "Pendiente";
    HEALBOT_WORD_STATUS                    = "Estado"
    HEALBOT_WORD_TIME                      = "Tiempo"
    HEALBOT_WORD_SUMMONS                   = "Invocaciones"
    HEALBOT_WORD_RESURRECTION              = "Resurrección"

    HEALBOT_OPTIONS_TTALPHA                = "Opacidad"
    HEALBOT_OPTIONS_TTMAXBUTTONS           = "Máx. de botones"
    HEALBOT_TOOLTIP_TARGETBAR              = "Barra de objetivo"
    HEALBOT_OPTIONS_MYTARGET               = "Lista privada"
    HEALBOT_WORD_LISTS                     = "Listas"

    HEALBOT_DISCONNECTED_TEXT              = "<DESC>"
    HEALBOT_DISCONNECTED_LABEL             = "Desconectado"
    HEALBOT_DISCONNECTED_TAG               = "DESC "
    HEALBOT_DEAD_SPIRIT                    = "Espíritu"
    HEALBOT_DEAD_LABEL                     = "Muerto"
    HEALBOT_DEAD_TAG                       = "RIP "
    HEALBOT_RES_TAG                        = "RES "
    HEALBOT_SUMMONS_TAG                    = "INV "
    HEALBOT_OUTOFRANGE_LABEL               = "Fuera de alcance"
    HEALBOT_INRANGE                        = "Al alcance"
    HEALBOT_RECENTHEALS                    = "Sanaciones recientes"
    HEALBOT_OUTOFRANGE_TAG                 = "FdA-"
    HEALBOT_RESERVED_LABEL                 = "Reservado"
    HEALBOT_RESERVED_TAG                   = "R-"

    HEALBOT_OPTIONS_SHOWUNITBUFFTIME       = "Mostrar mis beneficios";
    HEALBOT_OPTIONS_TOOLTIPUPDATE          = "Actualizar continuamente";
    HEALBOT_OPTIONS_SHOWGUILD              = "Mostrar hermandad";
    HEALBOT_OPTIONS_SHOWGUILDTITLE         = "Incluir título de hermandad";
    HEALBOT_OPTIONS_SHOWGUILDRANK          = "Incluir rango de hermandad";
    HEALBOT_OPTIONS_SHOWTITLE              = "Mostrar título";
    HEALBOT_OPTIONS_SHOWUNITBUFFREQUIRED   = "Mostrar beneficios requeridos";
    HEALBOT_OPTIONS_TIPSSHOWDEBUFFS        = "Mostrar perjuicios supervisados";
    HEALBOT_OPTIONS_BUFFSTEXTTIMER         = "Mostrar beneficio antes de que expire";
    HEALBOT_OPTIONS_SHORTBUFFTIMER         = "Beneficios cortos"
    HEALBOT_OPTIONS_LONGBUFFTIMER          = "Beneficios largos"

    HEALBOT_OPTIONS_NOTIFY_MSG             = "Mensaje"
    HEALBOT_OPTIONS_CASTNOTIFYTAGS         = " #s=nombre del hechizo  -  #l=enlace del hechizo  -  #n=nombre del jugador "
    HEALBOT_WORDS_YOU                      = "ti";
    HEALBOT_WORDS_MOREMEM                  = "Más memoria";
    HEALBOT_WORDS_LESSMEM                  = "Menos memoria";
    HEALBOT_WORDS_MORECPU                  = "Más CPU";
    HEALBOT_WORDS_LESSCPU                  = "Menos CPU";
    HEALBOT_WORDS_CRITICAL                 = "Crítico";
    HEALBOT_WORDS_INJURED                  = "Herido";
    HEALBOT_WORDS_HEALTHY                  = "Sano";
    HEALBOT_NOTIFYOTHERMSG                 = "Lanzando #s sobre #n";

    HEALBOT_OPTIONS_HOTPOSITION            = "Posición del icono"
    HEALBOT_OPTIONS_HOTSHOWTEXT            = "Mostrar texto del icono"
    HEALBOT_OPTIONS_HOTTEXTCOUNT           = "Acumulaciones"
    HEALBOT_OPTIONS_HOTTEXTDURATION        = "Duración"
    HEALBOT_OPTIONS_ICONSCALE              = "Escala del icono"
    HEALBOT_OPTIONS_ICONTEXTSCALE          = "Escala del texto del icono"
    HEALBOT_OPTIONS_MAXICONS               = "Máx. de iconos"
    HEALBOT_OPTIONS_NUMICONS               = "Número de iconos"
    HEALBOT_OPTIONS_ICONSPACER             = "Espaciado de iconos"
    HEALBOT_OPTIONS_ICONZOOM               = "Zoom del icono"
    HEALBOT_OPTIONS_ICONSIZE               = "Tamaño del icono"
    HEALBOT_OPTIONS_EMERGBUTTONUSE         = "Usar la barra de emergencia"
    HEALBOT_OPTIONS_BUFFSAUTOTIMED         = "Beneficios temporales"
    HEALBOT_OPTIONS_BUFFSAUTOALL           = "Todos los beneficios"
    HEALBOT_OPTIONS_FADEDOPACITY           = "Opacidad atenuada"
    HEALBOT_OPTIONS_HIGHLIGHTEDOPACITY     = "Opacidad resaltada"

    HEALBOT_OPTIONS_AGGROBARSIZE           = "Tamaño de barra de amenaza"
    HEALBOT_OPTIONS_DOUBLETEXTLINES        = "Líneas de texto dobles"
    HEALBOT_OPTIONS_TEXTALIGNMENT          = "Alineación horizontal"
    HEALBOT_OPTIONS_TEXTOFFSET             = "Desplazamiento vertical"
    HEALBOT_OPTIONS_TEXTHOROFFSET          = "Desplazamiento horizontal"
    HEALBOT_OPTIONS_EMERGINJTRIG           = "Umbral de herido"
    HEALBOT_OPTIONS_EMERGCRITTRIG          = "Umbral de crítico"
    HEALBOT_OPTIONS_CUSTOMCOLHEALTH        = "Colores personalizados de barra de salud"
    HEALBOT_OPTIONS_CUSTOMCOLBACK          = "Colores personalizados de barra de fondo"
    HEALBOT_OPTIONS_CUSTOMCOLINHEAL        = "Colores personalizados de sanaciones entrantes"
    HEALBOT_OPTIONS_CUSTOMCOLABSORB        = "Colores personalizados de efectos de absorción"
    HEALBOT_OPTIONS_CUSTOMCOLBACKBOR       = "Colores personalizados de borde de fondo"
    HEALBOT_OPTIONS_CUSTOMTEXTCOLNAME      = "Colores personalizados de texto de nombre"
    HEALBOT_OPTIONS_CUSTOMTEXTCOLHEALTH    = "Colores personalizados de texto de salud"
    HEALBOT_OPTIONS_CUSTOMTEXTCOLSTATE     = "Colores personalizados de texto de estado"
    HEALBOT_OPTIONS_CUSTOMTEXTCOLAGGRO     = "Colores personalizados de texto de amenaza"
    HEALBOT_OPTIONS_TXTOFFSET              = "Desplazamiento"
    HEALBOT_OPTIONS_TXTDEPTH               = "Profundidad"
    HEALBOT_OPTIONS_TXTSIZE                = "Tamaño"
    HEALBOT_WORDS_SPACE                    = "Espacio"
    HEALBOT_OPTIONS_MAXCHARS               = "Máx. de caracteres"
    HEALBOT_OPTIONS_PLAYERMAXCHARS         = "Máx. de caracteres - Nombre de jugador"
    HEALBOT_OPTIONS_MOBMAXCHARS            = "Máx. de caracteres - Nombre de criatura"
    HEALBOT_WORD_VEHICLE                   = "Vehículo"
    HEALBOT_WORDS_ERROR                    = "Error"
    HEALBOT_SPELL_NOT_FOUND                = "Hechizo no encontrado"
    HEALBOT_OPTIONS_DISABLETOOLTIPINCOMBAT = "Ocultar descripción emergente en combate"
    HEALBOT_OPTIONS_ENABLELIBQH            = "Habilitar fastHealth";

    HEALBOT_OPTIONS_BUFFNAMED              = "Introduzca los nombres de los jugadores a vigilar para\n\n"
    HEALBOT_WORD_ALWAYS                    = "Siempre";
    HEALBOT_WORD_SOLO                      = "En solitario";
    HEALBOT_WORD_NEVER                     = "Nunca";
    HEALBOT_SHOW_CLASS_AS_ICON             = "como icono";
    HEALBOT_SHOW_CLASS_AS_TEXT             = "como texto";
    HEALBOT_SHOW_ROLE                      = "mostrar rol";
    HEALBOT_SHOW_ROLETANKONLY              = "mostrar solo tanques";
    HEALBOT_SHOW_PLAYERROLE                = "Mostrar rol";
    HEALBOT_SHOW_RAIDRANK                  = "Mostrar rango";
    HEALBOT_SHOW_HIDEROLEWHENRANK          = "Ocultar rol cuando exista rango";

    HEALBOT_SHOW_INCHEALS                  = "Mostrar sanaciones entrantes";

    HEALBOT_FORHELP                        = "Para ver las opciones use: "
    HEALBOT_HELP = { [1]  = "[HealBot] /hb h -- Mostrar ayuda",
                     [2]  = "[HealBot] /hb o -- Alternar opciones",
                     [3]  = "[HealBot] /hb t -- Alternar HealBot entre desactivado y activado",
                     [4]  = "[HealBot] /hb bt -- Alternar supervisor de beneficios entre desactivado y activado",
                     [5]  = "[HealBot] /hb dt -- Alternar supervisor de perjuicios entre desactivado y activado",
                     [6]  = "[HealBot] /hb skin <skinName> -- Cambiar entre apariencias",
                     [7]  = "[HealBot] /hb d -- Restablecer opciones a sus valores predeterminados",
                     [8]  = "[HealBot] /hb spt -- Alternar mascota propia",
                     [9]  = "[HealBot] /hb hs -- Mostrar comandos de barra adicionales",
                     [10] = "[HealBot] - Todos los comandos están listados en el sitio web de HealBot en " .. HEALBOT_ABOUT_URL,
                   }

    HEALBOT_HELP2 = { [1] = "[HealBot] /hb rtb -- Alternar restricción de barra de objetivo a Izquierdo=Lanzamiento inteligente y Derecho=añadir/quitar de Lista privada",
                      [2] = "[HealBot] /hb aggro 2 <n> -- Establecer nivel de amenaza 2 en el porcentaje de amenaza <n>",
                      [3] = "[HealBot] /hb aggro 3 <n> -- Establecer nivel de amenaza 3 en el porcentaje de amenaza <n>",
                      [4] = "[HealBot] /hb tr <Role> -- Establecer máxima prioridad de rol al subordenar por rol. Roles válidos: 'TANK', 'HEALER' o 'DPS'",
                      [5] = "[HealBot] /hb use10 -- Usar automáticamente la ranura de ingeniería 10",
                      [6] = "[HealBot] - Consulte también la sección Comandos en la pestaña General de Opciones",
                    }

    HEALBOT_OPTION_HIGHLIGHTACTIVEBAR      = "Resaltar"
    HEALBOT_OPTION_HIGHLIGHTTARGETBAR      = "Resaltar objetivo"
    HEALBOT_OPTIONS_TESTBARS               = "Barras de prueba"
    HEALBOT_OPTIONS_TURNTESTBARSON         = "Activar"
    HEALBOT_OPTIONS_TURNTESTBARSOFF        = "Desactivar"
    HEALBOT_OPTION_NUMBARS                 = "Número de barras"
    HEALBOT_OPTION_NUMTANKS                = "Número de tanques"
    HEALBOT_OPTION_NUMMYTARGETS            = "Número en Lista privada"
    HEALBOT_OPTION_NUMHEALERS              = "Número de sanadores"
    HEALBOT_OPTION_NUMPETS                 = "Número de mascotas"
    HEALBOT_OPTION_DEBUFFICONS             = "Mostrar iconos de perjuicio"
    HEALBOT_OPTION_BUFFICONS               = "Mostrar iconos de beneficio"
    HEALBOT_OPTION_EXTRAICONS              = "Mostrar iconos adicionales"
    HEALBOT_WORD_TEST                      = "Prueba";
    HEALBOT_OPTION_TESTMODE                = "Modo de prueba";
    HEALBOT_WORD_TEXT                      = "Texto";
    HEALBOT_WORD_OFF                       = "Desactivado";
    HEALBOT_WORD_ON                        = "Activado";
    HEALBOT_WORD_ONWITHOUTSOUND            = "Activado sin sonido";
    HEALBOT_WORD_ONWITHSOUND               = "Activado con sonido";
    HEALBOT_OPTION_FRAMEPADDING            = "Relleno del marco"
    HEALBOT_OPTIONS_ONBARS                 = "En barras de salud"
    HEALBOT_OPTIONS_ONICONS                = "En iconos y barras de emergencia"
    HEALBOT_OPTIONS_TARGETOFFOCUS          = "Objetivo del foco"
    HEALBOT_OPTIONS_TARGETOFPRIVFOCUSTAR   = "Objetivo del objetivo de foco privado"
    HEALBOT_OPTIONS_PRIVFOCUS              = "Foco privado"

    HEALBOT_OPTIONS_TAB_CHAT               = "Chat"
    HEALBOT_OPTIONS_TAB_HEADERS            = "Cabeceras"
    HEALBOT_OPTIONS_TAB_BARS               = "Barras"
    HEALBOT_OPTIONS_TAB_AURAS              = "Auras"
    HEALBOT_OPTIONS_TAB_UNITTARGETS        = "Objetivos de jugadores"
    HEALBOT_OPTIONS_TAB_ENEMYUNITS         = "Unidades enemigas"
    HEALBOT_OPTIONS_TAB_TARGETOFTARGET     = "Objetivo del objetivo"
    HEALBOT_OPTIONS_TAB_BUTTONS            = "Botones"
    HEALBOT_OPTIONS_TAB_ICONS              = "Iconos"
    HEALBOT_OPTIONS_TAB_INDICATORS         = "Indicadores"
    HEALBOT_OPTIONS_TAB_ACTIONICONS        = "Iconos de acción"
    HEALBOT_OPTIONS_TAB_AGGROINDICATORS    = "Indicadores de amenaza"
    HEALBOT_OPTIONS_TAB_LOWMANAINDICATORS  = "Indicadores de maná bajo"
    HEALBOT_OPTIONS_TAB_SELFCASTINDICATORS = "Indicadores de icono de lanzamiento propio"
    HEALBOT_OPTIONS_TAB_POWERINDICATORS    = "Indicadores de poder"
    HEALBOT_OPTIONS_TAB_WARNING            = "Aviso"
    HEALBOT_OPTIONS_SKINDEFAULTFOR         = "Apariencia predeterminada para"
    HEALBOT_OPTIONS_INCHEAL                = "Sanaciones entrantes"
    HEALBOT_OPTIONS_INCABSORB              = "Efectos de " .. HEALBOT_classicABSORBHOT
    HEALBOT_OPTIONS_NOOVERHEALS            = "Sin sobresanación"
    HEALBOT_WORD_OVERHEALS                 = "Sobresanación"
    HEALBOT_WORD_OVERSHIELD                = "Sobreescudo"
    HEALBOT_WORD_ABSORBS                   = "Absorciones"
    HEALBOT_WORD_ARENA                     = "Arena"
    HEALBOT_WORD_BATTLEGROUND              = "Campo de batalla"
    HEALBOT_WORD_BG10                      = "CB 10";
    HEALBOT_WORD_BG15                      = "CB 15";
    HEALBOT_WORD_BG20                      = "CB 20";
    HEALBOT_WORD_BG25                      = "CB 25";
    HEALBOT_WORD_BG40                      = "CB 40";
    HEALBOT_OPTIONS_TEXTOPTIONS            = "Texto de barra"
    HEALBOT_WORD_PARTY                     = "Grupo"
    HEALBOT_WORD_COLOURS                   = "Colores";
    HEALBOT_WORD_COLOUR                    = "Color"
    HEALBOT_OPTIONS_COMBOAUTOTARGET        = "Objetivo\nautomático"
    HEALBOT_OPTIONS_COMBOAUTOTRINKET       = "Abalorio automático"
    HEALBOT_OPTIONS_COMBOBINDS             = "Atajos"
    HEALBOT_OPTIONS_GROUPSPERCOLUMN        = "Usar grupos por columna"
    HEALBOT_WORD_WHISPER                   = "Susurrar"
    HEALBOT_WORD_GUILD                     = "Hermandad"
    HEALBOT_WORD_KEYBIND                   = "Atajo de teclado"

    HEALBOT_OPTIONS_MAINSORT               = "Orden principal"
    HEALBOT_OPTIONS_SUBSORT                = "Suborden"
    HEALBOT_OPTIONS_SUBSORTINC             = "Subordenar también:"

    HEALBOT_OPTIONS_BUTTONCASTMETHOD       = "Lanzar cuando el botón se"
    HEALBOT_OPTIONS_BUTTONCASTPRESSED      = "Pulsa"
    HEALBOT_OPTIONS_BUTTONCASTRELEASED     = "Suelta"

    HEALBOT_WORD_EXPLORING                 = "Explorando"
    HEALBOT_WORD_INCOMBAT                  = "En combate"
    HEALBOT_WORD_NEUTRAL                   = "Neutral"
    HEALBOT_WORD_RESTING                   = "Descansando"
    HEALBOT_WORD_RAIDER                    = "Miembro de banda"
    HEALBOT_WORD_HEALER                    = "Sanador"
    HEALBOT_WORD_DAMAGER                   = "Atacante"
    HEALBOT_WORD_TANK                      = "Tanque"
    HEALBOT_WORD_MAINTANK                  = "Tanque principal"
    HEALBOT_WORD_PRIVATETANK               = "Tanque privado"
    HEALBOT_WORD_PRIVATEHEALER             = "Sanador privado"
    HEALBOT_WORD_LEADER                    = "Líder"
    HEALBOT_WORD_GROUPLEADER               = "Líder de grupo"
    HEALBOT_WORD_RAIDLEADER                = "Líder de banda"
    HEALBOT_WORD_RAIDASSISTANT             = "Ayudante de banda"
    HEALBOT_WORD_MASTERLOOTER              = "Maestro despojador"
    HEALBOT_WORD_VERSION                   = "Versión"
    HEALBOT_WORD_CLIENT                    = "Cliente"

    HEALBOT_WORD_STAR                      = "Estrella"
    HEALBOT_WORD_CIRCLE                    = "Círculo"
    HEALBOT_WORD_DIAMOND                   = "Diamante"
    HEALBOT_WORD_TRIANGLE                  = "Triángulo"
    HEALBOT_WORD_MOON                      = "Luna"
    HEALBOT_WORD_SQUARE                    = "Cuadrado"
    HEALBOT_WORD_CROSS                     = "Cruz"
    HEALBOT_WORD_SKULL                     = "Calavera"

    HEALBOT_OPTIONS_ACCEPTSKINMSG          = "Aceptar apariencia de [HealBot]: "
    HEALBOT_OPTIONS_ACCEPTSKINMSGFROM      = " de "
    HEALBOT_OPTIONS_BUTTONSHARESKIN        = "Compartir con"
    HEALBOT_OPTIONS_EXPORTSKIN             = "Seleccionar apariencia"
    HEALBOT_OPTIONS_EXTRASKINS             = "Apariencias adicionales"
    HEALBOT_OPTIONS_BUTTONEXPORT           = "Exportar"
    HEALBOT_OPTIONS_BUTTONPOSTLINK         = "Publicar enlace"
    HEALBOT_OPTIONS_BUTTONPOST             = "Publicar"
    HEALBOT_OPTIONS_BUTTONIMPORT           = "Importar"
    HEALBOT_OPTIONS_BUTTONIMPORTMETHOD     = "Método de importación"
    HEALBOT_IMPORT_OVERWRITEALL            = "Sobrescribir todo"
    HEALBOT_IMPORT_MERGEALL                = "Fusionar todo"
    HEALBOT_IMPORT_MERGENEW                = "Fusionar nuevos"
    HEALBOT_IMPORT_CREATEORREPLACE         = "Crear o reemplazar"

    HEALBOT_CHAT_ADDONID                   = "[HealBot] "
    HEALBOT_CHAT_NEWVERSION1               = "Hay una nueva versión disponible"
    HEALBOT_CHAT_NEWVERSION2               = "en " .. HEALBOT_ABOUT_URL
    HEALBOT_CHAT_SHARESKINERR1             = " Apariencia no encontrada para compartir"
    HEALBOT_CHAT_SHARESKINERR3             = " no encontrado para compartir apariencia"
    HEALBOT_CHAT_SHARESKINACPT             = "Apariencia compartida aceptada de "
    HEALBOT_CHAT_CONFIRMSKINDEFAULTS       = "Apariencias restablecidas a sus valores predeterminados"
    HEALBOT_CHAT_CONFIRMCUSTOMDEFAULTS     = "Perjuicios personalizados restablecidos"
    HEALBOT_CHAT_CHANGESKINERR1            = "Apariencia desconocida: /hb skin "
    HEALBOT_CHAT_CHANGESKINERR2            = "Apariencias válidas:  "
    HEALBOT_CHAT_CONFIRMSPELLCOPY          = "Hechizos actuales copiados a todas las especializaciones"
    HEALBOT_CHAT_UNKNOWNCMD                = "Comando de barra desconocido: /hb "
    HEALBOT_CHAT_ENABLED                   = "Entrando en estado habilitado"
    HEALBOT_CHAT_DISABLED                  = "Entrando en estado deshabilitado"
    HEALBOT_CHAT_SOFTRELOAD                = "Reinicio de HealBot solicitado"
    HEALBOT_CHAT_HARDRELOAD                = "Recarga de la IU solicitada"
    HEALBOT_CHAT_CONFIRMSPELLRESET         = "Los hechizos han sido restablecidos"
    HEALBOT_CHAT_CONFIRMCURESRESET         = "Las disipaciones han sido restablecidas"
    HEALBOT_CHAT_CONFIRMBUFFSRESET         = "Los beneficios han sido restablecidos"
    HEALBOT_CHAT_CONFIRMICONRESET          = "Los iconos han sido restablecidos"
    HEALBOT_CHAT_POSSIBLEMISSINGMEDIA      = "No se han podido recibir todos los ajustes de la apariencia; es posible que falte SharedMedia"
    HEALBOT_CHAT_MACROSOUNDON              = "Sonido no suprimido al usar abalorios automáticos"
    HEALBOT_CHAT_MACROSOUNDOFF             = "Sonido suprimido al usar abalorios automáticos"
    HEALBOT_CHAT_MACROERRORON              = "Errores no suprimidos al usar abalorios automáticos"
    HEALBOT_CHAT_MACROERROROFF             = "Errores suprimidos al usar abalorios automáticos"
    HEALBOT_CHAT_ACCEPTSKINON              = "Compartir apariencia - Mostrar ventana emergente cuando alguien comparta una apariencia contigo"
    HEALBOT_CHAT_ACCEPTSKINOFF             = "Compartir apariencia - Ignorar siempre las apariencias compartidas por otros jugadores"
    HEALBOT_CHAT_USE10ON                   = "Abalorio automático - Use10 está activado - Debe habilitar un abalorio automático existente para que use10 funcione"
    HEALBOT_CHAT_USE10OFF                  = "Abalorio automático - Use10 está desactivado"
    HEALBOT_CHAT_SKINREC                   = " apariencia importada"
    HEALBOT_CHAT_MAINASSISTOFF             = "Tanques secundarios excluidos de los tanques principales"
    HEALBOT_CHAT_MAINASSISTON              = "Tanques secundarios incluidos con los tanques principales"
    HEALBOT_OPTIONS_OFFTANKS               = "Incluir tanques secundarios con los tanques principales"

    HEALBOT_OPTIONS_SELFCASTS              = "Solo lanzamientos propios"
    HEALBOT_OPTIONS_SELFINDICATOR          = "Indicador propio"
    HEALBOT_OPTIONS_HOTSHOWICON            = "Mostrar icono"
    HEALBOT_OPTIONS_ALLSPELLS              = "Beneficios / SeT"
    HEALBOT_OPTIONS_BUFFNAME               = "Nombre del beneficio"
    HEALBOT_OPTIONS_DOUBLEROW              = "Doble fila"
    HEALBOT_OPTIONS_HOTBELOWBAR            = "Debajo de la barra"
    HEALBOT_OPTIONS_OTHERSPELLS            = "Otros hechizos"
    HEALBOT_WORD_MACROS                    = "Macros"
    HEALBOT_WORD_SELECT                    = "Seleccionar"
    HEALBOT_WORD_SELECT_ALL                = "Seleccionar todo"
    HEALBOT_WORD_SELECT_NONE               = "No seleccionar ninguno"
    HEALBOT_OPTIONS_QUESTION               = "?"
    HEALBOT_WORD_CANCEL                    = "Cancelar"
    HEALBOT_WORD_DONE                      = "Hecho"
    HEALBOT_WORD_COMMANDS                  = "Comandos"
    HEALBOT_WORD_COMMAND                   = "Comando"
    HEALBOT_OPTIONS_BARHEALTH3             = "como salud";
    HEALBOT_SORTBY_ROLE                    = "Rol"
    HEALBOT_WORD_DPS                       = "DPS"
    HEALBOT_CHAT_TOPROLEERR                = " rol no válido en este contexto - use 'TANK', 'DPS' o 'HEALER'"
    HEALBOT_CHAT_NEWTOPROLE                = "El rol de mayor prioridad ahora es "
    HEALBOT_CHAT_SUBSORTPLAYER1            = "El jugador aparecerá primero en el suborden"
    HEALBOT_CHAT_SUBSORTPLAYER2            = "El jugador se ordenará normalmente en el suborden"
    HEALBOT_OPTIONS_SHOWREADYCHECK         = "Mostrar comprobación de listos";
    HEALBOT_OPTIONS_READYCHECK             = "Comprobación de listos";
    HEALBOT_OPTIONS_SHOWCOMBATSTATE        = "Mostrar estado de combate";
    HEALBOT_OPTIONS_SHOWHOSTILE            = "Mostrar hostil";
    HEALBOT_OPTIONS_SHOWLEADER             = "Mostrar líder";
    HEALBOT_OPTIONS_SHOWLEADERMT           = "Mostrar tanques principales"
    HEALBOT_OPTIONS_SHOWAFK                = "Mostrar AUS";
    HEALBOT_OPTIONS_SHOWRESTING            = "Mostrar descansando (solo jugador)";
    HEALBOT_OPTIONS_SHOWCLASSICON          = "Mostrar clase";
    HEALBOT_OPTIONS_SUBSORTSELFFIRST       = "Suborden - Uno mismo primero"
    HEALBOT_WORD_FILTER                    = "Filtro"
    HEALBOT_OPTION_AGGROPCTBAR             = "Mover barra"
    HEALBOT_OPTION_AGGROPCTTXT             = "Mostrar texto"
    HEALBOT_OPTION_AGGROPCTTRACK           = "Mostrar porcentaje de amenaza"
    HEALBOT_OPTIONS_ALERTAGGROLEVEL0       = "0 - Desactivado"
    HEALBOT_OPTIONS_ALERTAGGROLEVEL1       = "1 - Amenaza baja"
    HEALBOT_OPTIONS_ALERTAGGROLEVEL2       = "2 - Amenaza alta"
    HEALBOT_OPTIONS_ALERTAGGROLEVEL3       = "3 - Tanqueando"
    HEALBOT_OPTIONS_AGGROALERT             = "Nivel de alerta de barra aux."
    HEALBOT_OPTIONS_AGGROINDALERT          = "Nivel de alerta de indicador"
    HEALBOT_OPTIONS_TOOLTIPSHOWHOT         = "Mostrar detalles de SeT activos supervisados"
    HEALBOT_WORDS_MIN                      = "mín."
    HEALBOT_WORDS_MAX                      = "máx."
    HEALBOT_CHAT_SELFPETSON                = "Mascota propia activada"
    HEALBOT_CHAT_SELFPETSOFF               = "Mascota propia desactivada"
    HEALBOT_CHAT_PLAYERROLESON             = "Roles de jugador permitidos"
    HEALBOT_CHAT_PLAYERROLESOFF            = "Roles de jugador denegados"
    HEALBOT_ALLOWTALENTQUERYON             = "Permitir consulta de talentos de jugadores"
    HEALBOT_ALLOWTALENTQUERYOFF            = "Denegar consulta de talentos de jugadores"
    HEALBOT_CLEARINSPECTON                 = "Ejecutar limpieza de inspección tras consultar talentos"
    HEALBOT_CLEARINSPECTOFF                = "No ejecutar limpieza de inspección"
    HEALBOT_WORD_PRIORITY                  = "Prioridad"
    HEALBOT_VISIBLE_RANGE                  = "Dentro de 100 metros"
    HEALBOT_SPELL_RANGE                    = "Dentro del alcance del hechizo"
    HEALBOT_WORD_RESET                     = "Restablecer"
    HEALBOT_WOWMENU                        = "Menú de Blizzard";
    HEALBOT_HBMENU                         = "Menú de HealBot"
    HEALBOT_ACTION_HBFOCUS                 = "Clic izquierdo para establecer\nfoco en el objetivo"
    HEALBOT_WORD_CLEAR                     = "Limpiar"
    HEALBOT_WORD_SET                       = "Establecer"
    HEALBOT_WORD_HBFOCUS                   = "Foco en el objetivo"
    HEALBOT_WORD_OUTSIDE                   = "Exterior"
    HEALBOT_WORD_ALLZONE                   = "Todas las zonas"
    HEALBOT_WORD_ZONE                      = "Zona"
    HEALBOT_WORD_SPEC                      = "Especialización"
    HEALBOT_OPTIONS_TAB_ALERT              = "Alerta"
    HEALBOT_OPTIONS_TAB_SORT               = "Orden"
    HEALBOT_OPTIONS_TAB_HIDE               = "Ocultar"
    HEALBOT_OPTIONS_TAB_VISIBILITY         = "Visibilidad"
    HEALBOT_OPTIONS_TAB_AGGRO              = "Amenaza"
    HEALBOT_OPTIONS_TAB_AUX                = "Aux."
    HEALBOT_OPTIONS_TAB_ICONTEXT           = "Texto de icono"
    HEALBOT_OPTIONS_TAB_DEBUFFICONTEXT     = "Texto de icono de perjuicio"
    HEALBOT_OPTIONS_TAB_BUFFICONTEXT       = "Texto de icono de beneficio"
    HEALBOT_OPTIONS_TAB_TEXT               = "Texto"
    HEALBOT_OPTIONS_AGGRO3COL              = "Color de barra\nde amenaza"
    HEALBOT_OPTIONS_AGGROFLASHFREQ         = "Frecuencia de destello"
    HEALBOT_OPTIONS_WORD_FASTER            = "Más rápido"
    HEALBOT_OPTIONS_WORD_SLOWER            = "Más lento"
    HEALBOT_OPTIONS_AGGROFLASHALPHA        = "Opacidad de destello"
    HEALBOT_OPTIONS_FOCUSGROUPS            = "Grupos focalizados"
    HEALBOT_OPTIONS_FOCUSGROUPS1           = "DESACTIVADO"
    HEALBOT_OPTIONS_FOCUSGROUPS2           = "ACTIVADO: Atenuar grupos no focalizados"
    HEALBOT_OPTIONS_FOCUSGROUPS3           = "ACTIVADO: Ocultar grupos no focalizados"
    HEALBOT_OPTIONS_SHOWDURATIONFROM       = "Mostrar duración a partir de"
    HEALBOT_OPTIONS_SHOWDURATIONWARN       = "Aviso de duración a partir de"
    HEALBOT_OPTIONS_GOTOAUXCONFIG          = "Establecer tipo de barra aux."
    HEALBOT_CMD_RESETCUSTOMDEBUFFS         = "Restablecer perjuicios personalizados"
    HEALBOT_CMD_RESETSKINS                 = "Restablecer apariencias"
    HEALBOT_CMD_CLEARBLACKLIST             = "Limpiar lista negra"
    HEALBOT_CMD_TOGGLEACCEPTSKINS          = "Alternar aceptación de apariencias de otros"
    HEALBOT_CMD_TOGGLEDISLIKEMOUNT         = "Alternar montura no deseada"
    HEALBOT_OPTION_DISLIKEMOUNT_ON         = "Marcar montura actual como no deseada"
    HEALBOT_CMD_DISMOUNT                   = "Desmontar"
    HEALBOT_OPTION_DISLIKEMOUNT_OFF        = "Dejar de marcar montura actual como no deseada"
    HEALBOT_CMD_COPYSPELLS                 = "Copiar hechizos actuales a todas las especializaciones"
    HEALBOT_CMD_RESETSPELLS                = "Restablecer hechizos"
    HEALBOT_CMD_RESETCURES                 = "Restablecer perjuicios"
    HEALBOT_CMD_RESETBUFFS                 = "Restablecer beneficios"
    HEALBOT_CMD_RESETICONS                 = "Restablecer beneficios personalizados"
    HEALBOT_CMD_RESETBARS                  = "Restablecer posición de las barras"
    HEALBOT_CMD_SUPPRESSSOUND              = "Alternar supresión de sonido al usar abalorios automáticos"
    HEALBOT_CMD_SUPPRESSERRORS             = "Alternar supresión de errores al usar abalorios automáticos"
    HEALBOT_OPTIONS_COMMANDS               = "Comandos de HealBot"
    HEALBOT_WORD_RUN                       = "Ejecutar"
    HEALBOT_OPTIONS_MOUSEWHEEL             = "Usar rueda del ratón"
    HEALBOT_OPTIONS_MOUSEUP                = "Rueda arriba"
    HEALBOT_OPTIONS_MOUSEDOWN              = "Rueda abajo"
    HEALBOT_OPTIONS_BINDTOCLICK            = "Asignar a clic"
    HEALBOT_CMD_DELCUSTOMDEBUFF9           = "Eliminar perjuicios personalizados en prioridad 9"
    HEALBOT_CMD_DELCUSTOMDEBUFF10          = "Eliminar perjuicios personalizados en prioridad 10"
    HEALBOT_CMD_DELCUSTOMDEBUFF11          = "Eliminar perjuicios personalizados en prioridad 11"
    HEALBOT_CMD_DELCUSTOMDEBUFF12          = "Eliminar perjuicios personalizados en prioridad 12"
    HEALBOT_ACCEPTSKINS                    = "Aceptar apariencias de otros"
    HEALBOT_SUPPRESSSOUND                  = "Abalorio automático: Suprimir sonido"
    HEALBOT_SUPPRESSERROR                  = "Abalorio automático: Suprimir errores"
    HEALBOT_PERFLEVEL                      = "Nivel de rendimiento"
    HEALBOT_TALENTINSPECT                  = "Inspeccionar talentos de jugadores"
    HEALBOT_OPTIONS_USEGENERALMACRO        = "Usar ranuras de macros generales"
    HEALBOT_CP_MACRO_LEN                   = "El nombre de la macro debe tener entre 1 y 14 caracteres"
    HEALBOT_CP_MACRO_BASE                  = "Nombre base de macro"
    HEALBOT_CP_MACRO_SAVE                  = "Último guardado: "
    HEALBOT_CP_STARTTIME                   = "Duración de la protección al iniciar sesión"
    HEALBOT_WORD_RESERVED                  = "Reservado"
    HEALBOT_OPTIONS_COMBATPROT             = "Protección en combate"
    HEALBOT_COMBATPROT_PARTYNO             = "Barras reservadas para Grupo"
    HEALBOT_COMBATPROT_RAIDNO              = "Barras reservadas para Banda"
    HEALBOT_SKIN_CHECK_DONE                = "Comprobación de integridad de apariencias completada"
    HEALBOT_ENABLE_CUSTOM_BUFFS            = "Se han habilitado todos los beneficios personalizados"
    HEALBOT_ENABLE_CUSTOM_DEBUFFS          = "Se han habilitado todos los perjuicios personalizados"
    HEALBOT_ALLOW_DUPLICATES               = "Permitir duplicados"
    HEALBOT_ALLOW_DUPLICATESINCPRIVLISTS   = "Incluir listas privadas"
    HEALBOT_OPTIONS_AUXSETTINGS            = "Ajustes de barras auxiliares"
    HEALBOT_OPTIONS_AUXASSIGN              = "Asignaciones de barras auxiliares"
    HEALBOT_OPTIONS_AUXCONFIG              = "Configuración de barra auxiliar"
    HEALBOT_OPTIONS_VISSTANDARD            = "Marcos estándar"
    HEALBOT_OPTIONS_ENEMYAURAS             = "Auras enemigas"
    HEALBOT_OPTIONS_BOSSAURA               = "Aura de jefe"
    HEALBOT_OPTIONS_ENEMYFRAME             = "Marco de enemigos"
    HEALBOT_OPTIONS_PLAYERFRAMES           = "Marcos de jugadores"
    HEALBOT_OPTIONS_AUXFLASH               = "Opacidad variable"
    HEALBOT_WORD_ASSIGNMENT                = "Asignación:"
    HEALBOT_WORD_ANCHOR                    = "Anclaje:"
    HEALBOT_OPTIONS_AUXOVERLAP             = "Extender tamaño de barras aux."
    HEALBOT_OPTIONS_AUXINDCONFIG           = "Configuración individual de barra"
    HEALBOT_OPTIONS_AUX                    = "Barra aux."
    HEALBOT_OPTIONS_FULLAUX                = "Barra auxiliar "
    HEALBOT_OPTIONS_AUXOPACITYTYPE         = "Tipo de opacidad"
    HEALBOT_OPTIONS_AUXOPACITYTYPE1        = "Fija"
    HEALBOT_OPTIONS_AUXOPACITYTYPE2        = "Variable"

    HEALBOT_WORD_HEALTH                    = "Salud"
    HEALBOT_WORD_GOLD                      = "Oro"
    HEALBOT_WORD_SILVER                    = "Plata"
    HEALBOT_WORD_BLUE                      = "Azul"
    HEALBOT_WORD_RED                       = "Rojo"
    HEALBOT_WORD_GREEN                     = "Verde"
    HEALBOT_WORD_AQUA                      = "Aguamarina"
    HEALBOT_WORD_WHITE                     = "Blanco"
    HEALBOT_WORD_DARK                      = "Oscuro"
    HEALBOT_WORD_ORANGE                    = "Naranja"
    HEALBOT_WORD_LIME                      = "Lima"
    HEALBOT_WORD_YELLOW                    = "Amarillo"
    HEALBOT_WORD_FUCHSIA                   = "Fucsia"
    HEALBOT_WORD_PURPLE                    = "Morado"
    HEALBOT_WORD_PINK                      = "Rosa"
    HEALBOT_WORD_TEAL                      = "Verde azulado"
    HEALBOT_WORD_BROWN                     = "Marrón"
    HEALBOT_WORD_BLACK                     = "Negro"
    HEALBOT_WORD_AND                       = "y"
    HEALBOT_WORD_PLAYERS                   = "Jugadores"
    HEALBOT_WORD_PLAYER                    = "Jugador"
    HEALBOT_OPTIONS_CPUUSAGE               = "Uso de CPU"
    HEALBOT_OPTIONS_THEME                  = "Tema de opciones"
    HEALBOT_OPTIONS_FRAMESTRATA            = "Estrato del marco"
    HEALBOT_OPTIONS_DONT_SHOW              = "No mostrar"
    HEALBOT_OPTIONS_HAZARDONLY             = "Solo peligro"
    HEALBOT_OPTIONS_SAME_AS_HLTH_CURRENT   = "Igual que la salud (salud actual)"
    HEALBOT_OPTIONS_SAME_AS_HLTH_FUTURE    = "Igual que la salud (salud futura)"
    HEALBOT_OPTIONS_FUTURE_HLTH            = "Salud futura"
    HEALBOT_OPTIONS_CLASSHLTHMIX           = "Mezcla de clase y salud"
    HEALBOT_OPTIONS_ROLEHLTHMIX            = "Mezcla de rol y salud"
    HEALBOT_OPTIONS_ADAPTIVE               = "Adaptativo"
    HEALBOT_OPTIONS_ADAPTIVECLASSMIX       = "Mezcla adaptativa de clase"
    HEALBOT_OPTIONS_ADAPTIVEROLEMIX        = "Mezcla adaptativa de rol"
    HEALBOT_OPTIONS_ADAPTIVECUSTOMMIX      = "Mezcla adaptativa personalizada"
    HEALBOT_OPTIONS_ADAPTIVEONLY           = "Solo adaptativo"
    HEALBOT_OPTIONS_ADAPTIVEHEALTHBAR      = "Adaptativo y barra de salud"
    HEALBOT_OPTIONS_HEALTHBARONLY          = "Solo barra de salud"
    HEALBOT_SKIN_HEALTHBARCOL_TEXT         = "Barra de salud"
    HEALBOT_SKIN_BORDER_HAZARD             = "Peligro en el borde"
    HEALBOT_SKIN_BORDER_HAZARDU            = "Peligro en el borde"
    HEALBOT_SKIN_BORDER_SOLID              = "Borde sólido"
    HEALBOT_SKIN_FRAME_GLOW                = "Líneas de resplandor"
    HEALBOT_SKIN_FRAME_GLOWSTARS           = "Estrellas de resplandor"
    HEALBOT_SKIN_FRAME_GLOWBLIZZ           = "Resplandor alternativo de Blizzard"
    HEALBOT_SKIN_BORDER_COL                = "Color del borde"
    HEALBOT_SKIN_NAMETEXTCOL_TEXT          = "Color del texto"
    HEALBOT_SKIN_OVERLAYCOL_TEXT           = "Color de superposición adaptativa"
    HEALBOT_SKIN_HEALTHBACKCOL_TEXT        = "Barra de fondo";
    HEALBOT_SKIN_BACKBORDERCOL_TEXT        = "Borde de fondo";
    HEALBOT_SKIN_INCHEALBARCOL_TEXT        = "Sanaciones entrantes";
    HEALBOT_OPTIONS_ALWAYS_SHOW_TARGET     = "Objetivo: mostrar siempre"
    HEALBOT_OPTIONS_ALWAYS_SHOW_FOCUS      = "Foco: mostrar siempre"
    HEALBOT_OPTIONS_GROUP_PETS_BY_FIVE     = "Mascotas: grupos de cinco"
    HEALBOT_OPTIONS_OWN_PET_WITH_SELF      = "Mascota propia: con uno mismo"
    HEALBOT_OPTIONS_USEGAMETOOLTIP         = "Usar fuentes y colores de la descripción emergente del juego"
    HEALBOT_OPTIONS_SHOWWOWTOOLTIP         = "Mostrar información de la descripción emergente del juego"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER       = "Mostrar contador de poder"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER_PALA  = "Mostrar poder sagrado"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER_ROGU  = "Mostrar puntos de combo"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER_WARL  = "Mostrar fragmentos de alma"
    HEALBOT_OPTIONS_SHOWPOWERCOUNTER_MONK  = "Mostrar poder de chi"
    HEALBOT_OPTIONS_CUSTOMDEBUFF_REVDUR    = "Duración inversa"
    HEALBOT_OPTIONS_DISABLEHEALBOTSOLO     = "solo cuando esté en solitario"
    HEALBOT_OPTIONS_DISABLEHEALBOTSPEC     = "Desactivar en la especialización "
    HEALBOT_OPTIONS_CUSTOM_ALLDISEASE      = "Todas las enfermedades"
    HEALBOT_OPTIONS_CUSTOM_ALLMAGIC        = "Toda la magia"
    HEALBOT_OPTIONS_CUSTOM_ALLCURSE        = "Todas las maldiciones"
    HEALBOT_OPTIONS_CUSTOM_ALLBLEED        = "Todos los sangrados"
    HEALBOT_OPTIONS_CUSTOM_ALLPOISON       = "Todos los venenos"
    HEALBOT_OPTIONS_CUSTOM_ALLBOSS         = "Todos los jefes"
    HEALBOT_OPTIONS_CUSTOM_ALLTIMED        = "Todos los temporales"
    HEALBOT_OPTIONS_CUSTOM_IDMETHOD        = "Identificar por"
    HEALBOT_OPTIONS_CUSTOM_CASTBY          = "Lanzado por"
    HEALBOT_OPTIONS_CUSTOM_IDMETHODSID     = "ID de hechizo"
    HEALBOT_WORDS_SPELLNAME                = "Nombre del hechizo"
    HEALBOT_OPTIONS_CUSTOM_IDMETHODSBOTH   = "ID y nombre"

    HEALBOT_FOLLOW                         = "Seguir"
    HEALBOT_TRADE                          = "Comerciar"
    HEALBOT_PROMOTE_RA                     = "Ascender a ayudante de banda"
    HEALBOT_DEMOTE_RA                      = "Degradar de ayudante de banda"
    HEALBOT_BLIZZARD_MENU                  = "Menú de Blizzard"
    HEALBOT_HB_MENU                        = "Menú de HealBot"
    HEALBOT_TARGETVEHICLE                  = "Seleccionar vehículo o mascota"
    HEALBOT_TOGGLE_ENABLED                 = "Alternar habilitado"
    HEALBOT_TOGGLE_MYTARGETS               = "Alternar Lista privada"
    HEALBOT_TOGGLE_PRIVTANKS               = "Alternar Tanques privados"
    HEALBOT_TOGGLE_PRIVHEALS               = "Alternar Sanadores privados"
    HEALBOT_TOGGLE_PRIVDPS                 = "Alternar Atacantes privados"
    HEALBOT_WORD_PERMANENT                 = "Permanente"
    HEALBOT_TOGGLE_PERMPRIVLISTS           = "Alternar Lista privada permanente"
    HEALBOT_TOGGLE_PERMPRIVTANKS           = "Alternar Tanques privados permanentes"
    HEALBOT_TOGGLE_PERMPRIVHEALS           = "Alternar Sanadores privados permanentes"
    HEALBOT_TOGGLE_PERMPRIVDPS             = "Alternar Atacantes privados permanentes"
    HEALBOT_TOGGLE_PRIVATETANKS            = HEALBOT_TOGGLE_PRIVTANKS
    HEALBOT_TOGGLE_PRIVATEHEALERS          = HEALBOT_TOGGLE_PRIVHEALS
    HEALBOT_RESET_BAR                      = "Restablecer barra"
    HEALBOT_HIDE_BARS                      = "Ocultar barras cuando el jugador no sea visible (a más de 100 metros)"
    HEALBOT_MOUNTSPETS                     = "Menú de monturas y mascotas"
    HEALBOT_FAVMOUNT                       = "Montura favorita"
    HEALBOT_FAVPET                         = "Mascota favorita"
    HEALBOT_MOUNTS                         = "Monturas"
    HEALBOT_RANDOMMOUNT                    = "Montura aleatoria"
    HEALBOT_RANDOMGOUNDMOUNT               = "Montura terrestre aleatoria"
    HEALBOT_RANDOMPET                      = "Mascota aleatoria"
    HEALBOT_RANDOMFAVMOUNT                 = "Montura favorita aleatoria"
    HEALBOT_RANDOMFAVPET                   = "Mascota favorita aleatoria"
    HEALBOT_EXTRASKINS_CAT_SRAID           = "Banda pequeña"
    HEALBOT_EXTRASKINS_CAT_LRAID           = "Banda grande"
    HEALBOT_MACRO                          = "Macro"
    HEALBOT_ACTION                         = "Acción"
    HEALBOT_EMOTE                          = "Emoción"
    HEALBOT_EMOTES                         = "Emociones"
    HEALBOT_EMOTE_CAT_COMBAT               = "Combate"
    HEALBOT_EMOTE_CAT_EMOTION              = "Emoción"
    HEALBOT_EMOTE_CAT_HAPPY                = "Feliz"
    HEALBOT_EMOTE_CAT_GREET                = "Saludo"
    HEALBOT_EMOTE_CAT_OTHER                = "Otros"
    HEALBOT_EMOTE_CAT_RESPECT              = "Respeto"
    HEALBOT_EMOTE_CAT_UNHAPPY              = "Infeliz"
    HEALBOT_EMOTE_ANGRY                    = "Enfadado"
    HEALBOT_EMOTE_APPLAUD                  = "Aplaudir"
    HEALBOT_EMOTE_ATTACKTARGET             = "Atacar objetivo"
    HEALBOT_EMOTE_BASHFUL                  = "Tímido"
    HEALBOT_EMOTE_BEG                      = "Suplicar"
    HEALBOT_EMOTE_BLOW                     = "Mandar beso"
    HEALBOT_EMOTE_BLUSH                    = "Sonrojarse"
    HEALBOT_EMOTE_BOGGLE                   = "Asombrarse"
    HEALBOT_EMOTE_BORED                    = "Aburrido"
    HEALBOT_EMOTE_BOW                      = "Reverencia"
    HEALBOT_EMOTE_BYE                      = "Adiós"
    HEALBOT_EMOTE_CACKLE                   = "Carcajada"
    HEALBOT_EMOTE_CHARGE                   = "Cargar"
    HEALBOT_EMOTE_CHEER                    = "Vitorear"
    HEALBOT_EMOTE_CHUCKLE                  = "Reír entre dientes"
    HEALBOT_EMOTE_CLAP                     = "Palmadas"
    HEALBOT_EMOTE_COMMEND                  = "Elogiar"
    HEALBOT_EMOTE_CONFUSED                 = "Confundido"
    HEALBOT_EMOTE_CONGRATS                 = "Felicitar"
    HEALBOT_EMOTE_COWER                    = "Acobardarse"
    HEALBOT_EMOTE_CRY                      = "Llorar"
    HEALBOT_EMOTE_CURIOUS                  = "Curioso"
    HEALBOT_EMOTE_CURTSEY                  = "Cortesía"
    HEALBOT_EMOTE_DANCE                    = "Bailar"
    HEALBOT_EMOTE_DOOM                     = "Condenar"
    HEALBOT_EMOTE_DRINK                    = "Beber"
    HEALBOT_EMOTE_EAT                      = "Comer"
    HEALBOT_EMOTE_EXCITED                  = "Entusiasmado"
    HEALBOT_EMOTE_FLEE                     = "Huir"
    HEALBOT_EMOTE_FLEX                     = "Sacar músculo"
    HEALBOT_EMOTE_FLIRT                    = "Coquetear"
    HEALBOT_EMOTE_FOLLOWME                 = "Sígueme"
    HEALBOT_EMOTE_GASP                     = "Jadear"
    HEALBOT_EMOTE_GIGGLE                   = "Risita"
    HEALBOT_EMOTE_GLOAT                    = "Regodearse"
    HEALBOT_EMOTE_GOLFCLAP                 = "Aplauso sarcástico"
    HEALBOT_EMOTE_GREET                    = "Saludar"
    HEALBOT_EMOTE_GROVEL                   = "Humillarse"
    HEALBOT_EMOTE_GROWL                    = "Gruñir"
    HEALBOT_EMOTE_GUFFAW                   = "Risotada"
    HEALBOT_EMOTE_HAIL                     = "Aclamar"
    HEALBOT_EMOTE_HEALME                   = "Sáname"
    HEALBOT_EMOTE_HELLO                    = "Hola"
    HEALBOT_EMOTE_INCOMING                 = "Enemigos a la vista"
    HEALBOT_EMOTE_INSULT                   = "Insultar"
    HEALBOT_EMOTE_KISS                     = "Besar"
    HEALBOT_EMOTE_KNEEL                    = "Arrodillarse"
    HEALBOT_EMOTE_LAUGH                    = "Reír"
    HEALBOT_EMOTE_LAY                      = "Tumbarse"
    HEALBOT_EMOTE_LOST                     = "Perdido"
    HEALBOT_EMOTE_MOURN                    = "Lamentar"
    HEALBOT_EMOTE_NO                       = "No"
    HEALBOT_EMOTE_NOD                      = "Asentir"
    HEALBOT_EMOTE_OOM                      = "Sin maná"
    HEALBOT_EMOTE_OPENFIRE                 = "Abrir fuego"
    HEALBOT_EMOTE_POINT                    = "Señalar"
    HEALBOT_EMOTE_PRAY                     = "Rezar"
    HEALBOT_EMOTE_PUZZLED                  = "Perplejo"
    HEALBOT_EMOTE_RASP                     = "Burla"
    HEALBOT_EMOTE_ROAR                     = "Rugir"
    HEALBOT_EMOTE_ROFL                     = "Partirse de risa"
    HEALBOT_EMOTE_ROLLEYES                 = "Poner los ojos en blanco"
    HEALBOT_EMOTE_RUDE                     = "Grosero"
    HEALBOT_EMOTE_SALUTE                   = "Saludo militar"
    HEALBOT_EMOTE_SHRUG                    = "Encogerse de hombros"
    HEALBOT_EMOTE_SHY                      = "Vergonzoso"
    HEALBOT_EMOTE_SIGH                     = "Suspirar"
    HEALBOT_EMOTE_SILLY                    = "Chiste"
    HEALBOT_EMOTE_SLEEP                    = "Dormir"
    HEALBOT_EMOTE_SURRENDER                = "Rendirse"
    HEALBOT_EMOTE_TALK                     = "Hablar"
    HEALBOT_EMOTE_TAUNT                    = "Provocar"
    HEALBOT_EMOTE_THANK                    = "Agradecer"
    HEALBOT_EMOTE_TRAIN                    = "Tren"
    HEALBOT_EMOTE_VICTORY                  = "Victoria"
    HEALBOT_EMOTE_VIOLIN                   = "Violín"
    HEALBOT_EMOTE_WAIT                     = "Espera"
    HEALBOT_EMOTE_WAVE                     = "Agitar la mano"
    HEALBOT_EMOTE_WELCOME                  = "Dar la bienvenida"
    HEALBOT_ZONE_AQ40                      = "Ahn'Qiraj"
    HEALBOT_ZONE_VASHJIR1                  = "Bosque Kelp'thar"
    HEALBOT_ZONE_VASHJIR2                  = "Extensión Bruñida"
    HEALBOT_ZONE_VASHJIR3                  = "Profundidades Abisales"
    HEALBOT_ZONE_VASHJIR                   = "Vashj'ir"
    HEALBOT_PRELOADOPTIONS_ON              = "Precargar opciones está activado"
    HEALBOT_PRELOADOPTIONS_OFF             = "Precargar opciones está desactivado"
    HEALBOT_RESLAG_INDICATOR               = "Mantener nombre en verde tras resurrección establecido en"
    HEALBOT_CLASSIC_HOT_IHDUR              = "Duración de sanación entrante de SeT clásico establecida en"
    HEALBOT_RESLAG_INDICATOR_ERROR         = "Número no válido - El número debe estar entre 1 y 30"
    HEALBOT_AGGRO2_ERROR_MSG               = "Para establecer el nivel de amenaza 2, el porcentaje de amenaza debe estar entre 25 y 95"
    HEALBOT_AGGRO3_ERROR_MSG               = "Para establecer el nivel de amenaza 3, el porcentaje de amenaza debe estar entre 75 y 100"
    HEALBOT_AGGRO2_SET_MSG                 = "Nivel de amenaza 2 establecido en el porcentaje de amenaza "
    HEALBOT_AGGRO3_SET_MSG                 = "Nivel de amenaza 3 establecido en el porcentaje de amenaza "
    HEALBOT_WORD_THREAT                    = "Amenaza"
    HEALBOT_AGGRO_ERROR_MSG                = "Nivel de amenaza no válido - use 2 o 3"

    HEALBOT_OPTIONS_QUERYTALENTS           = "Consultar información de talentos"
    HEALBOT_OPTIONS_LOWMANAINDICATOR       = "Indicador de maná bajo"
    HEALBOT_OPTIONS_LOWMANA                = "Maná bajo"
    HEALBOT_OPTIONS_LOWMANAINDICATOR1      = "No mostrar"
    HEALBOT_OPTIONS_LOWMANAINDICATOR2      = "*10% / **20% / ***30%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR3      = "*15% / **30% / ***45%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR4      = "*20% / **40% / ***60%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR5      = "*25% / **50% / ***75%"
    HEALBOT_OPTIONS_LOWMANAINDICATOR6      = "*30% / **60% / ***90%"

    HEALBOT_OPTIONS_SELFCASTIND            = "Lanzamiento propio"
    HEALBOT_OPTION_IGNORE_AURA_RESTED      = "Ignorar eventos de auras al descansar"

    HEALBOT_WORD_ENABLE                    = "Habilitar"
    HEALBOT_WORD_DISABLE                   = "Deshabilitar"

    HEALBOT_OPTIONS_PLUGINS                = "Complementos"
    HEALBOT_OPTIONS_PLUGIN_NA              = "Complemento no disponible"
    HEALBOT_OPTIONS_PLUGINTXT              = "Texto de complemento"
    HEALBOT_OPTIONS_AUXPLUGINTXT           = "Aux.: Texto de complemento"

    HEALBOT_OPTIONS_CONTENT_ABOUT          = "        Acerca de"
    HEALBOT_OPTIONS_CONTENT_OVERRIDES      = "        " .. HEALBOT_OPTIONS_TAB_OVERRIDES
    HEALBOT_OPTIONS_CONTENT_GENERAL        = "        " .. HEALBOT_OPTIONS_TAB_GENERAL
    HEALBOT_OPTIONS_CONTENT_SPELLS         = "        " .. HEALBOT_OPTIONS_TAB_SPELLS
    HEALBOT_OPTIONS_CONTENT_SKINS          = "        " .. HEALBOT_OPTIONS_TAB_SKIN
    HEALBOT_OPTIONS_CONTENT_CURE           = "        " .. HEALBOT_OPTIONS_TAB_DEBUFFS
    HEALBOT_OPTIONS_CONTENT_BUFFS          = "        " .. HEALBOT_OPTIONS_TAB_BUFFS
    HEALBOT_OPTIONS_CONTENT_TIPS           = "        " .. HEALBOT_OPTIONS_TAB_TIPS
    HEALBOT_OPTIONS_CONTENT_MOUSEWHEEL     = "        Rueda del ratón"
    HEALBOT_OPTIONS_CONTENT_BINDS          = "        Atajos"
    HEALBOT_OPTIONS_CONTENT_TEST           = "        Prueba"
    HEALBOT_OPTIONS_CONTENT_USAGE          = "        Uso"
    HEALBOT_OPTIONS_CONTENT_INOUT          = "        Importar / Exportar"
    HEALBOT_OPTIONS_CONTENT_PLUGINS        = "        " .. HEALBOT_OPTIONS_PLUGINS
    HEALBOT_OPTIONS_REFRESH                = "Actualizar"

    HEALBOT_CUSTOM_CATEGORY                = "Categoría"
    HEALBOT_CUSTOM_CAT_CUSTOM              = "Personalizado"
    HEALBOT_CUSTOM_CAT_01                  = "0-9"
    HEALBOT_CUSTOM_CAT_02                  = "A-B"
    HEALBOT_CUSTOM_CAT_03                  = "C-D"
    HEALBOT_CUSTOM_CAT_04                  = "E-F"
    HEALBOT_CUSTOM_CAT_05                  = "G-H"
    HEALBOT_CUSTOM_CAT_06                  = "I-J"
    HEALBOT_CUSTOM_CAT_07                  = "K-L"
    HEALBOT_CUSTOM_CAT_08                  = "M-N"
    HEALBOT_CUSTOM_CAT_09                  = "O-P"
    HEALBOT_CUSTOM_CAT_10                  = "Q-R"
    HEALBOT_CUSTOM_CAT_11                  = "S-T"
    HEALBOT_CUSTOM_CAT_12                  = "U-V"
    HEALBOT_CUSTOM_CAT_13                  = "W-X"
    HEALBOT_CUSTOM_CAT_14                  = "Y-Z"
    HEALBOT_CUSTOM_CAT_15                  = "Otros"

    HEALBOT_PLUGIN_THREAT                  = "HealBot: Amenaza"
    HEALBOT_PLUGIN_TIMETODIE               = "HealBot: Tiempo para morir"
    HEALBOT_PLUGIN_TIMETOLIVE              = "HealBot: Tiempo de vida"
    HEALBOT_PLUGIN_EXTRABUTTONS            = "HealBot: Botones adicionales"
    HEALBOT_PLUGIN_COMBATPROT              = "HealBot: Protección en combate"
    HEALBOT_PLUGIN_PERFORMANCE             = "HealBot: Rendimiento"
    HEALBOT_PLUGIN_MYCOOLDOWNS             = "HealBot: Mis reutilizaciones"
    HEALBOT_PLUGIN_TWEAKS                  = "HealBot: Ajustes avanzados"
    HEALBOT_PLUGIN_MEDIA                   = "HealBot: Multimedia"
    HEALBOT_PLUGIN_REQUESTS                = "HealBot: Peticiones"
    HEALBOT_PLUGIN_AURAWATCH               = "HealBot: Vigilancia de auras"
    HEALBOT_PLUGIN_HEALTHWATCH             = "HealBot: Vigilancia de salud"
    HEALBOT_PLUGIN_MANAWATCH               = "HealBot: Vigilancia de maná"
    HEALBOT_PLUGIN_THREATPCT               = "Amenaza mínima"
    HEALBOT_PLUGIN_THREATMOBBARCOL         = "Color de barra de criatura"
    HEALBOT_PLUGIN_THREATMOBTEXTCOL        = "Color de texto de criatura"
    HEALBOT_PLUGIN_COOLDOWNDURCOLS         = "Colores de duración de reutilización"
    HEALBOT_PLUGIN_SHORTDUR                = "Umbral de corta duración (s)"
    HEALBOT_PLUGIN_MEDIUMDUR               = "Umbral de media duración (s)"
    HEALBOT_PLUGIN_ICONPOS                 = "Iconos en el lado derecho del marco"
    HEALBOT_PLUGIN_BARDIR                  = "Las barras se reducen de derecha a izquierda"
    HEALBOT_PLUGIN_SHOWNAME                = "Mostrar nombre del hechizo"
    HEALBOT_PLUGIN_SHOWTIME                = "Mostrar tiempo restante"
    HEALBOT_PLUGIN_NAMECLASS               = "Nombre (Clase)"
    HEALBOT_PLUGIN_LASTSEEN                = "Visto por última vez"
    HEALBOT_PLUGIN_BLACKLISTSESSION        = "Añadir durante la sesión"
    HEALBOT_PLUGIN_BLACKLISTPERM           = "Añadir permanentemente"
    HEALBOT_PLUGIN_BLACKLISTREMOVE         = "Quitar"
    HEALBOT_PLUGIN_BLACKLISTED             = "En lista negra"
    HEALBOT_PLUGIN_BLACKLISTEDHELP         = "(*) = En lista negra permanentemente"
    HEALBOT_OPTIONS_USECP                  = "Usar protección contra cierres inesperados"
    HEALBOT_OPTIONS_USECPGROUP             = "Usar protección en combate en grupos"
    HEALBOT_OPTIONS_USECPRAID              = "Usar protección en combate en bandas"
    HEALBOT_OPTIONS_CPLOGONDURATION        = "Duración de la protección tras iniciar sesión"
    HEALBOT_PLUGIN_EXTRABUTTONS_0610       = "Botones 6 - 10"
    HEALBOT_PLUGIN_EXTRABUTTONS_1115       = "Botones 11 - 15"
    HEALBOT_PLUGIN_EXTRABUTTONS_1620       = "Botones 16 - 20"
    HEALBOT_PLUGIN_INTTIMER                = "Temporizadores internos y comprobaciones de alcance"
    HEALBOT_PLUGIN_FLUIDFREQ               = "Efectos - Actualizaciones fluidas"
    HEALBOT_PLUGIN_FLASHFREQ               = "Efectos - Actualizaciones de destello"
    HEALBOT_PLUGIN_STATEFREQ               = "Efectos - Actualizaciones de estado"
    HEALBOT_PLUGIN_CPMACRO                 = "Nombre de macro: "
    HEALBOT_PLUGIN_AGGRO2THRESHOLD         = "Umbral de amenaza de nivel 2"
    HEALBOT_PLUGIN_AGGRO3THRESHOLD         = "Umbral de amenaza de nivel 3"
    HEALBOT_PLUGIN_AUXMAXINHEALS           = "Valor máx. de sanaciones entrantes en barra aux."
    HEALBOT_PLUGIN_AUXMAXABSORBS           = "Valor máx. de absorciones en barra aux."
    HEALBOT_PLUGIN_AURAHISTORY             = "Historial de auras"
    HEALBOT_PLUGIN_AURAHISTKEEPDAYS        = "Historial de auras - días conservados"
    HEALBOT_PLUGIN_AURAFREQSAVES           = "Guardados frecuentes"
    HEALBOT_PLUGIN_INHEALHOTTIME           = "Tiempo de SeT en sanaciones entrantes"
    HEALBOT_PLUGIN_AUTOTIMEDBUFFDURATION   = "Duración automática de todos los beneficios temporales menor de"
    HEALBOT_PLUGIN_AUTOTIMEDDURATION       = "Duración automática de todos los perjuicios temporales menor de"
    HEALBOT_PLUGIN_SORTBYTOPROLE           = "Ordenar por rol - Rol principal"
    HEALBOT_PLUGIN_USETRINKET10            = "Abalorio automático incluye guantes"
    HEALBOT_PLUGIN_CLASSICPLAYERROLES      = "Permitir roles de jugador en grupos y bandas"
    HEALBOT_PLUGIN_CLASSICNORANKS          = "No mostrar rangos en los hechizos de sanación"
    HEALBOT_PLUGIN_REQUESTTEXT             = "Texto de petición"
    HEALBOT_PLUGIN_FILTER                  = "Filtro"
    HEALBOT_PLUGIN_NOFILTER                = "Sin filtro"
    HEALBOT_PLUGIN_REQUESTTABILITY         = "Facultad solicitada"
    HEALBOT_PLUGIN_REQUESTTTIMEOUT         = "Tiempo de espera de la petición"
    HEALBOT_PLUGIN_BUFFCANCELSREQUEST      = "El beneficio cancela la petición"
    HEALBOT_PLUGIN_RANGECANCELSREQUEST     = "Jugador visible cancela la petición"
    HEALBOT_PLUGIN_DUPCANCELSREQUEST       = "Una petición duplicada cancela la petición"
    HEALBOT_PLUGIN_REQUEST                 = "Petición"
    HEALBOT_PLUGIN_REQUESTTOOLTIP          = "Mostrar en la descripción emergente";
    HEALBOT_PLUGIN_REQUESTWARN             = "Mostrar texto de aviso";
    HEALBOT_PLUGIN_REQUESTCOL              = "Color de petición"
    HEALBOT_PLUGIN_REQUESTSOUND            = "Reproducir sonido al recibir petición";
    HEALBOT_PLUGIN_AURAWATCHTARGETPLAYERS  = "Jugadores objetivo";
    HEALBOT_PLUGIN_AURAWATCHPLAYERSFILTER  = "Filtro de jugadores objetivo";
    HEALBOT_PLUGIN_AURAWATCHSELFFILTER     = "Filtro propio";
    HEALBOT_PLUGIN_BUFFWATCHONLYINCOMBAT   = "Solo en combate";
    HEALBOT_PLUGIN_BUFFWATCHSELFBUFF       = "Mi hechizo";
    HEALBOT_PLUGIN_BUFFWATCHPLAYERSBUFF    = "Beneficio de jugadores objetivo";
    HEALBOT_PLUGIN_BUFFWATCHPLAYERSTAG     = "Etiqueta de jugadores objetivo";
    HEALBOT_PLUGIN_BUFFWATCHPLAYERSDEBUFF  = "Perjuicio de jugadores objetivo";
    HEALBOT_PLUGIN_BUFFWATCHSELFBUFFH      = "Alertar cuando termine la reutilización del hechizo";
    HEALBOT_PLUGIN_BUFFWATCHSTATE1         = "Inactivo"
    HEALBOT_PLUGIN_BUFFWATCHSTATE2         = "Esperar reutilización "
    HEALBOT_PLUGIN_BUFFWATCHSTATE3         = "Esperar a "
    HEALBOT_PLUGIN_BUFFWATCHSTATE5         = "Esperando combate"
    HEALBOT_PLUGIN_BUFFWATCHTTIMEOUT       = "Tiempo de espera de alerta"
    HEALBOT_PLUGIN_BUFFWATCHCOL            = "Color de alerta"
    HEALBOT_PLUGIN_STACKS                  = "Acumulaciones"
    HEALBOT_PLUGIN_BUFFWATCHSOUND          = "Reproducir sonido";
    HEALBOT_PLUGIN_AURAWATCHT              = "Vigilar"
    HEALBOT_PLUGIN_AURAWATCHBUFFEXISTS     = "Existe beneficio"
    HEALBOT_PLUGIN_AURAWATCHBUFFEXISTSTAG  = "Existe beneficio con etiqueta"
    HEALBOT_PLUGIN_AURAWATCHBUFFEXPIRE     = "Existe o no existe beneficio"
    HEALBOT_PLUGIN_AURAWATCHBUFFNOTEXIST   = "No existe beneficio"
    HEALBOT_PLUGIN_AURAWATCHDEBUFFEXISTS   = "Existe perjuicio"
    HEALBOT_PLUGIN_AURAWATCHDEBUFFEXISTSTAG= "Existe perjuicio con etiqueta"
    HEALBOT_PLUGIN_AURAWATCHDEBUFFEXPIRE   = "Existe o no existe perjuicio"
    HEALBOT_PLUGIN_AURAWATCHDEBUFFNOTEXIST = "No existe perjuicio"
    HEALBOT_PLUGIN_AURAWATCHHEALTHBELOW    = "Salud inferior a"
    HEALBOT_PLUGIN_AURAWATCHHEALTHABOVE    = "Salud superior a"
    HEALBOT_PLUGIN_AURAWATCHMANABELOW      = "Maná inferior a"
    HEALBOT_PLUGIN_AURAWATCHMANAABOVE      = "Maná superior a"
    HEALBOT_PLUGIN_AURAWATCHAGGROLEVEL     = "Nivel de amenaza"
    HEALBOT_PLUGIN_AURAWATCHRAIDTARGET     = "Objetivo de banda"
    HEALBOT_PLUGIN_AURAWATCHRAIDTARGETF    = "Filtrar objetivo de banda"
    HEALBOT_PLUGIN_AURAWATCHHEALGRPCFG     = "Configuración de grupos de sanación"
    HEALBOT_PLUGIN_AURAWATCHSBEXISTS       = "Existe beneficio en uno mismo"
    HEALBOT_PLUGIN_AURAWATCHSBEXISTSTAG    = "Existe beneficio en uno mismo con etiqueta"
    HEALBOT_PLUGIN_AURAWATCHCHAT           = "El jugador dice"
    HEALBOT_PLUGIN_AURAWATCHISALIVE        = "El jugador está vivo"
    HEALBOT_PLUGIN_AURAWATCHCHATTEXT       = "Texto de chat"
    HEALBOT_PLUGIN_AURAWATCHCHATCHAN       = "Canal de chat"
    HEALBOT_PLUGIN_AURAWATCHCHATTIME       = "Válido durante"
    HEALBOT_PLUGIN_ALERTRANGE              = "Alcance de alerta"
    HEALBOT_PLUGIN_TWEAKSDELETEALL         = "Eliminar todo"
    HEALBOT_PLUGIN_TWEAKSENABLEALL         = "Habilitar todo"
    HEALBOT_PLUGIN_TWEAKSDISABLEALL        = "Deshabilitar todo"
    HEALBOT_PLUGIN_TWEAKSRESETALL          = "Restablecer todo"
    HEALBOT_PLUGIN_TWEAKSCASTBYALL         = "Establecer «Lanzado por: Cualquiera» en todos"
    HEALBOT_PLUGIN_TWEAKSCASTBYSELF        = "Establecer «Lanzado por: Uno mismo» en todos"
    HEALBOT_PLUGIN_TWEAKSCOLOURNONE        = "Establecer todos en Ninguno"
    HEALBOT_PLUGIN_TWEAKSCOLOURADAPTIVE    = "Establecer todos en Solo adaptativo"
    HEALBOT_PLUGIN_TWEAKSCOLOURADAPTBAR    = "Establecer todos en Adaptativo y barra de salud"
    HEALBOT_PLUGIN_TWEAKSCOLOURBARCOL      = "Establecer todos en Solo barra de salud"
    HEALBOT_PLUGIN_TWEAKSCOLOURHAZARD      = "Establecer todos en Peligro en el borde"
    HEALBOT_PLUGIN_TWEAKSCOLOURLINES       = "Establecer todos en Líneas de resplandor"
    HEALBOT_PLUGIN_TWEAKSCOLOURSTARS       = "Establecer todos en Estrellas de resplandor"
    HEALBOT_PLUGIN_TWEAKSCOLOURBLIZZARD    = "Establecer todos en Resplandor alternativo de Blizzard"
    HEALBOT_PLUGIN_TWEAKSCOLOURSOLID       = "Establecer todos en Borde sólido"
    HEALBOT_PLUGIN_HEALTHALERTLEVEL        = "Nivel de alerta de salud"
    HEALBOT_PLUGIN_MANAALERTLEVEL          = "Nivel de alerta de maná"
    HEALBOT_PLUGIN_ALERTMETHOD             = "Método de alerta"
    HEALBOT_PLUGIN_FORWARDTOHW             = "Reenviar a Vigilancia de salud"
    HEALBOT_PLUGIN_FORWARDTOMW             = "Reenviar a Vigilancia de maná"
    HEALBOT_PLUGIN_RETRYDURATION           = "Recibido de Vigilancia de beneficios - Duración de reintento"
    HEALBOT_PLUGIN_REPEATONCD              = "Repetir tras tiempo de espera"
    HEALBOT_PLUGIN_QUEUEVENTBUFF           = "Poner en cola eventos de auras (Beneficios)"
    HEALBOT_PLUGIN_QUEUEVENTDEBUFF         = "Poner en cola eventos de auras (Perjuicios)"
    HEALBOT_PLUGIN_QUEUEVENTHEALTH         = "Poner en cola eventos de salud"
    HEALBOT_PLUGIN_QUEUEVENTPOWER          = "Poner en cola eventos de poder"
    HEALBOT_PLUGIN_QUEUEVENTINHEALS        = "Poner en cola eventos de sanación entrante"
    HEALBOT_PLUGIN_QUEUEVENTABSORBS        = "Poner en cola eventos de absorción"
    HEALBOT_PLUGIN_MEDIAEXAMPLEBAR         = "Barra de estado de ejemplo 321"
    HEALBOT_PLUGIN_TWEAKSCUSTOMCOL         = "Establecer todos los colores en este"
    HEALBOT_PLUGIN_TWEAKSLISTHELP          = "El foco privado es por personaje. Todas las demás listas son globales."
    HEALBOT_PLUGIN_GROWUP                  = "Crecer de abajo hacia arriba";
    HEALBOT_PLUGIN_HIGHLIGHTHEALBAR        = "Clic para resaltar la barra de salud"
    HEALBOT_PLUGIN_USELOWERNUMSUFFIX       = "Usar sufijo numérico en minúsculas"
    HEALBOT_PLUGIN_LASTSAVE                = "Último guardado:"
    HEALBOT_WORD_SAY                       = "Decir"
    HEALBOT_WORD_YELL                      = "Gritar"
    HEALBOT_PLUGIN_AURAWATCHINSTANCE       = "Estancia"

    HEALBOT_CUSTOM_CASTBY_EVERYONE         = "Cualquiera"
    HEALBOT_CUSTOM_CASTBY_ENEMY            = "Enemigo"
    HEALBOT_CUSTOM_CASTBY_FRIEND           = "Aliado"
    HEALBOT_OPTIONS_MYCLASS                = "Mi clase"
    HEALBOT_OPTIONS_CASTBYSELF             = "Lanzado por mí"
    HEALBOT_OPTIONS_CASTBYMYCLASS          = "Lanzado por mi clase"
    HEALBOT_OPTIONS_CASTBYEVERYONE         = "Lanzado por cualquiera"

    HEALBOT_OPTION_ISFALLING               = "Está cayendo"
    HEALBOT_OPTION_ISSWIMMING              = "Está nadando"
    HEALBOT_OPTION_GOURPHEALSEFFECT        = "Efecto de sanación de grupo activo"

    HEALBOT_CUSTOM_CAT_CUSTOM_AUTOMATIC    = "Perjuicios automáticos"
    HEALBOT_CUSTOM_CAT_CUSTOM_AUTOBUFFS    = "Beneficios automáticos"
    HEALBOT_CUSTOM_DEBUFF_CATS = {
         -- Defaults
        [HEALBOT_CUSTOM_CAT_CUSTOM_AUTOMATIC] = 1,
    }

    HEALBOT_ABOUT_DESC1                    = "Añade marcos con barras personalizables para sanar, disipar, aplicar beneficios, resucitar y controlar la amenaza"
    HEALBOT_ABOUT_WEBSITE                  = "Sitio web:"
    HEALBOT_ABOUT_AUTHORH                  = "Autor:"
    HEALBOT_ABOUT_AUTHORD                  = "Strife"
    HEALBOT_ABOUT_CATH                     = "Discord:"
    HEALBOT_ABOUT_CATD                     = "discord.gg/gwa6rdCeZ4"
    HEALBOT_ABOUT_CREDITH                  = "Créditos"
    HEALBOT_ABOUT_CREDITD                  = "Acirac, Kubik, Von, Aldetal, Brezza, CT, Milotic"
    HEALBOT_ABOUT_LOCALH                   = "Localizaciones:"
    HEALBOT_ABOUT_LOCALD                   = "deDE, enUK, esES, esMX, frFR, huHU, itIT, koKR, ptBR, ruRU, zhCN, zhTW"
    HEALBOT_ABOUT_FAQH                     = "Preguntas frecuentes"
    HEALBOT_ABOUT_FAQ_QUESTION             = "Pregunta"
    HEALBOT_ABOUT_FAQ_ANSWER               = "Respuesta"

    HEALBOT_ABOUT_FAQ_QUESTIONS = {   [1]  = "Beneficios - Todas las barras están blancas, ¿qué ha pasado?",
                                      [2]  = "Lanzamiento - A veces el cursor se vuelve azul y no puedo hacer nada",
                                      [3]  = "Macros - ¿Tenéis algún ejemplo de reutilización?",
                                      [4]  = "Macros - ¿Tenéis algún ejemplo de lanzamiento de hechizos?",
                                      [5]  = "Ratón - ¿Cómo uso mis macros de pasar el ratón (@mouseover)?",
                                      [6]  = "Opciones - ¿Se pueden ordenar las barras por grupos, por ejemplo tener 2 grupos por columna?",
                                      [7]  = "Opciones - ¿Puedo ocultar todas las barras y mostrar únicamente las que necesiten disipar un perjuicio?",
                                      [8]  = "Opciones - ¿Puedo ocultar las sanaciones entrantes?",
                                      [9]  = "Opciones - HealBot no guarda mis opciones al cerrar o iniciar sesión",
                                      [10] = "Opciones - ¿Cómo uso siempre los ajustes de estado habilitado?",
                                      [11] = "Opciones - ¿Cómo desactivo HealBot automáticamente?",
                                      [12] = "Opciones - ¿Cómo hago que las barras crezcan en otra dirección?",
                                      [13] = "Opciones - ¿Cómo configuro la 'Lista privada'?",
                                      [14] = "Opciones - ¿Cómo configuro los 'Tanques privados'?",
                                      [15] = "Opciones - ¿Creará HealBot una barra para un PNJ?",
                                      [16] = "Alcance - No veo cuándo los jugadores están fuera de alcance, ¿cómo lo soluciono?",
                                      [17] = "Hechizos - HealBot lanza un hechizo distinto al que tengo configurado",
                                      [18] = "Hechizos - Ya no puedo lanzar sanaciones sobre objetivos ilesos",
                                      [19] = "Apariencias - ¿Hay más apariencias disponibles?",
                                      [20] = "Marcos - No puedo mover el marco, ¿está bloqueado?",
                                  }

    HEALBOT_ABOUT_FAQ_SPELLS_ANSWER01       = "Esto se debe a las opciones configuradas en la pestaña Hechizos.\n" ..
                                              "Pruebe a cambiar lo siguiente y comprobar el resultado:\n\n" ..
                                              "En la pestaña Hechizos: desactive Lanzamiento inteligente (SmartCast).\n\n" ..
                                              "Nota: Es habitual que la mayoría de los usuarios quieran\n" ..
                                              "volver a activar Lanzamiento inteligente."

    HEALBOT_ABOUT_FAQ_ANSWERS = {     [1]  = "Está supervisando beneficios faltantes.\n\n" ..
                                              "Puede desactivarlo en la pestaña Beneficios > General.\n" ..
                                              "O bien, haga clic en la barra para lanzar el beneficio.",
                                      [2]  = "Es un comportamiento propio de Blizzard, no de HealBot.\n\n" ..
                                              "Usando los marcos estándar de Blizzard,\n" ..
                                              "intente lanzar un hechizo que esté en reutilización:\n" ..
                                              "verá cómo el cursor se vuelve azul.\n\n" ..
                                              "HealBot incluye una función para evitarlo:\n" ..
                                              "en la pestaña Hechizos, active «Evitar cursor azul».",
                                      [3]  = "Sí.\n\n" ..
                                              "Visite " .. HEALBOT_ABOUT_URL .. " para ver ejemplos.",
                                      [4]  = "Sí.\n\n" ..
                                              "Visite " .. HEALBOT_ABOUT_URL .. " para ver ejemplos.",
                                      [5]  = "Cree una macro usando [@mouseover]\n\n\n" ..
                                              "Macro de ejemplo:\n\n" ..
                                              "#showtooltip Sanación relámpago\n" ..
                                              "/cast [@mouseover] Sanación relámpago\n",
                                      [6]  = "Sí.\n\n\n" ..
                                              "Con cabeceras:\n" ..
                                              "1: En la pestaña Apariencias > Cabeceras > Barras,\nactive Mostrar cabeceras.\n" ..
                                              "2: En la pestaña Apariencias > Marcos > Barras > General,\n" ..
                                              "establezca el Número de grupos por columna.\n\nSin cabeceras:\n" ..
                                              "1: En la pestaña Apariencias > Marcos > Barras > General,\n" ..
                                              "active Usar grupos por columna.\n" ..
                                              "2: En la pestaña Apariencias > Marcos > Barras > General,\n" ..
                                              "establezca el Número de grupos por columna.",
                                      [7]  = "Sí.\n\n" ..
                                              "1: En Apariencias > Marcos > Barras > Visibilidad,\nestablezca los Niveles de alerta en 0.\n" ..
                                              "2: En Apariencias > Marcos > Barras > Amenaza,\ndesactive Supervisar amenaza.\n" ..
                                              "3: En Apariencias > Marcos > Barras > Colores,\nestablezca la Opacidad deshabilitada en 0.\n" ..
                                              "4: En Apariencias > Marcos > Barras > Colores,\nestablezca la Opacidad de fondo en 0.\n" ..
                                              "5: En las pestañas Apariencias > Marcos > Texto de barra,\nestablezca la Opacidad deshabilitada en 0.\n" ..
                                              "6: En las pestañas de Perjuicios, active Supervisar perjuicios.",
                                      [8]  = "Sí.\n\n" ..
                                              "1: En Apariencias > Marcos > Barras > Colores,\nestablezca Sanaciones entrantes en No mostrar.\n" ..
                                              "2: En Apariencias > Marcos > Texto de barra > Salud > Sanaciones entrantes,\n" ..
                                              "desactive Sanaciones entrantes.",
                                      [9]  = "Esto ocurre desde un cambio introducido en WoW 3.2,\n" ..
                                              "y puede afectar a personajes con caracteres especiales en su nombre.\n\n" ..
                                              "En Windows, pruebe lo siguiente:\n" ..
                                              "cambie la configuración regional del sistema\n(para programas no Unicode)\n" ..
                                              "en Panel de control > Región e idioma >\npestaña Administrativo.",
                                      [10] = "Establezca los Niveles de alerta en 100 en la pestaña\n" ..
                                              "Apariencias > Marcos > Barras > Visibilidad.",
                                      [11] = "Para desactivarlo en un personaje:\n\n" ..
                                              "1: Abra la pestaña General.\n" ..
                                              "2: Active la opción Desactivar HealBot.\n\n\n",
                                      [12] = "Cambie el ajuste Anclaje de las barras en la pestaña\nApariencias > Marcos > General:\n\n" ..
                                              "Arriba a la derecha: las barras crecerán hacia abajo y a la izquierda.\n" ..
                                              "Arriba a la izquierda: las barras crecerán hacia abajo y a la derecha.\n" ..
                                              "Abajo a la derecha: las barras crecerán hacia arriba y a la izquierda.\n" ..
                                              "Abajo a la izquierda: las barras crecerán hacia arriba y a la derecha.",
                                      [13] = "La Lista privada le permite crear una lista de objetivos que\n" ..
                                              "desea agrupar por separado del resto, de forma similar al\ngrupo de Tanques.\n\n" ..
                                              "Dispone de las siguientes opciones para\n" ..
                                              "añadir o quitar jugadores de la Lista privada:\n\n" ..
                                              "- El Menú de HealBot (asigne 'Menú de HealBot' en la pestaña Hechizos).\n" ..
                                              "- Cree una macro con el texto '/hb tpl hbtarget'.",
                                      [14] = "Se pueden añadir Tanques privados a la lista de Tanques principales;\n" ..
                                              "los tanques privados solo son visibles en su HealBot\n" ..
                                              "y no afectan a otros jugadores ni complementos.\n\n" ..
                                              "Dispone de las siguientes opciones para\n" ..
                                              "añadir o quitar jugadores de la lista de Tanques:\n\n" ..
                                              "- El Menú de HealBot (asigne 'Menú de HealBot' en la pestaña Hechizos).\n" ..
                                              "- Cree una macro con el texto '/hb tpt hbtarget'.",
                                      [15] = "Sí.\n\n" ..
                                              "1: En la pestaña Apariencias > Marcos > Grupos de sanación, active Foco.\n" ..
                                              "2: Establezca su foco en el PNJ.\n" ..
                                              "HealBot creará una barra en un marco nuevo.\n\n" ..
                                              "Nota: Si en una situación de combate entra y sale de zona\n" ..
                                              "y necesita restablecer el foco en un PNJ:\n\n" ..
                                              "En Apariencias > Marcos > Barras > Visibilidad,\nestablezca Foco al entrar en combate en Mostrar siempre.\n" ..
                                              "Esto mantendrá la barra disponible durante el combate.\n\n" ..
                                              "Nota: El Menú de HealBot cuenta con la opción\n'Foco en el objetivo'.\n" ..
                                              "Esto facilita establecer el foco en PNJ y\n" ..
                                              "sirve como recordatorio para fijarlo.\n\n" ..
                                              "Asigne 'Menú de HealBot' en la pestaña Hechizos para usar el menú.",
                                      [16] = "1: En la pestaña Apariencias > Marcos > Barras > Colores,\najuste la opacidad de barra fuera de alcance.\n" ..
                                              "2: En las pestañas Apariencias > Marcos > Texto de barra,\najuste la opacidad del texto deshabilitado.\n\n" ..
                                              "También puede establecer los Niveles de alerta en 100\n" ..
                                              "en la pestaña Apariencias > Marcos > Barras > Visibilidad.",
                                      [17] = "En realidad, HealBot está lanzando exactamente lo configurado.\n\n" .. HEALBOT_ABOUT_FAQ_SPELLS_ANSWER01,
                                      [18] = HEALBOT_ABOUT_FAQ_SPELLS_ANSWER01,
                                      [19] = "Sí.\n\n" ..
                                              "En la pestaña Importar / Exportar > Apariencias,\nseleccione Apariencias adicionales en el menú desplegable y pulse Importar.\n\n" ..
                                              "También pueden haberse compartido apariencias adicionales\nen " .. HEALBOT_ABOUT_CATD,
                                      [20] = "Compruebe si el marco está bloqueado en\nla pestaña Apariencias > Marcos > General.\n\n" ..
                                              "Para mover el marco, arrástrelo desde cerca del borde del marco.\n\n" ..
                                              "Para facilitar el movimiento de los marcos\ndispone de las siguientes opciones:\n\n" ..
                                              " - Activar el Modo de prueba.\n\n" ..
                                              " - En la pestaña General, desactivar «Ocultar etiqueta de desbloqueado».\n\n",
                                  }

    HEALBOT_OPTIONS_SKINAUTHOR              = "Autor de la apariencia"
    HEALBOT_OPTIONS_MORESKINSURL            = "Hay apariencias adicionales disponibles en la pestaña Importar / Exportar > Apariencias"
    HEALBOT_OPTIONS_AVOIDBLUECURSOR         = "Evitar\ncursor\nazul"
    HEALBOT_PLAYER_OF_REALM                 = "de"

    HEALBOT_OPTIONS_OVERRIDE_EFFECTS        = "Anular efectos"
    HEALBOT_OPTIONS_OVERRIDE_CLASSCOLS      = "Anular colores de clase"
    HEALBOT_OPTIONS_OVERRIDE_ROLECOLS       = "Anular colores de rol"
    HEALBOT_OPTIONS_OVERRIDE_POWERCOLS      = "Anular colores de poder"
    HEALBOT_OPTIONS_OVERRIDE_ADAPTIVECOLS   = "Anular colores adaptativos"
    HEALBOT_OPTIONS_OVERRIDE_CHAT           = "Anular chat"
    HEALBOT_OPTIONS_OVERRIDE_FRAMES         = "Anular marcos"
    HEALBOT_USE_OVERRIDE_NO                 = "Usar ajustes de la apariencia actual."
    HEALBOT_USE_OVERRIDE_YES                = "Usar siempre las anulaciones de esta pestaña."

    HEALBOT_OPTIONS_CONDITION               = "Condición";
    HEALBOT_OPTIONS_HIGHLIGHTFILTER         = "Condición de resaltado";
    HEALBOT_OPTIONS_HIGHLIGHTFILTER01       = "cuando la facultad no esté en reutilización"
    HEALBOT_OPTIONS_HIGHLIGHTFILTER01S      = "sin reutilización"
    HEALBOT_OPTIONS_HIGHLIGHTFILTER02       = "cuando la facultad no esté en reutilización y se cumpla la condición de alerta"
    HEALBOT_OPTIONS_HIGHLIGHTFILTER02S      = "sin reutilización y con alerta"
    HEALBOT_OPTIONS_SHOWCOOLDOWN            = "Mostrar reutilización"
    HEALBOT_OPTIONS_SHOWCOUNT               = "Mostrar acumulaciones"

    HEALBOT_OPTIONS_LANG                    = "Idioma"

    HEALBOT_OPTIONS_LANG_ZHCN               = "Chino (zhCN)"
    HEALBOT_OPTIONS_LANG_ENUK               = "Inglés del Reino Unido (enUK)"
    HEALBOT_OPTIONS_LANG_ENUS               = "Inglés de EE. UU. (enUS)"
    HEALBOT_OPTIONS_LANG_FRFR               = "Francés (frFR)"
    HEALBOT_OPTIONS_LANG_DEDE               = "Alemán (deDE)"
    HEALBOT_OPTIONS_LANG_GRGR               = "Griego (grGR)"
    HEALBOT_OPTIONS_LANG_HUHU               = "Húngaro (huHU)"
    HEALBOT_OPTIONS_LANG_ITIT               = "Italiano (itIT)"
    HEALBOT_OPTIONS_LANG_KRKR               = "Coreano (krKR)"
    HEALBOT_OPTIONS_LANG_PTBR               = "Portugués de Brasil (ptBR)"
    HEALBOT_OPTIONS_LANG_RURU               = "Ruso (ruRU)"
    HEALBOT_OPTIONS_LANG_ESES               = "Español de España (esES)"
    HEALBOT_OPTIONS_LANG_TWTW               = "Chino tradicional (twTW)"
    HEALBOT_OPTIONS_LANG_ESMX               = "Español de Hispanoamérica (esMX)"

    HEALBOT_OPTIONS_LANG_ADDON_FAIL1        = "Error al cargar el complemento de localización"
    HEALBOT_OPTIONS_LANG_ADDON_FAIL2        = "El motivo del fallo es:"
    HEALBOT_OPTIONS_LANG_ADDON_FAIL3        = "Nota: en la versión actual, este es el único aviso para"
    HEALBOT_OPTIONS_IMPORT_FAIL1            = "Error al importar"
    HEALBOT_OPTIONS_IMPORT_FAIL2            = "El motivo del fallo es:"
    HEALBOT_OPTIONS_IMPORT_VALID1           = "Importación válida"
    HEALBOT_OPTIONS_IMPORT_VALID2           = ": datos listos para cargarse\n\n¿Continuar?"
    HEALBOT_OPTIONS_LINK_REQUEST_DENIED     = "Petición de enlace denegada\n\nEspere unos segundos antes de enviar otra petición."
    HEALBOT_OPTIONS_LINK_REQUEST1           = "Petición para compartir de HealBot"
    HEALBOT_OPTIONS_LINK_CREATELR           = "Crear enlace de petición para compartir de HealBot"
    HEALBOT_OPTIONS_LINK_REQUEST2           = "Así es como se presenta su petición para compartir."
    HEALBOT_OPTIONS_LINK_REQUESTSENDQ       = "¿Enviar petición?"
    HEALBOT_OPTIONS_LINK_WAITQUEUE          = "Esperando en cola";
    HEALBOT_OPTIONS_LINK_TRANSCOMPLETE      = "Transferencia completada";
    HEALBOT_OPTIONS_LINK_TRANSSTARTED       = "Transferencia iniciada";
    HEALBOT_OPTIONS_LINK_TRANSINPROGRESS    = "Transferencia en curso ";
    HEALBOT_OPTIONS_LINK_POSTCHANNEL        = "Publicar en canal";
    HEALBOT_OPTIONS_LINK_POSTWHISPER        = "Susurrar a otros usuarios de HealBot.";
    HEALBOT_OPTIONS_LINK_CHAN1              = "Las comunicaciones se envían mediante los canales de complementos. Esto significa que:"
    HEALBOT_OPTIONS_LINK_CHAN2              = "-  Solo los usuarios de HealBot recibirán su enlace."
    HEALBOT_OPTIONS_LINK_CHAN3              = "-  Su enlace se mostrará en su canal de chat predeterminado."
    HEALBOT_OPTIONS_LINK_CHAN4              = "-  Puede susurrarse a sí mismo para comprobar cómo funciona."

    HEALBOT_OPTIONS_ADDON_FAIL              = "Error al cargar el complemento HealBot"

    HEALBOT_OPTIONS_IN_A_GROUP              = "Solo en grupo o banda"
    HEALBOT_OPTIONS_ALSO_WHEN_MOUNTED       = "también en montura"
    HEALBOT_OPTIONS_PALADIN_BLESSINGS       = "Ver todas mis bendiciones como equivalentes"
    HEALBOT_OPTIONS_ONLY_IN_INSTANCE        = "Solo en una estancia"

    HEALBOT_OPTIONS_TAB_EFFECTS             = "Efectos"
    HEALBOT_OPTIONS_TAB_EMERG               = "Emergencia"
    HEALBOT_OPTIONS_CONTENT_SKINS_GENERAL   = "    " .. HEALBOT_OPTIONS_TAB_GENERAL
    HEALBOT_OPTIONS_CONTENT_SKINS_EFFECTS   = "    " .. HEALBOT_OPTIONS_TAB_EFFECTS
    HEALBOT_OPTIONS_CONTENT_SKINS_COLOUR    = "    " .. HEALBOT_WORD_COLOURS
    HEALBOT_OPTIONS_CONTENT_SKINS_ENEMY     = "    " .. HEALBOT_CUSTOM_CASTBY_ENEMY
    HEALBOT_OPTIONS_CONTENT_SKINSF_GENERAL  = "        " .. HEALBOT_OPTIONS_TAB_GENERAL
    HEALBOT_OPTIONS_CONTENT_SKINS_HEALING   = "    " .. HEALBOT_OPTIONS_TAB_HEALING
    HEALBOT_OPTIONS_CONTENT_SKINS_HEADERS   = "        " .. HEALBOT_OPTIONS_TAB_HEADERS
    HEALBOT_OPTIONS_CONTENT_SKINS_BARS      = "        " .. HEALBOT_OPTIONS_TAB_BARS
    HEALBOT_OPTIONS_CONTENT_SKINS_ICONS     = "        " .. HEALBOT_OPTIONS_TAB_ICONS
    HEALBOT_OPTIONS_CONTENT_SKINS_ACTICONS  = "        " .. HEALBOT_OPTIONS_TAB_ACTIONICONS
    HEALBOT_OPTIONS_CONTENT_SKINS_INDICATORS= "        " .. HEALBOT_OPTIONS_TAB_INDICATORS
    HEALBOT_OPTIONS_CONTENT_SKINS_EMERG     = "        " .. HEALBOT_OPTIONS_TAB_EMERG
    HEALBOT_OPTIONS_CONTENT_SKINS_AGGRO     = "    " .. HEALBOT_OPTIONS_TAB_AGGRO
    HEALBOT_OPTIONS_CONTENT_SKINS_CHAT      = "    " .. HEALBOT_OPTIONS_TAB_CHAT
    HEALBOT_OPTIONS_CONTENT_SKINS_TEXT      = "        " .. HEALBOT_OPTIONS_TEXTOPTIONS
    HEALBOT_OPTIONS_CONTENT_SKINS_ICONTEXT  = "        " .. HEALBOT_OPTIONS_TAB_ICONTEXT

    HEALBOT_OPTIONS_CONTENT_CURE_DEBUFF     = "    " .. HEALBOT_OPTIONS_TAB_GENERAL
    HEALBOT_OPTIONS_CONTENT_CURE_CUSTOM     = "    " .. HEALBOT_CLASSES_CUSTOM
    HEALBOT_OPTIONS_CONTENT_CURE_WARNING    = "    " .. HEALBOT_OPTIONS_TAB_WARNING

    HEALBOT_OPTIONS_CONTENT_BUFFS_GENERAL   = "    " .. HEALBOT_OPTIONS_TAB_GENERAL
    HEALBOT_OPTIONS_CONTENT_BUFFS_HOTS      = "    " .. HEALBOT_CLASSES_CUSTOM

    HEALBOT_OPTIONS_CONTENT_INOUT_PRESETCOL = "Colores predefinidos"
    HEALBOT_OPTIONS_CONTENT_SKINS_FRAMES    = "    " .. HEALBOT_OPTIONS_TAB_FRAMES

    HEALBOT_SKIN_ABSORBCOL_TEXT             = "Efectos de " .. HEALBOT_classicABSORBHOT;
    HEALBOT_OPTIONS_BARALPHAABSORB          = "Opacidad de efectos de " .. HEALBOT_classicABSORBHOT;
    HEALBOT_OPTIONS_OUTLINE                 = "Contorno"
    HEALBOT_OPTIONS_OUTLINEAUXBAR           = "Contorno del borde"
    HEALBOT_OPTIONS_FRAME                   = "Marco"
    HEALBOT_OPTIONS_FRAMESOPTTEXT           = "Opciones de marcos"
    HEALBOT_OPTIONS_SETTOOLTIP_POSITION     = "Establecer posición de la descripción emergente"
    HEALBOT_OPTIONS_SETTOOLTIP_CUSTOMANCHOR = "Establecer anclaje personalizado de descripción emergente"
    HEALBOT_OPTIONS_TTCUSTOMANCHOR_TITLE    = "Anclaje personalizado de descripciones"
    HEALBOT_OPTIONS_TTCUSTOMANCHOR_POINT    = "Punto de anclaje"
    HEALBOT_OPTIONS_SKIN                    = "Apariencia"
    HEALBOT_OPTIONS_FRAME_TITLE             = "Título del marco"
    HEALBOT_OPTIONS_FRAME_TITLE_SHOW        = "Mostrar cabecera"
    HEALBOT_OPTIONS_FRAME_ALIAS_SHOW        = "Mostrar título"
    HEALBOT_OPTIONS_GROW_DIRECTION          = "Dirección de crecimiento"
    HEALBOT_OPTIONS_BARSORIENTATION         = "Orientación de las barras"
    HEALBOT_OPTIONS_GROW_HORIZONTAL         = "Horizontal"
    HEALBOT_OPTIONS_GROW_VERTICAL           = "Vertical"
    HEALBOT_OPTIONS_FONT_OFFSET             = "Desplazamiento de fuente"
    HEALBOT_OPTIONS_SET_FRAME_HEALGROUPS    = "Asignar grupos de sanación"
    HEALBOT_OPTION_EXCLUDEMOUNT_ON          = "Excluyendo montura actual"
    HEALBOT_OPTION_EXCLUDEMOUNT_OFF         = "Ya no se excluye la montura actual"
    HEALBOT_CMD_TOGGLEEXCLUDEMOUNT          = "Alternar exclusión de montura"
    HEALBOT_CMD_TOGGLECLEARINSPECT          = "Alternar limpieza de inspección tras consultar talentos"
    HEALBOT_CMD_TOGGLENUMBERSUFFIX          = "Alternar sufijo numérico entre mayúsculas y minúsculas"
    HEALBOT_OPTIONS_HIDEMINIBOSSFRAMES      = "Ocultar marcos de minijefes";
    HEALBOT_OPTIONS_HIDERAIDFRAMES          = "Ocultar marcos de banda";
    HEALBOT_OPTIONS_HIDEFOCUSFRAME          = "Ocultar marco de foco";
    HEALBOT_OPTIONS_FRAME_ALIAS             = "Alias"
    HEALBOT_OPTIONS_HEALGROUPS              = "Grupos de sanación"
    HEALBOT_OPTIONS_PRIVLISTS1              = "Los tanques privados se incluyen con los Tanques principales.\nLos sanadores privados se incluyen con los Sanadores."
    HEALBOT_OPTIONS_PRIVLISTS2              = "Las listas privadas se pueden gestionar mediante\nel complemento HealBot: Ajustes avanzados."
    HEALBOT_OPTIONS_CONTENT_SKINS_HEALGROUP = "        " .. HEALBOT_OPTIONS_HEALGROUPS
    HEALBOT_OPTIONS_CONTENT_SKINS_BARCOLOUR = "        Colores de barra"
    HEALBOT_OPTIONS_SET_ALL_FRAMES          = "Copiar marco y pestañas actuales a otros marcos"
    HEALBOT_OPTIONS_CURRENT_FRAME           = "Marco actual: "
    HEALBOT_OPTIONS_COPY_TABS               = "Copiar pestañas"
    HEALBOT_OPTIONS_COPY_FROM               = "Copiar desde"
    HEALBOT_OPTIONS_TO_FRAMES               = "A los marcos"
    HEALBOT_WORDS_PROFILE                   = "Perfil"
    HEALBOT_WORDS_GLOBALPROFILE             = "Perfil global"
    HEALBOT_SHARE_SCREENSHOT                = "Captura de pantalla realizada"
    HEALBOT_SHARE_EXPORTED                  = "Exportado correctamente"
    HEALBOT_OPTIONS_BUTTONLOADSKIN          = "Cargar apariencia"
    HEALBOT_ENEMY_USE_FRAME                 = "Usar marco"
    HEALBOT_ENEMY_INCLUDE_SELF              = "Objetivo"
    HEALBOT_ENEMY_INCLUDE_FOCUS             = "Foco"
    HEALBOT_ENEMY_INCLUDE_TANKS             = "Objetivos de los tanques"
    HEALBOT_ENEMY_INCLUDE_GROUP             = "Objetivos del grupo"
    HEALBOT_ENEMY_INCLUDE_RAID              = "Objetivos de la banda"
    HEALBOT_OPTIONS_ENEMY_OPT               = "Visibilidad de enemigos";
    HEALBOT_OPTIONS_SHARE_OPT               = "Opciones para compartir";
    HEALBOT_OPTIONS_CONTENT_SKINS_SHARE     = "    Compartir"

    HEALBOT_ENEMY_NO_TARGET                 = "Sin objetivo"
    HEALBOT_OPTIONS_ENEMYBARS               = "Barras de salud - Personajes enemigos";
    HEALBOT_OPTIONS_HARMFUL_SPELLS          = "Hechizos dañinos"
    HEALBOT_ENEMY_INCLUDE_MYTARGETS         = "Objetivos de Lista privada"
    HEALBOT_ENEMY_NUMBER_BOSSES             = "Número de jefes"
    HEALBOT_ENEMY_HIDE_OUTOFCOMBAT          = "Ocultar barras fuera de combate"
    HEALBOT_ENEMY_SHOW_TARGET               = "Mostrar objetivo del enemigo"
    HEALBOT_ENEMY_EXISTS_SHOW_PTARGETS      = "Objetivos de jugadores"
    HEALBOT_ENEMY_EXISTS_SHOW_BOSSES        = "Barras de jefes"
    HEALBOT_PLAYER_TARGET_SIZE              = "Tamaño del objetivo del jugador"
    HEALBOT_ENEMY_TARGET_SIZE               = "Tamaño del objetivo del enemigo"
    HEALBOT_ENEMY_TARUSESENEMYCOLS          = "El objetivo del jugador usa siempre los colores del marco de enemigos"
    HEALBOT_ENEMY_TOTUSESENEMYCOLS          = "El objetivo del objetivo del jugador usa siempre los colores del marco de enemigos"
    HEALBOT_OPTIONS_PROFILE                 = "Perfil para\nHechizos/Beneficios/Perjuicios"
    HEALBOT_OPTIONS_PROFILE_CHARACTER       = "Personaje"
    HEALBOT_OPTIONS_PROFILE_CLASS           = "Clase"
    HEALBOT_OPTIONS_INCOMBATALERTLEVEL      = "Nivel de alerta - En combate";
    HEALBOT_OPTIONS_OUTCOMBATALERTLEVEL     = "Nivel de alerta - Fuera de combate";
    HEALBOT_OPTIONS_SORTOORLAST             = "Ordenar fuera de alcance al final"
    HEALBOT_OPTION_NUMENEMYS                = "Número de enemigos"
    HEALBOT_OPTION_COMPRESSEXPORT           = "Comprimir exportación"
    HEALBOT_WORD_AUTO                       = "Auto"
    HEALBOT_WORDS_REMOVETEMPCUSTOMNAME      = "Quitar nombre personalizado temporal"
    HEALBOT_WORDS_REMOVEPERMCUSTOMNAME      = "Quitar nombre personalizado permanente"
    HEALBOT_WORDS_ADDTEMPCUSTOMNAME         = "Añadir nombre personalizado temporal"
    HEALBOT_WORDS_ADDPERMCUSTOMNAME         = "Añadir nombre personalizado permanente"
    HEALBOT_OPTIONS_ENABLELIBUTF8           = "Habilitar biblioteca UTF8"
    HEALBOT_OPTIONS_SHOWDIRECTION           = "Mostrar dirección fuera de alcance"
    HEALBOT_OPTIONS_SHOWDIRECTIONMOUSE      = "Solo al pasar el ratón"
    HEALBOT_LDB_LEFT_TOOLTIP                = "|cffffff00 Clic izquierdo:|r Alternar panel de opciones de HealBot";
    HEALBOT_LDB_SHIFTLEFT_TOOLTIP           = "|cffffff00 Mayús + Clic izquierdo:|r Cambiar entre apariencias de HealBot";
    HEALBOT_LDB_RIGHT_TOOLTIP               = "|cffffff00 Clic derecho:|r Reiniciar HealBot";
    HEALBOT_LDB_SHIFTRIGHT_TOOLTIP          = "|cffffff00 Mayús + Clic derecho:|r Activar/Desactivar HealBot";
    HEALBOT_WORD_PETBATTLE                  = "Duelo de mascotas"
    HEALBOT_ENEMY_INCLUDE_ARENA             = "Oponentes de arena"
    HEALBOT_ENEMY_INCLUDE_ARENAPETS         = "Incluyendo mascotas"
    HEALBOT_ENEMY_EXISTS_SHOW               = "Mostrar cuando exista"
    HEALBOT_ENEMY_NOBOSS_SHOW               = "Mostrar cuando no haya jefe"
    HEALBOT_CMD_TOGGLECUSTOMCURECASTBY      = "Alternar Perjuicios personalizados - Lanzado por predeterminado"
    HEALBOT_CMD_TOGGLEMAINASSIST            = "Alternar inclusión de Asistente principal con Tanques"
    HEALBOT_CMD_RESETSKINGROUP              = "Recuperar apariencia Grupo"
    HEALBOT_CMD_RESETSKINRAID25             = "Recuperar apariencia Banda 25"
    HEALBOT_CMD_RESETSKINRAID40             = "Recuperar apariencia Banda 40"
    HEALBOT_OPTIONS_ENTERINGCOMBAT          = "Al entrar en combate"
    HEALBOT_OPTIONS_ALWAYSINCOMBAT          = "Mostrar siempre"
    HEALBOT_OPTIONS_SHOWENEMYAURA           = "Supervisar auras enemigas"
    HEALBOT_OPTIONS_OUTOFCOMBAT             = "Fuera de combate"
    HEALBOT_OPTIONS_ONLYINGCOMBAT           = "Mostrar solo en combate"
    HEALBOT_OPTIONS_ONLYOUTOFCOMBAT         = "Mostrar solo fuera de combate"
    HEALBOT_OPTIONS_ONLYONDEMAND            = "Mostrar solo bajo demanda"
    HEALBOT_OPTIONS_USEENEMYFRAME           = "Marco de enemigos"
    HEALBOT_OPTIONS_USEPLAYERSFRAME         = "Marco de jugadores"
    HEALBOT_SKIN_RAIDBARCOL                 = "Color de banda"
    HEALBOT_SKIN_TANKBARCOL                 = "Color de tanque"
    HEALBOT_SKIN_YOURBARCOL                 = "Mi color"
    HEALBOT_OPTIONS_MAXBARS                 = "Máx. de barras"
    HEALBOT_OPTIONS_STATUS                  = "Estado"
    HEALBOT_OPTIONS_TEXTCOL_DEBUFF          = "Usar personalizado en perjuicio"
    HEALBOT_OPTIONS_ALWAYSHIDE              = "Ocultar siempre"
    HEALBOT_OPTIONS_NOCHANGE                = "Sin cambios"
    HEALBOT_OPTIONS_ALWAYSSHOW              = "Mostrar siempre"
    HEALBOT_OPTIONS_PAGE                    = "Página"
    HEALBOT_OPTIONS_PREV                    = "<<"
    HEALBOT_OPTIONS_NEXT                    = ">>"
    HEALBOT_OPTIONS_PRESET_COLOUR           = "Color predefinido"

    HEALBOT_OPTIONS_CLASSCOLOURS            = "Colores de " .. HEALBOT_SORTBY_CLASS
    HEALBOT_OPTIONS_ROLECOLOURS             = "Colores de " .. HEALBOT_SORTBY_ROLE
    HEALBOT_OPTIONS_POWERCOLOURS            = "Colores de " .. HEALBOT_OPTIONS_POWER
    HEALBOT_OPTIONS_ADAPTIVECOLOURS         = "Colores adaptativos de " .. HEALBOT_SKIN_HEALTHBACKCOL_TEXT .. " " .. HEALBOT_WORD_AND .. " " .. HEALBOT_SKIN_BACKBORDERCOL_TEXT
    HEALBOT_WORD_SUPPORTERS                 = "Colaboradores"
    HEALBOT_CREDITS_PEOPLE = {
                               [01] = "Acirac",
                               [02] = "CTShammy",
                               [03] = "Kubik",
                               [04] = "Von",
                               [05] = "Aldetal",
                               [06] = "Brezza",
                               [07] = "Moonlight",
                               [08] = "Han Xing",
                               [09] = "Hermis",
                               [10] = "Ariá",
                               [11] = "Snaomi",
                             }

    HEALBOT_WORD_TOGGLE                     = "Alternar"
    BINDING_CATEGORY_HEALBOT                = HEALBOT_HEALBOT
    BINDING_HEADER_HBBUTTONS                = HEALBOT_HEALBOT
    _G["BINDING_NAME_HEALBOTTOGGLEOPTIONS"] = HEALBOT_WORD_TOGGLE .. " " .. HEALBOT_ACTION_OPTIONS
    _G["BINDING_NAME_HEALBOTTOGGLEENABLED"] = HEALBOT_WORD_TOGGLE .. " " .. HEALBOT_SKIN_ENTEXT

    if HealBot_Lang_InitVars then
        HealBot_Lang_InitVars()
    end
    if hbv_SetClass then
        hbv_SetClass()
    end
end

if (GetLocale() == "esES") then
    HealBot_Lang_esES()
end

if (GetLocale() == "esMX") then
    HealBot_Lang_esMX()
end
