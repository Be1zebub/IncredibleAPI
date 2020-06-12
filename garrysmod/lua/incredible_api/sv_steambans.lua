--[[——————————————————————————————————————————————--
             Developer: [INC]Be1zebub

         Website: incredible-gmod.ru/owner
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

local Fetch, JSONToTable, IsValid, tonum, isstr = http.Fetch, util.JSONToTable, IsValid, tonumber, isstring

local APIModule = {}
APIModule.Name = "SteamBans"
APIModule.ApiURL = "http://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=%s&steamids=%s&format=json"
function APIModule:Call(target, steamapi_key, callback)
	if not isstr(target) and IsValid(target) and target:IsPlayer() then
		target = target:SteamID64()
	end

	if not isstr(target) then return end

	local cache = self:GetCache(target)
	if cache and callback then
		callback(cache)
		return
	end

	self:FetchURL(self.ApiURL:format(steamapi_key, target), function(body)
		if not body or body == "" then return end
		local tbl = JSONToTable(body)
		if not tbl or not tbl.players then return end

		tbl = tbl.players[1]
		tbl["SteamId"] = nil

		if tbl["EconomyBan"] == "none" then
			tbl["EconomyBan"] = false
		end
		self:DoCache(target, tbl)
		if callback then
			callback(tbl)
		end
	end)
end

return APIModule
