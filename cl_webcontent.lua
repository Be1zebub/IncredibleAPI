--[[——————————————————————————————————————————————--
             Developer: [INC]Be1zebub
         Website: incredible-gmod.ru/owner
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

IncredibleAPI = IncredibleAPI or {}
IncredibleAPI.Util = IncredibleAPI.Util or {}
IncredibleAPI.Cache = IncredibleAPI.Cache or {}
IncredibleAPI.Cache.WebMaterials = IncredibleAPI.Cache.WebMaterials or {}


local http_Fetch, LocalPly, Mat, string_Replace = http.Fetch, LocalPlayer, Material, string.Replace
local file_Write, file_Exists, CurrentTime = file.Write, file.Exists, CurTime


local ShowDownloadIcon = function()
    return IncredibleAPI.WebMaterial("https://incredible-gmod.ru/assets/icons/download.png")
end

IncredibleAPI.Util.GetFilenameFromURL = function(url, ext)
    local filename = url:match("([^/]+)$") -- Get filename+extention

    return string_Replace(filename, "." .. filename:match("[^.]+$"), "") -- Remove extention
end

IncredibleAPI.WebMaterial = function(img_url)
    local img_name = IncredibleAPI.Util.GetFilenameFromURL(img_url)
    local path = "incredible_materials/" .. img_name .. ".png"
    if IncredibleAPI.Cache.WebMaterials[img_name] then return IncredibleAPI.Cache.WebMaterials[img_name] end

    if file_Exists(path, "DATA") then
        IncredibleAPI.Cache.WebMaterials[img_name] = Mat("data/" .. path, "noclamp smooth")

        return IncredibleAPI.Cache.WebMaterials[img_name]
    else
        if (LocalPly().FetchDelay or 0) > CurrentTime() then return ShowDownloadIcon() end
        LocalPly().FetchDelay = CurrentTime() + 2

        http_Fetch(img_url, function(result)
            if result then
                if not file_Exists("incredible_materials", "DATA") then
                    file_CreateDir("incredible_materials")
                end

                file_Write(path, result)
            end
        end)
    end

    return ShowDownloadIcon()
end

ShowDownloadIcon() -- Force Download that shiet
