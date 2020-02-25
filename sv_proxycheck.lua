--[[——————————————————————————————————————————————--
             Developer: [INC]Be1zebub

         Website: incredible-gmod.ru/owner
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--
IncredibleAPI = IncredibleAPI or {}
IncredibleAPI.Cache = IncredibleAPI.Cache or {}
IncredibleAPI.Cache.Proxy = IncredibleAPI.Cache.Proxy or {}

local http_Fetch = http.Fetch
local Is_Valid = IsValid

IncredibleAPI.ProxyByIP = function(ip, callback)
    if not ip then return end

    if IncredibleAPI.Cache.Proxy[ip] then
        if callback then
            callback(IncredibleAPI.Cache.Proxy[ip])
        end

        return
    end

    http_Fetch("https://blackbox.ipinfo.app/lookup/" .. ip, function(body)
        if not body or body == "" then return end
        IncredibleAPI.Cache.Proxy[ip] = body == "Y" --(body == "Y" and true or body == "N" and false)

        if callback then
            callback(IncredibleAPI.Cache.Proxy[ip])
        end
    end)
end

IncredibleAPI.Proxy = function(ply, callback)
    if not Is_Valid(ply) then return end
    IncredibleAPI.ProxyByIP(ply:IPAddress(), callback)
end


--[[
	Usage:

	hook.Add("PlayerAuthed", "AntiProxy", function(ply)
		IncredibleAPI.Proxy(ply, function(isproxy)
			if isproxy then
				ply:Kick("Я ТЕБЯ ЗАПРЕЩАЮ!")
			end
		end)
	end)
]]--
