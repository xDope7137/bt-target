![Image of Target](https://i.imgur.com/0kTErhu.jpeg)

## What is difference in XDope's version and Original Repo

- Edited CSS.
- Argument Support for Events.
- Remove Zone Support (Thanks to https://github.com/OfficialNoms/bt-target)
- Fixed Duplicate zones when restarting script.
- AddTargetEntity support

Example: 

```lua
-- This example is taken from Qbus Stores.
Citizen.CreateThread(function()
    Citizen.Wait(2000)
    for shop, _ in pairs(Config.Locations) do
        local position = Config.Locations[shop]["coords"] -- Main table for coords
        for _, loc in pairs(position) do
            exports["bt-target"]:AddBoxZone("Shops"..shop, vector3(loc["x"], loc["y"], loc["z"]), 4.0, 4.0, { --Box zone because we are lazy
                name="Shops"..shop, -- Random name for each unique shop
                heading = 340.2,
                debugPoly= false, -- Make this true if you want to see all zones
                minZ = loc["z"] - 1.5 , 
                maxZ = loc["z"] + 1.5
            }, {
                options = {
                    {
                        event = "xd_shops:client:UpdateShopX", -- The event that needs to be triggered
                        argument = shop, --This will add argument for the event. In this example it will "TriggerEvent("xd_shops:client:UpdateShopX", shop)". I am passing shop arg to identify the shop name in my event.
                        icon = "fas fa-shopping-cart",
                        label = "Shop",
                    },
                },
                job = {"all"},
                distance = 2.0
            })
        end
    end
end)
```

Dependencies: https://github.com/mkafrin/PolyZone
Original : https://github.com/brentN5/bt-target
Extra Functions taken from : https://github.com/OfficialNoms/bt-target