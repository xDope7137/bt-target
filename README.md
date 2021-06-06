## What is difference in XDope's version and Original Repo

I have edited some CSS and html to suit my framework.

I will be adding arguments support in Trigger events in near future.

Download at your own risk. Might break your scripts.

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
                        fuck = shop, --This will add argument for the event. In this example it will "TriggerEvent("xd_shops:client:UpdateShopX", shop)". I am passing shop arg to identify the shop name in my event.
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

Icons: https://fontawesome.com/

Here a simple target tracking script that tracks where your player is looking at. Coords and models can be used. You can add multiple payphone models for example and when your player looks at it. It activates the UI to trigger an event. Polyzones can be used also. Its uses 0.00 ms (0.16% CPU Time) when idle. This can be used in multiple scripts to help with optimisation. Press ALT to activate. Using RegisterKeyMapping removes the need of checking if key has been pressed in a thread and players can customise the keybind in the ESCAPE menu. You can also create multiple options per target. Read the example to learn how to use it.

Original : https://github.com/brentN5/bt-target