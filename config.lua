Config = {
    Framework = "qb", -- qb / esx

    Categories = {
        ["weapons"] = {
            name = "weapons",
            label = "Weapons",
            description = "Weapons for sale",
            image = "assets/img/items/weapon_pistol.png",

            Items = {
                ["weapon_pistol"] = {
                    name = "weapon_pistol",
                    label = "Pistol",
                    image = "assets/img/items/weapon_pistol.png",
                },
                ["weapon_appistol"] = {
                    name = "weapon_appistol",
                    label = "Ap Pistol",
                    image = "assets/img/items/weapon_appistol.png",
                },
                ["weapon_assaultrifle"] = {
                    name = "weapon_assaultrifle",
                    label = "Rifle",
                    image = "assets/img/items/weapon_assaultrifle.png",
                },
            }
        },
        ["technology"] = {
            name = "technology",
            label = "Technology",
            description = "Technology for sale",
            image = "assets/img/items/phone.png",

            Items = {
                ["phone"] = {
                    name = "phone",
                    label = "Phone",
                    image = "assets/img/items/phone.png",
                },
            }
        },
        ["food"] = {
            name = "food",
            label = "Food",
            description = "Food for sale",
            image = "assets/img/items/sandwich.png",

            Items = {
                ["sandwich"] = {
                    name = "sandwich",
                    label = "Sandwich",
                    image = "assets/img/items/sandwich.png",
                },
            }
        },
    },

    Notify = function(message, title, type, length)
        if Config.Framework == "qb" then
            Framework.Functions.Notify(message, "primary")
        elseif Config.Framework == "esx" then
            Framework.ShowNotification(message)
        end
    end,
}