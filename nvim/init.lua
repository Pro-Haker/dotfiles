-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Opts
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.scrolloff = 8

-- Keybinds
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>gs", "<CMD>Git<CR>")
vim.keymap.set("n", "<leader>l", "<CMD>Lazy<CR>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Miscellaneous
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua" },
	command = "setlocal shiftwidth=2 tabstop=2",
})

-- Use undotree instead of the default
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"
vim.opt.undofile = true

-- Enable inlay hints
vim.lsp.inlay_hint.enable()

-- Briefly highlight yanked area
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "Hightlight selection on yank",
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 75 })
	end,
})

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},
		{
			"stevearc/conform.nvim",
			config = function()
				require("conform").setup({
					stop_after_first = true,
					notify_no_formatters = false,
					default_format_opts = {
						lsp_format = "fallback",
					},
					formatters_by_ft = {
						lua = { "stylua" },
					},
				})

				vim.keymap.set("n", "<leader>=", function()
					local did_format = require("conform").format({
						lsp_format = "fallback",
					})
					if did_format then
						return
					end

					local view = vim.fn.winsaveview()
					vim.cmd("normal! gg=G")
					vim.fn.winrestview(view)
				end, { desc = "Smart formatting using Conform" })
			end,
		},
		{
			"EdenEast/nightfox.nvim",
			config = function()
				vim.cmd("colorscheme carbonfox")
			end,
		},
		{ "tpope/vim-fugitive" },
		{ "lewis6991/gitsigns.nvim" },
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				vim.lsp.config["luals"] = {}
				vim.lsp.config["pyright"] = {}
				vim.lsp.config["rust_analyzer"] = {}

				vim.lsp.enable("luals")
				vim.lsp.enable("pyright")
				vim.lsp.enable("rust_analyzer")
			end,
		},
		{
			"stevearc/oil.nvim",
			config = function()
				require("oil").setup({
					view_options = {
						show_hidden = true,
					},
				})
				vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
			end,
		},
		{
			"benomahony/oil-git.nvim",
			dependencies = { "stevearc/oil.nvim" },
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		},
		{
			"kylechui/nvim-surround",
			version = "^3.0.0",
			event = "VeryLazy",
		},
		{
			"nvim-telescope/telescope.nvim",
			version = "*",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				config = function()
					require("telescope").setup()
					local builtin = require("telescope.builtin")
					vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
					vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
					vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
					vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
				end,
			},
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy",
			priority = 1000,
			config = function()
				require("tiny-inline-diagnostic").setup()
				vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
			end,
		},
		{
			"jiaoshijie/undotree",
			keys = { -- load the plugin only when using it's keybinding:
				{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
			},
		},
	},
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "carbonfox" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
