local config = require("cloc.config")
M = {}

---@class LangData
---@field lang string
---@field files number
---@field blank number
---@field comment number
---@field code number

---Initialize a new cloc instance
---@param root_dir string
---@param program string
---@param include string[]
---@return table
function M.new(root_dir, program, include, exclude_d)
	local obj = {
		result = {},
		root_dir = root_dir,
		program = program,
		include = include,
		exclude_d = exclude_d,
	}
	return setmetatable(obj, { __index = M })
end

---@return table
function M:get_cmd()
	local cmd = { self.program }
	for _, value in ipairs(self.exclude_d) do
		table.insert(cmd, '--not-match-d')
		table.insert(cmd, value)
	end
	for _, value in ipairs(self.include) do
		table.insert(cmd, value)
	end
	return cmd
end

function M:execute(callback)
	local function on_exit(result)
		if result.code == 0 then
			self:processData(result.stdout)
			if callback then
				callback(self.result)
			end
		end
	end
	local cmd = self:get_cmd()
	vim.system(cmd, { text = true, cwd = self.root_dir }, on_exit)
end

function M:processData(result)
	self.result = {}
	local lines = vim.split(result, "\n")
	for i, value in ipairs(lines) do
		if i > 3 and i < #lines - 3 then
			local langline = vim.split(value, "%s+", { trimempty = true })
			local lang = langline[1]
			if config.options.program == "tokei" then
				-- Files        Lines         Code     Comments       Blanks
				local files = tonumber(langline[2])
				local code = tonumber(langline[4])
				local comment = tonumber(langline[5])
				local blank = tonumber(langline[6])
				table.insert(self.result, {
					lang = lang,
					files = files or -1,
					blank = blank or -1,
					comment = comment or -1,
					code = code or -1,
				})
			else
				local files = tonumber(langline[2])
				local blank = tonumber(langline[3])
				local comment = tonumber(langline[4])
				local code = tonumber(langline[5])
				table.insert(self.result, {
					lang = lang,
					files = files or -1,
					blank = blank or -1,
					comment = comment or -1,
					code = code or -1,
				})
			end
		end
	end
end

return M
