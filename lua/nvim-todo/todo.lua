local M = {}

local todo_file = vim.fn.stdpath("data") .. "/todos.txt"

function M.add()
	vim.ui.input({ prompt = "New TODO: " }, function(input)
		if input and #input > 0 then
			local f = io.open(todo_file, "a")
			f:write("[ ] " .. input .. "\\n")
			f:close()
			print("✅ TODO added!")
		end
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

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local width = math.floor(vim.o.columns * 0.5)
	local height = math.floor(vim.o.lines * 0.5)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	})
end

return M

