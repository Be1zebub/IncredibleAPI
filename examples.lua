-- Usage examples:

IncredibleAPI:Call("WebMaterials", "http://incredible-gmod.ru/assets/other/beelze_pixel.png", function(webMat) -- Get web material
	print(webMat)
	if CLIENT then
		hook.Add("HUDPaint", "DrawWebMatExample", function()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(webMat)
			surface.DrawTexturedRect(ScrW()*0.5 - 128, ScrH()*0.5 - 120.5, 256, 241)
		end)
	end
end)

local ply = player.GetHumans()[1]

IncredibleAPI:Call("GeoIP", ply, function(country_code) -- Get country code (подобные функции принимают ply или SteamID64)
	print(country_code)
end)

IncredibleAPI:Call("Proxy", ply, function(is_use_proxy) -- Anti-proxy API
	ply:Kick("Proxy is not allowed!")
end)

local steam_api_key = "!!! Your SteamAPI-Key Here !!!"
IncredibleAPI:Call("SteamPlaytime", ply, steam_api_key, function(seconds) -- Get gmod playtime
	print(seconds/60)
end)

IncredibleAPI:Call("SteamAvatar", ply, steam_api_key, function(avatar_url) -- Get player avatar url
	print(avatar_url)
end)

IncredibleAPI:Call("SteamBans", ply, steam_api_key, function(bans_data) -- Get player bans
	PrintTable(bans_data)
end)

IncredibleAPI:Call("SteamFamilyShared", ply, steam_api_key, function(is_family_shared) -- Anti-FamilyShared
	if is_family_shared then
		ply:Kick("Family-Shared is not allowed!")
	end
end)

IncredibleAPI:Call("SteamIsInGroup", ply, steam_api_key, "4822177", function(bool) -- Check if user member of group
	print(bool)
end)

IncredibleAPI:Call("SteamGetCollectionItems", steam_api_key, "1829820706", function(ids) -- Auto resource.AddWorkshop 4all collection items
	for k, workshopid in pairs(ids) do
		resource.AddWorkshop(workshopid)
	end
end)
