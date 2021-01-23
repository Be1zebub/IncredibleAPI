-- incredible-gmod.ru
-- IncredibleAPI lib

local isstr = isstring

local APIModule = {}
APIModule.Name = "SteamBans"
APIModule.ApiURL = "http://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=%s&steamids=%s&format=json"
function APIModule:Call(target, steamapi_key, callback)
	target = self:RequestSteamID64(target)
	if not isstr(target) then return end

	local cache = self:GetCache(target)
	if cache and callback then
		callback(cache)
		return
	end

	self:FetchURL(self:FormatUrl(steamapi_key, target), function(body)
		if not body or body == "" then return end
		local tbl = self:HandleJson(body, "players", 1)
		if not tbl then return end

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
