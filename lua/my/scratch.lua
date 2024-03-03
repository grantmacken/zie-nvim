local rocks_config = {
	rocks_path = vim.fs.joinpath(vim.fn.stdpath('data'),'rocks'),
	luarocks_binary = vim.fn.system({'which', 'luarocks'}),
}

vim.g.rocks_nvim = rocks_config

--vim.print(vim.g.rocks_nvim)

local luarocks_path = {
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
}


vim.print(luarocks_path)

local rPath = vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1")   
print(vim.fn.system({'ls', rPath}))

