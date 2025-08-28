uti = {
    istable = function(item)
        return type(item)=="table"
    end,

    lprint = function(item, index)
        if uti.istable(item) then 
            for k, v in pairs(item) do 
                if istable(v) then 
                    print(string.rep("\t", index)..k)
                    uti.lprint(v, index + 1)
                else
                    print(string.rep("\t", index)..k, string.rep("\t", index)..v)
                end
            end
        else 
        print(string.rep("\t", index)..item)
        end
    end
}
