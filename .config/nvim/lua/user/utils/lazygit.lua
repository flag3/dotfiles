local M = {}

local origin_win, term

function M.open()
	origin_win = vim.api.nvim_get_current_win()
	term = Snacks.lazygit()
end

-- Called from lazygit's os.edit through `nvim --remote-send`: queue `q` so lazygit quits once
-- the edit command returns, and focus the launch window so `--remote` opens the file there.
function M.handoff()
	if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
		vim.api.nvim_chan_send(vim.bo[term.buf].channel, "q")
	end
	if origin_win and vim.api.nvim_win_is_valid(origin_win) then
		vim.api.nvim_set_current_win(origin_win)
	end
end

return M
