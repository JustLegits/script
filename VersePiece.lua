local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

--// Variables
local IsFarming = false
local IsBossFarming = false
local IsDungeonFarming = false
local ActiveTarget = nil -- Global target variable for skill loop

--// Settings
local SelectedWeaponName = nil
local FarmingPosition = "Top"
local FarmingDistance = 7
local SelectedAbilities = {}
local TargetPriorityList = {}
local BossPriorityList = {}

--// --- HELPER FUNCTIONS --- //--

local function debugPrint(msg)
    warn("[AutoFarm]: " .. tostring(msg))
end

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

-- Equip Weapon (Updated for "None")
local function EquipWeapon()
    if not Character or not Character:FindFirstChild("Humanoid") then return end
    
    if SelectedWeaponName == "None" then
        Character.Humanoid:UnequipTools()
        return
    end

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

-- M1 Attack Only (Fast)
local function AttackM1()
    if SelectedWeaponName and SelectedWeaponName ~= "None" and Character then
        local Tool = Character:FindFirstChild(SelectedWeaponName)
        if Tool then
            Tool:Activate()
        end
    end
end

-- Draggable
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

-- Get Mobs
local function getMobs()
    local mobs = {}
    local seen = {}
    local mainFolder = Workspace:FindFirstChild("Main")
    if mainFolder then
        for _, obj in pairs(mainFolder:GetDescendants()) do
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

-- Get Weapons (Adds "None" option)
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
    Title = "Auto Farm | Select Fix v12",
    Icon = "sword",
    Author = ".ftgs",
    Folder = "WindUI_SelectFix_v12",
    Size = UDim2.fromOffset(580, 480),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    OpenButton = nil 
})

local FarmTab = Window:Tab({ Title = "Auto Farm", Icon = "skull" })
local BossTab = Window:Tab({ Title = "Boss Farm", Icon = "crown" })
local DungeonTab = Window:Tab({ Title = "Dungeon", Icon = "castle" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

--// --- UI ELEMENTS --- //--

-- Farm Tab
local TargetSection = FarmTab:Section({ Title = "Normal Targets" })
local MobDropdown = TargetSection:Dropdown({
    Title = "Select Mobs", Desc = "Normal Farm Only.", Multi = true, Values = getMobs(), Value = {}, Flag = "MobList",
    Callback = function(val) TargetPriorityList = val end
})

-- Clear & Refresh Buttons
local MobBtnGroup = TargetSection:Group({Orientation = "Horizontal"})
MobBtnGroup:Button({ Title = "Refresh Mobs", Icon = "refresh-cw", Callback = function() MobDropdown:Refresh(getMobs(), TargetPriorityList) end })
MobBtnGroup:Button({ Title = "Clear Selection", Icon = "trash", Callback = function() 
    TargetPriorityList = {}
    MobDropdown:Refresh(getMobs(), {}) -- Resets selection
end })

FarmTab:Section({ Title = "Control" })
FarmTab:Toggle({
    Title = "Enable Auto Farm", Flag = "AutoFarm",
    Callback = function(val) IsFarming = val; if val then IsBossFarming = false; IsDungeonFarming = false end end
})

-- Boss Tab
local BossSection = BossTab:Section({ Title = "Boss Selection" })
local BossList = {"Benimaru", "Arthur Boyle", "Shinra", "Joker"}
local ScannedMobs = getMobs()
for _, mob in ipairs(ScannedMobs) do if not table.find(BossList, mob) then table.insert(BossList, mob) end end

local BossDropdown = BossSection:Dropdown({
    Title = "Select Bosses", Desc = "Prioritizes Bottom to Top.", Multi = true, Values = BossList, Value = {}, Flag = "BossList",
    Callback = function(val) BossPriorityList = val end
})

-- Clear Button for Bosses
BossSection:Button({ Title = "Clear Selection", Icon = "trash", Callback = function() 
    BossPriorityList = {}
    BossDropdown:Refresh(BossList, {}) 
end })

BossTab:Section({ Title = "Control" })
BossTab:Toggle({
    Title = "Enable Boss Farm", Flag = "BossFarm",
    Callback = function(val) IsBossFarming = val; if val then IsFarming = false; IsDungeonFarming = false end end
})

-- Dungeon Tab
local DungeonControl = DungeonTab:Section({ Title = "Dungeon Controls" })
DungeonControl:Toggle({
    Title = "Auto Farm Dungeon", Desc = "Farms EVERYTHING in Workspace.Main", Flag = "DungeonFarm",
    Callback = function(val) IsDungeonFarming = val; if val then IsFarming = false; IsBossFarming = false end end
})

-- Settings Tab
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
local WeaponDropdown = WeaponSection:Dropdown({
    Title = "Select Weapon", Desc = "Select 'None' to unequip.", Values = getWeapons(), Value = nil, Flag = "SelectedWeapon",
    Callback = function(val) SelectedWeaponName = val end
})
WeaponSection:Button({ Title = "Refresh Weapons", Icon = "refresh-ccw", Callback = function() WeaponDropdown:Refresh(getWeapons()) end })

local CombatSection = SettingsTab:Section({ Title = "Combat Logic" })
CombatSection:Dropdown({ Title = "Position", Values = {"Top", "Under", "Behind"}, Value = "Top", Flag = "FarmPos", Callback = function(val) FarmingPosition = val end })
CombatSection:Slider({ Title = "Distance", Value = { Min = 0, Max = 20, Default = 7 }, Flag = "FarmDist", Callback = function(val) FarmingDistance = val end })

local SkillDropdown = CombatSection:Dropdown({ Title = "Auto Skills", Multi = true, Values = {"Z", "X", "C", "V", "F", "B"}, Value = {}, Flag = "FarmSkills", Callback = function(val) SelectedAbilities = val end })
-- Clear Skills Button
CombatSection:Button({ Title = "Clear Skills", Icon = "trash", Callback = function() 
    SelectedAbilities = {}
    SkillDropdown:Refresh({"Z", "X", "C", "V", "F", "B"}, {})
end })

-- Config
local ConfigSection = SettingsTab:Section({ Title = "Configuration" })
local ConfigManager = Window.ConfigManager
ConfigManager:Init(Window)
local ConfigNameInput = ConfigSection:Input({ Title = "Config Name", Value = "Default", ClearTextOnFocus = false })
ConfigSection:Button({ Title = "Save Config", Icon = "save", Callback = function() local n = ConfigNameInput.ElementFrame.Frame.TextBox.Text; if n=="" then n="Default" end; ConfigManager:CreateConfig(n):Save(); WindUI:Notify({Title="Saved",Content=n,Duration=2}) end })
ConfigSection:Button({ Title = "Load Config", Icon = "file-up", Callback = function() local n = ConfigNameInput.ElementFrame.Frame.TextBox.Text; if n=="" then n="Default" end; if ConfigManager:CreateConfig(n):Load() then WindUI:Notify({Title="Loaded",Content=n,Duration=2}) end end })

-- Toggle Button
task.spawn(function()
    local toggleGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local toggleBtn = Instance.new("TextButton", toggleGui)
    toggleBtn.Name = "ToggleBtn"; toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, -25); toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Text = "UI"; toggleBtn.TextColor3 = Color3.new(1,1,1); toggleBtn.AutoButtonColor = true
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)
    MakeDraggable(toggleBtn)
    toggleBtn.MouseButton1Click:Connect(function() Window:Toggle() end)
end)


--// === LINEAR FARMING LOGIC === //--

local function FindTarget()
    local mainFolder = Workspace:FindFirstChild("Main")
    if not mainFolder then return nil end
    local targets = mainFolder:GetDescendants() -- Scan Once

    if IsDungeonFarming then
        for _, obj in pairs(targets) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                if not obj:FindFirstChild("DamageCounter") and obj.Name ~= LocalPlayer.Name then
                    return obj
                end
            end
        end
    end

    if IsBossFarming then
        for i = #BossPriorityList, 1, -1 do
            local name = BossPriorityList[i]
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

    if IsFarming then
        for _, name in ipairs(TargetPriorityList) do
            for _, obj in pairs(targets) do
                if obj.Name == name and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                    return obj
                end
            end
        end
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

-- // SEPARATE SKILL LOOP // --
task.spawn(function()
    while true do
        task.wait(0.1) -- Fast tick
        if ActiveTarget and ActiveTarget:FindFirstChild("Humanoid") and ActiveTarget.Humanoid.Health > 0 and (IsFarming or IsBossFarming or IsDungeonFarming) then
            if #SelectedAbilities > 0 then
                for _, key in ipairs(SelectedAbilities) do
                    -- Only press if we still have a target
                    if not ActiveTarget or ActiveTarget.Humanoid.Health <= 0 then break end
                    
                    pressKey(key)
                    task.wait(0.8) -- Delay between skills
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
            local target = FindTarget()
            
            -- Benimaru Spawn
            if not target and IsBossFarming and table.find(BossPriorityList, "Benimaru") then
                SpawnBenimaru()
                target = FindTarget()
            end

            -- Combat Lock-on
            if target and target:FindFirstChild("Humanoid") and target:FindFirstChild("HumanoidRootPart") then
                ActiveTarget = target
                local hum = target.Humanoid
                local root = target.HumanoidRootPart
                
                while hum.Health > 0 and (IsFarming or IsBossFarming or IsDungeonFarming) do
                    -- Update Position
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
