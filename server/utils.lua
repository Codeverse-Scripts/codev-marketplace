function RegisterServerCallback(...)
    if Config.Framework == "qb" then
        Framework.Functions.CreateCallback(...)
    elseif Config.Framework == "esx" then
        Framework.RegisterServerCallback(...)
    else
        print("CODEV: Framework not found.")
    end
end

function _GetPlayerIdentifier(player)
	for i = 0, GetNumPlayerIdentifiers(player) - 1 do
		local license = GetPlayerIdentifier(player, i)

		if string.sub(license, 1, string.len("license:")) == "license:" then
			return license
		end
	end

    return false
end

function IsItemFound(items, sitem)
    for _, item in pairs(items) do
        if item.name == sitem then
            return true
        end
    end

    return false
end

function DoesIdentifierExists(identifier, file)
    for _, player in pairs(file) do
        if player.identifier == identifier then
            return true
        end
    end

    return false
end