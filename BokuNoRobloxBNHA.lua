-- BNHA Full System Script + Anti-AFK (No Key System)
-- 🌟 Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Boku No Roblox X GAMEDES",
    LoadingTitle = "Welcome...",
    LoadingSubtitle = "By GAMEDES",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BNHAAutoScript",
        FileName = "AutoFarmQuest"
    },
    KeySystem = false  -- ❌ ปิดการใช้งาน KeySystem
})

-- =========================
-- เริ่มสคริปต์เดิมทั้งหมด
-- =========================

local TabAuto = Window:CreateTab("⚔️ AutoFarm")
local TabSkill = Window:CreateTab("🎯 AutoSkill")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RepStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

local QuestModule
pcall(function()
    QuestModule = require(RepStorage.Questing.Main)
end)

-- 🌠 Defaults / Globals
_G.HitboxHeight = 11
_G.LockEnemy = true
_G.Invisible = false
_G.SkillKeys = {Q=false, Z=false, X=false, C=false, V=false, F=false}
_G.SkillDelay = 3
_G.AutoFarmMain = false

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
print("✅ Anti-AFK active")

local function ensureCharacter()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    while not char:FindFirstChild("HumanoidRootPart") do
        char.ChildAdded:Wait()
    end
    return char
end

local function waitForAlive()
    repeat task.wait(0.5) until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0
    return ensureCharacter()
end

local function enlargeHitbox(enemy, size)
    if not enemy or not enemy.Parent then return end
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hitbox = hrp:FindFirstChild("BNHA_FakeHitbox")
    if not hitbox then
        hitbox = Instance.new("Part")
        hitbox.Name = "BNHA_FakeHitbox"
        hitbox.Anchored = true
        hitbox.CanCollide = false
        hitbox.Parent = hrp
    end
    hitbox.Transparency = 0.7
    hitbox.Size = size
    hitbox.Material = Enum.Material.Neon
    hitbox.Color = Color3.fromRGB(255,0,0)
    hitbox.CFrame = hrp.CFrame
end

-- Invisible
task.spawn(function()
    while true do
        task.wait(0.25)
        local char = LocalPlayer.Character
        if not char then continue end
        for _, d in ipairs(char:GetDescendants()) do
            if _G.Invisible then
                if d:IsA("BasePart") then
                    d.Transparency = 1
                    d.LocalTransparencyModifier = 1
                elseif d:IsA("Decal") then
                    d.Transparency = 1
                elseif d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
                    d.Enabled = false
                end
            else
                if d:IsA("BasePart") then
                    d.Transparency = 0
                    d.LocalTransparencyModifier = 0
                elseif d:IsA("Decal") then
                    d.Transparency = 0
                elseif d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
                    d.Enabled = true
                end
            end
        end
    end
end)

-- AutoSkill
task.spawn(function()
    while true do
        for key, enabled in pairs(_G.SkillKeys) do
            if enabled then
                VirtualInput:SendKeyEvent(true, key, false, game)
                task.wait(0.03)
                VirtualInput:SendKeyEvent(false, key, false, game)
                task.wait(0.05)
            end
        end
        task.wait(math.max(0.1,_G.SkillDelay))
    end
end)

-- AutoFarm Function
function AutoFarmMain(flagName, questId, npcNames, folders)
    task.spawn(function()
        ensureCharacter()
        local currentTarget = nil
        local stayStart = nil

        while _G[flagName] do
            pcall(function()
                -- เช็คเควส
                if QuestModule then
                    local userQuest = QuestModule.PlayerQuests.getQuestFromUser(LocalPlayer, questId)
                    if not userQuest or userQuest:IsFinished() then
                        QuestModule.startQuest(LocalPlayer, questId)
                        task.wait(2)
                        currentTarget = nil
                    end
                end

                folders = folders or {workspace:FindFirstChild("NPCs")}

                -- หา NPC
                if not currentTarget then
                    for _, folder in ipairs(folders) do
                        if folder then
                            for _, npc in ipairs(folder:GetChildren()) do
                                if table.find(npcNames, npc.Name)
                                and npc:FindFirstChild("Humanoid")
                                and npc.Humanoid.Health > 0
                                and npc:FindFirstChild("HumanoidRootPart") then
                                    
                                    currentTarget = npc
                                    stayStart = tick()
                                    enlargeHitbox(currentTarget, Vector3.new(10,15,10))
                                    break
                                end
                            end
                        end
                    end
                end

                -- โจมตี
                if currentTarget then
                    local char = LocalPlayer.Character
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local targetHRP = currentTarget:FindFirstChild("HumanoidRootPart")

                    if hrp and hum and targetHRP then
                        if _G.LockEnemy then
                            targetHRP.Anchored = true
                        end

                        while currentTarget
                        and currentTarget:FindFirstChild("Humanoid")
                        and currentTarget.Humanoid.Health > 0
                        and _G[flagName] do

                            local pos = targetHRP.Position + Vector3.new(0,_G.HitboxHeight,0)
                            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(pos),0.25)

                            local swing = char:FindFirstChild("Main") and char.Main:FindFirstChild("Swing")
                            if swing then
                                swing:FireServer(targetHRP.Position,targetHRP)
                            end
                            RunService.Heartbeat:Wait()
                        end
                    end
                    currentTarget = nil
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- ========================
-- UI AutoFarm
-- ========================

TabAuto:CreateToggle({
    Name = "👊 Criminal 1–100",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoFarmCriminal = v
        if v then AutoFarmMain("AutoFarmCriminal","QUEST_INJURED MAN_1",{"Criminal"}) end
    end
})

TabAuto:CreateToggle({
    Name = "🔥 Weak Villain 100–300",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoFarmVillain100 = v
        if v then AutoFarmMain("AutoFarmVillain100","QUEST_AIZAWA_1",{"Weak Villain"}) end
    end
})

TabAuto:CreateToggle({
    Name = "👻 Villain 300–650",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoFarmVillain300 = v
        if v then AutoFarmMain("AutoFarmVillain300","QUEST_HERO_1",{"Villain"}) end
    end
})

TabAuto:CreateToggle({
    Name = "🐱‍👤 Weak Nomu 650–1000",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoFarmNomu = v
        if v then AutoFarmMain("AutoFarmNomu","QUEST_JEANIST_1",
        {"Weak Nomu 1","Weak Nomu 2","Weak Nomu 3","Weak Nomu 4"}) end
    end
})

TabAuto:CreateToggle({
    Name = "🧛‍♂️ High End 1000–MAX",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoFarmHighEnd = v
        if v then AutoFarmMain("AutoFarmHighEnd","QUEST_MIRKO_1",
        {"High End 1","High End 2","High End 3","High End 4"}) end
    end
})

TabAuto:CreateToggle({
    Name = "🧛‍♀️ Awakened Tomura",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoFarmTomura = v
        if v then AutoFarmMain("AutoFarmTomura","QUEST_MIRKO_1",
        {"Awakened Tomura"}) end
    end
})

-- ⭐ Mirko (ตามที่คุณเคยขอ)
TabAuto:CreateToggle({
    Name = "🐇 Mirko",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoFarmMirko = v
        if v then AutoFarmMain("AutoFarmMirko","QUEST_MIRKO_1",
        {"Mirko"}) end
    end
})

TabAuto:CreateSlider({
    Name = "📏 Attack Height",
    Range = {5,500}, -- ⭐ เพิ่มสูงสุดเป็น 500
    Increment = 1,
    Suffix = " studs",
    CurrentValue = _G.HitboxHeight,
    Callback = function(val)
        _G.HitboxHeight = val
    end
})

TabAuto:CreateToggle({
    Name = "🧷 Lock Enemy",
    CurrentValue = _G.LockEnemy,
    Callback = function(v) _G.LockEnemy = v end
})

TabAuto:CreateToggle({
    Name = "👻 Invisible + Hide Name",
    CurrentValue = _G.Invisible,
    Callback = function(v) _G.Invisible = v end
})

-- ========================
-- AutoSkill
-- ========================
for _, key in ipairs({"Q","Z","X","C","V","F"}) do
    TabSkill:CreateToggle({
        Name = "Auto Skill ["..key.."]",
        CurrentValue = false,
        Callback = function(v) _G.SkillKeys[key] = v end
    })
end

TabSkill:CreateSlider({
    Name = "⏱️ Skill Delay (sec)",
    Range = {1,10},
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = _G.SkillDelay,
    Callback = function(v) _G.SkillDelay = v end
})

Rayfield:Notify({
    Title = "BNHA Script Loaded",
    Content = "No Key Required — Enjoy!",
    Duration = 4
})
