MongoDB = {}
setmetatable(MongoDB, {})

function MongoDB:PrintError(error)
    print("^1############ [MONGODB ERROR] ############^7")
    print("## "..error.." ##")
    print("^1############ ############### ############^7")
end