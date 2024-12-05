local config = require("cloc.config")
local cloc = require("cloc.cloc")

local M = {}

local function update()
	cloc.execute(function()
		-- update
	end)
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
