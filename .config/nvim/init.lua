if vim.loader then
	vim.loader.enable()
end

-- _G.dd = function(...)
--     require("util.debug").dump(...)
-- end
-- vim.print = _G.dd

_G.User = require("user.utils")
require("user.config.options")
require("user.config.keymaps")
require("user.config.autocmds")
require("user.config.commands")
require("user.config.workarounds")
require("user.plugins")
