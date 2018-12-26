local scripts = {}

scripts.execute = function (...)
	local arg = {...}
    Name = arg[1]
	if Name == "snippet" then
		snippet(arg[2])
	elseif Name == "" then
	
    else
        print "Function " ..Name.. " not found."
	end
end

function snippet(Type)
	if Type == "uelog" then
	    print "works"
	end
end

return scripts
