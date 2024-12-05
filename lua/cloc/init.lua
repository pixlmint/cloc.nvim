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

function M.setup(opts)
	config.setup(opts)

	if config.options.autocmds ~= nil then
		local group = vim.api.nvim_create_augroup("cloc", { clear = true })
		vim.api.nvim_create_autocmd(config.options.autocmds, {
			group = group,
			callback = update,
		})
	end
end

M.get_status = status.get_status

return M
