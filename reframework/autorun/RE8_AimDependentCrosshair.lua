--==============================
-- RE8 Aim-Dependent Crosshair 

-- Author: Andrew Creekmore
-- Version: 1.3 
-- Description: prevents the crosshair reticle from being drawn unless configurable conditions are met
-- Special thanks to: praydog
--==============================

log.info("[RE8_AimDependentCrosshair] loaded")
local configFilePath = "RE8_AimDependentCrosshair_Configs/crosshairConfig.json"
local config = json.load_file(configFilePath)

function saveSettings(crosshairSettings)
    json.dump_file(configFilePath, crosshairSettings)
end

local crosshairSettings = {
    disableWhenSprinting = false,
    disableWhenNotAiming = true,
    disableWhenSprintingInCombat = true,
    disableWhenNotAimingInCombat = false,
}

if config then crosshairSettings = config end

local isSprinting = false
local isAiming = false
local isInCombat = false
local propsManager = sdk.get_managed_singleton(sdk.game_namespace("PropsManager"))

local function isPlayerAimingWeapon()

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

local function isPlayerAiming()
    return isPlayerAimingWeapon() or isRoseAimingPowers()
end

local function isPlayerSprinting()

    if propsManager then 
        player = propsManager:call("get_Player")
        if player then
            playerUpdaterComponent = player:call("getComponent(System.Type)", sdk.typeof("app.PlayerUpdaterBase"))
            if playerUpdaterComponent then
                playerStatus = playerUpdaterComponent:call("get_playerstatus")
                if playerStatus then
                    playerMovement = playerStatus:call("get_playerMovement")
                end
            end
        end
    end

    if playerMovement then
        return playerMovement:call("get_isSprint")
    end 

    return nil
end

local function isPlayerInCombat()
    
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
        return playerStatus:call("get_isBattle")
    end 
    
    return nil
end

re.on_frame(function()
	
    if propsManager then 
        player = propsManager:call("get_Player")
        if player then
            isInCombat = isPlayerInCombat()
        end
    end

end)

re.on_pre_gui_draw_element(function(element, context)

    local game_object = element:call("get_GameObject")
    if game_object == nil then return true end

    local name = game_object:call("get_Name")

    if string.find(name, "Reticle") then

        isSprinting = isPlayerSprinting()
        isAiming = isPlayerAiming()

        -- in combat
        if crosshairSettings.disableWhenSprintingInCombat and isInCombat and isSprinting then
                return false
        elseif crosshairSettings.disableWhenNotAimingInCombat and isInCombat and not isAiming then
                return false
        end

        -- out of combat
        if crosshairSettings.disableWhenSprinting and not isInCombat and isSprinting then
                return false
        elseif crosshairSettings.disableWhenNotAiming and not isInCombat and not isAiming then
                return false
        end

    end

    return true
end)


-- script-generated UI
--========================
re.on_draw_ui(function()

    -- debug
    --========================
    --imgui.text("isPlayerAiming: " .. tostring(isAiming))
    --imgui.text("isRoseAimingPowers: " .. tostring(isRoseAimingPowers()))
    --imgui.text("isSprinting: " .. tostring(isSprinting))
    --imgui.text("isPlayerInCombat: " .. tostring(isInCombat))

     --imgui.text("crosshairSettings.disableWhenSprinting :" .. tostring(crosshairSettings.disableWhenSprinting))
     --imgui.text("crosshairSettings.disableWhenNotAiming :" .. tostring(crosshairSettings.disableWhenNotAiming))
     --imgui.text("crosshairSettings.disableWhenSprintingInCombat :" .. tostring(crosshairSettings.disableWhenSprintingInCombat))
     --imgui.text("crosshairSettings.disableWhenNotAimingInCombat :" .. tostring(crosshairSettings.disableWhenNotAimingInCombat))

    -- mod user controls
    --========================
    local wasChanged = false

    local function setWasChanged()
        wasChanged = wasChanged or changed
        if wasChanged then
            saveSettings(crosshairSettings)
        end
    end

    imgui.begin_group()
    imgui.text("RE8 Aim-Dependent Crosshair")
    imgui.indent(20.0)

        imgui.text("Out of combat: ")
        imgui.indent(20.0)

            changed, crosshairSettings.disableWhenNotAiming = imgui.checkbox("Hide Whenever Not Aiming", crosshairSettings.disableWhenNotAiming); 
            if crosshairSettings.disableWhenNotAiming then 
                crosshairSettings.disableWhenSprinting = false 
            end
            setWasChanged()

            changed, crosshairSettings.disableWhenSprinting = imgui.checkbox("Hide Only When Sprinting", crosshairSettings.disableWhenSprinting);
            if crosshairSettings.disableWhenSprinting then 
                crosshairSettings.disableWhenNotAiming = false 
            end
            setWasChanged()

        imgui.unindent(20.0)
        imgui.text("In combat: ")
        imgui.indent(20.0)

            changed, crosshairSettings.disableWhenNotAimingInCombat = imgui.checkbox("Hide Whenever Not Aiming (COMBAT)", crosshairSettings.disableWhenNotAimingInCombat); 
            if crosshairSettings.disableWhenNotAimingInCombat then 
                crosshairSettings.disableWhenSprintingInCombat = false 
            end
            setWasChanged()

            changed, crosshairSettings.disableWhenSprintingInCombat = imgui.checkbox("Hide Only When Sprinting (COMBAT)", crosshairSettings.disableWhenSprintingInCombat); 
            if crosshairSettings.disableWhenSprintingInCombat then 
                crosshairSettings.disableWhenNotAimingInCombat = false 
            end
            setWasChanged()

    imgui.unindent(40.0)

    imgui.text("")  -- for spacing with other script-generated UI

    imgui.end_group()
end)