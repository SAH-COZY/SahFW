function _DisableControls()
    for k,v in pairs(Config.ControlsToDisable) do
        DisableControlAction(0, v, true)
    end
end