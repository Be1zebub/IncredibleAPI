-- incredible-gmod.ru
-- IncredibleAPI lib

local isstr, pairs = isstring, pairs

local APIModule = {}
APIModule.Name = "SteamPlaytime"
APIModule.ApiURL = "https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key=%s&steamid=%s"
function APIModule:Call(target, steamapi_key, callback, appid)
	target = self:RequestSteamID64(target)
	if not isstr(target) then return end

	appid = {[appid or 4000] = true}

	local cache = self:GetCache(target)
	if cache and callback then
		callback(cache)
		return
	end

	self:FetchURL(self:FormatUrl(steamapi_key, target), function(body)
		if not body or body == "" then return end
		local result = self:HandleJson(body, "response", "games")
		if not result then return end

		for k,v in pairs(result) do
			if appid[v.appid] then
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
