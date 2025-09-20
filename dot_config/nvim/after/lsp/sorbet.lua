local notification = require("fidget.notification")

local function show_operation(err, params)
	if err then
		return
	end

	local operation = params["operationName"]
	local description = params["description"]
	local status = params["status"]
	local done = status == "end"

	local opts = {
		key = operation,
		group = "sorbet",
		annote = "Sorbet",
		ttl = done and 0 or math.huge,
	}

	if done then
		description = description .. " ✅"
	end

	notification.notify(description, vim.log.levels.INFO, opts)
end

local function get_sorbet_file(uri, client)
	return client.request_sync("sorbet/readFile", {
		uri = uri,
	})
end

--- @type vim.lsp.Config
return {
	root_markers = { "Gemfile" },
	init_options = {
		-- 	highlightUntyped = true,
		supportsOperationNotifications = true,
		supportsSorbetURIs = true,
	},
	cmd = { "srb", "tc", "--lsp", "-vvv" },
	root_dir = function(bufnr, on_dir)
		local sorbet_dir = vim.fs.find(
			{ "sorbet" },
			{ path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)), upward = true, type = "directory" }
		)[1]
		local gemfile = vim.fs.find(
			{ "Gemfile" },
			{ path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)), upward = true, type = "file" }
		)[1]
		if sorbet_dir and gemfile then
			-- there is a sorbet dir and a gemfile
			on_dir(vim.fs.dirname(sorbet_dir[1]))
		end
	end,
	handlers = {
		["sorbet/showOperation"] = show_operation,
	},
	before_init = function()
		-- provides a way to read sorbet: files which are returned by sortbet for
		-- builtin or library files
		vim.api.nvim_create_autocmd({ "BufReadCmd", "FileReadCmd" }, {
			pattern = { "*/sorbet:*" },
			callback = function(ev)
				local file = ev.file
				local bufnr = ev.buf
				vim.api.nvim_set_option_value("ft", "ruby", { buf = bufnr })
				local client = vim.lsp.get_clients({ name = "sorbet" })[1]

				local res = get_sorbet_file(file, client)["result"]
				local lines = vim.split(res.text, "\n")

				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
				vim.api.nvim_set_option_value("ft", res.languageId, { buf = bufnr })
				vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
				vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
				vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
				vim.lsp.buf_attach_client(bufnr, client.id)
			end,
		})
	end,
}
