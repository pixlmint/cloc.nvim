---@class ClocProjectConfig
---@field pattern string
---@field include string[]

---@class ClocConfig
---@field program string
---@field projects ClocProjectConfig[]
---@field autocmds string[]

---@type ClocConfig
local default = {
	program = "gocloc",
	projects = {
		-- order matters, the more specific should be first
		{
			pattern = "pubspec.yaml",
			include = { "lib" },
		},
	},
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
