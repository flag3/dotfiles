vim.loader.enable()

User = require("user.utils")

require("user.config.options")
require("user.config.keymaps")
require("user.config.autocmds")
require("user.config.commands")
require("user.config.workarounds")

require("user.plugins")
