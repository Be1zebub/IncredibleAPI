-- incredible-gmod.ru
-- IncredibleAPI lib

local isstr, pairs = isstring, pairs

local APIModule = {}
APIModule.Name = "SteamIsInGroup"
APIModule.ApiURL = "https://api.steampowered.com/ISteamUser/GetUserGroupList/v1/?key=%s&steamid=%s"
function APIModule:Call(target, steamapi_key, group_id, callback)
	target = self:RequestSteamID64(target)
	if not isstr(target) then return end

	local cache_uid = target.."_"..group_id
	local cache = self:GetCache(cache_uid)
	if cache and callback then
		callback(cache)
		return
	end

	self:FetchURL(self:FormatUrl(steamapi_key, target), function(body)
		if not body or body == "" then return end
		local tbl = self:HandleJson(body, "response", "groups")
		if not tbl then return end

		local result
		for k, v in pairs(tbl) do
			if v.gid == group_id then
				result = true
				break
			end
		end

		self:DoCache(cache_uid, result)
		if callback then
			callback(result)
		end
	end)
end

return APIModule
