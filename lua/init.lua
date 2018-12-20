local init = {}

init.config = {
	EnableUnrealEngineSnippets = false,
}

function EnableUnrealEngineSnippets()

end

init.snippet = function(SnippetType)
	print(vim.api.nvim_win_get_cursor())
end

return init

-- execute this way :lua require('init').main()