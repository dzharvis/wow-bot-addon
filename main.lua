function HelloWorld()
    print("Hello, dzharvis!");
end

function UpdateSemaphors()
    --    size();
    showPlayerPosition();
    updateGameStatus();
    updateBGStatus();
    updatePlayerStatus();
end

function getPlayerPosition()
    local x, y = GetPlayerMapPosition("player");
end

function showPlayerPosition()
    local facing = GetPlayerFacing();
    local pitch = GetUnitPitch("player");
    local x, y = GetPlayerMapPosition("player");
    local x1, x2 = math.modf(x*255)
    local y1, y2 = math.modf(y*255)
    PlayerPosY:SetTexture(x1/255, x2, facing/7);
    PlayerPosX:SetTexture(y1/255, y2, pitch/4+0.5)
end

function updatePlayerStatus()
    PlayerT:SetTexture(0, 0, 0);
    local name, realm = UnitName("player");
    local status = UnitIsDead(name)
    if (status == 1) then
        PlayerT:SetTexture(0, 0, 0);
    else
        PlayerT:SetTexture(1, 0, 0);
    end
end

function updateGameStatus()
    StatusT:SetTexture(1, 1, 1);
end

function updateBGStatus()
--    BGT:SetTexture(0, 0, 0);
    local status, mapName, instanceID, minlevel, maxlevel, teamSize = GetBattlefieldStatus(1);
    --nil - queued - confirm
    if (status == nil or status == "none") then
        BGT:SetTexture(0, 0, 0);
    end
    if (status == "queued") then
        BGT:SetTexture(1, 0, 0);
    end
    if (status == "confirm") then
        BGT:SetTexture(0, 1, 0);
    end
    if (status == "active") then
        BGT:SetTexture(0, 0, 1);
    end
end

function size()
    L:SetSize(1, 1);
end