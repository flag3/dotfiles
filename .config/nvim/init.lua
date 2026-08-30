if vim.loader then
	vim.loader.enable()
end

-- _G.dd = function(...)
--     require("util.debug").dump(...)
-- end
-- vim.print = _G.dd

_G.Dotfiles = require("utils")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("plugins")
