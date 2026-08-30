if vim.loader then
	vim.loader.enable()
end

-- _G.dd = function(...)
--     require("util.debug").dump(...)
-- end
-- vim.print = _G.dd

_G.Dotfiles = require("dotfiles.utils")
require("dotfiles.config.options")
require("dotfiles.config.keymaps")
require("dotfiles.config.autocmds")
require("dotfiles.config.commands")
require("dotfiles.plugins")
