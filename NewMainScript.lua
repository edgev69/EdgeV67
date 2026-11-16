local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/edgev69/EdgeCompiled/'..readfile('main/profiles/commit.txt')..'/'..select(1, path:gsub('main/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'main', 'main/games', 'main/profiles', 'main/assets', 'main/libraries', 'main/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/edgev69/EdgeCompiled')
	end)

	local assetVer = '1'
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'

	if commit == 'main' or (isfile('main/profiles/commit.txt') and readfile('main/profiles/commit.txt') or '') ~= commit then
		wipeFolder('main')
		wipeFolder('main/games')
		wipeFolder('main/guis')
		wipeFolder('main/libraries')
	end

	if (isfile('main/profiles/asset.txt') and readfile('main/profiles/asset.txt') or '') ~= assetVer then
		wipeFolder('main/assets')
	end

	writefile('main/profiles/asset.txt', assetVer)
	writefile('main/profiles/commit.txt', commit)
end

return loadstring(downloadFile('main/main.lua'), 'main')()