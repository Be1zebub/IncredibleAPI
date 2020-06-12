--[[——————————————————————————————————————————————--
               Developer: Be1zebub

             Website: incredible-gmod.ru
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

local Fetch, IsValid, isstr = http.Fetch, IsValid, isstring

local APIModule = {}
APIModule.Name = "Proxy"
APIModule.ApiURL = "https://blackbox.ipinfo.app/lookup/%s"
function APIModule:Call(target, callback)
	if not isstr(target) and IsValid(target) and target:IsPlayer() then
		target = target:IPAddress()
	end
	if not isstr(target) then return end

	local cache = self:GetCache(target)
	if cache and callback then
		callback(cache)
		return
	end

	self:FetchURL(self.ApiURL:format(target), function(body)
		if not body or body == "" then return end
		local result = body == "Y"

		self:DoCache(target, result)
		if callback then
			callback(result)
		end
	end)
end

return APIModule
