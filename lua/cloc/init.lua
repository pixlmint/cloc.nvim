local config = require("cloc.config")

local M = {}

---@class LangData
---@field lang string
---@field files number
---@field blank number
---@field comment number
---@field code number

---@typel LangData[]
M.data = {}

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
				files = files,
				blank = blank,
				comment = comment,
				code = code,
			}
		end
	end
end

local function update()
	local function on_exit(result)
		if result.code == 0 then
			processData(result.stdout)
		end
	end
	local cmd = {
		config.options.cmd,
		config.options.cwd,
	}
	vim.system(cmd, { text = true }, on_exit)
end

function M.setup(opts)
	config.setup(opts)

	if config.options.autocmd then
		local group = vim.api.nvim_create_augroup("cloc", { clear = true })
		vim.api.nvim_create_autocmd(config.options.autocmd, {
			group = group,
			callback = update,
		})
	end
end

return M
