function _DisableControls()
    for k,v in pairs(SharedTables.ControlsToDisable) do
        DisableControlAction(0, v, true)
    end
end