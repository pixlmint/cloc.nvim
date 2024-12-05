---@class ClocConfig
---@field cmd string
---@field cwd string|function
---@field autocmds string[]

---@type ClocConfig
local default = {
	cmd = "gocloc",
	cwd = ".", -- string or function, returns the working dir
	autocmds = { "BufWritePost", "BufEnter" }, -- or nil, nil indicates no autocmd will be set
}

local M = {}

---@type ClocConfig
---@diagnostic disable-next-line: missing-fields
M.options = {}

function M.setup(config)
	M.options = vim.tbl_extend("force", default, config or {})
end

return M
