--[[——————————————————————————————————————————————--
             Developer: [INC]Be1zebub

         Website: incredible-gmod.ru/owner
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

local Fetch, JSONToTable, IsValid, tonum, isstr = http.Fetch, util.JSONToTable, IsValid, tonumber, isstring

local APIModule = {}
APIModule.Name = "SteamFamilyShared"
APIModule.ApiURL = "https://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v1/?key=%s&steamid=%s"
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
		local tab = JSONToTable(body)
		if not tab or not tab["response"] or not tab["response"]["lender_steamid"] then return end
		local result = tab["response"]["lender_steamid"] == 1

		self:DoCache(target, result)
		if callback then
			callback(result)
		end
	end)
end

return APIModule
