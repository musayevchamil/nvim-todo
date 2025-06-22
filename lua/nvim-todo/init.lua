local todo = require("nvim-todo.todo")

vim.api.nvim_create_user_command("TodoAdd", function()
	todo.add()
end, {})

vim.api.nvim_create_user_command("TodoList", function()
	todo.show()
end, {})

