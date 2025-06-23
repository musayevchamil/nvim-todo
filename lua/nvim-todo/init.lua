local todo = require("nvim-todo.todo")

vim.api.nvim_create_user_command("TodoAdd", function()
	todo.add()
end, {})

vim.api.nvim_create_user_command("TodoList", function()
	todo.show()
end, {})

vim.api.nvim_create_user_command("TodoDelete", function()
	todo.delete()
end, {})

vim.api.nvim_create_user_command("TodoToggle", function()
  todo.toggle()
end, {})

vim.api.nvim_create_user_command("TodoTelescope", function()
  todo.telescope()
end, {})

return todo
