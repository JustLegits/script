-- Load the UI Library
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustLegits/WindUI/refs/heads/main/DrRay.lua"))()
local Window = DrRayLibrary:Load("Anime Spirits", "Default")

-- // TABS //
local MainTab = DrRayLibrary.newTab("Main", "Why not")

-- // AUTO FARM VARIABLES //
MainTab.newLabel("Auto Farm")

local SelectedEnemy = "Default"
local EnemyList = { "Default" }
local EnemyDropdown = nil

-- // FUNCTION: REFRESH ENEMIES //
local function RefreshEnemyList()
    local tempEnemyNames = {}
    local tempEnemyCounts = {}

    pcall(function()
        for _, npc in pairs(workspace["NPC\'s"]:GetChildren()) do
            if npc:FindFirstChild("Humanoid") then
                local npcName = npc.Name
                if tempEnemyCounts[npcName] then
                    tempEnemyCounts[npcName] = tempEnemyCounts[npcName] + 1
                else
                    tempEnemyCounts[npcName] = 1
                    table.insert(tempEnemyNames, npcName)
                end
            end
        end
    end)

    table.sort(tempEnemyNames)

    if #tempEnemyNames <= 0 then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Enemy List",
            Text = "No enemies found!",
            Duration = 2
        })
    else
        EnemyList = tempEnemyNames
        SelectedEnemy = EnemyList[1]
        
        -- Update the dropdown UI
        if EnemyDropdown and EnemyDropdown.Update then
            EnemyDropdown:Update(EnemyList)
        end

        -- Calculate total enemies
        local totalEnemies = 0
        for _, count in pairs(tempEnemyCounts) do
            totalEnemies = totalEnemies + count
        end

        game.StarterGui:SetCore("SendNotification", {
            Title = "Enemy List",
            Text = "Found " .. #EnemyList .. " unique enemies (" .. totalEnemies .. " total)",
            Duration = 3
        })

        -- Print debug info
        print("--- Enemy Counts ---")
        for name, count in pairs(tempEnemyCounts) do
            print(name .. ": " .. count)
        end
        print("-------------------")
    end
end

-- // INITIAL ENEMY SCAN //
pcall(function()
    local initialNames = {}
    local nameSet = {}
    for _, npc in pairs(workspace["NPC\'s"]:GetChildren()) do
        if npc:FindFirstChild("Humanoid") then
            local name = npc.Name
            if nameSet[name] then
                nameSet[name] = nameSet[name] + 1
            else
                nameSet[name] = 1
                table.insert(initialNames, name)
            end
        end
    end
    table.sort(initialNames)
    if #initialNames > 0 then
        EnemyList = initialNames
        SelectedEnemy = EnemyList[1]
    end
end)

-- // MAIN FARM UI ELEMENTS //
EnemyDropdown = MainTab.newDropdown("Select Enemy", "Choose", EnemyList, function(val)
    SelectedEnemy = val
end)

MainTab.newButton("Refresh Enemies List", "Updates the available enemies", function()
    RefreshEnemyList()
end)

-- // AUTO QUEST LOGIC //
local PlaceId = game.PlaceId
local QuestList = {}
local IsAutoQuestActive = false
local SelectedQuestGiver = "Quest Giver 1"

-- Determine quests based on Place ID (Map)
if PlaceId == 11756036029 then
    for i = 1, 42 do table.insert(QuestList, "Quest Giver " .. i) end
elseif PlaceId == 16041086429 then
    for i = 43, 66 do table.insert(QuestList, "Quest Giver " .. i) end
elseif PlaceId == 73417524077325 then
    for i = 67, 81 do table.insert(QuestList, "Quest Giver " .. i) end
end

MainTab.newDropdown("Select Quest", "Choose a quest", QuestList, function(val)
    SelectedQuestGiver = val
end)

MainTab.newButton("Start Auto Quest", "", function()
    IsAutoQuestActive = true
    spawn(function()
        while IsAutoQuestActive do
            local questArgs = { "InteractControl", SelectedQuestGiver }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer(unpack(questArgs))
            end)
            wait(0.2)
        end
    end)
end)

MainTab.newButton("Stop Auto Quest", "", function()
    IsAutoQuestActive = false
end)

-- // FARM SETTINGS //
local FarmPositionMode = "Behind"
local FarmDistanceVal = 3

MainTab.newDropdown("Farm Position", "Choose position relative to enemy", { "Behind", "Above", "Below" }, function(val)
    FarmPositionMode = val
end)

MainTab.newInput("Farm Distance", "Enter distance (1-20)", function(val)
    local num = tonumber(val)
    if num and (1 <= num and num <= 20) then
        FarmDistanceVal = num
        game.StarterGui:SetCore("SendNotification", {
            Title = "Farm Distance",
            Text = "Set to " .. tostring(FarmDistanceVal),
            Duration = 2
        })
    end
end)

-- // TELEPORT FARM LOGIC //
MainTab.newButton("Start Auto Farm (Teleport)", "Begins auto attacking selected enemy by teleporting", function()
    _G.AutoFarm = true
    spawn(function()
        while _G.AutoFarm do
            wait()
            pcall(function()
                for _, target in pairs(workspace["NPC\'s"]:GetChildren()) do
                    if target.Name == SelectedEnemy and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                        local Player = game.Players.LocalPlayer
                        if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("HumanoidRootPart") then
                            
                            -- Calculate CFrame based on position mode
                            local targetCFrame = nil
                            if FarmPositionMode == "Behind" then
                                targetCFrame = CFrame.new(0, 0, FarmDistanceVal)
                            elseif FarmPositionMode == "Above" then
                                targetCFrame = CFrame.new(0, FarmDistanceVal, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            elseif FarmPositionMode == "Below" then
                                targetCFrame = CFrame.new(0, -FarmDistanceVal, 0) * CFrame.Angles(math.rad(90), 0, 0)
                            end

                            -- Teleport Player
                            Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * targetCFrame
                            
                            -- Attack Args
                            local combatArgs = {
                                "CombatControl",
                                Player.Character:FindFirstChildOfClass("Tool") and (Player.Character:FindFirstChildOfClass("Tool").Name or "") or "",
                                1,
                                false
                            }
                            
                            -- Fire Attack
                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer(unpack(combatArgs))
                            end)
                            
                            -- Simulate Click
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        end
                    end
                end
            end)
        end
    end)
end)

-- // WALKING FARM LOGIC //
MainTab.newButton("Start Auto Farm (Walking)", "Walks to enemy and uses combat keys", function()
    _G.WalkFarm = true
    local SkillKeys = {
        { key = "E", delay = 0.3 },
        { key = "Z", delay = 0.5 },
        { key = "X", delay = 0.7 },
        { key = "C", delay = 1 },
        { key = "T", delay = 2 }
    }

    local function PressKey(key)
        local VUser = game:GetService("VirtualUser")
        VUser:CaptureController()
        VUser:TypeKey(key)
    end

    spawn(function()
        while _G.WalkFarm do
            pcall(function()
                local Player = game.Players.LocalPlayer
                if not (Player and Player.Character and Player.Character:FindFirstChild("Humanoid")) then
                    wait(0.2)
                    return
                end

                -- Find closest valid enemy
                local targetEnemy = nil
                for _, npc in pairs(workspace["NPC\'s"]:GetChildren()) do
                    if npc.Name == SelectedEnemy and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                        targetEnemy = npc
                        break
                    end
                end

                if targetEnemy and targetEnemy:FindFirstChild("HumanoidRootPart") then
                    local RootPart = Player.Character.HumanoidRootPart
                    local EnemyRoot = targetEnemy.HumanoidRootPart
                    
                    -- Check distance
                    if (RootPart.Position - EnemyRoot.Position).Magnitude <= FarmDistanceVal + 5 then
                        -- Close enough to attack
                        Player.Character.Humanoid:SetAttribute("WalkAnim", false)
                        Player.Character.Humanoid:MoveTo(Player.Character.HumanoidRootPart.Position) -- Stop moving
                        
                        -- Adjust orientation relative to enemy
                        if FarmPositionMode == "Below" then
                            local newPos = EnemyRoot.Position - Vector3.new(0, FarmDistanceVal, 0)
                            RootPart.CFrame = CFrame.new(newPos) * CFrame.Angles(math.rad(90), 0, 0)
                        elseif FarmPositionMode == "Above" then
                            local newPos = EnemyRoot.Position + Vector3.new(0, FarmDistanceVal, 0)
                            RootPart.CFrame = CFrame.new(newPos) * CFrame.Angles(math.rad(-90), 0, 0)
                        else -- Behind
                            local lookVec = EnemyRoot.CFrame.LookVector
                            local newPos = EnemyRoot.Position - lookVec * FarmDistanceVal
                            RootPart.CFrame = CFrame.lookAt(newPos, EnemyRoot.Position)
                        end

                        -- Execute Skills
                        for _, skill in ipairs(SkillKeys) do
                            PressKey(skill.key)
                            wait(skill.delay)
                            
                            local combatArgs = {
                                "CombatControl",
                                Player.Character:FindFirstChildOfClass("Tool") and (Player.Character:FindFirstChildOfClass("Tool").Name or "") or "",
                                1,
                                false
                            }
                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer(unpack(combatArgs))
                            end)
                            
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                            
                            if not _G.WalkFarm then break end
                        end
                    else
                        -- Walk to enemy
                        if FarmPositionMode == "Below" then
                            local targetPos = EnemyRoot.Position - Vector3.new(0, FarmDistanceVal, 0)
                            Player.Character.Humanoid:MoveTo(targetPos)
                        elseif FarmPositionMode == "Above" then
                            local targetPos = EnemyRoot.Position + Vector3.new(0, FarmDistanceVal, 0)
                            Player.Character.Humanoid:MoveTo(targetPos)
                        else -- Behind
                            local lookVec = EnemyRoot.CFrame.LookVector
                            local targetPos = EnemyRoot.Position - lookVec * FarmDistanceVal
                            Player.Character.Humanoid:SetAttribute("WalkAnim", true)
                            Player.Character.Humanoid:Move(lookVec * -1, false) -- Walk backward relative to enemy look
                            Player.Character.Humanoid:MoveTo(targetPos)
                        end

                        RootPart.CFrame = CFrame.lookAt(RootPart.Position, Vector3.new(EnemyRoot.Position.X, RootPart.Position.Y, EnemyRoot.Position.Z))
                        
                        -- Jump if obstructed (Raycast)
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = { Player.Character }
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        local direction = (EnemyRoot.Position - RootPart.Position).Unit * 5
                        
                        if workspace:Raycast(RootPart.Position, direction, rayParams) then
                            Player.Character.Humanoid.Jump = true
                        end
                    end
                else
                    wait(0.2)
                end
            end)
            wait(0.1)
        end
    end)
    game.StarterGui:SetCore("SendNotification", { Title = "Auto Farm", Text = "Walking auto farm started!", Duration = 2 })
end)

MainTab.newButton("Stop Auto Farm", "Stops all auto farming methods", function()
    _G.AutoFarm = false
    _G.WalkFarm = false
    local Player = game.Players.LocalPlayer
    if Player and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:SetAttribute("WalkAnim", false)
        Player.Character.Humanoid:MoveTo(Player.Character.HumanoidRootPart.Position)
    end
    game.StarterGui:SetCore("SendNotification", { Title = "Auto Farm", Text = "All auto farm methods stopped", Duration = 2 })
end)

-- // INSTANT KILL //
MainTab.newLabel("Instant Kill")
local InstantKillActive = false

MainTab.newButton("Toggle Instant Kill (<30% HP)", "Automatically kills mobs below 30% HP", function()
    InstantKillActive = not InstantKillActive
    if InstantKillActive then
        spawn(function()
            while InstantKillActive do
                for _, npc in pairs(workspace["NPC\'s"]:GetChildren()) do
                    if npc:FindFirstChild("Humanoid") then
                        local hum = npc.Humanoid
                        if hum.Health < hum.MaxHealth * 0.3 then
                            hum.Health = 0
                        end
                    end
                end
                wait(0.1)
            end
        end)
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Instant Kill", Text = "Enabled", Duration = 2 })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Instant Kill", Text = "Disabled", Duration = 2 })
    end
end)

-- // BOSS CHECKER //
MainTab.newButton("Check Special Boss", "Checks for special bosses", function()
    local BossNames = { "Momrraga", "Thukunaa", "Zenny", "ItadoruAwakened", "GalacticAntiSpiral" }
    local FoundBosses = {}
    
    for _, name in ipairs(BossNames) do
        if workspace["NPC\'s"]:FindFirstChild(name) then
            table.insert(FoundBosses, name)
        end
    end

    if workspace:FindFirstChild("SeaBeast") then
        local sb = workspace.SeaBeast
        if sb:FindFirstChild("HumanoidRootPart") then
            local sbPos = sb.HumanoidRootPart.Position
            local closestDist = math.huge
            local nearestIsland = "Unknown"
            
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") and obj:FindFirstChild("IslandCenter") then
                    local dist = (obj.IslandCenter.Position - sbPos).Magnitude
                    if dist < closestDist then
                        nearestIsland = obj.Name
                        closestDist = dist
                    end
                end
            end
            table.insert(FoundBosses, "SeaBeast near " .. nearestIsland)
        end
    end

    local notifyText = #FoundBosses > 0 and table.concat(FoundBosses, ", ") .. " found!" or "No special bosses found."
    game.StarterGui:SetCore("SendNotification", { Title = "Boss Check", Text = notifyText, Duration = 3 })
end)

MainTab.newButton("Teleport to SeaBeast", "Teleports to SeaBeast if present", function()
    if workspace:FindFirstChild("SeaBeast") and workspace.SeaBeast:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.SeaBeast.HumanoidRootPart.CFrame * CFrame.new(0, 10, 20))
        game.StarterGui:SetCore("SendNotification", { Title = "Teleport", Text = "Teleported to SeaBeast!", Duration = 2 })
    else
        game.StarterGui:SetCore("SendNotification", { Title = "Teleport", Text = "No SeaBeast found!", Duration = 2 })
    end
end)

MainTab.newButton("Teleport to Special Boss", "Teleports to first found special boss", function()
    local BossNames = { "Momrraga", "Thukunaa", "Zenny", "ItadoruAwakened", "GalacticAntiSpiral" }
    for _, name in ipairs(BossNames) do
        local boss = workspace["NPC\'s"]:FindFirstChild(name)
        if boss and boss:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(boss.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
            game.StarterGui:SetCore("SendNotification", { Title = "Boss Teleport", Text = "Teleported to " .. name, Duration = 2 })
            break
        end
    end
end)

-- // WEAPON MANAGEMENT //
local WeaponDropdownObject = nil
local WeaponList = {}
local SelectedWeapon = nil
local AutoEquipEnabled = false

local function RefreshWeaponList()
    WeaponList = {}
    local Player = game:GetService("Players").LocalPlayer
    if not Player.Backpack then return {} end
    
    WeaponList = {}
    -- Check Backpack
    for _, item in pairs(Player.Backpack:GetChildren()) do
        if item:IsA("Tool") then table.insert(WeaponList, item.Name) end
    end
    -- Check Character
    if Player.Character then
        for _, item in pairs(Player.Character:GetChildren()) do
            if item:IsA("Tool") then table.insert(WeaponList, item.Name) end
        end
    end
    
    table.sort(WeaponList)
    
    if WeaponDropdownObject then
        WeaponDropdownObject:Update(WeaponList)
        if #WeaponList <= 0 then
            SelectedWeapon = nil
        else
            SelectedWeapon = WeaponList[1]
        end
    end
    return WeaponList
end

RefreshWeaponList() -- Run once at start

WeaponDropdownObject = MainTab.newDropdown("Select Weapon", "Choose weapon to equip", WeaponList, function(val)
    SelectedWeapon = val
end)

-- Auto refresh listeners
local Player = game:GetService("Players").LocalPlayer
Player.Backpack.ChildAdded:Connect(RefreshWeaponList)
Player.Backpack.ChildRemoved:Connect(RefreshWeaponList)
if Player.Character then
    Player.Character.ChildAdded:Connect(RefreshWeaponList)
    Player.Character.ChildRemoved:Connect(RefreshWeaponList)
end
Player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(RefreshWeaponList)
    char.ChildRemoved:Connect(RefreshWeaponList)
    wait(1)
    RefreshWeaponList()
end)

MainTab.newInput("Weapon Name", "Enter weapon name to equip", function(val)
    if val and val ~= "" then
        SelectedWeapon = val
        local Plr = game.Players.LocalPlayer
        if Plr and Plr.Character then
            local tool = Plr.Backpack:FindFirstChild(val)
            if tool then
                tool.Parent = Plr.Character
                game.StarterGui:SetCore("SendNotification", { Title = "Weapon Equipped", Text = val .. " equipped successfully!", Duration = 2 })
            else
                game.StarterGui:SetCore("SendNotification", { Title = "Weapon Not Found", Text = val .. " not found in inventory", Duration = 2 })
            end
        end
    end
end)

MainTab.newButton("Refresh Weapons", "Force refresh weapon list", function()
    local list = RefreshWeaponList()
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Weapons", Text = "Found " .. #list .. " weapons!", Duration = 2 })
end)

MainTab.newButton("Toggle Auto Equip", "Auto equips selected weapon", function()
    AutoEquipEnabled = not AutoEquipEnabled
    if AutoEquipEnabled then
        spawn(function()
            while AutoEquipEnabled do
                if SelectedWeapon then
                    local Plr = game.Players.LocalPlayer
                    if Plr.Character and Plr.Character:FindFirstChild("Humanoid") then
                        local tool = Plr.Backpack:FindFirstChild(SelectedWeapon)
                        if tool then tool.Parent = Plr.Character end
                    else
                        repeat wait() until Plr.Character and Plr.Character:FindFirstChild("Humanoid")
                        wait(1)
                    end
                end
                wait(0.2)
            end
        end)
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Auto Equip", Text = "Auto equip enabled!", Duration = 2 })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Auto Equip", Text = "Auto equip disabled!", Duration = 2 })
    end
end)

-- // SPECS SECTION //
MainTab.newLabel("Specs")
local SelectedSpec = "Buso Haki V1"
local SpecList = {
    "Buso Haki V1", "Substitution Jutsu", "Crit Boost", "Gear5 Emperor Roc",
    "Buso Haki V2", "Conquerors Haki", "Nine Tails", "Cursed Blue",
    "Super Spirit Bomb", "Ultra Instinct", "Awakened Sakuno Domain",
    "Awakened Six Eyes", "Itadoru Domain", "Red Karma", "I AM ATOMIC!!",
    "God Naturo", "Zeno Universe Destroyer", "Omni Oguk", "Adult Gone",
    "Chrono Acceleration", "Camera Man", "Godspeed Killuo", "Death Note",
    "Soul Kings Might", "Imuu Destruction", "Kargogon", "Baran",
    "Jinvoo Dual Strike", "Gear 6", "Super Saiyan 100"
}

MainTab.newDropdown("Select Spec", "Choose", SpecList, function(val)
    SelectedSpec = val
end)

MainTab.newButton("Use Spec Once", "Triggers the selected spec one time", function()
    local Plr = game.Players.LocalPlayer
    local Root = Plr and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if Root then
        game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer("Specs", SelectedSpec, Root.Position)
    end
end)

MainTab.newButton("Start Loop Spec", "Repeatedly activates selected spec", function()
    _G.LoopSpec = true
    spawn(function()
        while _G.LoopSpec do
            local Plr = game.Players.LocalPlayer
            local Root = Plr and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            if Root then
                game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer("Specs", SelectedSpec, Root.Position)
            end
            wait(8)
        end
    end)
end)

MainTab.newButton("Stop Loop Spec", "Stops the repeated spec use", function()
    _G.LoopSpec = false
end)

MainTab.newButton("Redeem All Codes", "Redeems all unclaimed codes", function()
    local CodeFolder = game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Codes")
    for _, codeObj in pairs(CodeFolder:GetChildren()) do
        if codeObj:IsA("BoolValue") and not codeObj.Value then
            game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("Code"):FireServer(codeObj.Name)
            wait(0.2)
        end
    end
end)

-- // DUNGEON TAB //
local DungeonTab = DrRayLibrary.newTab("Dungeon", "Ez Gems")

-- Scan Dungeons
local DungeonNames = {}
local DungeonParts = {}
for _, folder in pairs(workspace:WaitForChild("DungeonTeleporters"):GetChildren()) do
    local zone = folder:FindFirstChild("TeleportingZone")
    if zone and zone:FindFirstChild("TeleportData") then
        local dName = zone.TeleportData.Value
        table.insert(DungeonNames, dName)
        DungeonParts[dName] = folder
    end
end

local SelectedDungeon = DungeonNames[1] or "None"

DungeonTab.newDropdown("Select Dungeon", "Choose", DungeonNames, function(val)
    SelectedDungeon = val
end)

DungeonTab.newButton("Teleport to Dungeon", "Teleports you to selected dungeon", function()
    local Char = game.Players.LocalPlayer.Character
    if Char and Char:FindFirstChild("HumanoidRootPart") then
        local dungeonObj = DungeonParts[SelectedDungeon]
        if dungeonObj and dungeonObj:FindFirstChild("TeleportingZone") then
            Char.HumanoidRootPart.CFrame = dungeonObj.TeleportingZone.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

-- Dungeon Auto Kill
DungeonTab.newLabel("Instant Wave/Boss Kill")
local AutoKillWaveActive = false
local AutoKillBossActive = false
local WaveKillTask = nil
local BossKillConnection = nil

local function IsInDungeon()
    local Plr = game.Players.LocalPlayer
    if Plr and Plr.Character then
        return (workspace:FindFirstChild("WaveEnemies") or workspace:FindFirstChild("Boss")) ~= nil
    else
        return false
    end
end

local function WaitForDungeon()
    while not IsInDungeon() do wait(1) end
    return true
end

DungeonTab.newButton("Activate Kill Wave Enemies", "Kills all wave enemies repeatedly", function()
    if not AutoKillWaveActive then
        AutoKillWaveActive = true
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Wave Kill", Text = "Wave enemy kill enabled!", Duration = 2 })
        
        WaveKillTask = task.spawn(function()
            while AutoKillWaveActive do
                if not IsInDungeon() then WaitForDungeon() end
                
                while AutoKillWaveActive do
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                    local WaveFolder = workspace:FindFirstChild("WaveEnemies")
                    if WaveFolder then
                        for _, enemy in pairs(WaveFolder:GetDescendants()) do
                            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
                                enemy.Humanoid.Health = 0
                            end
                        end
                    end
                    wait(0.5)
                end
            end
        end)
    end
end)

DungeonTab.newButton("Activate Kill Boss On Damage", "Kills boss if damaged", function()
    if not AutoKillBossActive then
        AutoKillBossActive = true
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Boss Kill", Text = "Boss instant kill enabled!", Duration = 2 })
        
        BossKillConnection = game:GetService("RunService").Heartbeat:Connect(function()
            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
            local BossObj = workspace:FindFirstChild("Boss")
            if BossObj then
                for _, child in pairs(BossObj:GetDescendants()) do
                    local hum = child:FindFirstChildWhichIsA("Humanoid")
                    if hum and (hum.Health > 0 and hum.Health < hum.MaxHealth) then
                        hum.Health = 0
                    end
                end
            end
        end)
    end
end)

DungeonTab.newButton("Disable All Killers", "Stops all auto kill functions", function()
    if AutoKillWaveActive then
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Wave Kill", Text = "Wave enemy kill disabled!", Duration = 2 })
    end
    if AutoKillBossActive then
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Boss Kill", Text = "Boss instant kill disabled!", Duration = 2 })
    end
    
    AutoKillWaveActive = false
    if WaveKillTask then task.cancel(WaveKillTask) WaveKillTask = nil end
    
    AutoKillBossActive = false
    if BossKillConnection then BossKillConnection:Disconnect() BossKillConnection = nil end
end)

-- // TELEPORT TAB //
local TeleportTab = DrRayLibrary.newTab("Teleport")
local SelectedSpawnPoint = nil
local SpawnList = {}

pcall(function()
    for _, spawnPoint in pairs(workspace:FindFirstChild("SpawnPoints"):GetChildren()) do
        if spawnPoint:IsA("BasePart") then
            table.insert(SpawnList, spawnPoint.Name)
        end
    end
end)

TeleportTab.newDropdown("Select Spawn", "Choose location", SpawnList, function(val)
    SelectedSpawnPoint = workspace.SpawnPoints:FindFirstChild(val)
end)

TeleportTab.newButton("Teleport to Selected Spawn", "Moves your character", function()
    local Plr = game.Players.LocalPlayer
    if SelectedSpawnPoint and Plr and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        Plr.Character.HumanoidRootPart.CFrame = SelectedSpawnPoint.CFrame + Vector3.new(0, 3, 0)
    end
end)

local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer

TeleportTab.newButton("Go to First Sea", "Teleport to First Sea", function()
    TeleportService:Teleport(11756036029, LocalPlayer)
end)

TeleportTab.newButton("Go to Second Sea", "Teleport to Second Sea", function()
    TeleportService:Teleport(16041086429, LocalPlayer)
end)

TeleportTab.newButton("Go to Space", "Teleport to Space", function()
    TeleportService:Teleport(73417524077325, LocalPlayer)
end)

-- // MISC TAB //
local MiscTab = DrRayLibrary.newTab("Misc", " ")
MiscTab.newLabel("Auto DF")
local AutoSellRarities = {}

MiscTab.newDropdown("Select Rarities to AutoSell", "Multi-select", { "Common", "Rare", "Epic", "Legendary" }, function(val)
    if table.find(AutoSellRarities, val) then
        for i, rarity in ipairs(AutoSellRarities) do
            if rarity == val then table.remove(AutoSellRarities, i) break end
        end
    else
        table.insert(AutoSellRarities, val)
    end
end)

local AutoSellEnabled = false
MiscTab.newButton("Start AutoSell", "", function()
    AutoSellEnabled = true
    spawn(function()
        while AutoSellEnabled do
            for _, rarity in ipairs(AutoSellRarities) do
                game:GetService("ReplicatedStorage"):WaitForChild("AutoDeleteRemote"):FireServer(unpack({ rarity, true }))
                task.wait(0.2)
            end
            task.wait(3)
        end
    end)
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "AutoSell", Text = "AutoSell started!", Duration = 2 })
end)

MiscTab.newButton("Stop AutoSell", "", function()
    AutoSellEnabled = false
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "AutoSell", Text = "AutoSell stopped.", Duration = 2 })
end)

-- Soul Buying
local SoulDeals = { "G$25k 1 Soul", "G$125k 5 Souls" }
local SelectedSoulDeal = SoulDeals[1]

MiscTab.newDropdown("Select Soul Deal", "Choose deal", SoulDeals, function(val)
    SelectedSoulDeal = val
end)

MiscTab.newButton("Buy Soul Once", "Buys selected soul deal once", function()
    local args = { "SoulsDealer", SelectedSoulDeal }
    game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer(unpack(args))
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Soul Purchase", Text = "Soul bought: " .. SelectedSoulDeal, Duration = 2 })
end)

local LoopSoulBuy = false
MiscTab.newButton("Start Loop Soul Buy", "Repeatedly buys selected soul deal", function()
    LoopSoulBuy = true
    spawn(function()
        while LoopSoulBuy do
            local args = { "SoulsDealer", SelectedSoulDeal }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer(unpack(args))
            end)
            wait(0.2)
        end
    end)
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Soul Loop", Text = "Loop Soul Buy started!", Duration = 2 })
end)

MiscTab.newButton("Stop Loop Soul Buy", "Stops auto soul purchase", function()
    LoopSoulBuy = false
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Soul Loop", Text = "Loop Soul Buy stopped.", Duration = 2 })
end)

-- Race Spinner
local RaceList = {
    "Skypian", "Mink", "Saiyan", "Uzumaki", "Otsutski", "D. Clan",
    "Sorcerer", "Demon Slime", "Ichigu Hybrid", "King Of Curses",
    "Gojo Clan", "Shadow Monarch"
}
local SelectedRace = RaceList[1]
local RaceSpinActive = false

MiscTab.newDropdown("Select Race", "Choose race to stop at", RaceList, function(val)
    SelectedRace = val
end)

MiscTab.newButton("Start Race Spin", "Auto spins until selected race", function()
    RaceSpinActive = true
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Race Spin", Text = "Started spinning for " .. SelectedRace, Duration = 2 })
    spawn(function()
        while RaceSpinActive do
            if game.Players.LocalPlayer.Data.Race.Value == SelectedRace then
                RaceSpinActive = false
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Race Spin Success!",
                    Text = "Got " .. SelectedRace .. "!\nSpins remaining: " .. game:GetService("Players").LocalPlayer.Data.RaceSpins.Value,
                    Duration = 3
                })
                break
            end
            game:GetService("ReplicatedStorage"):WaitForChild("RaceSpin"):FireServer()
            wait(0.1)
        end
    end)
end)

MiscTab.newButton("Stop Race Spin", "Stops auto spinning race", function()
    RaceSpinActive = false
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Race Spin",
        Text = "Stopped spinning. You have " .. game:GetService("Players").LocalPlayer.Data.RaceSpins.Value .. " spins left",
        Duration = 2
    })
end)

MiscTab.newButton("Buy Race Spin", "Purchase race spin with gems", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer("BuySpinsForGems", "Race")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Race Spins",
        Text = "You have " .. game:GetService("Players").LocalPlayer.Data.RaceSpins.Value .. " race spins!",
        Duration = 2
    })
end)

-- Perk Spinner
local PerkList = {
    "Run Faster", "Energy Builds Faster", "More Health", "Double Geppo Jump",
    "2x Chest Gold", "10% Luck Boost", "Nine Tails Power", "Conquerors Haki",
    "Ultra Instinct", "Prodigy"
}
local SelectedPerk = PerkList[1]
local PerkSpinActive = false

MiscTab.newDropdown("Select Perk", "Choose perk to stop at", PerkList, function(val)
    SelectedPerk = val
end)

MiscTab.newButton("Start Perk Spin", "Auto spins until selected perk", function()
    PerkSpinActive = true
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Perk Spin", Text = "Started spinning for " .. SelectedPerk, Duration = 2 })
    spawn(function()
        while PerkSpinActive do
            if game.Players.LocalPlayer.Data.Perk.Value == SelectedPerk then
                PerkSpinActive = false
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Perk Spin Success!",
                    Text = "Got " .. SelectedPerk .. "!\nSpins remaining: " .. game:GetService("Players").LocalPlayer.Data.PerkSpins.Value,
                    Duration = 3
                })
                break
            end
            game:GetService("ReplicatedStorage"):WaitForChild("PerkSpin"):FireServer()
            wait(0.1)
        end
    end)
end)

MiscTab.newButton("Stop Perk Spin", "Stops auto spinning perk", function()
    PerkSpinActive = false
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Perk Spin",
        Text = "Stopped spinning. You have " .. game:GetService("Players").LocalPlayer.Data.PerkSpins.Value .. " spins left",
        Duration = 2
    })
end)

MiscTab.newButton("Buy Perk Spin", "Purchase perk spin with gems", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer("BuySpinsForGems", "Perk")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Perk Spins",
        Text = "You have " .. game:GetService("Players").LocalPlayer.Data.PerkSpins.Value .. " perk spins!",
        Duration = 2
    })
end)

-- Shadow Army
MiscTab.newLabel("Shadow Army")
local ShadowArmySpawned = false
local ShadowArmyAttacking = false

MiscTab.newButton("Toggle Shadow Army", "Summon or dismiss shadow army", function()
    ShadowArmySpawned = not ShadowArmySpawned
    local args = { ShadowArmySpawned }
    game:GetService("ReplicatedStorage"):WaitForChild("CommandUnspawnUnits"):FireServer(unpack(args))
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Shadow Army",
        Text = ShadowArmySpawned and "Shadow Army summoned!" or "Shadow Army dismissed!",
        Duration = 2
    })

    if not ShadowArmySpawned and ShadowArmyAttacking then
        ShadowArmyAttacking = false
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Shadow Army", Text = "Shadow Army attack stopped!", Duration = 2 })
    end
end)

MiscTab.newButton("Toggle Shadow Attack", "Start or stop shadow army attack", function()
    if ShadowArmySpawned then
        ShadowArmyAttacking = not ShadowArmyAttacking
        if ShadowArmyAttacking then
            spawn(function()
                while ShadowArmyAttacking and ShadowArmySpawned do
                    local Plr = game.Players.LocalPlayer
                    if Plr and Plr.Character then
                        local hum = Plr.Character:FindFirstChild("Humanoid")
                        if not hum or hum.Health <= 0 then
                            repeat wait(0.1) until Plr.Character and Plr.Character:FindFirstChild("Humanoid") and Plr.Character.Humanoid.Health > 0
                            wait(1)
                            -- Respawn units if player died
                            for _ = 1, 3 do
                                pcall(function()
                                    game:GetService("ReplicatedStorage"):WaitForChild("CommandUnspawnUnits"):FireServer(true)
                                end)
                                wait(0.2)
                            end
                            wait(0.5)
                        end
                        if ShadowArmyAttacking and ShadowArmySpawned then
                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("CommandAttack"):FireServer(true)
                            end)
                        end
                    end
                    wait(0.5)
                end
            end)
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Shadow Army", Text = "Shadow Army attacking!", Duration = 2 })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Shadow Army", Text = "Shadow Army attack stopped!", Duration = 2 })
        end
    else
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Shadow Army", Text = "Summon Shadow Army first!", Duration = 2 })
    end
end)

-- Arise Farm
MiscTab.newLabel("Arise Farm")
local BossEffectTeleport = false

MiscTab.newButton("Toggle Boss Effects Teleport", "Loop teleport to boss effects", function()
    BossEffectTeleport = not BossEffectTeleport
    if BossEffectTeleport then
        spawn(function()
            local BossEffectsList = {
                "Bandit Boss", "Pirate Captain", "King Gorilla", "Axe Hand Morang",
                "Naturo", "Graa", "Orochiramu", "Vetega", "Freezer", "Son Oguk",
                "Eneru", "Gojoh", "Peeko", "Sukuna", "Thukunaa", "Momrraga",
                "Ichigu Mugeto", "Lord Rimuro", "Statue of God", "Hakarro",
                "Kaiduu", "One-Punch Man", "Coyote Shark", "Astoo", "Zenny",
                "ItadoruAwakened", "AlmightyYawahoo", "Puccoi", "UltimateBeast Goham",
                "Eron Kruger", "HybridDragon Kaidu", "GalacticAntiSpiral",
                "Donte DevilHunter", "Soldier", "D-RANK Igris", "A-RANK Igris",
                "S-RANK Igris"
            }
            while BossEffectTeleport do
                if workspace:FindFirstChild("Effects") then
                    for _, effectName in ipairs(BossEffectsList) do
                        local effect = workspace.Effects:FindFirstChild(effectName)
                        if effect and game.Players.LocalPlayer.Character then
                            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(effect.CFrame * CFrame.new(0, 3, 0))
                            wait(0.1)
                        end
                    end
                end
                wait(0.1)
            end
        end)
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Boss Effects", Text = "Boss effects teleport enabled!", Duration = 2 })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Boss Effects", Text = "Boss effects teleport disabled!", Duration = 2 })
    end
end)

MiscTab.newButton("Toggle Auto Press E", "Auto press E key", function()
    _G.AutoPressKey = not _G.AutoPressKey
    if _G.AutoPressKey then
        spawn(function()
            while _G.AutoPressKey do
                pcall(function()
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    wait(0.05)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end)
                wait(0.2)
            end
        end)
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Auto Press E", Text = "Enabled!", Duration = 2 })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Auto Press E", Text = "Disabled!", Duration = 2 })
    end
end)

MiscTab.newLabel("Other Stuffs")

MiscTab.newButton("Stop All Functions", "Stops everything running", function()
    if RaceSpinActive then
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Race Spin", Text = "Stopped.", Duration = 2 })
    end
    if PerkSpinActive then
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Perk Spin", Text = "Stopped.", Duration = 2 })
    end
    
    RaceSpinActive = false
    PerkSpinActive = false
    _G.AutoFarm = false
    _G.LoopSpec = false
    
    AutoKillWaveActive = false
    if WaveKillTask then task.cancel(WaveKillTask) WaveKillTask = nil end
    
    AutoKillBossActive = false
    if BossKillConnection then BossKillConnection:Disconnect() BossKillConnection = nil end
    
    IsAutoQuestActive = false
    ShadowArmyAttacking = false
    ShadowArmySpawned = false
    AutoSellEnabled = false
    LoopSoulBuy = false
    
    -- Teleport/View Cleanups (defined below)
    if ViewPlayerConnection then
        ViewPlayerConnection:Disconnect()
        ViewPlayerConnection = nil
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Functions Stopped", Text = "All functions have been stopped", Duration = 2 })
end)

MiscTab.newButton("Stats Reset", "Reset Your Stats", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer("ResetStats")
end)

MiscTab.newButton("Geppo Buy", "Buy Geppo", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer("InteractControl", "Geppo Trainer")
end)

MiscTab.newButton("Title Changer", "Change Anywhere", function()
    game:GetService("Players").LocalPlayer.PlayerGui.TitleInv.Frame.Visible = true
end)

-- // PLAYER FUNCTIONS //
MiscTab.newLabel("Player Functions")
local PlayerList = {}
local SelectedPlayer = nil
local LoopTeleportPlayer = false

local function RefreshPlayerList()
    PlayerList = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(PlayerList, plr.Name)
        end
    end
    return PlayerList
end

MiscTab.newDropdown("Select Player", "Choose player", RefreshPlayerList(), function(val)
    SelectedPlayer = val
end)

MiscTab.newButton("Refresh Player List", "Updates the player list", function()
    MiscTab:Update(RefreshPlayerList()) -- Note: Update logic depends on library implementation
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Player List", Text = "Player list refreshed!", Duration = 2 })
end)

MiscTab.newButton("Teleport Once", "Teleport to selected player", function()
    if SelectedPlayer then
        local Target = game.Players:FindFirstChild(SelectedPlayer)
        if Target and Target.Character then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(Target.Character.PrimaryPart.CFrame)
        end
    end
end)

MiscTab.newButton("Start Loop Teleport", "Loop teleport to player", function()
    LoopTeleportPlayer = true
    spawn(function()
        while LoopTeleportPlayer do
            if SelectedPlayer then
                local Target = game.Players:FindFirstChild(SelectedPlayer)
                if Target and Target.Character and game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(Target.Character.PrimaryPart.CFrame)
                end
            end
            wait(0.1)
        end
    end)
end)

MiscTab.newButton("Stop Loop Teleport", "Stop teleporting", function()
    LoopTeleportPlayer = false
end)

local IsViewingPlayer = false
local ViewPlayerConnection = nil

MiscTab.newButton("View Selected Player", "Camera follows player", function()
    local Target = SelectedPlayer and not IsViewingPlayer and game.Players:FindFirstChild(SelectedPlayer)
    if Target then
        IsViewingPlayer = true
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        workspace.CurrentCamera.CameraSubject = Target.Character.Humanoid
    end
end)

local JoinNotifyEnabled = false
MiscTab.newButton("Toggle Join Notifications", "Notify when players join", function()
    JoinNotifyEnabled = not JoinNotifyEnabled
    if JoinNotifyEnabled then
        game.Players.PlayerAdded:Connect(function(plr)
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Player Joined", Text = plr.Name .. " has joined!", Duration = 3 })
        end)
    end
end)

MiscTab.newButton("Stop Viewing Player", "Reset camera control", function()
    IsViewingPlayer = false
    if ViewPlayerConnection then
        ViewPlayerConnection:Disconnect()
        ViewPlayerConnection = nil
    end
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    -- Also reset subject to self
    if game.Players.LocalPlayer.Character then
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
    end
end)

MiscTab.newLabel("Player Movement")
local WalkSpeedVal = 16
local JumpPowerVal = 50

MiscTab.newInput("Walkspeed", "Enter walkspeed value", function(val)
    local num = tonumber(val)
    if num then WalkSpeedVal = num end
end)

MiscTab.newButton("Set Walkspeed", "Apply walkspeed value", function()
    local Plr = game.Players.LocalPlayer
    if Plr and Plr.Character and Plr.Character:FindFirstChild("Humanoid") then
        Plr.Character.Humanoid.WalkSpeed = WalkSpeedVal
        game.StarterGui:SetCore("SendNotification", { Title = "Walkspeed", Text = "Set to " .. tostring(WalkSpeedVal), Duration = 2 })
    end
end)

MiscTab.newInput("Jump Height", "Enter jump height value", function(val)
    local num = tonumber(val)
    if num then JumpPowerVal = num end
end)

MiscTab.newButton("Set Jump Height", "Apply jump height value", function()
    local Plr = game.Players.LocalPlayer
    if Plr and Plr.Character and Plr.Character:FindFirstChild("Humanoid") then
        Plr.Character.Humanoid.JumpPower = JumpPowerVal
        game.StarterGui:SetCore("SendNotification", { Title = "Jump Height", Text = "Set to " .. tostring(JumpPowerVal), Duration = 2 })
    end
end)

MiscTab.newLabel("More")
MiscTab.newButton("Max Camera Zoom", "Remove zoom limit", function()
    game.Players.LocalPlayer.CameraMaxZoomDistance = math.huge
end)

MiscTab.newButton("Toggle Noclip Camera", "Phase through objects", function()
    local newState = not getgenv().noclipEnabled
    getgenv().noclipEnabled = newState
    local Plr = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")
    
    if newState then
        if not getgenv().noclipConnection then
            getgenv().noclipConnection = RunService.Stepped:Connect(function()
                if Plr.Character then
                    for _, part in pairs(Plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end
        game.StarterGui:SetCore("SendNotification", { Title = "Noclip", Text = "Noclip enabled!", Duration = 2 })
    else
        if getgenv().noclipConnection then
            getgenv().noclipConnection:Disconnect()
            getgenv().noclipConnection = nil
        end
        if Plr.Character then
            for _, part in pairs(Plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
        game.StarterGui:SetCore("SendNotification", { Title = "Noclip", Text = "Noclip disabled!", Duration = 2 })
    end
end)

MiscTab.newButton("Remove Fog", "Clear view distance", function()
    game.Lighting.FogEnd = 100000
    game.Lighting.FogStart = 0
end)

MiscTab.newButton("Anti Lag", "Reduce game effects", function()
    settings().Rendering.QualityLevel = 1
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        end
    end
end)

local EffectsToggleState = true
local CachedEffects = {}

MiscTab.newButton("Toggle Effects", "Enable/Disable workspace effects", function()
    EffectsToggleState = not EffectsToggleState
    if workspace:FindFirstChild("Effects") then
        if EffectsToggleState then
            -- Restore
            for _, stored in pairs(CachedEffects) do
                if stored.Instance and stored.Instance.Parent then
                    stored.Instance.Enabled = stored.WasEnabled
                end
            end
            CachedEffects = {}
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Effects", Text = "Effects restored", Duration = 2 })
        else
            -- Disable
            CachedEffects = {}
            for _, obj in pairs(workspace.Effects:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    table.insert(CachedEffects, { Instance = obj, WasEnabled = obj.Enabled })
                    obj.Enabled = false
                end
            end
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Effects", Text = "Effects removed", Duration = 2 })
        end
    end
end)

MiscTab.newButton("Give Teleport Tool", "Click anywhere to teleport", function()
    local Plr = game.Players.LocalPlayer
    local Tool = Instance.new("Tool")
    Tool.Name = "Click Teleport"
    Tool.RequiresHandle = false
    Tool.CanBeDropped = false
    Tool.Activated:Connect(function()
        local Mouse = Plr:GetMouse()
        if Mouse.Target then
            Plr.Character:SetPrimaryPartCFrame(CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)))
        end
    end)
    Tool.Parent = Plr.Backpack
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Teleport Tool", Text = "Click anywhere to teleport!", Duration = 2 })
end)

local AntiAFKActive = false
MiscTab.newButton("Toggle Anti-AFK", "Enable/Disable Anti-AFK", function()
    AntiAFKActive = not AntiAFKActive
    if AntiAFKActive then
        spawn(function()
            while AntiAFKActive do
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new(1280, 672))
                wait(20)
            end
        end)
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Anti-AFK", Text = "Anti-AFK enabled!", Duration = 2 })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Anti-AFK", Text = "Anti-AFK disabled!", Duration = 2 })
    end
end)

-- // CREDITS //
local CreditsTab = DrRayLibrary.newTab("Credits", "Yes")
CreditsTab.newLabel("Credits")
CreditsTab.newButton("Discord", "Contact Us Here!", function()
    setclipboard("https://discord.gg/JbZq4sBzT3")
end)
CreditsTab.newButton("Rick", "Founder", function() end)

print("Executed!")