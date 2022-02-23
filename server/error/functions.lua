Errors = {}
setmetatable(Errors, {})

function Errors:MissingArg(args, func_name)
    if args and func_name then
        if type(args) == "table" then
            print(string.format("^2[FRAMEWORK] arguments %s are missing in function %s ^7", table.unpack(args), func_name))
        elseif type(args) == "string" then
            print(string.format("^2[FRAMEWORK] argument %s is missing in function %s ^7", args, func_name))
        end
    end
end

function Errors:PlayerIdNotValid(ID, func_name)
    if ID and func_name then
        print(string.format("^2[FRAMEWORK] Player with ID %s doesn't exists (remember to check if the ID is a number) | function %s^7", ID, func_name))
    end
end

function Errors:PlayerIdNotValid(Identifier, func_name)
    if Identifier and func_name then
        print(string.format("^2[FRAMEWORK] Player with identifier %s doesn't exists | function %s^7", Identifier, func_name))
    end
end

function Errors:FailedPlayerSave(Ident_ID, func_name)
    if Ident_ID and func_name then
        print(string.format("^2[FRAMEWORK] Player with ID %s and identifier %s was not save | %s^7", Ident_ID[2], Ident_ID[1], func_name))
    end
end

function Errors:CampaignRegisterFailed(identifier_of_owner, func_name)
    print(string.format("^2[FRAMEWORK] Campaign of %s was not registerd. Kicking player... | %s^7", identifier_of_owner, func_name))
end