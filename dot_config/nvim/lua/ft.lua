local ft = require("vim.filetype")

ft.add({
	filename = {
		Fastfile = "ruby",
		Pluginfile = "ruby",
		Matchfile = "ruby",
		Appfile = "ruby",
		Podfile = "ruby",
	},
	extension = {
		rbi = "ruby",
	},
})

