local remap_funcs = require("setup.remap_functions")
local set_print_snippet = remap_funcs.set_print_snippet

-- print snippets in multiple languages
set_print_snippet({ is_visual = true, is_json = false, format = 'vim.print("${copy}: " .. ${copy})' })
set_print_snippet({ is_visual = false, is_json = false, format = 'vim.print("${copy}: " .. ${copy})' })
set_print_snippet({ is_visual = true, is_json = true, format = 'vim.print("${copy}: " .. dump(${copy}))' })
set_print_snippet({ is_visual = false, is_json = true, format = 'vim.print("${copy}: " .. dump(${copy}))' })

local snippet_group = vim.api.nvim_create_augroup("augroup", {})
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufEnter", {
	group = snippet_group,
	pattern = "*.cs",
	callback = function(ev)
		set_print_snippet({
			is_visual = true,
			is_json = false,
			format = 'Console.WriteLine("${copy}: " +  ${copy});',
			buffer = ev.buf,
		})
		set_print_snippet({
			is_visual = false,
			is_json = false,
			format = 'Console.WriteLine("${copy}: " +  ${copy});',
			buffer = ev.buf,
		})
		set_print_snippet({
			is_visual = true,
			is_json = true,
			format = 'Console.WriteLine("${copy}: " +  JsonConvert.SerializeObject(${copy}));',
			buffer = ev.buf,
		})
		set_print_snippet({
			is_visual = false,
			is_json = true,
			format = 'Console.WriteLine("${copy}: " +  JsonConvert.SerializeObject(${copy}));',
			buffer = ev.buf,
		})
	end,
})

autocmd("BufEnter", {
	group = snippet_group,
	pattern = { "*.ts", "*.js", "*.mjs", "*.cjs", "*.vue" },
	callback = function(ev)
		set_print_snippet({
			is_visual = true,
			is_json = false,
			format = 'console.log("${copy}: " + ${copy})',
			buffer = ev.buf,
		})
		set_print_snippet({
			is_visual = false,
			is_json = false,
			format = 'console.log("${copy}: " + ${copy})',
			buffer = ev.buf,
		})
		set_print_snippet({
			is_visual = true,
			is_json = true,
			format = 'console.log("${copy}: " + JSON.stringify(${copy}))',
			buffer = ev.buf,
		})
		set_print_snippet({
			is_visual = false,
			is_json = true,
			format = 'console.log("${copy}: " + JSON.stringify(${copy}))',
			buffer = ev.buf,
		})
	end,
})

autocmd("BufEnter", {
	group = snippet_group,
	pattern = { "*.py" },
	callback = function(ev)
		set_print_snippet({
			is_visual = true,
			is_json = false,
			format = 'print("${copy}: " + ${copy})',
			buffer = ev.buf,
		})
		set_print_snippet({
			is_visual = false,
			is_json = false,
			format = 'print("${copy}: " + ${copy})',
			buffer = ev.buf,
		})
		set_print_snippet({
			is_visual = true,
			is_json = true,
			format = 'print("${copy}: " + json.dumps(${copy}))',
			buffer = ev.buf,
		})
		set_print_snippet({
			is_visual = false,
			is_json = true,
			format = 'print("${copy}: " + json.dumps(${copy}))',
			buffer = ev.buf,
		})
	end,
})
