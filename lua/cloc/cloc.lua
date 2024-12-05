local config = require("cloc.config")

M = {}

---@class LangData
---@field lang string
---@field files number
---@field blank number
---@field comment number
---@field code number

---@type LangData[]
M.data = {}

---@param data string
local function processData(data)
	local lines = vim.split(data, "\n")
	for i, value in ipairs(lines) do
		if i > 3 and i < #lines - 3 then
			local langline = vim.split(value, "%s+", { trimempty = true })
			local lang = langline[1]
			local files = tonumber(langline[2])
			local blank = tonumber(langline[3])
			local comment = tonumber(langline[4])
			local code = tonumber(langline[5])
			M.data[#M.data + 1] = {
				lang = lang,
				files = files or -1,
				blank = blank or -1,
				comment = comment or -1,
				code = code or -1,
			}
		end
	end
end

---@param callback function
function M.execute(callback)
	local function on_exit(result)
		if result.code == 0 then
			processData(result.stdout)
			if callback then
				callback(M.data)
			end
		end
	end
	local cmd = {
		config.options.cmd,
		config.options.cwd,
	}
	vim.system(cmd, { text = true }, on_exit)
end

return M
