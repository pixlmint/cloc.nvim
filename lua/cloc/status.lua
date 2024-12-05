---@class ClocStatus
---@field statusCode string<"loading", "ready", "error">
---@field data LangData[]

local M = {}

---@type ClocStatus
M.status = {
	statusCode = "loading",
	data = {},
}

---@param status ClocStatus
function M.set_status(status)
	M.status = status
end

---@return ClocStatus
function M.get_status()
	return M.status
end

return M
