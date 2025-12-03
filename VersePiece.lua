local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

--// Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

--// Variables
local IsFarming = false
local IsDungeonFarming = false
local CurrentTarget = nil
local DungeonTarget = nil

--// Settings (Defaults)
local SelectedWeaponName = nil
local FarmingPosition = "Top"
local FarmingDistance = 7
local SelectedAbilities = {}
local TargetPriorityList = {}

--// --- HELPER FUNCTIONS --- //--

local function debugPrint(msg)
    print("[AutoFarm]: " .. tostring(msg))
end

local function pressKey(keyName)
    local key = Enum.KeyCode[keyName]
    if key then
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, key, false, game)
    end
end

-- Make Draggable Button
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

-- Get Unique Mobs from Workspace
local function getMobs()
    local mobs = {}
    local seen = {}
    local mainFolder = Workspace:FindFirstChild("Main")
    
    if mainFolder then
        -- Deep Scan (GetDescendants) to find NPCs inside sub-folders
        for _, obj in pairs(mainFolder:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= LocalPlayer.Name then
                -- Only add if not a player (Players usually have DamageCounter)
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

-- Get Unique Weapons
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
    Title = "Auto Farm + Dungeon",
    Icon = "sword",
    Author = ".ftgs",
    Folder = "WindUI_Config_v9",
    Size = UDim2.fromOffset(580, 480),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    OpenButton = nil 
})

local FarmTab = Window:Tab({ Title = "Auto Farm", Icon = "skull" })
local DungeonTab = Window:Tab({ Title = "Dungeon", Icon = "castle" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

--// --- AUTO FARM TAB --- //--

local TargetSection = FarmTab:Section({ Title = "Target Selection" })

local MobDropdown = TargetSection:Dropdown({
    Title = "Select Mobs",
    Desc = "Normal Farm Only. Multi-select available.",
    Multi = true,
    Values = getMobs(),
    Value = {},
    Flag = "MobList",
    Callback = function(val)
        TargetPriorityList = val
    end
})

TargetSection:Button({
    Title = "Refresh Mobs",
    Icon = "refresh-cw",
    Callback = function()
        MobDropdown:Refresh(getMobs())
    end
})

FarmTab:Section({ Title = "Control" })

FarmTab:Toggle({
    Title = "Enable Auto Farm",
    Flag = "AutoFarm",
    Callback = function(val)
        IsFarming = val
        if not val then
            CurrentTarget = nil
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    end
})

--// --- DUNGEON TAB --- //--

local DungeonStatus = DungeonTab:Section({ Title = "Status" })
local StatusLabel = DungeonStatus:Paragraph({ Title = "State", Desc = "Idle" })

local DungeonControl = DungeonTab:Section({ Title = "Dungeon Controls" })

DungeonControl:Toggle({
    Title = "Auto Farm Dungeon",
    Desc = "Farms ALL mobs in Workspace.Main",
    Flag = "DungeonFarm",
    Callback = function(val)
        IsDungeonFarming = val
        if not val then 
            DungeonTarget = nil
            StatusLabel:SetTitle("State: Idle")
        else
            StatusLabel:SetTitle("State: Scanning...")
        end
    end
})

--// --- SETTINGS TAB --- //--

local WeaponSection = SettingsTab:Section({ Title = "Weapon" })

local WeaponDropdown = WeaponSection:Dropdown({
    Title = "Select Weapon",
    Desc = "Select your tool.",
    Values = getWeapons(),
    Value = nil,
    Flag = "SelectedWeapon",
    Callback = function(val)
        SelectedWeaponName = val
    end
})

WeaponSection:Button({
    Title = "Refresh Weapons",
    Icon = "refresh-ccw",
    Callback = function()
        WeaponDropdown:Refresh(getWeapons())
    end
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

--// --- CONFIGURATION SECTION --- //--

local ConfigSection = SettingsTab:Section({ Title = "Configuration" })
local ConfigManager = Window.ConfigManager
ConfigManager:Init(Window)

local ConfigNameInput = ConfigSection:Input({
    Title = "Config Name",
    Value = "Default",
    ClearTextOnFocus = false
})

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
    -- Character Validity Check
    Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Humanoid or Humanoid.Health <= 0 then return end

    -- === MASTER SWITCH ===
    -- If no farming mode is active, STOP HERE.
    -- This prevents Haki checking and Weapon Equipping when idle.
    if not IsFarming and not IsDungeonFarming then return end

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
            -- Attack (Only if targeted)
            if (IsFarming and CurrentTarget) or (IsDungeonFarming and DungeonTarget) then
                Tool:Activate()
            end
        end
    end

    -- 3. Target Logic
    local TargetToAttack = nil

    -- DUNGEON FARM (ALL NPCs)
    if IsDungeonFarming then
        if not DungeonTarget or not DungeonTarget.Parent or not DungeonTarget:FindFirstChild("Humanoid") or DungeonTarget.Humanoid.Health <= 0 then
            DungeonTarget = nil
            if mainFolder then
                -- Deep scan for ANY Humanoid in Workspace.Main
                for _, obj in pairs(mainFolder:GetDescendants()) do
                    if obj:IsA("Humanoid") and obj.Health > 0 then
                        local model = obj.Parent
                        if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
                            -- Check DamageCounter to verify it's not a player
                            if not model:FindFirstChild("DamageCounter") then
                                DungeonTarget = model
                                StatusLabel:SetTitle("Attacking: " .. model.Name)
                                break
                            end
                        end
                    end
                end
            end
        end
        TargetToAttack = DungeonTarget

    -- NORMAL FARM (Selected NPCs)
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
        if (IsFarming or IsDungeonFarming) then
            RootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)
