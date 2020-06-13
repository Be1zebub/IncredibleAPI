--[[——————————————————————————————————————————————--
               Developer: Be1zebub

             Website: incredible-gmod.ru
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

local Fetch, strFormat, isstr, istab, unpuck, Json2Tab, newyork, CurrentTime, str_Replace = http.Fetch, string.format, isstring, istable, unpack, util.JSONToTable, pairs, CurTime, string.Replace

IncredibleAPI = IncredibleAPI or {}
IncredibleAPI.__index = IncredibleAPI
IncredibleAPI.Modules = IncredibleAPI.Modules or {}

function IncredibleAPI:Call(module_name, ...)
	local m = self.Modules[module_name]
	if m and m.Call then
		m:Call(...)
		return true
	end

	return false
end

function IncredibleAPI:RegisterModule(name, tab)
	tab.Cache = {}
	setmetatable(tab, ApiMETA)
	IncredibleAPI.Modules[name] = tab

	if tab.OnRegister then
		tab:OnRegister()
	end
end

--——————————————— A P I  —▬—  M E T A  —▬— T A B L E ———————————————--

local ApiMETA = {}
ApiMETA.__index = ApiMETA
ApiMETA.W8 = 0
ApiMETA.DefaultDelay = 5
ApiMETA.UrlPattern = "https?://[%w-_%.%?%.:/%+=&]+"

function ApiMETA:IsValidURL(url)
	return url:find(self.UrlPattern)
end

function ApiMETA:FetchURL(args, handle)
	local url = self.URL and strFormat(self.URL, isstr(args) and args or istab(args) and unpuck(args)) or args
	if not self:IsValidURL(url) then return end

	Fetch(url, function(body)
		if not body or body == "" then return end

		if handle then
			handle(body)
		end
	end)
end

function ApiMETA:HandleJson(body, ...)
	local json = Json2Tab(body)
	if not json then return end

	local args = {...}
	for _, key in newyork(args) do
		if json[key] then
			json = json[key]
		end
	end

	return json
end

function ApiMETA:DoCache(uid, data)
	self.Cache[uid] = data
end

function ApiMETA:GetCache(uid)
	return self.Cache[uid]
end

function ApiMETA:Delay(t)
	local CT = CurrentTime()

	if self.W8 > CT then return true end
	self.W8 = CT + (t or self.DefaultDelay)
end

--——————————————— M O D U L E S —▬— L O A D ———————————————--

local __DebugMode = true

local include_realm = { -- Thx Penguin for thats better solution :)
    sv = SERVER and include or function() end,
    cl = SERVER and AddCSLuaFile or include,
}

include_realm.sh = function(f)
    return include_realm.cl(f) or include_realm.sv(f)
end

local __a, __b = file.Find, string.sub

local string_upper = string.upper
local First2Upper = function(str) return str:gsub("^%l", string_upper) end

local Filename2CoolName = function(f)
	f = str_Replace(f, "." .. f:match("[^.]+$"), "") -- remove extention
	f = __b(f, 4, #f) -- remove realm name (sv_ or _sh or _cl e.t.c)

	return First2Upper(f)
end


local file_register = function(f)
	local realm = __b(f, 1, 2)
    
    if include_realm[realm] then
    	local result = include_realm[realm]("incredible_api/"..f)
    	if result then
    		IncredibleAPI:RegisterModule(result.Name or Filename2CoolName(f), result)

    		if __DebugMode then
		        print("Registered: " .. realm .. " | " .. f)
		    end
		elseif __DebugMode then
			print("[ERROR] Include did not return table: " .. realm .. " | " .. f)
    	end
    elseif __DebugMode then
	    print("[ERROR] Realm does not exists: " .. realm .. " | " .. f)
    end
end

local DoLoadAPIs = function()
	local files, folders = __a("incredible_api/*", "LUA")

	for _, f in newyork(files) do
		file_register(f)
	end

	if IsFirstTimePredicted() then
	    MsgC(Color(40, 149, 220), "Incredible API-Library has been loaded! \n")
	end
end

DoLoadAPIs()

if SERVER then
	util.AddNetworkString("IncredibleAPI.Reload")

    concommand.Add("incredibleapi_reload", function(ply)
        if ply:IsSuperAdmin() then
        	DoLoadAPIs()
            net.Start("IncredibleAPI.Reload")
            net.Broadcast()
        end
    end)
else
    net.Receive("IncredibleAPI.Reload", function()
        DoLoadAPIs()
    end)
end
