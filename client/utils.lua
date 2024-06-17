function TriggerCallback(...)
    if Config.Framework == "qb" then
        Framework.Functions.TriggerCallback(...)
    elseif Config.Framework == "esx" then
        Framework.TriggerServerCallback(...)
    else
        print("CODEV: Framework not found.")
    end
end