return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
	config = function()
		local telescope = require("telescope")
		telescope.setup()
		telescope.load_extension("fzf")

		local builtin = require("telescope.builtin")

		local find_files = function()
			vim.fn.system("git rev-parse --is-inside-work-tree")
			if vim.v.shell_error == 0 then
				builtin.git_files({ show_untracked = true, cwd = vim.fn.getcwd() })
			else
				builtin.find_files({})
			end
		end

		local find_hidden = function()
			builtin.find_files({
				find_command = { "rg", "--files", "--no-ignore", "--hidden", "--glob", "!**/.git/*" },
			})
		end

		local find_string = function()
			-- local input = vim.fn.input("Search > ")

			builtin.live_grep({ debounce = 1000 })
		end

		vim.keymap.set("n", "<leader>fa", builtin.resume, { desc = "resume last picker" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "show buffers" })
		vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "show all commands" })
		vim.keymap.set("n", "<leader>ff", find_files, { desc = "find files" })
		-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "rg" })
		vim.keymap.set("n", "<leader>fg", find_string, { desc = "rg" })
		vim.keymap.set("n", "<leader>fh", find_hidden, { desc = "find hidden files" })
		vim.keymap.set("n", "<leader>fm", function()
			builtin.man_pages({ sections = { "ALL" } })
		end, { desc = "Open the manual" })
		vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "rg for string under cursor" })
	end,
	keys = {
		"<leader>f",
	},
}
