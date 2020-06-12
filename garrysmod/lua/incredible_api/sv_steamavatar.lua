--[[——————————————————————————————————————————————--
             Developer: [INC]Be1zebub

         Website: incredible-gmod.ru/owner
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

local Fetch, JSONToTable, IsValid, tonum, isstr = http.Fetch, util.JSONToTable, IsValid, tonumber, isstring

local APIModule = {}
APIModule.Name = "SteamAvatar"
APIModule.ApiURL = "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s"
APIModule.DefaultAvatar = "https://incredible-gmod.ru/assets/branding/discord_avatar.png"
function APIModule:Call(target, steamapi_key, callback, show_default)
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
		if not body or body == "" then
			if callback and show_default then
				callback(self.DefaultAvatar)
			end
			return
		end

		local tbl = JSONToTable(body)
		if not tbl or not tbl.response or not tbl.response.players or not tbl.response.players[1] or not tbl.response.players[1].avatarfull then
			if callback and show_default then
				callback(self.DefaultAvatar)
			end
			return
		end
		local result = tbl.response.players[1].avatarfull

		self:DoCache(target, result)
		if callback then
			callback(result)
		end
	end)

	if show_default then
		callback(self.DefaultAvatar)
	end
end

return APIModule
