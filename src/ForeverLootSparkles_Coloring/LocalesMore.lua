-- Further client languages: Spanish (esES, esMX), Brazilian Portuguese (ptBR),
-- Italian (itIT), Russian (ruRU), Korean (koKR), Simplified and Traditional
-- Chinese (zhCN, zhTW). Read by Locales.lua; keys as in its English tables.
-- EXTRA_L: this addon's own texts. EXTRA_FLS: the sparkle option texts.

local _, ns = ...;

local L, FLS = {}, {};
ns.EXTRA_L, ns.EXTRA_FLS = L, FLS;

local function Sparkles(t)
	local how = t.how;
	return {
		enabled = t.enabled,
		enabledTip = t.enabledTip,
		header = t.header,
		ore = t.ore,
		oreTip = t.oreTip .. how,
		herb = t.herb,
		herbTip = t.herbTip .. how,
		quest = t.quest,
		questTip = t.questTip .. how,
		corpse = t.corpse,
		corpseTip = t.corpseTip .. how,
	};
end

---------------------------------------------------------------------------
-- Español
---------------------------------------------------------------------------

L.esES = {
	PANEL_NAME = "Colores",
	TITLE = "Forever Loot Sparkles - Colores",
	DESCRIPTION = "Elige un color de destello para cada categoría. Fuera de alcance los destellos son más tenues y siguen volviéndose grises cuando no se puede usar un objeto.",
	ENABLE = "Colorear los destellos",
	ENABLE_TOOLTIP = "Desactivado: los destellos mantienen el color dorado de Forever Loot Sparkles.",
	herb = "Hierbas",
	ore = "Vetas de mineral",
	quest = "Objetos de misión",
	corpseLoot = "Cadáveres con botín",
	SWATCH_TOOLTIP = "Haz clic para elegir un color.",
	RESET = "Restablecer colores",
	SAFE_CAST = "Autolanzamiento seguro",
	SAFE_CAST_TOOLTIP = "Los hechizos lanzados sin objetivo podrían caer sobre el jugador o PNJ que el objetivo suave ha elegido a tu lado. Con esta opción, el objetivo suave se desactiva en combate y siempre que elige una unidad viva, y se reactiva cuando te has movido unos metros. Los nodos y cadáveres siguen brillando. Mientras está desactivado, la tecla de interacción no funciona con PNJ.",
	HIDE_PLATE = "Ocultar la placa de nombre bajo el destello",
	HIDE_PLATE_TOOLTIP = "El destello cuelga de la placa de nombre del objeto o cadáver. Con esta opción, esa placa (nombre, barra de salud vacía, icono) es invisible y solo se ve el destello.",
	OPEN_HINT = "Las opciones están en Esc > Opciones > Accesorios > Forever Loot Sparkles.",
	other = "Otros objetos",
	npc = "PNJ",
	ICONS_NPC_TOOLTIP = "Oculta el icono de interacción sobre los PNJ, como vendedores, instructores y quienes dan misiones. Sobre los PNJ sin placa de nombre lo dibuja el propio juego, así que también se desactiva la opción del juego para los iconos de interacción de PNJ (se restablece al desmarcar).",
	ICONS_HEADER = "Ocultar iconos de interacción",
	ICONS_ALL = "Ocultar todos",
	ICONS_ALL_TOOLTIP = "Oculta el icono de interacción del juego (engranaje, pico, hoja, mano...) sobre todos los objetos, cadáveres y PNJ. Los destellos se mantienen.",
	ICONS_TOOLTIP = "Oculta el icono de interacción del juego sobre este tipo de objeto. Los destellos necesitan estos iconos activados, así que solo se vuelven invisibles. El destello se mantiene.",
	ICONS_OTHER_TOOLTIP = "Oculta el icono de interacción sobre todos los demás objetos, p. ej. corchos de pesca, cofres, buzones y puertas. Los destellos se mantienen.",
	NOTE = "Solo se pueden colorear los destellos que dibuja el accesorio. El destello de botín propio del juego en los objetos de misión lo dibuja el motor del juego y mantiene su color.",
};
L.esMX = L.esES;

FLS.esES = Sparkles({
	how = " Usa el objetivo suave de Blizzard: brilla el objeto más cercano en unos 15 metros, con más intensidad cuando puedes alcanzarlo. Requiere la opción del juego «Activar tecla de interacción» y sus iconos de interacción en objetos; al activar esto se activan ambos, y sin ellos nada brilla.",
	enabled = "Mostrar destellos en objetos de misión",
	enabledTip = "Mantiene activado el destello de botín del juego, incluso después de que una configuración gráfica lo desactive. Tu modo de contorno se queda como lo tengas. Desactivarlo surte efecto tras reiniciar el juego.",
	header = "Destellos al acercarse",
	ore = "Vetas de mineral",
	oreTip = "Destellos en las vetas de mineral al acercarte.",
	herb = "Hierbas",
	herbTip = "Destellos en las hierbas al acercarte.",
	quest = "Objetos de misión",
	questTip = "Destellos adicionales en los objetos de misión al acercarte. Desactivado por defecto: el destello de botín del juego ya marca la mayoría.",
	corpse = "Cadáveres con botín",
	corpseTip = "Destellos en un cadáver que aún tiene botín para ti, jefes incluidos. Solo después del combate: durante el combate el juego no deja a los accesorios cambiar la placa de nombre de la que cuelga.",
});
FLS.esMX = FLS.esES;

---------------------------------------------------------------------------
-- Português (Brasil)
---------------------------------------------------------------------------

L.ptBR = {
	PANEL_NAME = "Cores",
	TITLE = "Forever Loot Sparkles - Cores",
	DESCRIPTION = "Escolha uma cor de brilho para cada categoria. Fora de alcance os brilhos ficam mais fracos e continuam ficando cinza quando um objeto não pode ser usado.",
	ENABLE = "Colorir os brilhos",
	ENABLE_TOOLTIP = "Desativado: os brilhos mantêm a cor dourada do Forever Loot Sparkles.",
	herb = "Ervas",
	ore = "Veios de minério",
	quest = "Objetos de missão",
	corpseLoot = "Corpos com saque",
	SWATCH_TOOLTIP = "Clique para escolher uma cor.",
	RESET = "Redefinir cores",
	SAFE_CAST = "Autolançamento seguro",
	SAFE_CAST_TOOLTIP = "Feitiços lançados sem alvo poderiam cair no jogador ou PNJ que a seleção suave de alvo escolheu ao seu lado. Com esta opção, a seleção suave é desligada em combate e sempre que escolhe uma unidade viva, e volta quando você anda alguns metros. Nós e corpos continuam brilhando. Enquanto estiver desligada, a tecla de interação não funciona em PNJs.",
	HIDE_PLATE = "Ocultar a placa de nome sob o brilho",
	HIDE_PLATE_TOOLTIP = "O brilho fica preso à placa de nome do objeto ou corpo. Com esta opção, essa placa (nome, barra de vida vazia, ícone) fica invisível e só o brilho aparece.",
	OPEN_HINT = "As opções ficam em Esc > Opções > AddOns > Forever Loot Sparkles.",
	other = "Outros objetos",
	npc = "PNJs",
	ICONS_NPC_TOOLTIP = "Oculta o ícone de interação sobre PNJs, como vendedores, instrutores e quem dá missões. Sobre PNJs sem placa de nome o próprio jogo o desenha, por isso a opção do jogo para ícones de interação de PNJs também é desligada (restaurada ao desmarcar).",
	ICONS_HEADER = "Ocultar ícones de interação",
	ICONS_ALL = "Ocultar todos",
	ICONS_ALL_TOOLTIP = "Oculta o ícone de interação do jogo (engrenagem, picareta, folha, mão...) sobre todos os objetos, corpos e PNJs. Os brilhos continuam.",
	ICONS_TOOLTIP = "Oculta o ícone de interação do jogo sobre este tipo de objeto. Os brilhos precisam desses ícones ligados, então eles apenas ficam invisíveis. O brilho continua.",
	ICONS_OTHER_TOOLTIP = "Oculta o ícone de interação sobre todos os outros objetos, p. ex. boias de pesca, baús, caixas de correio e portas. Os brilhos continuam.",
	NOTE = "Só os brilhos desenhados pelo addon podem ser coloridos. O brilho de saque do próprio jogo em itens de missão é desenhado pelo motor do jogo e mantém sua cor.",
};

FLS.ptBR = Sparkles({
	how = " Usa a seleção suave de alvo da Blizzard: o objeto mais próximo em cerca de 15 metros brilha, mais forte quando você pode alcançá-lo. Requer a opção do jogo \"Ativar tecla de interação\" e seus ícones de interação em objetos; ligar isto liga os dois, e sem eles nada brilha.",
	enabled = "Mostrar brilho em itens de missão",
	enabledTip = "Mantém o brilho de saque do jogo ligado, mesmo depois que uma predefinição gráfica o desliga. Seu modo de contorno fica como você definiu. Desligar só tem efeito após reiniciar o jogo.",
	header = "Brilhos ao se aproximar",
	ore = "Veios de minério",
	oreTip = "Brilhos nos veios de minério quando você se aproxima.",
	herb = "Ervas",
	herbTip = "Brilhos nas ervas quando você se aproxima.",
	quest = "Objetos de missão",
	questTip = "Brilhos extras em objetos de missão quando você se aproxima. Desligado por padrão: o brilho de saque do jogo já marca a maioria.",
	corpse = "Corpos com saque",
	corpseTip = "Brilhos em um corpo que ainda tem saque para você, chefes incluídos. Só depois do combate: em combate o jogo não deixa addons trocar a placa de nome em que o brilho fica preso.",
});

---------------------------------------------------------------------------
-- Italiano
---------------------------------------------------------------------------

L.itIT = {
	PANEL_NAME = "Colori",
	TITLE = "Forever Loot Sparkles - Colori",
	DESCRIPTION = "Scegli un colore di scintillio per ogni categoria. Fuori portata gli scintillii restano più tenui e diventano comunque grigi quando un oggetto non si può usare.",
	ENABLE = "Colora gli scintillii",
	ENABLE_TOOLTIP = "Disattivato: gli scintillii mantengono il colore dorato di Forever Loot Sparkles.",
	herb = "Erbe",
	ore = "Vene di minerale",
	quest = "Oggetti delle missioni",
	corpseLoot = "Cadaveri con bottino",
	SWATCH_TOOLTIP = "Clicca per scegliere un colore.",
	RESET = "Ripristina colori",
	SAFE_CAST = "Autolancio sicuro",
	SAFE_CAST_TOOLTIP = "Gli incantesimi lanciati senza bersaglio potrebbero colpire il giocatore o PNG che il bersaglio morbido ha scelto accanto a te. Con questa opzione il bersaglio morbido si spegne in combattimento e ogni volta che sceglie un'unità viva, e si riaccende dopo che ti sei spostato di qualche metro. Giacimenti e cadaveri continuano a scintillare. Mentre è spento, il tasto di interazione non funziona sui PNG.",
	HIDE_PLATE = "Nascondi la targhetta sotto lo scintillio",
	HIDE_PLATE_TOOLTIP = "Lo scintillio è agganciato alla targhetta del nome dell'oggetto o del cadavere. Con questa opzione la targhetta (nome, barra della salute vuota, icona) è invisibile e si vede solo lo scintillio.",
	OPEN_HINT = "Le opzioni si trovano in Esc > Opzioni > AddOn > Forever Loot Sparkles.",
	other = "Altri oggetti",
	npc = "PNG",
	ICONS_NPC_TOOLTIP = "Nasconde l'icona di interazione sopra i PNG, come venditori, istruttori e chi assegna missioni. Sopra i PNG senza targhetta la disegna il gioco stesso, quindi viene spenta anche l'opzione di gioco per le icone di interazione dei PNG (ripristinata quando togli la spunta).",
	ICONS_HEADER = "Nascondi icone di interazione",
	ICONS_ALL = "Nascondi tutte",
	ICONS_ALL_TOOLTIP = "Nasconde l'icona di interazione del gioco (ingranaggio, piccone, foglia, mano...) sopra tutti gli oggetti, cadaveri e PNG. Gli scintillii restano.",
	ICONS_TOOLTIP = "Nasconde l'icona di interazione del gioco sopra questo tipo di oggetto. Gli scintillii hanno bisogno di queste icone attive, quindi vengono solo rese invisibili. Lo scintillio resta.",
	ICONS_OTHER_TOOLTIP = "Nasconde l'icona di interazione sopra tutti gli altri oggetti, ad es. galleggianti da pesca, forzieri, cassette postali e porte. Gli scintillii restano.",
	NOTE = "Si possono colorare solo gli scintillii disegnati dall'addon. Lo scintillio del bottino del gioco sugli oggetti delle missioni è disegnato dal motore di gioco e mantiene il suo colore.",
};

FLS.itIT = Sparkles({
	how = " Usa il bersaglio morbido di Blizzard: scintilla l'oggetto più vicino entro circa 15 metri, più intensamente quando puoi raggiungerlo. Richiede l'opzione di gioco \"Attiva tasto di interazione\" e le sue icone di interazione sugli oggetti; attivando questa opzione si attivano entrambe, e senza di esse non scintilla nulla.",
	enabled = "Mostra lo scintillio sugli oggetti delle missioni",
	enabledTip = "Mantiene attivo lo scintillio del bottino del gioco, anche dopo che un'impostazione grafica predefinita lo spegne. La tua modalità contorno resta come l'hai impostata. Lo spegnimento ha effetto dopo il riavvio del gioco.",
	header = "Scintillii all'avvicinamento",
	ore = "Vene di minerale",
	oreTip = "Scintillii sulle vene di minerale quando ti avvicini.",
	herb = "Erbe",
	herbTip = "Scintillii sulle erbe quando ti avvicini.",
	quest = "Oggetti delle missioni",
	questTip = "Scintillii aggiuntivi sugli oggetti delle missioni quando ti avvicini. Disattivato di base: lo scintillio del bottino del gioco ne segna già la maggior parte.",
	corpse = "Cadaveri con bottino",
	corpseTip = "Scintillii su un cadavere che ha ancora bottino per te, boss compresi. Solo dopo il combattimento: in combattimento il gioco non permette agli addon di cambiare la targhetta a cui è agganciato.",
});

---------------------------------------------------------------------------
-- Русский
---------------------------------------------------------------------------

L.ruRU = {
	PANEL_NAME = "Цвета",
	TITLE = "Forever Loot Sparkles - Цвета",
	DESCRIPTION = "Выберите цвет мерцания для каждой категории. Вне досягаемости мерцание тусклее и по-прежнему становится серым, если объект нельзя использовать.",
	ENABLE = "Окрашивать мерцание",
	ENABLE_TOOLTIP = "Выкл.: мерцание сохраняет золотой цвет Forever Loot Sparkles.",
	herb = "Травы",
	ore = "Рудные жилы",
	quest = "Объекты заданий",
	corpseLoot = "Трупы с добычей",
	SWATCH_TOOLTIP = "Щелкните, чтобы выбрать цвет.",
	RESET = "Сбросить цвета",
	SAFE_CAST = "Безопасное заклинание на себя",
	SAFE_CAST_TOOLTIP = "Заклинания без цели могли попасть в игрока или НИП, которого мягкий выбор цели выбрал рядом с вами. С этой настройкой мягкий выбор цели отключается в бою и всякий раз, когда он выбирает живое существо, и включается снова, когда вы отойдете на несколько метров. Жилы и трупы продолжают мерцать. Пока он отключен, клавиша взаимодействия не работает с НИП.",
	HIDE_PLATE = "Скрывать индикатор под мерцанием",
	HIDE_PLATE_TOOLTIP = "Мерцание крепится к индикатору (табличке с именем) объекта или трупа. С этой настройкой индикатор (имя, пустая полоса здоровья, значок) невидим, видно только мерцание.",
	OPEN_HINT = "Настройки находятся в Esc > Настройки > Модификации > Forever Loot Sparkles.",
	other = "Другие объекты",
	npc = "НИП",
	ICONS_NPC_TOOLTIP = "Скрывает значок взаимодействия над НИП, например торговцами, учителями и теми, кто дает задания. Над НИП без индикатора его рисует сама игра, поэтому также отключается игровая настройка значков взаимодействия для НИП (восстанавливается, когда снимете флажок).",
	ICONS_HEADER = "Скрывать значки взаимодействия",
	ICONS_ALL = "Скрыть все",
	ICONS_ALL_TOOLTIP = "Скрывает игровой значок взаимодействия (шестеренка, кирка, лист, рука...) над всеми объектами, трупами и НИП. Мерцание остается.",
	ICONS_TOOLTIP = "Скрывает игровой значок взаимодействия над объектами этого типа. Мерцанию нужны эти значки включенными, поэтому они только становятся невидимыми. Мерцание остается.",
	ICONS_OTHER_TOOLTIP = "Скрывает значок взаимодействия над всеми прочими объектами, например поплавками, сундуками, почтовыми ящиками и дверями. Мерцание остается.",
	NOTE = "Окрасить можно только мерцание, которое рисует модификация. Собственное мерцание добычи на предметах для заданий рисует движок игры, и оно сохраняет свой цвет.",
};

FLS.ruRU = Sparkles({
	how = " Использует мягкий выбор цели Blizzard: мерцает ближайший объект в радиусе около 15 метров, ярче, когда вы можете до него дотянуться. Требуется игровая настройка «Включить клавишу взаимодействия» и ее значки взаимодействия на объектах; включение этой настройки включает и то и другое, а без них ничего не мерцает.",
	enabled = "Показывать мерцание на предметах для заданий",
	enabledTip = "Держит мерцание добычи включенным, даже если графический пресет его отключил. Ваш режим контура остается как есть. Отключение вступает в силу после перезапуска игры.",
	header = "Мерцание при приближении",
	ore = "Рудные жилы",
	oreTip = "Мерцание на рудных жилах, когда вы подходите к ним.",
	herb = "Травы",
	herbTip = "Мерцание на травах, когда вы подходите к ним.",
	quest = "Объекты заданий",
	questTip = "Дополнительное мерцание на объектах заданий, когда вы подходите к ним. По умолчанию выкл.: игровое мерцание добычи уже отмечает большинство из них.",
	corpse = "Трупы с добычей",
	corpseTip = "Мерцание на трупе, в котором еще есть добыча для вас, включая боссов. Только после боя: в бою игра не дает модификациям переключать индикатор, к которому оно крепится.",
});

---------------------------------------------------------------------------
-- 한국어
---------------------------------------------------------------------------

L.koKR = {
	PANEL_NAME = "색상",
	TITLE = "Forever Loot Sparkles - 색상",
	DESCRIPTION = "분류마다 반짝임 색상을 고르세요. 사거리 밖에서는 반짝임이 더 흐리며, 사용할 수 없는 물체에서는 여전히 회색으로 바뀝니다.",
	ENABLE = "반짝임 색상 적용",
	ENABLE_TOOLTIP = "끄면 반짝임이 Forever Loot Sparkles의 금색을 유지합니다.",
	herb = "약초",
	ore = "광맥",
	quest = "퀘스트 물체",
	corpseLoot = "전리품이 남은 시체",
	SWATCH_TOOLTIP = "클릭하여 색상을 고르세요.",
	RESET = "색상 초기화",
	SAFE_CAST = "안전한 자신에게 시전",
	SAFE_CAST_TOOLTIP = "대상 없이 시전한 주문이 소프트 대상 지정이 근처에서 고른 플레이어나 NPC에게 갈 수 있었습니다. 이 옵션을 켜면 전투 중과 살아 있는 대상을 고를 때마다 소프트 대상 지정이 꺼지고, 몇 미터 이동하면 다시 켜집니다. 채집물과 시체는 계속 반짝입니다. 꺼져 있는 동안에는 NPC에게 상호작용 키가 작동하지 않습니다.",
	HIDE_PLATE = "반짝임 아래의 이름표 숨기기",
	HIDE_PLATE_TOOLTIP = "반짝임은 물체나 시체의 이름표에 붙어 있습니다. 이 옵션을 켜면 그 이름표(이름, 빈 생명력 바, 아이콘)가 보이지 않고 반짝임만 보입니다.",
	OPEN_HINT = "설정은 Esc > 설정 > 애드온 > Forever Loot Sparkles에 있습니다.",
	other = "기타 물체",
	npc = "NPC",
	ICONS_NPC_TOOLTIP = "상인, 기술 전문가, 퀘스트 제공자 같은 NPC 위의 상호작용 아이콘을 숨깁니다. 이름표가 없는 NPC 위에는 게임이 직접 그리므로, NPC 상호작용 아이콘 게임 설정도 꺼집니다(선택을 해제하면 복원됨).",
	ICONS_HEADER = "상호작용 아이콘 숨기기",
	ICONS_ALL = "모두 숨기기",
	ICONS_ALL_TOOLTIP = "모든 물체, 시체, NPC 위의 게임 상호작용 아이콘(톱니바퀴, 곡괭이, 잎, 손 등)을 숨깁니다. 반짝임은 유지됩니다.",
	ICONS_TOOLTIP = "이 종류의 물체 위에 있는 게임 상호작용 아이콘을 숨깁니다. 반짝임에는 이 아이콘이 켜져 있어야 하므로 보이지 않게만 합니다. 반짝임은 유지됩니다.",
	ICONS_OTHER_TOOLTIP = "낚시찌, 상자, 우편함, 문 등 그 밖의 모든 물체 위의 상호작용 아이콘을 숨깁니다. 반짝임은 유지됩니다.",
	NOTE = "애드온이 그리는 반짝임만 색상을 바꿀 수 있습니다. 퀘스트 아이템에 있는 게임 자체의 전리품 반짝임은 게임 엔진이 그리므로 색상이 그대로입니다.",
};

FLS.koKR = Sparkles({
	how = " 블리자드의 소프트 대상 지정을 사용합니다. 약 15미터 안의 가장 가까운 물체가 반짝이며, 닿을 수 있으면 더 밝아집니다. 게임 설정 '상호작용 키 활성화'와 물체의 상호작용 아이콘이 필요합니다. 이 옵션을 켜면 둘 다 켜지며, 꺼져 있으면 아무것도 반짝이지 않습니다.",
	enabled = "퀘스트 아이템 반짝임 표시",
	enabledTip = "그래픽 프리셋이 꺼도 게임의 전리품 반짝임을 켜 둡니다. 윤곽선 모드는 설정한 그대로 유지됩니다. 끄기는 게임을 다시 시작한 뒤 적용됩니다.",
	header = "다가갈 때 반짝임",
	ore = "광맥",
	oreTip = "광맥에 다가가면 반짝입니다.",
	herb = "약초",
	herbTip = "약초에 다가가면 반짝입니다.",
	quest = "퀘스트 물체",
	questTip = "퀘스트 물체에 다가가면 추가로 반짝입니다. 기본값은 꺼짐: 게임의 전리품 반짝임이 대부분을 이미 표시합니다.",
	corpse = "전리품이 남은 시체",
	corpseTip = "우두머리를 포함해 아직 내 전리품이 남은 시체가 반짝입니다. 전투 후에만: 전투 중에는 게임이 애드온에게 반짝임이 붙은 이름표를 전환하지 못하게 합니다.",
});

---------------------------------------------------------------------------
-- 简体中文
---------------------------------------------------------------------------

L.zhCN = {
	PANEL_NAME = "颜色",
	TITLE = "Forever Loot Sparkles - 颜色",
	DESCRIPTION = "为每个类别选择闪光颜色。超出范围时闪光较暗，物体无法使用时仍会变灰。",
	ENABLE = "为闪光着色",
	ENABLE_TOOLTIP = "关闭：闪光保持 Forever Loot Sparkles 的金色。",
	herb = "草药",
	ore = "矿脉",
	quest = "任务物体",
	corpseLoot = "有战利品的尸体",
	SWATCH_TOOLTIP = "点击选择颜色。",
	RESET = "重置颜色",
	SAFE_CAST = "安全自我施法",
	SAFE_CAST_TOOLTIP = "无目标施放的法术可能落在软目标在你身旁选中的玩家或NPC身上。开启后，软目标会在战斗中以及每当选中活着的单位时关闭，在你移动几码后重新开启。矿点和尸体仍会闪光。关闭期间，互动键对NPC无效。",
	HIDE_PLATE = "隐藏闪光下方的姓名板",
	HIDE_PLATE_TOOLTIP = "闪光挂在物体或尸体的姓名板上。开启后，该姓名板（名字、空的生命条、图标）不可见，只显示闪光。",
	OPEN_HINT = "设置位于 Esc > 选项 > 插件 > Forever Loot Sparkles。",
	other = "其他物体",
	npc = "NPC",
	ICONS_NPC_TOOLTIP = "隐藏NPC（如商人、训练师和任务发布者）上方的互动图标。没有姓名板的NPC上方的图标由游戏自己绘制，因此还会关闭NPC互动图标的游戏设置（取消勾选时恢复）。",
	ICONS_HEADER = "隐藏互动图标",
	ICONS_ALL = "全部隐藏",
	ICONS_ALL_TOOLTIP = "隐藏所有物体、尸体和NPC上方的游戏互动图标（齿轮、矿镐、叶子、手等）。闪光保留。",
	ICONS_TOOLTIP = "隐藏此类物体上方的游戏互动图标。闪光需要这些图标保持开启，因此只是让它们不可见。闪光保留。",
	ICONS_OTHER_TOOLTIP = "隐藏所有其他物体上方的互动图标，例如鱼漂、宝箱、邮箱和门。闪光保留。",
	NOTE = "只有插件绘制的闪光可以着色。游戏自带的任务物品战利品闪光由游戏引擎绘制，保持原色。",
};

FLS.zhCN = Sparkles({
	how = " 使用暴雪的软目标：约15码内最近的物体会闪光，可以触及时更亮。需要游戏设置“启用互动按键”及其物体互动图标；开启此项会同时开启两者，关闭它们则不会闪光。",
	enabled = "显示任务物品闪光",
	enabledTip = "即使图形预设关闭了战利品闪光，也保持其开启。你的轮廓模式保持不变。关闭后需重启游戏才生效。",
	header = "靠近时闪光",
	ore = "矿脉",
	oreTip = "靠近矿脉时闪光。",
	herb = "草药",
	herbTip = "靠近草药时闪光。",
	quest = "任务物体",
	questTip = "靠近任务物体时额外闪光。默认关闭：游戏的战利品闪光已标记大部分任务物体。",
	corpse = "有战利品的尸体",
	corpseTip = "仍有你的战利品的尸体会闪光，包括首领。仅在战斗后：战斗中游戏不允许插件切换闪光所挂的姓名板。",
});

---------------------------------------------------------------------------
-- 繁體中文
---------------------------------------------------------------------------

L.zhTW = {
	PANEL_NAME = "顏色",
	TITLE = "Forever Loot Sparkles - 顏色",
	DESCRIPTION = "為每個類別選擇閃光顏色。超出範圍時閃光較暗，物件無法使用時仍會變灰。",
	ENABLE = "為閃光上色",
	ENABLE_TOOLTIP = "關閉：閃光維持 Forever Loot Sparkles 的金色。",
	herb = "草藥",
	ore = "礦脈",
	quest = "任務物件",
	corpseLoot = "有戰利品的屍體",
	SWATCH_TOOLTIP = "點擊選擇顏色。",
	RESET = "重置顏色",
	SAFE_CAST = "安全自我施法",
	SAFE_CAST_TOOLTIP = "無目標施放的法術可能落在軟目標在你身旁選中的玩家或NPC身上。開啟後，軟目標會在戰鬥中以及每當選中活著的單位時關閉，在你移動幾碼後重新開啟。礦點和屍體仍會閃光。關閉期間，互動鍵對NPC無效。",
	HIDE_PLATE = "隱藏閃光下方的名條",
	HIDE_PLATE_TOOLTIP = "閃光掛在物件或屍體的名條上。開啟後，該名條（名字、空的生命條、圖示）不可見，只顯示閃光。",
	OPEN_HINT = "設定位於 Esc > 選項 > 插件 > Forever Loot Sparkles。",
	other = "其他物件",
	npc = "NPC",
	ICONS_NPC_TOOLTIP = "隱藏NPC（如商人、訓練師和任務發布者）上方的互動圖示。沒有名條的NPC上方的圖示由遊戲自己繪製，因此也會關閉NPC互動圖示的遊戲設定（取消勾選時恢復）。",
	ICONS_HEADER = "隱藏互動圖示",
	ICONS_ALL = "全部隱藏",
	ICONS_ALL_TOOLTIP = "隱藏所有物件、屍體和NPC上方的遊戲互動圖示（齒輪、礦鎬、葉子、手等）。閃光保留。",
	ICONS_TOOLTIP = "隱藏此類物件上方的遊戲互動圖示。閃光需要這些圖示保持開啟，因此只是讓它們不可見。閃光保留。",
	ICONS_OTHER_TOOLTIP = "隱藏所有其他物件上方的互動圖示，例如浮標、寶箱、郵箱和門。閃光保留。",
	NOTE = "只有插件繪製的閃光可以上色。遊戲本身的任務物品戰利品閃光由遊戲引擎繪製，維持原色。",
};

FLS.zhTW = Sparkles({
	how = " 使用暴雪的軟目標：約15碼內最近的物件會閃光，可以觸及時更亮。需要遊戲設定「啟用互動按鍵」及其物件互動圖示；開啟此項會同時開啟兩者，關閉它們則不會閃光。",
	enabled = "顯示任務物品閃光",
	enabledTip = "即使圖形預設關閉了戰利品閃光，也保持其開啟。你的輪廓模式維持不變。關閉後需重新啟動遊戲才生效。",
	header = "靠近時閃光",
	ore = "礦脈",
	oreTip = "靠近礦脈時閃光。",
	herb = "草藥",
	herbTip = "靠近草藥時閃光。",
	quest = "任務物件",
	questTip = "靠近任務物件時額外閃光。預設關閉：遊戲的戰利品閃光已標記大部分任務物件。",
	corpse = "有戰利品的屍體",
	corpseTip = "仍有你的戰利品的屍體會閃光，包括首領。僅在戰鬥後：戰鬥中遊戲不允許插件切換閃光所掛的名條。",
});
