local M = {}

local function get_todo_file()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if git_root and git_root ~= "" and vim.fn.isdirectory(git_root) == 1 then
		return git_root .. "/.nvim_todo"
	else
		return vim.fn.stdpath("data") .. "/todos.txt"
	end
end

local todo_file = get_todo_file()

function M.add()
	vim.ui.input({ prompt = "New TODO: " }, function(input)
		if input and #input > 0 then
			local f = io.open(todo_file, "a")
			f:write("[ ] " .. input .. "\n")
			f:close()
			print("✅ TODO added!")
		end
		M.show()
	end)
end

function M.delete()
	local todos = {}
	local f = io.open(todo_file, "r")
	if f then
		for line in f:lines() do
			table.insert(todos, line)
		end
		f:close()
	end

	vim.ui.input({ prompt = "Delete which TODO (number)?" }, function(input)
		local index = tonumber(input)
		if index and todos[index] then
			table.remove(todos, index)
			local fw = io.open(todo_file, "w")
			for _, line in ipairs(todos) do
				fw:write(line .. "\n")
			end
			fw:close()
			print("🗑️ TODO deleted!")
		else
			print("❌ Invalid number")
		end
		M.show()
	end)
end

function M.toggle()
	local todos = {}
	local f = io.open(todo_file, "r")
	if f then
		for line in f:lines() do
			table.insert(todos, line)
		end
		f:close()
	end

	vim.ui.input({ prompt = "Toggle which TODO (number)?" }, function(input)
		local index = tonumber(input)
		if index and todos[index] then
			local line = todos[index]
			if line:match("^%[ %]") then
				todos[index] = line:gsub("^%[ %]", "[x]")
			elseif line:match("^%[x%]") then
				todos[index] = line:gsub("^%[x%]", "[ ]")
			else
				print("❌ Not a valid TODO format.")
				return
			end

			local fw = io.open(todo_file, "w")
			for _, l in ipairs(todos) do
				fw:write(l .. "\n")
			end
			fw:close()
			print("✅ TODO toggled!")
		else
			print("❌ Invalid number")
		end
		M.show()
	end)
end

function M.show()
	local lines = {}
	local f = io.open(todo_file, "r")
	if f then
		for line in f:lines() do
			table.insert(lines, line)
		end
		f:close()
	else
		table.insert(lines, "No TODOs yet!")
	end

	for i, line in ipairs(lines) do
		lines[i] = string.format("%d. %s", i, line)
	end

	if todo_buf and vim.api.nvim_buf_is_valid(todo_buf) and vim.api.nvim_win_is_valid(todo_win) then
		vim.api.nvim_buf_set_lines(todo_buf, 0, -1, false, lines)
		return
	end

	todo_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(todo_buf, 0, -1, false, lines)

	local width = math.floor(vim.o.columns * 0.5)
	local height = math.floor(vim.o.lines * 0.5)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	todo_win = vim.api.nvim_open_win(todo_buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	})
end

function M.telescope()
	local todo_file = get_todo_file()
	local todos = {}
	local f = io.open(todo_file, "r")
	if f then
		for line in f:lines() do
			table.insert(todos, line)
		end
		f:close()
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local function toggle_todo(selected)
		local index = nil
		for i, v in ipairs(todos) do
			if v == selected then
				index = i
				break
			end
		end

		if index then
			if todos[index]:match("^%[ %]") then
				todos[index] = todos[index]:gsub("^%[ %]", "[x]")
			elseif todos[index]:match("^%[x%]") then
				todos[index] = todos[index]:gsub("^%[x%]", "[ ]")
			end

			local fw = io.open(todo_file, "w")
			for _, l in ipairs(todos) do
				fw:write(l .. "\n")
			end
			fw:close()
			print("🔁 Toggled: " .. todos[index])
		end
	end

	pickers.new({}, {
		prompt_title = "TODOs",
		finder = finders.new_table {
			results = todos,
			entry_maker = function(item)
				return {
					value   = item,   -- the raw string
					display = item,   -- what you see
					ordinal = item,   -- for sorting
				}
			end,
		},
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, map)
			local function do_toggle()
				local sel = action_state.get_selected_entry()
				if not sel or type(sel.value) ~= "string" then
					print("❌ No valid TODO selected")
					return
				end

				toggle_todo(sel.value)
				actions.close(prompt_bufnr)
				-- reopen for fresh list
				vim.defer_fn(function()
					M.telescope()
				end, 100)
			end

			map("i", "<C-t>", do_toggle)
			map("n", "<C-t>", do_toggle)
			return true
		end,

	}):find()
end


return M

