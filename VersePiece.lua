local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

--// Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

--// Variables
local IsFarming = false
local IsBossFarming = false
local IsDungeonFarming = false
local CurrentTarget = nil
local DungeonTarget = nil

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

-- Send Chat Message (Supports Legacy and TextChatService)
local function sendChat(msg)
    -- Method 1: Legacy Chat (Most common for commands like !code)
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    local sayMessage = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")
    if sayMessage then
        sayMessage:FireServer(msg, "All")
        return
    end

    -- Method 2: TextChatService (Newer games)
    if TextChatService.ChatInputBarConfiguration.TargetTextChannel then
        TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(msg)
    end
end

-- Draggable Button Logic
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

-- Get Weapons
local function getWeapons()
    local tools = {}
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
    table.sort(tools)
    return tools
end

--// --- UI SETUP --- //--

local Window = WindUI:CreateWindow({
    Title = "Auto Farm + Codes | v8",
    Icon = "sword",
    Author = ".ftgs",
    Folder = "WindUI_Codes_v8",
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

--// --- AUTO FARM TAB --- //--

local TargetSection = FarmTab:Section({ Title = "Normal Targets" })

local MobDropdown = TargetSection:Dropdown({
    Title = "Select Mobs",
    Desc = "Normal Farm Only.",
    Multi = true,
    Values = getMobs(),
    Value = {},
    Flag = "MobList",
    Callback = function(val) TargetPriorityList = val end
})

TargetSection:Button({
    Title = "Refresh Mobs",
    Icon = "refresh-cw",
    Callback = function() MobDropdown:Refresh(getMobs()) end
})

FarmTab:Section({ Title = "Control" })

FarmTab:Toggle({
    Title = "Enable Auto Farm",
    Flag = "AutoFarm",
    Callback = function(val)
        IsFarming = val
        if val then IsBossFarming = false; IsDungeonFarming = false end
        if not val then
            CurrentTarget = nil
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    end
})

--// --- BOSS FARM TAB --- //--

local BossSection = BossTab:Section({ Title = "Boss Selection" })

local BossList = {"Benimaru", "Arthur Boyle", "Shinra", "Joker"}
local ScannedMobs = getMobs()
for _, mob in ipairs(ScannedMobs) do
    if not table.find(BossList, mob) then table.insert(BossList, mob) end
end

local BossDropdown = BossSection:Dropdown({
    Title = "Select Bosses",
    Desc = "Prioritizes Bottom to Top.",
    Multi = true,
    Values = BossList,
    Value = {},
    Flag = "BossList",
    Callback = function(val) BossPriorityList = val end
})

BossTab:Section({ Title = "Control" })

BossTab:Toggle({
    Title = "Enable Boss Farm",
    Flag = "BossFarm",
    Callback = function(val)
        IsBossFarming = val
        if val then IsFarming = false; IsDungeonFarming = false end
        if not val then CurrentTarget = nil end
    end
})

--// --- DUNGEON TAB --- //--

local DungeonStatus = DungeonTab:Section({ Title = "Status" })
local StatusLabel = DungeonStatus:Paragraph({ Title = "State", Desc = "Idle" })

local DungeonControl = DungeonTab:Section({ Title = "Dungeon Controls" })

DungeonControl:Toggle({
    Title = "Auto Farm Dungeon",
    Desc = "Farms EVERYTHING in Workspace.Main",
    Flag = "DungeonFarm",
    Callback = function(val)
        IsDungeonFarming = val
        if val then IsFarming = false; IsBossFarming = false end
        if not val then 
            DungeonTarget = nil
            StatusLabel:SetTitle("State: Idle")
        else
            StatusLabel:SetTitle("State: Scanning...")
        end
    end
})

--// --- SETTINGS TAB --- //--

local GeneralSection = SettingsTab:Section({ Title = "General" })

-- [ NEW FEATURE ] Redeem Codes Button
GeneralSection:Button({
    Title = "Redeem All Codes",
    Desc = "Scans CodeData and redeems unclaim codes.",
    Icon = "ticket",
    Callback = function()
        local codeData = LocalPlayer:FindFirstChild("CodeData")
        if not codeData then
            WindUI:Notify({ Title = "Error", Content = "CodeData folder not found!", Duration = 3 })
            return
        end
        
        local count = 0
        for _, item in pairs(codeData:GetChildren()) do
            if item:IsA("BoolValue") and item.Value == false then
                local codeName = item.Name
                -- Send Code to Chat
                sendChat("!code " .. codeName)
                count = count + 1
                task.wait(0.5) -- Delay to prevent kick/spam filter
            end
        end
        
        if count > 0 then
            WindUI:Notify({ Title = "Success", Content = "Sent " .. count .. " codes to chat.", Duration = 4 })
        else
            WindUI:Notify({ Title = "Info", Content = "No unredeemed codes found.", Duration = 3 })
        end
    end
})

local WeaponSection = SettingsTab:Section({ Title = "Weapon" })

local WeaponDropdown = WeaponSection:Dropdown({
    Title = "Select Weapon",
    Desc = "Select your tool.",
    Values = getWeapons(),
    Value = nil,
    Flag = "SelectedWeapon",
    Callback = function(val) SelectedWeaponName = val end
})

WeaponSection:Button({
    Title = "Refresh Weapons",
    Icon = "refresh-ccw",
    Callback = function() WeaponDropdown:Refresh(getWeapons()) end
})

local CombatSection = SettingsTab:Section({ Title = "Combat Logic" })

CombatSection:Dropdown({
    Title = "Position",
    Values = {"Top", "Under", "Behind"},
    Value = "Top",
    Flag = "FarmPos",
    Callback = function(val) FarmingPosition = val end
})

CombatSection:Slider({
    Title = "Distance",
    Value = { Min = 0, Max = 20, Default = 7 },
    Flag = "FarmDist",
    Callback = function(val) FarmingDistance = val end
})

CombatSection:Dropdown({
    Title = "Auto Skills",
    Multi = true,
    Values = {"Z", "X", "C", "V", "F", "B"},
    Value = {},
    Flag = "FarmSkills",
    Callback = function(val) SelectedAbilities = val end
})

--// --- CONFIGURATION --- //--

local ConfigSection = SettingsTab:Section({ Title = "Configuration" })
local ConfigManager = Window.ConfigManager
ConfigManager:Init(Window)

local ConfigNameInput = ConfigSection:Input({ Title = "Config Name", Value = "Default", ClearTextOnFocus = false })

ConfigSection:Button({
    Title = "Save Config",
    Icon = "save",
    Callback = function()
        local name = ConfigNameInput.ElementFrame.Frame.TextBox.Text
        if name == "" then name = "Default" end
        local config = ConfigManager:CreateConfig(name)
        config:Save()
        WindUI:Notify({ Title = "Saved", Content = "Config saved: " .. name, Duration = 2 })
    end
})

ConfigSection:Button({
    Title = "Load Config",
    Icon = "file-up",
    Callback = function()
        local name = ConfigNameInput.ElementFrame.Frame.TextBox.Text
        if name == "" then name = "Default" end
        local config = ConfigManager:CreateConfig(name)
        if config:Load() then
            WindUI:Notify({ Title = "Loaded", Content = "Config loaded: " .. name, Duration = 2 })
        end
    end
})

--// --- TOGGLE BUTTON --- //--

task.spawn(function()
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "WindUI_Toggle"
    toggleGui.Parent = game:GetService("CoreGui")
    if not toggleGui.Parent then toggleGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Parent = toggleGui
    toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
    toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Text = "UI"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 18
    toggleBtn.AutoButtonColor = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleBtn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.8
    stroke.Parent = toggleBtn
    
    MakeDraggable(toggleBtn)
    
    toggleBtn.MouseButton1Click:Connect(function()
        Window:Toggle()
    end)
end)

--// --- MAIN LOGIC LOOP --- //--

RunService.Heartbeat:Connect(function()
    Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Humanoid or Humanoid.Health <= 0 then return end

    if not IsFarming and not IsBossFarming and not IsDungeonFarming then return end

    -- 1. Haki
    local mainFolder = Workspace:FindFirstChild("Main")
    if mainFolder then
        local playerFolder = mainFolder:FindFirstChild(LocalPlayer.Name)
        if playerFolder and not playerFolder:FindFirstChild("HakiActive") then
            pressKey("T")
        end
    end

    -- 2. Equip
    if SelectedWeaponName then
        local Tool = Character:FindFirstChild(SelectedWeaponName)
        if not Tool then
            local Backpack = LocalPlayer:FindFirstChild("Backpack")
            if Backpack and Backpack:FindFirstChild(SelectedWeaponName) then
                Humanoid:EquipTool(Backpack[SelectedWeaponName])
            end
        else
            if (IsFarming or IsBossFarming or IsDungeonFarming) and (CurrentTarget or DungeonTarget) then
                Tool:Activate()
            end
        end
    end

    -- 3. Target Logic
    local TargetToAttack = nil

    if IsDungeonFarming then
        if not DungeonTarget or not DungeonTarget.Parent or not DungeonTarget:FindFirstChild("Humanoid") or DungeonTarget.Humanoid.Health <= 0 then
            DungeonTarget = nil
            if mainFolder then
                for _, obj in pairs(mainFolder:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                        if not obj:FindFirstChild("DamageCounter") and obj.Name ~= LocalPlayer.Name then
                            DungeonTarget = obj
                            StatusLabel:SetTitle("Attacking: " .. obj.Name)
                            break
                        end
                    end
                end
            end
        end
        TargetToAttack = DungeonTarget

    elseif IsBossFarming then
        if not CurrentTarget or not CurrentTarget.Parent or not CurrentTarget:FindFirstChild("Humanoid") or CurrentTarget.Humanoid.Health <= 0 then
            CurrentTarget = nil
            
            for i = #BossPriorityList, 1, -1 do
                local bossName = BossPriorityList[i]
                if CurrentTarget then break end
                
                if bossName == "Benimaru" then
                    local foundClone = false
                    for _, obj in pairs(mainFolder:GetDescendants()) do
                        if (obj.Name == "Benimaru Clone" or obj.Name == "Benimaru Clone2") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                            CurrentTarget = obj
                            foundClone = true
                            break
                        end
                    end
                    
                    if not foundClone then
                        local spawner = Workspace:FindFirstChild("Npc") and Workspace.Npc:FindFirstChild("BenimaruSpawner")
                        if spawner then
                            local part = spawner:FindFirstChild("Head") or spawner:FindFirstChild("HumanoidRootPart") or spawner
                            if part then
                                Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 0, 3)
                                Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                                task.wait(0.5)
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                task.wait(0.1)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                task.wait(3)
                                return
                            end
                        end
                    end
                else
                    if mainFolder then
                        for _, obj in pairs(mainFolder:GetDescendants()) do
                            if obj.Name == bossName and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                                CurrentTarget = obj
                                break
                            end
                        end
                    end
                end
            end
        end
        TargetToAttack = CurrentTarget

    elseif IsFarming then
        if not CurrentTarget or not CurrentTarget.Parent or not CurrentTarget:FindFirstChild("Humanoid") or CurrentTarget.Humanoid.Health <= 0 then
            CurrentTarget = nil
            for _, name in ipairs(TargetPriorityList) do
                if CurrentTarget then break end
                if mainFolder then
                    for _, obj in pairs(mainFolder:GetDescendants()) do
                        if obj.Name == name and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                            CurrentTarget = obj
                            break
                        end
                    end
                end
            end
        end
        TargetToAttack = CurrentTarget
    end

    -- 4. Movement & Skills
    if TargetToAttack and TargetToAttack:FindFirstChild("HumanoidRootPart") then
        local TargetRoot = TargetToAttack.HumanoidRootPart
        local Offset = CFrame.new(0, 0, 0)

        if FarmingPosition == "Top" then
            Offset = CFrame.new(0, FarmingDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
        elseif FarmingPosition == "Under" then
            Offset = CFrame.new(0, -FarmingDistance, 0) * CFrame.Angles(math.rad(90), 0, 0)
        elseif FarmingPosition == "Behind" then
            Offset = CFrame.new(0, 0, FarmingDistance)
        else
            Offset = CFrame.new(0, FarmingDistance, 0)
        end

        RootPart.CFrame = TargetRoot.CFrame * Offset
        RootPart.Velocity = Vector3.new(0, 0, 0)

        for _, key in ipairs(SelectedAbilities) do
            pressKey(key)
        end
    else
        if (IsFarming or IsBossFarming or IsDungeonFarming) then
            RootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)
