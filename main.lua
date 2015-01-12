local _x = 5;
local _y = -100;

function makeFrame(x, y)
    local f = CreateFrame("Frame", nil, AIFrame)
    f:SetFrameStrata("BACKGROUND")
    f:SetWidth(5) 
    f:SetHeight(5) 
    f:SetPoint("TOPLEFT", _x+x , _y+y)
    f.texture = f:CreateTexture(nil,"ARTWORK")
    f.texture:SetAllPoints(f)
    f:Show()
    return f
end

local frames = {}
local numOfPlayers = makeFrame(10, -15)
local insID = makeFrame(20, -15)

for i=1,40 do
    frames[i] = {}
    for j=1,2 do
        frames[i][j] = makeFrame(10+j*5, -20-i*5)
    end
end

function HelloWorld()
    print("Hello, dzharvis!");
    print((StringHash("Альтеракская долина")));
end

function UpdateSemaphors()
    showPlayerPosition();
    showRaidPosition();
    updateGameStatus();
    updateBGStatus();
    updatePlayerStatus();
end

function showRaidPosition()
    local num = GetNumRaidMembers()
    if (num == 0) then
        for i=1,40 do
            frames[i][1]:Hide()
            frames[i][2]:Hide()
            numOfPlayers:Hide()
        end
    else
        for i=1,num do
            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
            local x, y = GetPlayerMapPosition(name);
            local x3,x2,x1 = serializeFloat(x)
            local y3,y2,y1 = serializeFloat(y)
            frames[i][1].texture:SetTexture(x3, x2, x1);
            frames[i][2].texture:SetTexture(y3, y2, y1);
            frames[i][1]:Show()
            frames[i][2]:Show()
        end
        numOfPlayers.texture:SetTexture(num/100, 0, 0);
        numOfPlayers:Show()
    end
end

function serializeFloat(v)
    local k = math.floor(v * 16581375);
    return serializeInt(k);
end

function serializeInt( m )
    local x1 = bit.band(m, 255)/255;
    local x2 = bit.rshift(bit.band(m, 65280),8)/255;
    local x3 = bit.rshift(bit.band(m, 16711680),16)/255;
    return x3,x2,x1;
end

function showPlayerPosition()
    local facing = GetPlayerFacing();
    -- local pitch = GetUnitPitch("player");
    local x, y = GetPlayerMapPosition("player");
    local x3,x2,x1 = serializeFloat(x);
    local y3,y2,y1 = serializeFloat(y);
    local f3,f2,f1 = serializeFloat(facing/7);
    PlayerPosX:SetTexture(x3, x2, x1);
    PlayerPosY:SetTexture(y3, y2, y1);
    PlayerFT:SetTexture(f3, f2, f1);

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

function StringHash(text)
  local counter = 1
  local len = string.len(text)
  for i = 1, len, 3 do 
    counter = math.fmod(counter*8161, 4294967279) +  -- 2^32 - 17: Prime!
      (string.byte(text,i)*16776193) +
      ((string.byte(text,i+1) or (len-i+256))*8372226) +
      ((string.byte(text,i+2) or (len-i+256))*3932164)
  end
  return math.fmod(counter, 16777215) -- 2^32 - 5: Prime (and different from the prime in the loop)
end

function updateBGStatus()
--    BGT:SetTexture(0, 0, 0);
    local status, mapName, instanceID, minlevel, maxlevel, teamSize = GetBattlefieldStatus(1);
    --nil - queued - confirm
    if (status == nil or status == "none") then
        BGT:SetTexture(0, 0, 0);
    else 
        local id3, id2, id1 = serializeInt(StringHash(mapName));
        insID.texture:SetTexture(id3, id2, id1);
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