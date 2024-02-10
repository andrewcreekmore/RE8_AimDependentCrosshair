--==============================
-- RE8 Aim-Dependent Crosshair 

-- Author: Andrew Creekmore
-- Version: 1.2 
-- Description: prevents the crosshair reticle from being drawn unless the player is aiming a weapon
-- Special thanks to: praydog
--==============================

log.info("[RE8_AimDependentCrosshair] loaded")

local propsManager = sdk.get_managed_singleton(sdk.game_namespace("PropsManager"))

local function isPlayerAiming()

    if propsManager then 
        player = propsManager:call("get_Player")
        if player then
            playerUpdaterComponent = player:call("getComponent(System.Type)", sdk.typeof("app.PlayerUpdaterBase"))
            if playerUpdaterComponent then
                playerGun = playerUpdaterComponent:call("get_playerGun")
            end
        end    
    end

    if playerGun then
        return playerGun:call("get_isAimStart") or playerGun:call("get_isAimIdle") or playerGun:call("get_isAimIdleSp") or playerGun:call("get_isAimMove") or playerGun:call("get_isAimAttack")
    end 

    return nil
end

local function isRoseAimingPowers()

    if propsManager then 
        player = propsManager:call("get_Player")
        if player then
            playerUpdaterComponent = player:call("getComponent(System.Type)", sdk.typeof("app.PlayerUpdaterBase"))
            if playerUpdaterComponent then
                playerStatus = playerUpdaterComponent:call("get_playerstatus")
            end
        end
    end

    if playerStatus then
        return playerStatus:call("get_isESPAim") or playerStatus:call("get_isESPFreezeAim")
    end 
    
    return nil
end

re.on_pre_gui_draw_element(function(element, context)

    local game_object = element:call("get_GameObject")
    if game_object == nil then return true end

    local name = game_object:call("get_Name")

    if string.find(name, "Reticle") then

        if not isPlayerAiming() then
            if not isRoseAimingPowers() then
                return false
            end
        end
    end

    return true
end)


-- script-generated UI (debug)
--========================
-- re.on_draw_ui(function()
--     imgui.text("isPlayerAiming: " .. tostring(isPlayerAiming()))
--     imgui.text("isRoseAimingPowers: " .. tostring(isRoseAimingPowers()))
-- end)