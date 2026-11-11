--[[ Copyright (C) 2018-2026 TomCat's Gaming, LLC. All Rights Reserved.
     Unauthorized use, reproduction, or distribution is prohibited.
     See license.txt included with this distribution for full terms. ]]
select(2, ...).SetupGlobalFacade()

L = { }

local patternsES = {
	{ "^, get your level (%d+) abilities from the $", ", aprende tus facultades de nivel %1 con el " },
	{ "^Get your level (%d+) abilities from the $", "Aprende tus facultades de nivel %1 con el " },
	{ "^, get your level (%d+) spells/abilities from the $", ", aprende tus hechizos y facultades de nivel %1 con el " },
	{ "^Get your level (%d+) spells/abilities from the $", "Aprende tus hechizos y facultades de nivel %1 con el " },
	{ "^Get level (%d+) spells/abilities from the $", "Aprende tus hechizos y facultades de nivel %1 con el " },
	{ "^Since you are level (%d+) now, get new spells/abilities%.?$", "Como ya eres nivel %1, aprende nuevos hechizos/facultades." },
	{ "^, learn new abilities from the $", ", aprende nuevas facultades con el " },
	{ "^Learn new weapon possibilities from the $", "Aprende nuevas habilidades de armas con el " },
	{ "^Get new spells/abilities from the $", "Aprende nuevos hechizos y facultades con el " },
	{ "^Hearth to (.+)$", "Usa tu piedra de hogar hacia %1" },
	{ "^Go back to (.+)$", "Regresa a %1" },
	{ "^Head to (.+)$", "Dirígete a %1" },
	{ "^Back at (.+)$", "De vuelta en %1" },
	{ "^Enter (.+)$", "Entra a %1" },
	{ "^Exit (.+)$", "Sal de %1" },
	{ "^Loot: (.+)$", "Despoja: %1" },
	{ "^Kill: (.+)$", "Derrota: %1" },
	{ "^Kill/loot: (.+)$", "Derrota y despoja: %1" },
	{ "^Kill and loot (.+)$", "Derrota y despoja %1" },
	{ "^Kill/loot (.+)$", "Derrota y despoja %1" },
	{ "^Talk to (.+)$", "Habla con %1" },
	{ "^Speak with (.+)$", "Habla con %1" },
	{ "^Speak to (.+)$", "Habla con %1" },
	{ "^Turn in at (.+)$", "Entrega en %1" },
	{ "^Turn in (.+)$", "Entrega %1" },
	{ "^Accept (.+)$", "Acepta %1" },
	{ "^Buy (.+)%?$", "¿Comprar %1?" },
	{ "^Follow waypoint to (.+)$", "Sigue el punto de ruta hacia %1" },
	{ "^Follow waypoint (.+)$", "Sigue el punto de ruta %1" },
	{ "^(.+) mostly around here$", "%1 principalmente por aquí" },
	{ "^Level (%a+) to (%d+)$", "Sube %1 a %2" }
}

setmetatable(L, {
	__index = function(self, key)
		local value = rawget(self, key)
		if (value) then return value end
		if (type(key) == "string") then
			local loc = GetLocale and GetLocale()
			if (loc == "esES" or loc == "esMX") then
				for i = 1, #patternsES do
					local pat, rep = patternsES[i][1], patternsES[i][2]
					local res = key:match(pat)
					if (res) then
						local translated = key:gsub(pat, rep)
						rawset(self, key, translated)
						return translated
					end
				end
			end
		end
		return key
	end
})
