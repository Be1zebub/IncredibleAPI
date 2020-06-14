--[[——————————————————————————————————————————————--
             Developer: [INC]Be1zebub

         Website: incredible-gmod.ru/owner
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

local httpPost, pairs, insert = http.Post, pairs, table.insert

local APIModule = {}
APIModule.Name = "SteamGetCollectionItems"
APIModule.ApiURL = "https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1/"
function APIModule:Call(steamapi_key, collection_id, callback)
	local cache = self:GetCache(collection_id)
	if cache and callback then
		callback(cache)
		return
	end

	httpPost(self.ApiURL, {
		["key"] = steamapi_key,
		["publishedfileids[0]"] = collection_id,
		["collectioncount"] = "1",
	}, function(body)
		if not body or body == "" then return end
		local result = self:HandleJson(body, "response", "collectiondetails", 1, "children")
		if not result then return end

		local data = {}
		for k, v in pairs(result) do
			insert(data, v.publishedfileid)
		end

		self:DoCache(collection_id, data)
		if callback then
			callback(data)
		end
	end)
end

return APIModule
