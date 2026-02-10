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
local GuiService = game:GetService("GuiService")

--// Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

--// Variables (Farming)
local IsFarming = false
local IsBossFarming = false
local IsDungeonFarming = false
local ActiveTarget = nil 
local IsSpawningJulius = false -- NEW FLAG

--// Variables (Spinning)
local IsSpinning = false
local DesiredTrait = ""
local LastTraitVal = ""
local TraitStuckCount = 0
local LastTraitCheckTime = 0

--// Settings
local SelectedWeaponName = nil
local FarmingPosition = "Top"
local FarmingDistance = 7
local SelectedAbilities = {}
local BossPriorityList = {}

--// DATA STRUCTURES
local TargetCache = {} 
local LastTargetFoundTime = tick() 
local CurrentSelectedMobs = {} 

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

local function holdKey(keyName, duration)
    local key = Enum.KeyCode[keyName]
    if key then
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        task.wait(duration)
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

local function ClickGuiButton(btn)
    if not btn then return end
    if btn.Visible then
        local pos = btn.AbsolutePosition
        local size = btn.AbsoluteSize
        local inset = GuiService:GetGuiInset() 
        local center = pos + (size / 2) + inset 
        VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 1)
    end
    pcall(function() if firesignal then firesignal(btn.MouseButton1Click) end end)
    pcall(function() for _, connection in pairs(getconnections(btn.MouseButton1Click)) do connection:Fire() end end)
    pcall(function() if btn.Activate then btn:Activate() end end)
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

--// --- SCANNING FUNCTIONS --- //--

local function getMobs()
    local mobs = {}
    local seen = {}
    local main = Workspace:FindFirstChild("Main")
    if main then
        for _, obj in pairs(main:GetDescendants()) do
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

local function getWeapons()
    local tools = {"None"}
    local seen = {}
    local function add(list)
        for _, item in pairs(list) do
            if item:IsA("Tool") and not seen[item.Name] then table.insert(tools, item.Name); seen[item.Name] = true end
        end
    end
    if LocalPlayer:FindFirstChild("Backpack") then add(LocalPlayer.Backpack:GetChildren()) end
    if LocalPlayer.Character then add(LocalPlayer.Character:GetChildren()) end
    return tools
end

--// --- UI SETUP --- //--

local Window = WindUI:CreateWindow({
    Title = "Auto Farm | Julius Fix v22",
    Icon = "sword",
    Author = ".ftgs",
    Folder = "WindUI_v22",
    Size = UDim2.fromOffset(580, 500),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    OpenButton = nil 
})

local FarmTab = Window:Tab({ Title = "Auto Farm", Icon = "skull" })
local BossTab = Window:Tab({ Title = "Boss Farm", Icon = "crown" })
local DungeonTab = Window:Tab({ Title = "Dungeon", Icon = "castle" })
local SpinTab = Window:Tab({ Title = "Spin / Gacha", Icon = "dices" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

--// --- FARM TAB --- //--
local TargetSection = FarmTab:Section({ Title = "Select & Farm" })
local MobDropdown = TargetSection:Dropdown({ 
    Title = "Select Mobs", Desc = "Scans entire map.", Multi = true, Values = getMobs(), Value = {}, 
    Callback = function(val) CurrentSelectedMobs = val; TargetCache = {} end 
})
TargetSection:Button({ Title = "Refresh Mobs List", Icon = "refresh-cw", Callback = function() MobDropdown:Refresh(getMobs(), CurrentSelectedMobs) end })
FarmTab:Section({ Title = "Control" })
FarmTab:Toggle({ Title = "Enable Auto Farm", Flag = "AutoFarm", Callback = function(val) 
    IsFarming = val; TargetCache = {}; LastTargetFoundTime = tick()
    if val then IsBossFarming = false; IsDungeonFarming = false 
        if #CurrentSelectedMobs == 0 then WindUI:Notify({Title="Warning", Content="No mobs selected!", Duration=3}) end
    end 
end })

--// --- BOSS TAB --- //--
local BossSection = BossTab:Section({ Title = "Boss Selection" })
local BossListNames = {"Benimaru", "Arthur Boyle", "Shinra", "Joker", "Yuno", "Julius"}
local BossDropdown = BossSection:Dropdown({ Title = "Select Bosses", Desc = "Top to Bottom.", Multi = true, Values = BossListNames, Value = {}, Flag = "BossList", Callback = function(val) BossPriorityList=val end })
BossSection:Button({ Title = "Clear Selection", Icon = "trash", Callback = function() BossPriorityList={}; BossDropdown:Refresh(BossListNames, {}) end })
BossTab:Section({ Title = "Control" })
BossTab:Toggle({ Title = "Enable Boss Farm", Flag = "BossFarm", Callback = function(val) IsBossFarming=val; if val then IsFarming=false; IsDungeonFarming=false end end })

--// --- DUNGEON TAB --- //--
local DungeonControl = DungeonTab:Section({ Title = "Dungeon Controls" })
DungeonControl:Toggle({ Title = "Auto Farm Dungeon", Desc = "Farms EVERYTHING in Workspace.Main", Flag = "DungeonFarm", Callback = function(val) IsDungeonFarming=val; if val then IsFarming=false; IsBossFarming=false end end })

--// --- SPIN TAB --- //--
local SpinSection = SpinTab:Section({ Title = "Trait Spin" })
SpinSection:Paragraph({ Title = "Requirement", Desc = "Stand near Trait NPC." })
SpinSection:Input({ Title = "Desired Trait", Placeholder = "Godly", ClearTextOnFocus = false, Callback = function(text) DesiredTrait = text end })
local SpinToggle = SpinSection:Toggle({ Title = "Auto Spin Trait", Desc = "Spams E & Auto Confirm.", Callback = function(val) IsSpinning=val; TraitStuckCount=0; LastTraitCheckTime=tick(); if val then WindUI:Notify({Title="Started",Content="Spinning for: "..DesiredTrait,Duration=3}) end end })

--// --- SETTINGS TAB --- //--
local GeneralSection = SettingsTab:Section({ Title = "General" })
GeneralSection:Button({ Title = "Redeem All Codes", Icon = "ticket", Callback = function()
    local codeData = LocalPlayer:FindFirstChild("CodeData")
    if not codeData then return end
    local count = 0
    for _, item in pairs(codeData:GetChildren()) do
        if item:IsA("BoolValue") and item.Value == false then
            sendChat("!code " .. item.Name); count = count + 1; task.wait(0.5)
        end
    end
    WindUI:Notify({Title="Success",Content="Sent "..count.." codes.",Duration=4})
end })
local WeaponSection = SettingsTab:Section({ Title = "Weapon" })
local WeaponDropdown = WeaponSection:Dropdown({ Title = "Select Weapon", Desc = "'None' to unequip.", Values = getWeapons(), Value = nil, Flag = "SelectedWeapon", Callback = function(val) SelectedWeaponName = val end })
WeaponSection:Button({ Title = "Refresh Weapons", Icon = "refresh-ccw", Callback = function() WeaponDropdown:Refresh(getWeapons()) end })
local CombatSection = SettingsTab:Section({ Title = "Combat Logic" })
CombatSection:Dropdown({ Title = "Position", Values = {"Top", "Under", "Behind"}, Value = "Top", Flag = "FarmPos", Callback = function(val) FarmingPosition = val end })
CombatSection:Slider({ Title = "Distance", Value = { Min = 0, Max = 20, Default = 7 }, Flag = "FarmDist", Callback = function(val) FarmingDistance = val end })
local SkillDropdown = CombatSection:Dropdown({ Title = "Auto Skills", Multi = true, Values = {"Z", "X", "C", "V", "F", "B"}, Value = {}, Flag = "FarmSkills", Callback = function(val) SelectedAbilities = val end })
CombatSection:Button({ Title = "Clear Skills", Icon = "trash", Callback = function() SelectedAbilities={}; SkillDropdown:Refresh({"Z", "X", "C", "V", "F", "B"}, {}) end })

--// --- TOGGLE BUTTON --- //--
task.spawn(function()
    local toggleGui = Instance.new("ScreenGui", game:GetService("CoreGui")); toggleGui.Name = "WindUI_Toggle"
    local toggleBtn = Instance.new("TextButton", toggleGui)
    toggleBtn.Name = "ToggleBtn"; toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, -25); toggleBtn.Size = UDim2.new(0, 50, 0, 50)
    toggleBtn.Text = "UI"; toggleBtn.TextColor3 = Color3.new(1,1,1); toggleBtn.AutoButtonColor = true
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10); MakeDraggable(toggleBtn)
    toggleBtn.MouseButton1Click:Connect(function() Window:Toggle() end)
end)

--// === LOGIC FUNCTIONS === //--

local function ForceLoadMap()
    if #CurrentSelectedMobs > 0 then
        local main = Workspace:FindFirstChild("Main")
        if main then
            local parts = {}
            for _, v in pairs(main:GetDescendants()) do if v:IsA("BasePart") then table.insert(parts, v) end end
            if #parts > 0 then
                local randomPart = parts[math.random(1, #parts)]
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    Character.HumanoidRootPart.CFrame = randomPart.CFrame * CFrame.new(0, 10, 0)
                    WindUI:Notify({Title="Anti-Stuck",Content="Teleported to reload NPCs.",Duration=2})
                end
            end
        end
    end
end

-- // SPAWN LOOP (JULIUS FIX) // --
task.spawn(function()
    while true do
        task.wait(2) -- Faster check (2s)
        if IsBossFarming and table.find(BossPriorityList, "Julius") then
            -- 1. Check if Boss is already alive (Priority)
            local bossExists = false
            local main = Workspace:FindFirstChild("Main")
            if main and main:FindFirstChild("Julius") and main.Julius:FindFirstChild("Humanoid") and main.Julius.Humanoid.Health > 0 then
                bossExists = true
            end

            -- 2. If Boss is NOT alive, check requirement to spawn
            if not bossExists then
                local npcFolder = Workspace:FindFirstChild("Npc")
                local misc = npcFolder and npcFolder:FindFirstChild("Misc")
                local juliusNPC = misc and misc:FindFirstChild("Julios Boss")
                
                if juliusNPC then
                    local prompt = juliusNPC:FindFirstChild("ProximityPrompt")
                    if prompt then
                        local text = prompt.ObjectText or prompt.ActionText or ""
                        local countStr = string.match(text, "Defeat%s*(%d+)/100")
                        
                        if countStr then
                            local count = tonumber(countStr)
                            if count and count >= 100 then
                                -- !!! STOP FARMING -> SPAWN BOSS !!!
                                IsSpawningJulius = true 
                                ActiveTarget = nil -- Force break the farming loop
                                
                                WindUI:Notify({Title="Julius Boss", Content="Requirement met! Spawning...", Duration=3})
                                if Character and Character:FindFirstChild("HumanoidRootPart") and juliusNPC:FindFirstChild("HumanoidRootPart") then
                                    -- Teleport
                                    Character.HumanoidRootPart.CFrame = juliusNPC.HumanoidRootPart.CFrame * CFrame.new(0,8,0)
                                    task.wait(0.5)
                                    holdKey("E", 1) -- Hold E longer (1s) to be safe
                                    task.wait(3) -- Wait for spawn animation
                                end
                                IsSpawningJulius = false -- Resume finding targets (which will be the boss now)
                            else
                                IsSpawningJulius = false
                            end
                        end
                    end
                end
            else
                IsSpawningJulius = false
            end
        else
            IsSpawningJulius = false
        end
    end
end)

local function GetNextTarget()
    -- If we are busy spawning Julius, DO NOT pick a target
    if IsSpawningJulius then return nil end

    for i = #TargetCache, 1, -1 do
        local mob = TargetCache[i]
        if mob and mob.Parent and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            table.remove(TargetCache, i); LastTargetFoundTime = tick(); return mob
        else table.remove(TargetCache, i) end
    end

    if IsDungeonFarming then
        local main = Workspace:FindFirstChild("Main")
        if main then
            local targets = main:GetDescendants()
            for _, obj in pairs(targets) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                    if not obj:FindFirstChild("DamageCounter") and obj.Name ~= LocalPlayer.Name then table.insert(TargetCache, obj) end
                end
            end
        end
    end

    if IsBossFarming then
        local main = Workspace:FindFirstChild("Main")
        if main then
            local targets = main:GetDescendants()
            for _, name in ipairs(BossPriorityList) do
                if name == "Benimaru" then
                    for _, obj in pairs(targets) do
                        if (obj.Name == "Benimaru Clone" or obj.Name == "Benimaru Clone2") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then return obj end
                    end
                elseif name == "Yuno" then
                    local village = main:FindFirstChild("Hage Village")
                    if village then
                        local yuno = village:FindFirstChild("Yuno") 
                        if yuno and yuno:FindFirstChild("Humanoid") and yuno.Humanoid.Health > 0 then return yuno end
                    end
                    for _, obj in pairs(targets) do
                        if obj.Name == "Yuno" and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then return obj end
                    end
                elseif name == "Julius" then
                    -- Priority 1: The Boss
                    local juliusBoss = main:FindFirstChild("Julius")
                    if juliusBoss and juliusBoss:FindFirstChild("Humanoid") and juliusBoss.Humanoid.Health > 0 then 
                        return juliusBoss 
                    end
                    
                    -- Priority 2: Farm Aspirants IF NOT SPAWNING
                    if not IsSpawningJulius then
                        for _, obj in pairs(targets) do
                            if obj.Name == "Magic Aspirant" and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then 
                                return obj 
                            end
                        end
                    end
                else
                    for _, obj in pairs(targets) do
                        if obj.Name == name and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then return obj end
                    end
                end
            end
        end
        return nil
    end

    if IsFarming and #CurrentSelectedMobs > 0 then
        local main = Workspace:FindFirstChild("Main")
        if main then
            for _, obj in pairs(main:GetDescendants()) do
                if table.find(CurrentSelectedMobs, obj.Name) and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                     table.insert(TargetCache, obj)
                end
            end
        end
    end

    if #TargetCache > 0 then
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            table.sort(TargetCache, function(a, b)
                local distA = (a.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                local distB = (b.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                return distA < distB
            end)
        end
        local mob = TargetCache[1]; table.remove(TargetCache, 1); LastTargetFoundTime = tick(); return mob
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

-- // SPIN LOOP // --
task.spawn(function()
    while true do
        task.wait(0.1)
        if IsSpinning and DesiredTrait ~= "" then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            if tick() - LastTraitCheckTime >= 1 then
                LastTraitCheckTime = tick()
                local playerData = LocalPlayer:FindFirstChild("PlayerData")
                local info = playerData and playerData:FindFirstChild("Info")
                local traitVal = info and info:FindFirstChild("Trait")
                
                if traitVal then
                    local currentTrait = traitVal.Value
                    if currentTrait == DesiredTrait then
                        IsSpinning = false; SpinToggle:Set(false); WindUI:Notify({Title="Success!",Content="Got: "..currentTrait,Duration=10})
                    end
                    if currentTrait == LastTraitVal then TraitStuckCount = TraitStuckCount + 1 else TraitStuckCount = 0; LastTraitVal = currentTrait end
                    
                    if TraitStuckCount >= 2 then
                        local gui = LocalPlayer:WaitForChild("PlayerGui")
                        if gui:FindFirstChild("Sure") and gui.Sure:FindFirstChild("Main") and gui.Sure.Main:FindFirstChild("Sure") then
                            ClickGuiButton(gui.Sure.Main.Sure)
                            TraitStuckCount = 0; WindUI:Notify({Title="Skipping",Content="Auto-confirmed.",Duration=1})
                        end
                    end
                end
            end
        end
    end
end)

-- // SKILL LOOP // --
task.spawn(function()
    while true do
        task.wait(0.1)
        if ActiveTarget and ActiveTarget:FindFirstChild("Humanoid") and ActiveTarget.Humanoid.Health > 0 and (IsFarming or IsBossFarming or IsDungeonFarming) then
            if #SelectedAbilities > 0 then
                for _, key in ipairs(SelectedAbilities) do
                    if not ActiveTarget or ActiveTarget.Humanoid.Health <= 0 then break end
                    pressKey(key); task.wait(0.8)
                end
            end
        end
    end
end)

-- // MAIN MOVEMENT LOOP (UPDATED TO BREAK ON ACTIVETARGET CHANGE) // --
task.spawn(function()
    while true do
        task.wait() 
        if IsFarming or IsBossFarming or IsDungeonFarming then
            Character = LocalPlayer.Character
            local mainFolder = Workspace:FindFirstChild("Main")
            if mainFolder then
                local playerFolder = mainFolder:FindFirstChild(LocalPlayer.Name)
                if playerFolder and not playerFolder:FindFirstChild("HakiActive") then pressKey("T") end
            end

            local target = GetNextTarget()
            if not target and IsFarming and tick() - LastTargetFoundTime > 10 then ForceLoadMap(); LastTargetFoundTime = tick(); task.wait(1) end
            if not target and IsBossFarming and table.find(BossPriorityList, "Benimaru") then SpawnBenimaru(); target = GetNextTarget() end

            if target and target:FindFirstChild("Humanoid") and target:FindFirstChild("HumanoidRootPart") then
                ActiveTarget = target
                local hum = target.Humanoid; local root = target.HumanoidRootPart
                
                -- Modified loop: Checks if ActiveTarget matches target. 
                -- If we set ActiveTarget = nil in spawn loop, this breaks instantly.
                while hum.Health > 0 and (IsFarming or IsBossFarming or IsDungeonFarming) and ActiveTarget == target do
                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                         local Offset = CFrame.new(0, 0, 0)
                         if FarmingPosition == "Top" then Offset = CFrame.new(0, FarmingDistance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                         elseif FarmingPosition == "Under" then Offset = CFrame.new(0, -FarmingDistance, 0) * CFrame.Angles(math.rad(90), 0, 0)
                         elseif FarmingPosition == "Behind" then Offset = CFrame.new(0, 0, FarmingDistance)
                         else Offset = CFrame.new(0, FarmingDistance, 0) end
                         Character.HumanoidRootPart.CFrame = root.CFrame * Offset
                         Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    end
                    EquipWeapon(); AttackM1(); task.wait() 
                end
                ActiveTarget = nil
            else ActiveTarget = nil end
        else ActiveTarget = nil; task.wait(0.5) end
    end
end)
