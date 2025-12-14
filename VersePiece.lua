--// --- CLEANUP OLD UI --- //--
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if CoreGui:FindFirstChild("WindUI_Toggle") then CoreGui.WindUI_Toggle:Destroy() end
    if PlayerGui and PlayerGui:FindFirstChild("WindUI_Toggle") then PlayerGui.WindUI_Toggle:Destroy() end
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "WindUI" then v:Destroy() end
    end
end)

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

--// Variables
local IsFarming = false
local IsBossFarming = false
local IsDungeonFarming = false
local ActiveTarget = nil 

--// Settings
local SelectedWeaponName = nil
local FarmingPosition = "Top"
local FarmingDistance = 7
local SelectedAbilities = {}
local BossPriorityList = {}

--// NEW FARMING DATA STRUCTURE
-- FarmList = { {Name = "MobName", Folder = Instance(Folder)}, ... }
local FarmList = {} 
local TargetCache = {} 
local LastTargetFoundTime = tick() -- For the 10s delay logic

--// UI Helper Variables
local CurrentSelectedIsland = nil
local CurrentSelectedMobs = {}

--// --- HELPER FUNCTIONS --- //--

local function pressKey(keyName)
    local key = Enum.KeyCode[keyName]
    if key then
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end
end

local function sendChat(msg)
    if TextChatService.ChatInputBarConfiguration.TargetTextChannel then
        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
    elseif ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
    end
end

local function EquipWeapon()
    if not Character or not Character:FindFirstChild("Humanoid") then return end
    if SelectedWeaponName == "None" then Character.Humanoid:UnequipTools(); return end
    if SelectedWeaponName then
        local Tool = Character:FindFirstChild(SelectedWeaponName)
        if not Tool then
            local Backpack = LocalPlayer:FindFirstChild("Backpack")
            if Backpack and Backpack:FindFirstChild(SelectedWeaponName) then
                Character.Humanoid:EquipTool(Backpack[SelectedWeaponName])
            end
        end
    end
end

local function AttackM1()
    if SelectedWeaponName and SelectedWeaponName ~= "None" and Character then
        local Tool = Character:FindFirstChild(SelectedWeaponName)
        if Tool then Tool:Activate() end
    end
end

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

--// --- NEW SCANNING FUNCTIONS --- //--

-- Get List of Islands (Folders inside Main)
local function getIslands()
    local islands = {}
    local main = Workspace:FindFirstChild("Main")
    if main then
        -- Add "Main" itself for loose NPCs
        table.insert(islands, "Main (Global)")
        
        for _, child in pairs(main:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Model") then
                table.insert(islands, child.Name)
            end
        end
    end
    table.sort(islands)
    return islands
end

-- Get Mobs inside a SPECIFIC Island
local function getMobsInIsland(islandName)
    local mobs = {}
    local seen = {}
    local main = Workspace:FindFirstChild("Main")
    
    local targetFolder = main
    if islandName ~= "Main (Global)" then
        targetFolder = main:FindFirstChild(islandName)
    end

    if targetFolder then
        for _, obj in pairs(targetFolder:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= LocalPlayer.Name then
                if not obj:FindFirstChild("DamageCounter") then
                    if not seen[obj.Name] then
                        table.insert(mobs, obj.Name)
                        seen[obj.Name] = true
                    end
                end
            end
        end
    end
    table.sort(mobs)
    return mobs
end

-- Get Weapons
local function getWeapons()
    local tools = {"None"}
    local seen = {}
    local function add(list)
        for _, item in pairs(list) do
            if item:IsA("Tool") and not seen[item.Name] then
                table.insert(tools, item.Name)
                seen[item.Name] = true
            end
        end
    end
    if LocalPlayer:FindFirstChild("Backpack") then add(LocalPlayer.Backpack:GetChildren()) end
    if LocalPlayer.Character then add(LocalPlayer.Character:GetChildren()) end
    return tools
end

--// --- UI SETUP --- //--

local Window = WindUI:CreateWindow({
    Title = "Auto Farm | Smart Scan v14",
    Icon = "sword",
    Author = ".ftgs",
    Folder = "WindUI_Smart_v14",
    Size = UDim2.fromOffset(580, 500), -- Slightly taller for new UI
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    OpenButton = nil 
})

local FarmTab = Window:Tab({ Title = "Auto Farm", Icon = "skull" })
local BossTab = Window:Tab({ Title = "Boss Farm", Icon = "crown" })
local DungeonTab = Window:Tab({ Title = "Dungeon", Icon = "castle" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

--// --- FARM TAB (Redesigned) --- //--

local TargetSection = FarmTab:Section({ Title = "Target Builder" })

-- 1. Select Island
local IslandDropdown = TargetSection:Dropdown({
    Title = "1. Select Island",
    Desc = "Choose a folder to scan.",
    Values = getIslands(),
    Value = nil,
    Callback = function(val)
        CurrentSelectedIsland = val
        -- Auto Refresh Mob List when Island Changes
        local mobs = getMobsInIsland(val)
        -- We need to access the MobDropdown to refresh it.
        -- WindUI doesn't make variable access easy, so we rely on user clicking "Refresh Mobs" 
        -- OR we just re-render the dropdown if library allows (WindUI usually doesn't dynamic update well without user interaction)
    end
})

-- 2. Select Mobs (Context aware)
local MobDropdown = TargetSection:Dropdown({
    Title = "2. Select Mobs",
    Desc = "Mobs found in selected island.",
    Multi = true,
    Values = {}, -- Empty initially
    Value = {},
    Callback = function(val)
        CurrentSelectedMobs = val
    end
})

-- Refresh Button (Critical for this flow)
TargetSection:Button({
    Title = "Refresh Mobs List",
    Desc = "Click after changing Island",
    Icon = "refresh-cw",
    Callback = function()
        if CurrentSelectedIsland then
            local mobs = getMobsInIsland(CurrentSelectedIsland)
            MobDropdown:Refresh(mobs, {})
        else
            WindUI:Notify({ Title = "Error", Content = "Select an Island first!", Duration = 3 })
        end
    end
})

-- 3. Add to List
TargetSection:Button({
    Title = "3. Add Selection to Farm List",
    Icon = "plus",
    Callback = function()
        if not CurrentSelectedIsland or #CurrentSelectedMobs == 0 then
            WindUI:Notify({ Title = "Error", Content = "Select an Island and Mobs first.", Duration = 3 })
            return
        end
        
        -- Resolve Folder Instance
        local main = Workspace:FindFirstChild("Main")
        local folderInst = main
        if CurrentSelectedIsland ~= "Main (Global)" then
            folderInst = main:FindFirstChild(CurrentSelectedIsland)
        end
        
        if not folderInst then return end

        -- Add to logic table
        local count = 0
        for _, mobName in ipairs(CurrentSelectedMobs) do
            table.insert(FarmList, {
                Name = mobName,
                Folder = folderInst,
                FolderName = CurrentSelectedIsland -- For display/debug
            })
            count = count + 1
        end
        
        TargetCache = {} -- Reset cache
        WindUI:Notify({ Title = "Added", Content = "Added " .. count .. " mobs from " .. CurrentSelectedIsland, Duration = 2 })
    end
})

-- Status & Clear
local ListSection = FarmTab:Section({ Title = "Current Farm List" })

ListSection:Button({
    Title = "Clear Farm List",
    Icon = "trash",
    Callback = function()
        FarmList = {}
        TargetCache = {}
        WindUI:Notify({ Title = "Cleared", Content = "Farm list is empty.", Duration = 2 })
    end
})

FarmTab:Section({ Title = "Control" })
FarmTab:Toggle({ Title = "Enable Auto Farm", Flag = "AutoFarm", Callback = function(val) IsFarming = val; TargetCache = {}; LastTargetFoundTime = tick(); if val then IsBossFarming = false; IsDungeonFarming = false end end })

--// --- BOSS TAB --- //--

local BossSection = BossTab:Section({ Title = "Boss Selection" })
local BossListNames = {"Benimaru", "Arthur Boyle", "Shinra", "Joker"}
local BossDropdown = BossSection:Dropdown({
    Title = "Select Bosses", Desc = "Prioritizes Top to Bottom.", Multi = true, Values = BossListNames, Value = {}, Flag = "BossList",
    Callback = function(val) BossPriorityList = val end
})
BossSection:Button({ Title = "Clear Selection", Icon = "trash", Callback = function() BossPriorityList = {}; BossDropdown:Refresh(BossListNames, {}) end })
BossTab:Section({ Title = "Control" })
BossTab:Toggle({ Title = "Enable Boss Farm", Flag = "BossFarm", Callback = function(val) IsBossFarming = val; if val then IsFarming = false; IsDungeonFarming = false end end })

--// --- DUNGEON TAB --- //--

local DungeonControl = DungeonTab:Section({ Title = "Dungeon Controls" })
DungeonControl:Toggle({ Title = "Auto Farm Dungeon", Desc = "Farms EVERYTHING in Workspace.Main", Flag = "DungeonFarm", Callback = function(val) IsDungeonFarming = val; if val then IsFarming = false; IsBossFarming = false end end })

--// --- SETTINGS TAB --- //--

local GeneralSection = SettingsTab:Section({ Title = "General" })
GeneralSection:Button({
    Title = "Redeem All Codes", Desc = "Scans CodeData.", Icon = "ticket",
    Callback = function()
        local codeData = LocalPlayer:FindFirstChild("CodeData")
        if not codeData then return end
        local count = 0
        for _, item in pairs(codeData:GetChildren()) do
            if item:IsA("BoolValue") and item.Value == false then
                sendChat("!code " .. item.Name)
                count = count + 1
                task.wait(0.5)
            end
        end
        WindUI:Notify({ Title = "Success", Content = "Sent " .. count .. " codes.", Duration = 4 })
    end
})

local WeaponSection = SettingsTab:Section({ Title = "Weapon" })
local WeaponDropdown = WeaponSection:Dropdown({ Title = "Select Weapon", Desc = "Select 'None' to unequip.", Values = getWeapons(), Value = nil, Flag = "SelectedWeapon", Callback = function(val) SelectedWeaponName = val end })
WeaponSection:Button({ Title = "Refresh Weapons", Icon = "refresh-ccw", Callback = function() WeaponDropdown:Refresh(getWeapons()) end })

local CombatSection = SettingsTab:Section({ Title = "Combat Logic" })
CombatSection:Dropdown({ Title = "Position", Values = {"Top", "Under", "Behind"}, Value = "Top", Flag = "FarmPos", Callback = function(val) FarmingPosition = val end })
CombatSection:Slider({ Title = "Distance", Value = { Min = 0, Max = 20, Default = 7 }, Flag = "FarmDist", Callback = function(val) FarmingDistance = val end })
local SkillDropdown = CombatSection:Dropdown({ Title = "Auto Skills", Multi = true, Values = {"Z", "X", "C", "V", "F", "B"}, Value = {}, Flag = "FarmSkills", Callback = function(val) SelectedAbilities = val end })
CombatSection:Button({ Title = "Clear Skills", Icon = "trash", Callback = function() SelectedAbilities = {}; SkillDropdown:Refresh({"Z", "X", "C", "V", "F", "B"}, {}) end })

--// --- TOGGLE BUTTON --- //--

task.spawn(function()
    local toggleGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    toggleGui.Name = "WindUI_Toggle"
    local toggleBtn = Instance.new("TextButton", toggleGui)
    toggleBtn.Name = "ToggleBtn"; toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, -25); toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Text = "UI"; toggleBtn.TextColor3 = Color3.new(1,1,1); toggleBtn.AutoButtonColor = true
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)
    MakeDraggable(toggleBtn)
    toggleBtn.MouseButton1Click:Connect(function() Window:Toggle() end)
end)


--// === OPTIMIZED LOGIC === //--

local function ForceLoadMap()
    -- Only works if we have at least one thing in the farm list
    if #FarmList > 0 then
        local targetInfo = FarmList[1] -- Pick the first zone we want to farm
        local folder = targetInfo.Folder
        
        if folder then
            -- Find a random part in this folder to teleport to
            local parts = {}
            for _, v in pairs(folder:GetDescendants()) do
                if v:IsA("BasePart") then table.insert(parts, v) end
            end
            
            if #parts > 0 then
                local randomPart = parts[math.random(1, #parts)]
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    -- TP 10 studs above to be safe
                    Character.HumanoidRootPart.CFrame = randomPart.CFrame * CFrame.new(0, 10, 0)
                    WindUI:Notify({ Title = "Anti-Stuck", Content = "Teleported to reload NPCs.", Duration = 2 })
                end
            end
        end
    end
end

local function GetNextTarget()
    -- 1. Check Cache
    for i = #TargetCache, 1, -1 do
        local mob = TargetCache[i]
        if mob and mob.Parent and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            table.remove(TargetCache, i) 
            LastTargetFoundTime = tick() -- Reset timer
            return mob
        else
            table.remove(TargetCache, i) 
        end
    end

    -- 2. Scan Logic
    if IsDungeonFarming then
        local main = Workspace:FindFirstChild("Main")
        if main then
            local targets = main:GetDescendants()
            for _, obj in pairs(targets) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                    if not obj:FindFirstChild("DamageCounter") and obj.Name ~= LocalPlayer.Name then
                        table.insert(TargetCache, obj)
                    end
                end
            end
        end
    end

    if IsBossFarming then
        local main = Workspace:FindFirstChild("Main")
        if main then
            local targets = main:GetDescendants()
            -- Priority: TOP TO BOTTOM (ipairs)
            for _, name in ipairs(BossPriorityList) do
                if name == "Benimaru" then
                    for _, obj in pairs(targets) do
                        if (obj.Name == "Benimaru Clone" or obj.Name == "Benimaru Clone2") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                            return obj
                        end
                    end
                else
                    for _, obj in pairs(targets) do
                        if obj.Name == name and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                            return obj
                        end
                    end
                end
            end
        end
        return nil -- Bosses don't cache, we return direct
    end

    if IsFarming then
        -- THIS IS THE OPTIMIZATION: Only scan folders in FarmList
        -- Priority: First Added = First Killed (Top to Bottom)
        for _, farmData in ipairs(FarmList) do
            local folder = farmData.Folder
            local mobName = farmData.Name
            
            if folder then
                -- Scan ONLY this folder
                for _, obj in pairs(folder:GetDescendants()) do
                    if obj.Name == mobName and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                        table.insert(TargetCache, obj)
                    end
                end
            end
        end
    end

    -- 3. Return from Cache
    if #TargetCache > 0 then
        -- Sort by distance
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            table.sort(TargetCache, function(a, b)
                local distA = (a.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                local distB = (b.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                return distA < distB
            end)
        end
        
        local mob = TargetCache[1]
        table.remove(TargetCache, 1)
        LastTargetFoundTime = tick() -- Reset timer
        return mob
    end

    return nil
end

local function SpawnBenimaru()
    local spawner = Workspace:FindFirstChild("Npc") and Workspace.Npc:FindFirstChild("BenimaruSpawner")
    if spawner then
        local part = spawner:FindFirstChild("Head") or spawner:FindFirstChild("HumanoidRootPart") or spawner
        if part and Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 0, 3)
            Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            task.wait(0.5)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(1.5)
        end
    end
end

-- // SKILL LOOP // --
task.spawn(function()
    while true do
        task.wait(0.1)
        if ActiveTarget and ActiveTarget:FindFirstChild("Humanoid") and ActiveTarget.Humanoid.Health > 0 and (IsFarming or IsBossFarming or IsDungeonFarming) then
            if #SelectedAbilities > 0 then
                for _, key in ipairs(SelectedAbilities) do
                    if not ActiveTarget or ActiveTarget.Humanoid.Health <= 0 then break end
                    pressKey(key)
                    task.wait(0.8)
                end
            end
        end
    end
end)

-- // MAIN MOVEMENT LOOP // --
task.spawn(function()
    while true do
        task.wait() 

        if IsFarming or IsBossFarming or IsDungeonFarming then
            Character = LocalPlayer.Character
            
            -- Haki
            local mainFolder = Workspace:FindFirstChild("Main")
            if mainFolder then
                local playerFolder = mainFolder:FindFirstChild(LocalPlayer.Name)
                if playerFolder and not playerFolder:FindFirstChild("HakiActive") then
                    pressKey("T")
                end
            end

            -- Find Target
            local target = GetNextTarget()
            
            -- Anti-Stuck / Load Map Logic (Only for Normal Farm)
            if not target and IsFarming then
                if tick() - LastTargetFoundTime > 10 then
                    ForceLoadMap()
                    LastTargetFoundTime = tick() -- Reset so we don't spam TP
                    task.wait(1) -- Wait for load
                end
            end

            -- Benimaru Spawn Logic
            if not target and IsBossFarming and table.find(BossPriorityList, "Benimaru") then
                SpawnBenimaru()
                target = GetNextTarget()
            end

            -- Combat Lock-on
            if target and target:FindFirstChild("Humanoid") and target:FindFirstChild("HumanoidRootPart") then
                ActiveTarget = target
                local hum = target.Humanoid
                local root = target.HumanoidRootPart
                
                while hum.Health > 0 and (IsFarming or IsBossFarming or IsDungeonFarming) do
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                         local Offset = CFrame.new(0, 0, 0)
                         if FarmingPosition == "Top" then Offset = CFrame.new(0, FarmingDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                         elseif FarmingPosition == "Under" then Offset = CFrame.new(0, -FarmingDistance, 0) * CFrame.Angles(math.rad(90), 0, 0)
                         elseif FarmingPosition == "Behind" then Offset = CFrame.new(0, 0, FarmingDistance)
                         else Offset = CFrame.new(0, FarmingDistance, 0) end
                         
                         Character.HumanoidRootPart.CFrame = root.CFrame * Offset
                         Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    end
                    EquipWeapon()
                    AttackM1()
                    task.wait() 
                end
                ActiveTarget = nil
            else
                ActiveTarget = nil
            end
        else
            ActiveTarget = nil
            task.wait(0.5) 
        end
    end
end)
