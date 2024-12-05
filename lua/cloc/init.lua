local config = require("cloc.config")
local Cloc = require("cloc.cloc")

local status = require("cloc.status")

local cloc_group = vim.api.nvim_create_augroup("cloc", { clear = true })

local M = {}

---initialize a cloc instance and set autocmds
---@param dir any
---@param project ClocProjectConfig
local function init(dir, project)
	local cloc = Cloc.new(dir, config.options.program, project.include)
	local callback = function()
		status.set_status({ data = {}, statusCode = "loading" })
		cloc:execute(function(data)
			status.set_status({ data = data, statusCode = "ready" })
		end)
	end

	vim.api.nvim_create_autocmd(config.options.autocmds, {
		group = cloc_group,
		callback = callback,
	})

	callback()
end

local function try_init(event)
	local dir = event.file
	for _, project in pairs(config.options.projects) do
		local pattern = project.pattern
		local stat = vim.uv.fs_stat(dir .. "/" .. pattern)
		if stat then
			init(dir, project)
			return
		end
	end
end

function M.setup(opts)
	config.setup(opts)

	vim.api.nvim_create_autocmd("DirChanged", {
		pattern = "global",
		group = cloc_group,
		callback = try_init,
	})

	try_init({ file = vim.fn.getcwd() })
end

M.get_status = status.get_status

return M
