--[[——————————————————————————————————————————————--
             Developer: [INC]Be1zebub

         Website: incredible-gmod.ru/owner
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--
Incredible_API = Incredible_API or {}
Incredible_API.Cache = Incredible_API.Cache or {}

Incredible_API.Cache.Proxy = Incredible_API.Cache.Proxy or {}

local http_Fetch = http.Fetch
local Is_Valid = IsValid

Incredible_API.ProxyByIP = function(ip, callback)
	if not ip then return end

	if Incredible_API.Cache.Proxy[ip] then
		if callback then
			callback(Incredible_API.Cache.Proxy[ip])
		end
		return
	end

	http_Fetch("https://blackbox.ipinfo.app/lookup/"..ip, function(body)
		if not body or body == "" then return end

		Incredible_API.Cache.Proxy[ip] = body == "Y" --(body == "Y" and true or body == "N" and false)

		if callback then
			callback(Incredible_API.Cache.Proxy[ip])
		end
	end)
end

Incredible_API.Proxy = function(ply, callback)
	if not Is_Valid(ply) then return end

	Incredible_API.ProxyByIP(ply:IPAddress(), callback)
end


--[[
	Usage:

	hook.Add("PlayerAuthed", "AntiProxy", function(ply)
		Incredible_API.Proxy(ply, function(isproxy)
			if isproxy then
				ply:Kick("Я ТЕБЯ ЗАПРЕЩАЮ!")
			end
		end)
	end)
]]--
