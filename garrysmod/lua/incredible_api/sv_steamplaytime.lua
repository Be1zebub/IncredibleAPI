--[[——————————————————————————————————————————————--
             Developer: [INC]Be1zebub

         Website: incredible-gmod.ru/owner
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

local Fetch, JSONToTable, IsValid, tonum, isstr, pairs = http.Fetch, util.JSONToTable, IsValid, tonumber, isstring, pairs

local APIModule = {}
APIModule.Name = "SteamPlaytime"
APIModule.ApiURL = "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=%s&steamid=%s"
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
		local games = JSONToTable(body)
		if not games or not games["response"] or not games["response"]["games"] then return end

		for k,v in pairs(games["response"]["games"]) do
			if v["appid"] == 4000 then
				local result = v["playtime_forever"]

				self:DoCache(target, result)
				if callback then
					callback(result)
				end

				break
			end
		end
	end)
end

return APIModule
