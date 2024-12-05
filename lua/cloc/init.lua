local config = require("cloc.config")
local cloc = require("cloc.cloc")

local status = require("cloc.status")

local M = {}

local function update()
	status.set_status({ data = {}, statusCode = "loading" })
	cloc.execute(function(data)
		status.set_status({ data = data, statusCode = "ready" })
	end)
end

---initialize a cloc instance and set autocmds
---@param dir any
---@param project any
local function init(dir, project)
	local group = vim.api.nvim_create_augroup("cloc", { clear = true })
	vim.api.nvim_create_autocmd(config.options.autocmds, {
		group = group,
		callback = update,
	})
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

	local group = vim.api.nvim_create_augroup("cloc ", { clear = true })
	vim.api.nvim_create_autocmd("DirChanged", {
		pattern = "global",
		group = group,
		callback = try_init,
	})

	try_init({ file = vim.fn.getcwd() })
end

M.get_status = status.get_status

return M
