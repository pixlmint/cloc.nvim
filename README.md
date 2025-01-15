# 🕐 cloc.nvim

A Neovim plugin that counts how many lines of code a project contains and provides intuitive API. 


# ✨ Showcase
![showcase](showcase.gif)

# ⚡️ Requiremenets
- [neovim](https://neovim.io/)
- [gocloc](https://github.com/hhatto/gocloc)(recommended more) or [cloc](https://github.com/AlDanial/cloc)  or [tokei](https://github.com/XAMPPRocky/tokei)
# 📦 Installation
You can download it manually or using a package manager(recommended).

❗**Make sure you have installed any of cloc programs, [gocloc](https://github.com/hhatto/gocloc)(recommended) or [cloc](https://github.com/AlDanial/cloc) or [tokei](https://github.com/XAMPPRocky/tokei) **

## [Lazy.nvim](https://github.com/folke/lazy.nvim)
```lua 
---@class ClocProjectConfig
---@field pattern string
---@field include string[]

---@class ClocConfig
---@field program string
---@field projects ClocProjectConfig[]
---@field autocmds string[]

---@type ClocConfig
{
    "gcanoxl/cloc.nvim",
    opts = {
        program = "gocloc", -- `gocloc` or `tokei` or `cloc`
        -- order matters, the more specific should be first
        projects = {
            -- flutter project
            {
                pattern = "pubspec.yaml",
                include = { "lib" },
            },
            -- project managed by git
            {
                pattern = ".git",
                include = { "." },
            },
            -- project declared by .project file
            {
                pattern = ".project",
                include = { "." },
            },
        },
        autocmds = { "BufWritePost" }, -- or nil, nil indicates no autocmd will be set
    }
},
```
# 🚀 Usage

## Models

```lua 
---@class ClocStatus
---@field statusCode string<"loading", "ready", "error">
---@field data LangData[]

---@class LangData
---@field lang string
---@field files number
---@field blank number
---@field comment number
---@field code number
```

## Basic

```lua 
vim.api.nvim_create_autocmd("User", {
	pattern = "ClocStatusUpdated",
	---@param status ClocStatus
	callback = function(status)
		print(vim.inspect(status))
	end,
})
```

## Working with [heirline.nvim](https://github.com/rebelot/heirline.nvim)
```lua 
local Cloc = {
	update = { "User", pattern = "ClocStatusUpdated" },
	provider = function(_)
		---@type ClocStatus
		local status = cloc.get_status()
		if status.statusCode == "loading" then
			return "Clocing..."
		end
		if status.statusCode == "error" then
			return "Error"
		end
		return status.data[1].code
	end,
}
```
