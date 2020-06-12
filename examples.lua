Usage examples:

IncredibleAPI:Call("SteamPlaytime", player.GetHumans()[1]:SteamID64(), "YorSteamAPIKeyHere", function(seconds) -- Get gmod playtime
	print(seconds/60)
end)

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
