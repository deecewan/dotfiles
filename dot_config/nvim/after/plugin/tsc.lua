local augroup = vim.api.nvim_create_augroup("tsc", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "typescript,typescriptreact",
	group = augroup,
	callback = function()
		vim.cmd("compiler tsc")
		vim.opt.makeprg = "./node_modules/.bin/tsc --pretty false"
	end,
})
