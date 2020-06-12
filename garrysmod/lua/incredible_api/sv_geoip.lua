--[[——————————————————————————————————————————————--
               Developer: Be1zebub

             Website: incredible-gmod.ru
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

local Fetch, JSONToTable, IsValid, tonum, isstr = http.Fetch, util.JSONToTable, IsValid, tonumber, isstr

local function ip2dec(ip)
	local dec = 0
	ip:gsub("%d+", function(s)
		dec = dec * 256 + tonum(s)
	end)
	return dec
end

local APIModule = {}
APIModule.Name = "GeoIP"
APIModule.ApiURL = "https://freegeoip.app/json/%s" -- http://ip-api.com/json/%s?fields=countryCode  (Another GeoAPI)
function APIModule:Call(target, callback)
	if not isstr(target) and IsValid(target) and target:IsPlayer() then
		target = target:IPAddress()
	end

	if not isstr(target) then return end
	target = ip2dec(target)

	local cache = self:GetCache(target)
	if cache and callback then
		callback(cache)
		return
	end

	self:FetchURL(self.ApiURL:format(target), function(body)
		if not body or body == "" then return end
		local tbl = util_JSONToTable(body)
		if not tbl or not tbl["country_code"] then return end

		self:DoCache(target, tbl["country_code"])
		if callback then
			callback(tbl["country_code"])
		end
	end)
end

return APIModule
