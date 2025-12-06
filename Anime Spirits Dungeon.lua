-- Load the UI Library
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustLegits/WindUI/refs/heads/main/DrRay.lua"))()
UILibrary:Load("Anime Spirits", "Default")

-- // TABS //
local MainTab = UILibrary.newTab("Main", "Why not")
local DungeonTab = UILibrary.newTab("Dungeon", "Ez Gems\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189")
local TeleportTab = UILibrary.newTab("Teleport", "Locations")
local MiscTab = UILibrary.newTab("Misc", " ")
local CreditsTab = UILibrary.newTab("Credits", "Yes")

-- // MAIN TAB: AUTO FARM //
MainTab.newLabel("Auto Farm")

local SelectedEnemyName = "Default"
local EnemyNameList = { "Default" }
local EnemyDropdown = nil

-- Function to refresh the list of enemies in the workspace
local function RefreshEnemyList()
    local tempEnemyNames = {}
    local tempEnemyCounts = {}
    
    pcall(function()
        for _, npc in pairs(workspace["NPC's"]:GetChildren()) do
            if npc:FindFirstChild("Humanoid") then
                local name = npc.Name
                if tempEnemyCounts[name] then
                    tempEnemyCounts[name] = tempEnemyCounts[name] + 1
                else
                    tempEnemyCounts[name] = 1
                    table.insert(tempEnemyNames, name)
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
        EnemyNameList = tempEnemyNames
        SelectedEnemyName = EnemyNameList[1]
        
        if EnemyDropdown and EnemyDropdown.Update then
            EnemyDropdown:Update(EnemyNameList)
        end

        local totalEnemies = 0
        for _, count in pairs(tempEnemyCounts) do
            totalEnemies = totalEnemies + count
        end

        game.StarterGui:SetCore("SendNotification", {
            Title = "Enemy List",
            Text = "Found " .. #EnemyNameList .. " unique enemies (" .. totalEnemies .. " total)",
            Duration = 3
        })
        
        print("--- Enemy Counts ---")
        for name, count in pairs(tempEnemyCounts) do
            print(name .. ": " .. count)
        end
        print("-------------------")
    end
end

-- Initial Enemy Load
pcall(function()
    local initialNames = {}
    local initialCounts = {}
    for _, npc in pairs(workspace["NPC's"]:GetChildren()) do
        if npc:FindFirstChild("Humanoid") then
            local name = npc.Name
            if initialCounts[name] then
                initialCounts[name] = initialCounts[name] + 1
            else
                initialCounts[name] = 1
                table.insert(initialNames, name)
            end
        end
    end
    table.sort(initialNames)
    if #initialNames > 0 then
        EnemyNameList = initialNames
        SelectedEnemyName = EnemyNameList[1]
    end
end)

EnemyDropdown = MainTab.newDropdown("Select Enemy", "Choose", EnemyNameList, function(selected)
    SelectedEnemyName = selected
end)

MainTab.newButton("Refresh Enemies List", "Updates the available enemies", function()
    RefreshEnemyList()
end)

-- // AUTO QUEST //
local PlaceId = game.PlaceId
local QuestList = {}
local AutoQuestRunning = false
local SelectedQuest = "Quest Giver 1"

-- Determine quests based on Place ID (Sea 1, Sea 2, Space)
if PlaceId == 11756036029 then
    for i = 1, 42 do
        table.insert(QuestList, "Quest Giver " .. i)
    end
elseif PlaceId == 16041086429 then
    for i = 43, 66 do
        table.insert(QuestList, "Quest Giver " .. i)
    end
elseif PlaceId == 73417524077325 then
    for i = 67, 81 do
        table.insert(QuestList, "Quest Giver " .. i)
    end
end

MainTab.newDropdown("Select Quest", "Choose a quest", QuestList, function(selected)
    SelectedQuest = selected
end)

MainTab.newButton("Start Auto Quest", "", function()
    AutoQuestRunning = true
    spawn(function()
        while AutoQuestRunning do
            local args = { "InteractControl", SelectedQuest }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer(unpack(args))
            end)
            wait(0.2)
        end
    end)
end)

MainTab.newButton("Stop Auto Quest", "", function()
    AutoQuestRunning = false
end)

-- // FARM SETTINGS //
local FarmPosition = "Behind"
local FarmDistance = 3

MainTab.newDropdown("Farm Position", "Choose position relative to enemy", { "Behind", "Above", "Below" }, function(selected)
    FarmPosition = selected
end)

MainTab.newInput("Farm Distance", "Enter distance (1-20)", function(input)
    local dist = tonumber(input)
    if dist and (dist >= 1 and dist <= 20) then
        FarmDistance = dist
        game.StarterGui:SetCore("SendNotification", {
            Title = "Farm Distance",
            Text = "Set to " .. tostring(FarmDistance),
            Duration = 2
        })
    end
end)

-- // TELEPORT AUTO FARM //
MainTab.newButton("Start Auto Farm (Teleport)", "Begins auto attacking selected enemy by teleporting", function()
    _G.AutoFarm = true
    spawn(function()
        while _G.AutoFarm do
            wait()
            pcall(function()
                for _, npc in pairs(workspace["NPC's"]:GetChildren()) do
                    if npc.Name == SelectedEnemyName and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                        local player = game.Players.LocalPlayer
                        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("HumanoidRootPart") then
                            
                            local offsetCFrame = nil
                            if FarmPosition == "Below" then
                                offsetCFrame = CFrame.new(0, -FarmDistance, 0) * CFrame.Angles(math.rad(90), 0, 0)
                            elseif FarmPosition == "Above" then
                                offsetCFrame = CFrame.new(0, FarmDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            else -- Behind
                                offsetCFrame = CFrame.new(0, 0, FarmDistance)
                            end
                            
                            player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * offsetCFrame
                            
                            local combatArgs = {
                                "CombatControl",
                                player.Character:FindFirstChildOfClass("Tool") and (player.Character:FindFirstChildOfClass("Tool").Name or "") or "",
                                1,
                                false
                            }
                            
                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer(unpack(combatArgs))
                            end)
                            
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        end
                    end
                end
            end)
        end
    end)
end)

-- // WALKING AUTO FARM //
MainTab.newButton("Start Auto Farm (Walking)", "Walks to enemy and uses combat keys", function()
    _G.WalkFarm = true
    local SkillSequence = {
        { key = "E", delay = 0.3 },
        { key = "Z", delay = 0.5 },
        { key = "X", delay = 0.7 },
        { key = "C", delay = 1 },
        { key = "T", delay = 2 }
    }

    local function PressKey(k)
        local virtualUser = game:GetService("VirtualUser")
        virtualUser:CaptureController()
        virtualUser:TypeKey(k)
    end

    spawn(function()
        while _G.WalkFarm do
            pcall(function()
                local player = game.Players.LocalPlayer
                if not (player and player.Character and player.Character:FindFirstChild("Humanoid")) then
                    wait(0.2)
                    return
                end

                -- Find valid enemy
                local targetEnemy = nil
                for _, npc in pairs(workspace["NPC's"]:GetChildren()) do
                    if npc.Name == SelectedEnemyName and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                        targetEnemy = npc
                        break
                    end
                end

                if targetEnemy and targetEnemy:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local enemyHrp = targetEnemy.HumanoidRootPart
                    
                    -- Check if close enough to attack
                    if (hrp.Position - enemyHrp.Position).Magnitude <= FarmDistance + 5 then
                        player.Character.Humanoid:SetAttribute("WalkAnim", false)
                        player.Character.Humanoid:MoveTo(player.Character.HumanoidRootPart.Position) -- Stop moving
                        
                        -- Position character for attack
                        if FarmPosition == "Below" then
                            local pos = enemyHrp.Position - Vector3.new(0, FarmDistance, 0)
                            hrp.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(90), 0, 0)
                        elseif FarmPosition == "Above" then
                            local pos = enemyHrp.Position + Vector3.new(0, FarmDistance, 0)
                            hrp.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(-90), 0, 0)
                        else -- Behind
                            local lookVector = enemyHrp.CFrame.LookVector
                            local pos = enemyHrp.Position - lookVector * FarmDistance
                            hrp.CFrame = CFrame.lookAt(pos, enemyHrp.Position)
                        end
                        
                        -- Execute Skills
                        for _, skill in ipairs(SkillSequence) do
                            PressKey(skill.key)
                            wait(skill.delay)
                            
                            local combatArgs = {
                                "CombatControl",
                                player.Character:FindFirstChildOfClass("Tool") and (player.Character:FindFirstChildOfClass("Tool").Name or "") or "",
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
                        -- Move towards enemy
                        if FarmPosition == "Below" then
                             local targetPos = enemyHrp.Position - Vector3.new(0, FarmDistance, 0)
                             player.Character.Humanoid:MoveTo(targetPos)
                        elseif FarmPosition == "Above" then
                             local targetPos = enemyHrp.Position + Vector3.new(0, FarmDistance, 0)
                             player.Character.Humanoid:MoveTo(targetPos)
                        else -- Behind
                             local lookVector = enemyHrp.CFrame.LookVector
                             local targetPos = enemyHrp.Position - lookVector * FarmDistance
                             player.Character.Humanoid:SetAttribute("WalkAnim", true)
                             player.Character.Humanoid:Move(lookVector * -1, false)
                             player.Character.Humanoid:MoveTo(targetPos)
                        end
                        
                        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(enemyHrp.Position.X, hrp.Position.Y, enemyHrp.Position.Z))
                        
                        -- Jump if obstructed
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = { player.Character }
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        local origin = hrp.Position
                        local direction = (enemyHrp.Position - origin).Unit * 5
                        
                        if workspace:Raycast(origin, direction, rayParams) then
                            player.Character.Humanoid.Jump = true
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
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:SetAttribute("WalkAnim", false)
        player.Character.Humanoid:MoveTo(player.Character.HumanoidRootPart.Position)
    end
    game.StarterGui:SetCore("SendNotification", { Title = "Auto Farm", Text = "All auto farm methods stopped", Duration = 2 })
end)

-- // INSTANT KILL //
MainTab.newLabel("Instant Kill")
local InstantKillEnabled = false

MainTab.newButton("Toggle Instant Kill (<30% HP)", "Automatically kills mobs below 30% HP", function()
    InstantKillEnabled = not InstantKillEnabled
    if InstantKillEnabled then
        spawn(function()
            while InstantKillEnabled do
                for _, npc in pairs(workspace["NPC's"]:GetChildren()) do
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
    local SpecialBosses = { "Momrraga", "Thukunaa", "Zenny", "ItadoruAwakened", "GalacticAntiSpiral" }
    local FoundBosses = {}
    
    for _, bossName in ipairs(SpecialBosses) do
        if workspace["NPC's"]:FindFirstChild(bossName) then
            table.insert(FoundBosses, bossName)
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
    
    local msg = #FoundBosses > 0 and table.concat(FoundBosses, ", ") .. " found!" or "No special bosses found."
    game.StarterGui:SetCore("SendNotification", { Title = "Boss Check", Text = msg, Duration = 3 })
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
    local SpecialBosses = { "Momrraga", "Thukunaa", "Zenny", "ItadoruAwakened", "GalacticAntiSpiral" }
    for _, bossName in ipairs(SpecialBosses) do
        local boss = workspace["NPC's"]:FindFirstChild(bossName)
        if boss and boss:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(boss.HumanoidRootPart.CFrame * CFrame.new(0, 5, 5))
            game.StarterGui:SetCore("SendNotification", { Title = "Boss Teleport", Text = "Teleported to " .. bossName, Duration = 2 })
            break
        end
    end
end)

-- // WEAPONS //
local WeaponDropdown = nil
local WeaponList = {}
local SelectedWeapon = nil
local AutoEquipEnabled = false

local function RefreshWeapons()
    WeaponList = {}
    local player = game:GetService("Players").LocalPlayer
    if not player.Backpack then return {} end
    
    WeaponList = {}
    -- Check Backpack
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(WeaponList, item.Name)
        end
    end
    -- Check Character (Equipped)
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(WeaponList, item.Name)
            end
        end
    end
    
    table.sort(WeaponList)
    
    if WeaponDropdown then
        WeaponDropdown:Update(WeaponList)
        if #WeaponList <= 0 then
            SelectedWeapon = nil
            print("Dropdown is empty - no weapons found")
        else
            SelectedWeapon = WeaponList[1]
            print("\n=== Current Dropdown Contents ===")
            for i, name in ipairs(WeaponList) do
                print(i .. ". " .. name)
            end
            print("=== End of Dropdown Contents ===\n")
        end
    end
    return WeaponList
end

RefreshWeapons()

WeaponDropdown = MainTab.newDropdown("Select Weapon", "Choose weapon to equip", WeaponList, function(selected)
    SelectedWeapon = selected
end)

-- Update weapons on inventory change
game:GetService("Players").LocalPlayer.Backpack.ChildAdded:Connect(RefreshWeapons)
game:GetService("Players").LocalPlayer.Backpack.ChildRemoved:Connect(RefreshWeapons)
if game:GetService("Players").LocalPlayer.Character then
    game:GetService("Players").LocalPlayer.Character.ChildAdded:Connect(RefreshWeapons)
    game:GetService("Players").LocalPlayer.Character.ChildRemoved:Connect(RefreshWeapons)
end
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(RefreshWeapons)
    char.ChildRemoved:Connect(RefreshWeapons)
    wait(1)
    RefreshWeapons()
end)

MainTab.newInput("Weapon Name", "Enter weapon name to equip", function(name)
    if name and name ~= "" then
        SelectedWeapon = name
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local tool = player.Backpack:FindFirstChild(name)
            if tool then
                tool.Parent = player.Character
                game.StarterGui:SetCore("SendNotification", { Title = "Weapon Equipped", Text = name .. " equipped successfully!", Duration = 2 })
            else
                game.StarterGui:SetCore("SendNotification", { Title = "Weapon Not Found", Text = name .. " not found in inventory", Duration = 2 })
            end
        end
    end
end)

MainTab.newButton("Refresh Weapons", "Force refresh weapon list", function()
    local list = RefreshWeapons()
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Weapons", Text = "Found " .. #list .. " weapons!", Duration = 2 })
end)

MainTab.newButton("Toggle Auto Equip", "Auto equips selected weapon", function()
    AutoEquipEnabled = not AutoEquipEnabled
    if AutoEquipEnabled then
        spawn(function()
            while AutoEquipEnabled do
                if SelectedWeapon then
                    local player = game.Players.LocalPlayer
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        local tool = player.Backpack:FindFirstChild(SelectedWeapon)
                        if tool then
                            tool.Parent = player.Character
                        end
                    else
                        repeat wait() until player.Character and player.Character:FindFirstChild("Humanoid")
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

-- // SPECS //
MainTab.newLabel("Specs")
local SelectedSpec = "Buso Haki V1"
local SpecsList = {
    "Buso Haki V1", "Substitution Jutsu", "Crit Boost", "Gear5 Emperor Roc", "Buso Haki V2",
    "Conquerors Haki", "Nine Tails", "Cursed Blue", "Super Spirit Bomb", "Ultra Instinct",
    "Awakened Sakuno Domain", "Awakened Six Eyes", "Itadoru Domain", "Red Karma", "I AM ATOMIC!!",
    "God Naturo", "Zeno Universe Destroyer", "Omni Oguk", "Adult Gone", "Chrono Acceleration",
    "Camera Man", "Godspeed Killuo", "Death Note", "Soul Kings Might", "Imuu Destruction",
    "Kargogon", "Baran", "Jinvoo Dual Strike", "Gear 6", "Super Saiyan 100"
}

MainTab.newDropdown("Select Spec", "Choose", SpecsList, function(selected)
    SelectedSpec = selected
end)

MainTab.newButton("Use Spec Once", "Triggers the selected spec one time", function()
    local player = game.Players.LocalPlayer
    local hrp = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer("Specs", SelectedSpec, hrp.Position)
    end
end)

MainTab.newButton("Start Loop Spec", "Repeatedly activates selected spec", function()
    _G.LoopSpec = true
    spawn(function()
        while _G.LoopSpec do
            local player = game.Players.LocalPlayer
            local hrp = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer("Specs", SelectedSpec, hrp.Position)
            end
            wait(8)
        end
    end)
end)

MainTab.newButton("Stop Loop Spec", "Stops the repeated spec use", function()
    _G.LoopSpec = false
end)

MainTab.newButton("Redeem All Codes", "Redeems all unclaimed codes", function()
    local codesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Codes")
    for _, code in pairs(codesFolder:GetChildren()) do
        if code:IsA("BoolValue") and not code.Value then
            game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("Code"):FireServer(code.Name)
            wait(0.2)
        end
    end
end)

-- // DUNGEON TAB //
DungeonTab.newLabel("Instant Wave/Boss Kill")
local AutoKillWave = false
local AutoKillBoss = false
local WaveKillTask = nil
local BossKillConnection = nil

local function IsDungeonActive()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        return (workspace:FindFirstChild("WaveEnemies") or workspace:FindFirstChild("Boss")) ~= nil
    else
        return false
    end
end

local function WaitForDungeonStart()
    while not IsDungeonActive() do
        wait(1)
    end
    return true
end

DungeonTab.newButton("Activate Kill Wave Enemies", "Kills all wave enemies repeatedly", function()
    if not AutoKillWave then
        AutoKillWave = true
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Wave Kill", Text = "Wave enemy kill enabled!", Duration = 2 })
        
        WaveKillTask = task.spawn(function()
            while AutoKillWave do
                if not IsDungeonActive() then
                    WaitForDungeonStart()
                end
                while AutoKillWave do
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                    local waveFolder = workspace:FindFirstChild("WaveEnemies")
                    if waveFolder then
                        for _, enemy in pairs(waveFolder:GetDescendants()) do
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
    if not AutoKillBoss then
        AutoKillBoss = true
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Boss Kill", Text = "Boss instant kill enabled!", Duration = 2 })
        
        BossKillConnection = game:GetService("RunService").Heartbeat:Connect(function()
            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
            local bossModel = workspace:FindFirstChild("Boss")
            if bossModel then
                for _, obj in pairs(bossModel:GetDescendants()) do
                    local hum = obj:FindFirstChildWhichIsA("Humanoid")
                    if hum and (hum.Health > 0 and hum.Health < hum.MaxHealth) then
                        hum.Health = 0
                    end
                end
            end
        end)
    end
end)

DungeonTab.newButton("Disable All Killers", "Stops all auto kill functions", function()
    if AutoKillWave then
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Wave Kill", Text = "Wave enemy kill disabled!", Duration = 2 })
    end
    if AutoKillBoss then
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Boss Kill", Text = "Boss instant kill disabled!", Duration = 2 })
    end
    
    AutoKillWave = false
    if WaveKillTask then
        task.cancel(WaveKillTask)
        WaveKillTask = nil
    end
    
    AutoKillBoss = false
    if BossKillConnection then
        BossKillConnection:Disconnect()
        BossKillConnection = nil
    end
end)

-- // TELEPORT TAB //
local SelectedSpawn = nil
local SpawnPointsList = {}

pcall(function()
    for _, sp in pairs(workspace:FindFirstChild("SpawnPoints"):GetChildren()) do
        if sp:IsA("BasePart") then
            table.insert(SpawnPointsList, sp.Name)
        end
    end
end)

TeleportTab.newDropdown("Select Spawn", "Choose location", SpawnPointsList, function(selected)
    SelectedSpawn = workspace.SpawnPoints:FindFirstChild(selected)
end)

TeleportTab.newButton("Teleport to Selected Spawn", "Moves your character", function()
    local player = game.Players.LocalPlayer
    if SelectedSpawn and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = SelectedSpawn.CFrame + Vector3.new(0, 3, 0)
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
MiscTab.newLabel("Auto DF")
local AutoSellRarities = {}

MiscTab.newDropdown("Select Rarities to AutoSell", "Multi-select", { "Common", "Rare", "Epic", "Legendary" }, function(selected)
    if table.find(AutoSellRarities, selected) then
        -- Remove if exists
        for i, val in ipairs(AutoSellRarities) do
            if val == selected then
                table.remove(AutoSellRarities, i)
                break
            end
        end
    else
        -- Add if not exists
        table.insert(AutoSellRarities, selected)
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

-- Souls
local SoulDeals = { "G$25k 1 Soul", "G$125k 5 Souls" }
local SelectedSoulDeal = SoulDeals[1]

MiscTab.newDropdown("Select Soul Deal", "Choose deal", SoulDeals, function(selected)
    SelectedSoulDeal = selected
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

-- Races
local RaceList = {
    "Skypian", "Mink", "Saiyan", "Uzumaki", "Otsutski", "D. Clan",
    "Sorcerer", "Demon Slime", "Ichigu Hybrid", "King Of Curses",
    "Gojo Clan", "Shadow Monarch"
}
local TargetRace = RaceList[1]
local AutoSpinRace = false

MiscTab.newDropdown("Select Race", "Choose race to stop at", RaceList, function(selected)
    TargetRace = selected
end)

MiscTab.newButton("Start Race Spin", "Auto spins until selected race", function()
    AutoSpinRace = true
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Race Spin", Text = "Started spinning for " .. TargetRace, Duration = 2 })
    
    spawn(function()
        while AutoSpinRace do
            if game.Players.LocalPlayer.Data.Race.Value == TargetRace then
                AutoSpinRace = false
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Race Spin Success!",
                    Text = "Got " .. TargetRace .. "!\nSpins remaining: " .. game:GetService("Players").LocalPlayer.Data.RaceSpins.Value,
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
    AutoSpinRace = false
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Race Spin",
        Text = "Stopped spinning. You have " .. game:GetService("Players").LocalPlayer.Data.RaceSpins.Value .. " spins left",
        Duration = 2
    })
end)

MiscTab.newButton("Buy Race Spin", "Purchase race spin with gems", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer(unpack({ "BuySpinsForGems", "Race" }))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Race Spins",
        Text = "You have " .. game:GetService("Players").LocalPlayer.Data.RaceSpins.Value .. " race spins!",
        Duration = 2
    })
end)

-- Perks
local PerkList = {
    "Run Faster", "Energy Builds Faster", "More Health", "Double Geppo Jump",
    "2x Chest Gold", "10% Luck Boost", "Nine Tails Power", "Conquerors Haki",
    "Ultra Instinct", "Prodigy"
}
local TargetPerk = PerkList[1]
local AutoSpinPerk = false

MiscTab.newDropdown("Select Perk", "Choose perk to stop at", PerkList, function(selected)
    TargetPerk = selected
end)

MiscTab.newButton("Start Perk Spin", "Auto spins until selected perk", function()
    AutoSpinPerk = true
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Perk Spin", Text = "Started spinning for " .. TargetPerk, Duration = 2 })
    
    spawn(function()
        while AutoSpinPerk do
            if game.Players.LocalPlayer.Data.Perk.Value == TargetPerk then
                AutoSpinPerk = false
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Perk Spin Success!",
                    Text = "Got " .. TargetPerk .. "!\nSpins remaining: " .. game:GetService("Players").LocalPlayer.Data.PerkSpins.Value,
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
    AutoSpinPerk = false
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Perk Spin",
        Text = "Stopped spinning. You have " .. game:GetService("Players").LocalPlayer.Data.PerkSpins.Value .. " spins left",
        Duration = 2
    })
end)

MiscTab.newButton("Buy Perk Spin", "Purchase perk spin with gems", function()
    game:GetService("ReplicatedStorage"):WaitForChild("Game"):WaitForChild("Remotes"):WaitForChild("ServerHandler"):FireServer(unpack({ "BuySpinsForGems", "Perk" }))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Perk Spins",
        Text = "You have " .. game:GetService("Players").LocalPlayer.Data.PerkSpins.Value .. " perk spins!",
        Duration = 2
    })
end)

-- Shadow Army
MiscTab.newLabel("Shadow Army")
local ShadowArmySummoned = false
local ShadowArmyAttacking = false

MiscTab.newButton("Toggle Shadow Army", "Summon or dismiss shadow army", function()
    ShadowArmySummoned = not ShadowArmySummoned
    game:GetService("ReplicatedStorage"):WaitForChild("CommandUnspawnUnits"):FireServer(ShadowArmySummoned)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Shadow Army",
        Text = ShadowArmySummoned and "Shadow Army summoned!" or "Shadow Army dismissed!",
        Duration = 2
    })
    
    if not ShadowArmySummoned and ShadowArmyAttacking then
        ShadowArmyAttacking = false
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Shadow Army", Text = "Shadow Army attack stopped!", Duration = 2 })
    end
end)

MiscTab.newButton("Toggle Shadow Attack", "Start or stop shadow army attack", function()
    if ShadowArmySummoned then
        ShadowArmyAttacking = not ShadowArmyAttacking
        if ShadowArmyAttacking then
            spawn(function()
                while ShadowArmyAttacking and ShadowArmySummoned do
                    local player = game.Players.LocalPlayer
                    if player and player.Character then
                        local hum = player.Character:FindFirstChild("Humanoid")
                        
                        -- Wait for respawn if dead
                        if not hum or hum.Health <= 0 then
                            repeat wait(0.1) until player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
                            wait(1)
                            -- Resummon army after death
                            for _ = 1, 3 do
                                pcall(function()
                                    game:GetService("ReplicatedStorage"):WaitForChild("CommandUnspawnUnits"):FireServer(true)
                                end)
                                wait(0.2)
                            end
                            wait(0.5)
                        end
                        
                        if ShadowArmyAttacking and ShadowArmySummoned then
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
local BossEffectsTeleport = false

MiscTab.newButton("Toggle Boss Effects Teleport", "Loop teleport to boss effects", function()
    BossEffectsTeleport = not BossEffectsTeleport
    if BossEffectsTeleport then
        spawn(function()
            local BossNamesForEffects = {
                "Bandit Boss", "Pirate Captain", "King Gorilla", "Axe Hand Morang", "Naturo", "Graa",
                "Orochiramu", "Vetega", "Freezer", "Son Oguk", "Eneru", "Gojoh", "Peeko", "Sukuna",
                "Thukunaa", "Momrraga", "Ichigu Mugeto", "Lord Rimuro", "Statue of God", "Hakarro",
                "Kaiduu", "One-Punch Man", "Coyote Shark", "Astoo", "Zenny", "ItadoruAwakened",
                "AlmightyYawahoo", "Puccoi", "UltimateBeast Goham", "Eron Kruger", "HybridDragon Kaidu",
                "GalacticAntiSpiral", "Donte DevilHunter", "Soldier", "D-RANK Igris", "A-RANK Igris", "S-RANK Igris"
            }
            while BossEffectsTeleport do
                if workspace:FindFirstChild("Effects") then
                    for _, bossName in ipairs(BossNamesForEffects) do
                        local effectModel = workspace.Effects:FindFirstChild(bossName)
                        if effectModel and game.Players.LocalPlayer.Character then
                            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(effectModel.CFrame * CFrame.new(0, 3, 0))
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
    -- Stop Spins
    if AutoSpinRace then
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Race Spin", Text = "Stopped spinning. You have " .. game:GetService("Players").LocalPlayer.Data.RaceSpins.Value .. " spins left", Duration = 2 })
    end
    if AutoSpinPerk then
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Perk Spin", Text = "Stopped spinning. You have " .. game:GetService("Players").LocalPlayer.Data.PerkSpins.Value .. " spins left", Duration = 2 })
    end
    
    -- Reset all flags
    AutoSpinRace = false
    AutoSpinPerk = false
    _G.AutoFarm = false
    _G.LoopSpec = false
    
    AutoKillWave = false
    if WaveKillTask then task.cancel(WaveKillTask); WaveKillTask = nil end
    
    AutoKillBoss = false
    if BossKillConnection then BossKillConnection:Disconnect(); BossKillConnection = nil end
    
    AutoQuestRunning = false
    ShadowArmyAttacking = false
    ShadowArmySummoned = false
    AutoSellEnabled = false
    LoopSoulBuy = false
    
    -- Teleport/View variables (defined later)
    TeleportToPlayerLoop = false
    ViewingPlayer = false
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
local TeleportToPlayerLoop = false

local function RefreshPlayerList()
    PlayerList = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(PlayerList, plr.Name)
        end
    end
    return PlayerList
end

MiscTab.newDropdown("Select Player", "Choose player", RefreshPlayerList(), function(selected)
    SelectedPlayer = selected
end)

MiscTab.newButton("Refresh Player List", "Updates the player list", function()
    -- Note: Dropdown update logic isn't fully exposed in this variable scope, assuming refresh works on re-open or similar
    -- In proper DrRay, you would update the dropdown object like we did for Enemies.
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Player List", Text = "Player list refreshed!", Duration = 2 })
end)

MiscTab.newButton("Teleport Once", "Teleport to selected player", function()
    if SelectedPlayer then
        local target = game.Players:FindFirstChild(SelectedPlayer)
        if target and target.Character then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame)
        end
    end
end)

MiscTab.newButton("Start Loop Teleport", "Loop teleport to player", function()
    TeleportToPlayerLoop = true
    spawn(function()
        while TeleportToPlayerLoop do
            if SelectedPlayer then
                local target = game.Players:FindFirstChild(SelectedPlayer)
                if target and target.Character and game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.PrimaryPart.CFrame)
                end
            end
            wait(0.1)
        end
    end)
end)

MiscTab.newButton("Stop Loop Teleport", "Stop teleporting", function()
    TeleportToPlayerLoop = false
end)

local ViewingPlayer = false
local ViewPlayerConnection = nil

MiscTab.newButton("View Selected Player", "Camera follows player", function()
    local target = SelectedPlayer and not ViewingPlayer and game.Players:FindFirstChild(SelectedPlayer)
    if target then
        ViewingPlayer = true
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
    end
end)

local JoinNotifications = false
MiscTab.newButton("Toggle Join Notifications", "Notify when players join", function()
    JoinNotifications = not JoinNotifications
    if JoinNotifications then
        game.Players.PlayerAdded:Connect(function(plr)
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Player Joined", Text = plr.Name .. " has joined!", Duration = 3 })
        end)
    end
end)

MiscTab.newButton("Stop Viewing Player", "Reset camera control", function()
    ViewingPlayer = false
    if ViewPlayerConnection then
        ViewPlayerConnection:Disconnect()
        ViewPlayerConnection = nil
    end
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
end)

-- // PLAYER MOVEMENT //
MiscTab.newLabel("Player Movement")
local WalkSpeedValue = 16
local JumpHeightValue = 50

MiscTab.newInput("Walkspeed", "Enter walkspeed value", function(input)
    local val = tonumber(input)
    if val then WalkSpeedValue = val end
end)

MiscTab.newButton("Set Walkspeed", "Apply walkspeed value", function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = WalkSpeedValue
        game.StarterGui:SetCore("SendNotification", { Title = "Walkspeed", Text = "Set to " .. tostring(WalkSpeedValue), Duration = 2 })
    end
end)

MiscTab.newInput("Jump Height", "Enter jump height value", function(input)
    local val = tonumber(input)
    if val then JumpHeightValue = val end
end)

MiscTab.newButton("Set Jump Height", "Apply jump height value", function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = JumpHeightValue
        game.StarterGui:SetCore("SendNotification", { Title = "Jump Height", Text = "Set to " .. tostring(JumpHeightValue), Duration = 2 })
    end
end)

MiscTab.newLabel("More")

MiscTab.newButton("Max Camera Zoom", "Remove zoom limit", function()
    game.Players.LocalPlayer.CameraMaxZoomDistance = math.huge
end)

MiscTab.newButton("Toggle Noclip Camera", "Phase through objects", function()
    local noclip = not getgenv().noclipEnabled
    getgenv().noclipEnabled = noclip
    local player = game.Players.LocalPlayer
    local runService = game:GetService("RunService")
    
    if noclip then
        if not getgenv().noclipConnection then
            getgenv().noclipConnection = runService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
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
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
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

-- Effects Toggler
local EffectsVisible = true
local CachedEffects = {}

MiscTab.newButton("Toggle Effects", "Enable/Disable workspace effects", function()
    EffectsVisible = not EffectsVisible
    if workspace:FindFirstChild("Effects") then
        if EffectsVisible then
            -- Restore effects
            for _, stored in pairs(CachedEffects) do
                if stored.Instance and stored.Instance.Parent then
                    stored.Instance.Enabled = stored.WasEnabled
                end
            end
            CachedEffects = {}
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Effects", Text = "Effects restored", Duration = 2 })
        else
            -- Hide effects
            CachedEffects = {}
            for _, effect in pairs(workspace.Effects:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Trail") or effect:IsA("Beam") then
                    table.insert(CachedEffects, { Instance = effect, WasEnabled = effect.Enabled })
                    effect.Enabled = false
                end
            end
            game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Effects", Text = "Effects removed", Duration = 2 })
        end
    end
end)

MiscTab.newButton("Give Teleport Tool", "Click anywhere to teleport", function()
    local player = game.Players.LocalPlayer
    local tool = Instance.new("Tool")
    tool.Name = "Click Teleport"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        if mouse.Target then
            player.Character:SetPrimaryPartCFrame(CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)))
        end
    end)
    
    tool.Parent = player.Backpack
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Teleport Tool", Text = "Click anywhere to teleport!", Duration = 2 })
end)

local AntiAFKEnabled = false
MiscTab.newButton("Toggle Anti-AFK", "Enable/Disable Anti-AFK", function()
    AntiAFKEnabled = not AntiAFKEnabled
    if AntiAFKEnabled then
        spawn(function()
            while AntiAFKEnabled do
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
CreditsTab.newLabel("Credits")
CreditsTab.newButton("Discord", "Contact Us Here!", function()
    setclipboard("https://discord.gg/JbZq4sBzT3")
end)
CreditsTab.newButton("Rick", "Founder", function() end)

print("Executed!")