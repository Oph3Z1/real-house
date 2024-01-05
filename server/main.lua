response = false
ScriptLoaded = false

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
    while not response do
        Citizen.Wait(0)
    end
end)