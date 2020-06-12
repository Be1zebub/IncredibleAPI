Usage examples:

IncredibleAPI:Call("SteamPlaytime", player.GetHumans()[1]:SteamID64(), "YorSteamAPIKeyHere", function(seconds) -- Get gmod playtime
	print(seconds/60)
end)

IncredibleAPI:Call("WebMaterials", "https://incredible-gmod.ru/assets/branding/discord_avatar.png", function(webMat) -- Get web material
  print(webMat)
  if CLIENT then
    hook.Add("HUDPaint", "DrawWebMatExample", function()
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(webMat)
        surface.DrawTexturedRect(ScrW()*0.5 - 256, ScrH()*0.5 - 256, 512, 512)
    end)
  end
end)
