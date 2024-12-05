---@class ClocConfig
---@field cmd string
---@field cwd string|function
---@field autocmd string
local default = {
	cmd = "gocloc",
	cwd = ".", -- string or function, returns the working dir
	autocmd = "BufWritePost", -- bufwritepost or nil, nil indicates no autocmd will be set
}

local M = {}

M.options = {}

function M.setup(config)
	M.options = vim.tbl_extend("force", default, config or {})
end

return M
