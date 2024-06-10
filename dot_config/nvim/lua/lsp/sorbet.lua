local nvim_lsp = require("lspconfig")
local notification = require("fidget.notification")

local M = {}

local function create_virtual_text_document(uri, res, client)
	if not res then
		return nil
	end

	local result = res["result"]

	local lines = vim.split(result.text, "\n")
	local bufnr = vim.uri_to_bufnr(uri)

	local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	if #current_buf ~= 0 then
		return nil
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.api.nvim_set_option_value("ft", result.languageId, { buf = bufnr })
	vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
	vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
	vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
	vim.lsp.buf_attach_client(bufnr, client.id)

	return bufnr
end

local function get_sorbet_file(uri, client)
	return client.request_sync("sorbet/readFile", {
		uri = uri,
	})
end

local function setup_auto_commands()
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
end

local function get_virtual_text_document(uri, client)
	local res = get_sorbet_file(uri, client)
	create_virtual_text_document(uri, res, client)
end

local function synthetic_file_hander(err, result, ctx)
	if not result or vim.tbl_isempty(result) then
		return nil
	end

	local client = vim.lsp.get_client_by_id(ctx.client_id)
	for _, res in pairs(result) do
		local uri = res.uri
		if uri:match("^sorbet:") then
			get_virtual_text_document(uri, client)
			res["uri"] = uri
		end
	end

	vim.lsp.handlers[ctx.method](err, result, ctx)
end

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

-- trouble can't handle sorbet: file types
local function override_trouble()
	local trouble = require("trouble.util")

	local og_process = trouble.process_item

	local function notify(status)
		show_operation(nil, { operationName = "FileOpen", description = "Loading remote file...", status = status })
	end

	trouble.process_item = function(item, bufnr)
		if item.uri and item.uri:match("^sorbet:") then
			notify("start")
			local results = vim.lsp.buf_request_sync(0, "sorbet/readFile", { uri = item.uri })
			for client_id, result in ipairs(results) do
				if result.result then
					local client = vim.lsp.get_client_by_id(client_id)
					local virt_bufnr = create_virtual_text_document(item.uri, result, client)
					local range = item.range or item.targetSelectionRange
					local row = range and vim.tbl_get(range, "start", "line") or item.lnum
					local lines = vim.api.nvim_buf_get_lines(virt_bufnr, row, row + 1, false)
					item.message = lines[1] or ""
					break
				end
			end

			notify("end")

			return og_process(item, bufnr)
		else
			return og_process(item, bufnr)
		end
	end
end

function M.setup(on_attach, capabilities)
  setup_auto_commands()

	nvim_lsp.sorbet.setup({
		cmd = { "srb", "tc", "--lsp" },
		root_dir = nvim_lsp.util.root_pattern("sorbet", "Gemfile"),
		on_attach = on_attach,
		capabilities = capabilities,
		init_options = {
			-- 	highlightUntyped = true,
			supportsOperationNotifications = true,
			supportsSorbetURIs = true,
		},
		handlers = {
			["sorbet/showOperation"] = show_operation,

			["textDocument/definition"] = synthetic_file_hander,
			["textDocument/typeDefinition"] = synthetic_file_hander,
			["textDocument/references"] = synthetic_file_hander,
		},
	})

	-- override_trouble()
end

return M
