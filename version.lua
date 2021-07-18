-- version check
Citizen.CreateThread( function()
    SetConvarServerInfo("bt-target", "Version"..Config.versionCheck)
    local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
    if vRaw and Config.versionCheck then
        local v = json.decode(vRaw)
        PerformHttpRequest(
            'https://raw.githubusercontent.com/xDope7137/bt-target/master/version.json',
            function(code, res, headers)
                if code == 200 then
                    local rv = json.decode(res)
                    if rv.version ~= v.version then
                        print(
                            ([[^1
-------------------------------------------------------
bt-target (https://github.com/xDope7137/bt-target)
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------
^0]]):format(
                                rv.version,
                                rv.changelog
                            )
                        )
                    end
                else
                    print('bt-target unable to check version')
                end
            end,
            'GET'
        )
    end
end
)