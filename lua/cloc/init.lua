local config = require("cloc.config")

local M = {}

local function project_root()
	-- TODO: Implement this
	return "."
end

local function get_args()
	-- TODO: Implement this
	return nil
end

--- @param callback fun(data: string)
local function run_cloc(callback)
	local stdout = vim.uv.new_pipe()
	local cwd = project_root()
	local args = get_args()
	local handle = vim.uv.spawn(config.options.cmd, {
		args = { cwd, args },
		stdio = { nil, stdout, nil },
	})
	if handle == nil then
		vim.notify("Failed to spawn cloc", vim.log.levels.ERROR)
		return
	end

	vim.uv.read_start(stdout, function(err, data)
		assert(not err, err)
		if data then
			callback(data)
		else
			vim.uv.read_stop(stdout)
			vim.uv.close(stdout)
			vim.uv.close(handle)
		end
	end)
end

local function process_data(data)
	local lines = string.gmatch(data, "[^\n]+")
	local results = {}
	for line in lines do
		if string.sub(line, 1, 1) ~= "-" then
			line = string.gsub(line, "%s+", " ")
			local parts = vim.split(line, " ")
			local lang = parts[1]
			local files = tonumber(parts[2])
			local blank = tonumber(parts[3])
			local comment = tonumber(parts[4])
			local code = tonumber(parts[5])
			if lang ~= "Language" then
				table.insert(results, { lang = lang, files = files, blank = blank, comment = comment, code = code })
			end
		end
	end
	vim.notify(vim.inspect(results))
end

local function run()
	run_cloc(process_data)
end

function M.setup(opts)
	config.setup(opts)
	if config.options.autocmd then
		local group = vim.api.nvim_create_augroup("cloc", { clear = true })
		vim.api.nvim_create_autocmd(config.options.autocmd, {
			group = group,
			callback = run,
		})
	end
end

return M
