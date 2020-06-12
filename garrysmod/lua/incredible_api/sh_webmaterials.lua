--[[——————————————————————————————————————————————--
               Developer: Be1zebub

             Website: incredible-gmod.ru
        EMail: beelzebub@incredible-gmod.ru
        Discord: discord.incredible-gmod.ru
--——————————————————————————————————————————————]]--

local CRC, file_Exists, file_Write = util.CRC, file.Exists, file.Write

local oMaterial = Material
local Material = function(path)
	return oMaterial("data/" .. path, "noclamp", "smooth")
end

if not file.Exists("incredible_materials", "DATA") then
    file.CreateDir("incredible_materials")
end

local downloadhash = CRC("https://incredible-gmod.ru/assets/icons/download.png")
local errorMaterial = Material("error")
local DrawDL = function(self, callback, show_dl)
	if not callback or not show_dl then return end

	local dlico = self:GetCache(downloadhash)
	if dlico then
		callback(dlico, true)
	else
		callback(errorMaterial, true)
	end
end

local APIModule = {}
APIModule.Name = "WebMaterials"
function APIModule:Call(imgurl, callback, show_dl)
	local hash = CRC(imgurl)
	local path = "incredible_materials/" .. hash .. ".png"

	local cache = self:GetCache(hash)
	if cache and callback then
		callback(cache)
		return
	elseif file_Exists(path, "DATA") then
		self:DoCache(hash, Material(path))
		local cache = self:GetCache(hash)
		if cache and callback then
			callback(cache)
			return
		end
	end

	if self:Delay() then DrawDL(self, callback, show_dl) return end

	self:FetchURL(imgurl, function(body)
		if not body or body == "" then return end

		file_Write(path, body)
		self:DoCache(hash, Material(path))

		local cache = self:GetCache(hash)
		if cache and callback then
			callback(cache)
		end
	end)

	DrawDL(self, callback, show_dl)
end
function APIModule:OnRegister()
	self:Call("https://incredible-gmod.ru/assets/icons/download.png") -- precache
end

return APIModule
