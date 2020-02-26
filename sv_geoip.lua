--[[——————————————————————————————————————————————--
             Developer: Beelzebub

         Website: incredible-gmod.ru/owner
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

IncredibleAPI = IncredibleAPI or {}
IncredibleAPI.Cache = IncredibleAPI.Cache or {}
IncredibleAPI.Cache.GeoIP = IncredibleAPI.Cache.GeoIP or {}


local http_Fetch = http.Fetch
local util_JSONToTable = util.JSONToTable
local Is_Valid = IsValid

--- http://ip-api.com/json/12.34.5.6?fields=countryCode  (Another GeoAPI)

IncredibleAPI.GeoIPByIP = function(ip, callback)
	if not ip then return end

	if IncredibleAPI.Cache.GeoIP[ip] then
		if callback then
			callback(IncredibleAPI.Cache.GeoIP[ip])
		end
		return
	end
	
	http_Fetch("https://freegeoip.app/json/"..ip, function(body)
		if not body or body == "" then return end
		local tbl = util_JSONToTable(body)
		if not tbl or not tbl["country_code"] then return end

		IncredibleAPI.Cache.GeoIP[ip] = tbl["country_code"]
	end)
end

IncredibleAPI.GeoIP = function(ply, callback)
	if not Is_Valid(ply) then return end

	IncredibleAPI.GeoIPByIP(ply:IPAddress(), callback)
end

--[[
  Usage:
  
   hook.Add("PlayerAuthed", "API_GeoIP_Test", function(ply)
    IncredibleAPI.GeoIP(ply, function(country_code)
      print(ply:Nick(), "ip has:", country_code, "country code")
    end
   end)
]]--
