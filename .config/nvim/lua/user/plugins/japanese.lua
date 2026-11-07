vim.fn["skkeleton#config"]({
	globalDictionaries = {
		"~/Library/Application Support/AquaSKK/skk-jisyo.utf8",
		"~/Library/Application Support/AquaSKK/SKK-JISYO.L",
		"~/dotfiles/SKK-JISYO.latex.utf8",
	},
	showCandidatesCount = 1,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		vim.fn["skkeleton#register_kanatable"]("rom", {
			[","] = { "，", "" },
			["."] = { "．", "" },
		})
	end,
})

local INDICATOR_BG = {
	Eiji = "#9b9b9b",
	Hira = "#ff7d00",
	Kata = "#78a741",
	Hankata = "#ab7fd5",
	Zenkaku = "#ffd401",
	Abbrev = "#9b9b9b",
}
for mode, bg in pairs(INDICATOR_BG) do
	vim.api.nvim_set_hl(0, "SkkeletonIndicator" .. mode, { fg = "#ffffff", bg = bg, bold = true })
end

require("skkeleton_indicator").setup({
	eijiText = " ＠ ",
	hiraText = " あ ",
	kataText = " ア ",
	hankataText = " ｶﾅ ",
	zenkakuText = " 英 ",
	abbrevText = " ＠ ",
})
