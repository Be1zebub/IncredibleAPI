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

IncredibleAPI:Call("GeoIP", ply, function(country_code) -- Get country code
	print(country_code)
end)

IncredibleAPI:Call("Proxy", ply, function(is_use_proxy) -- Anti-proxy API
	ply:Kick("Proxy is not allowed!")
end)

IncredibleAPI:Call("SteamPlaytime", ply, "!!! Your SteamAPI-Key Here !!!", function(seconds) -- Get gmod playtime
	print(seconds/60)
end)

IncredibleAPI:Call("SteamAvatar", ply, "!!! Your SteamAPI-Key Here !!!", function(avatar_url) -- Get player avatar url
	print(avatar_url)
end)

IncredibleAPI:Call("SteamBans", ply, "!!! Your SteamAPI-Key Here !!!", function(bans_data) -- Get player bans
	PrintTable(bans_data)
end)

IncredibleAPI:Call("SteamFamilyShared", ply, "!!! Your SteamAPI-Key Here !!!", function(is_family_shared) -- Anti-FamilyShared
	if is_family_shared then
		ply:Kick("Family-Shared is not allowed!")
	end
end)
