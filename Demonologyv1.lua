-- Feel free to edit this script, please put credits to respect the owner.
-- [Beginning of Script]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "GhostStatsGUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 40)
mainFrame.Position = UDim2.new(0.5, -160, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 2
stroke.Color = Color3.fromHSV(0, 1, 1)
task.spawn(function()
    local hue = 0
    while true do
        stroke.Color = Color3.fromHSV(hue, 1, 1)
        hue = (hue + 0.01) % 1
        task.wait(0.03)
    end
end)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -30, 0, 40)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Ghost Stats"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.TextXAlignment = Enum.TextXAlignment.Center

local minimize = Instance.new("TextButton", mainFrame)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 5)
minimize.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
minimize.Text = "-"
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 24

Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

-- Stat Labels
local stats = {
    Gender = "W.I.P",
    ["Ghost Orbs"] = "Checking...",
    Handprints = "Checking...",
    ["Favorite Room"] = "W.I.P",
    ["Ghost Type"] = "W.I.P",
    ["Current Room"] = "..."
}
local labels, yOffset = {}, 50

for statName, statValue in pairs(stats) do
    local label = Instance.new("TextLabel", mainFrame)
    label.Size = UDim2.new(1, -30, 0, 25)
    label.Position = UDim2.new(0, 15, 0, yOffset)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(170, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.Text = statName .. ": " .. statValue
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Visible = false
    labels[statName] = label
    yOffset += 30
end

-- Ghost Orbs
task.spawn(function()
    task.wait(5)
    local found = false
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "GhostOrb" then
            found = true
            break
        end
    end
    if labels["Ghost Orbs"] then
        labels["Ghost Orbs"].Text = "Ghost Orbs: " .. (found and "Yes" or "No")
    end
end)

-- Handprints
task.spawn(function()
    local found = false
    while true do
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (
                obj.Name == "Handprint1" or
                obj.Name == "Handprint2" or
                obj.Name == "Footprint" or
                obj.Name == "Footprint1"
            ) then
                found = true
                break
            end
        end
        if found then break end
        task.wait(1)
    end
    if labels["Handprints"] then
        labels["Handprints"].Text = "Handprints: " .. (found and "Yes" or "No")
    end
end)

-- Gender
task.spawn(function()
    local ghost = workspace:FindFirstChild("Ghost")
    if ghost and ghost:FindFirstChild("Gender") then
        local genderValue = ghost.Gender
        if genderValue:IsA("StringValue") or genderValue:IsA("IntValue") then
            local genderText = typeof(genderValue.Value) == "number" and (genderValue.Value == 1 and "Male" or "Female") or genderValue.Value
            labels["Gender"].Text = "Gender: " .. genderText
        end
    end
end)

-- Room Tracking & Temps
task.spawn(function()
    local ghostModel = workspace:WaitForChild("Ghost", 10)
    if not ghostModel then return end
    local ghostPart = ghostModel:FindFirstChildWhichIsA("BasePart")
    local roomsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Rooms")
    if not ghostPart or not roomsFolder then return end

    local roomVisitCounts = {}
    local stableRoom, roomStreak = nil, 0

    local function isPointInRegion(part, pos)
        local rel = part.CFrame:pointToObjectSpace(pos)
        return math.abs(rel.X) <= part.Size.X / 2 and math.abs(rel.Y) <= part.Size.Y / 2 and math.abs(rel.Z) <= part.Size.Z / 2
    end

    local function getRoomName(pos)
        for _, room in ipairs(roomsFolder:GetChildren()) do
            for _, part in ipairs(room:GetDescendants()) do
                if part:IsA("BasePart") and isPointInRegion(part, pos) then
                    return room.Name, room
                end
            end
        end
        return nil
    end

    local currentTempLabel = Instance.new("TextLabel", mainFrame)
    currentTempLabel.Size = UDim2.new(1, -30, 0, 25)
    currentTempLabel.Position = UDim2.new(0, 15, 0, yOffset)
    currentTempLabel.BackgroundTransparency = 1
    currentTempLabel.TextColor3 = Color3.fromRGB(170, 255, 255)
    currentTempLabel.Font = Enum.Font.Gotham
    currentTempLabel.TextSize = 20
    currentTempLabel.TextXAlignment = Enum.TextXAlignment.Left
    currentTempLabel.Text = "Current Temp: ..."
    currentTempLabel.Visible = false
    labels["Current Temp"] = currentTempLabel
    yOffset += 30

    local favoriteTempLabel = Instance.new("TextLabel", mainFrame)
    favoriteTempLabel.Size = UDim2.new(1, -30, 0, 25)
    favoriteTempLabel.Position = UDim2.new(0, 15, 0, yOffset)
    favoriteTempLabel.BackgroundTransparency = 1
    favoriteTempLabel.TextColor3 = Color3.fromRGB(170, 255, 255)
    favoriteTempLabel.Font = Enum.Font.Gotham
    favoriteTempLabel.TextSize = 20
    favoriteTempLabel.TextXAlignment = Enum.TextXAlignment.Left
    favoriteTempLabel.Text = "Favorite Temp: ..."
    favoriteTempLabel.Visible = false
    labels["Favorite Temp"] = favoriteTempLabel
    yOffset += 30

    while task.wait(1.5) do
        local currentRoomName, roomInstance = getRoomName(ghostPart.Position)
        if currentRoomName == stableRoom then
            roomStreak += 1
        else
            stableRoom = currentRoomName
            roomStreak = 1
        end

        if roomStreak >= 2 and currentRoomName then
            if labels["Current Room"] then labels["Current Room"].Text = "Current Room: " .. currentRoomName end
            if roomInstance and roomInstance:GetAttribute("Temperature") then
                currentTempLabel.Text = string.format("Current Temp: %.1f°C", roomInstance:GetAttribute("Temperature"))
            end

            if currentRoomName ~= "Base Camp" then
                roomVisitCounts[currentRoomName] = (roomVisitCounts[currentRoomName] or 0) + 1
                local favorite, max = nil, 0
                for name, count in pairs(roomVisitCounts) do
                    if count > max then favorite, max = name, count end
                end
                if favorite and labels["Favorite Room"] then
                    labels["Favorite Room"].Text = "Favorite Room: " .. favorite
                    local favRoom = roomsFolder:FindFirstChild(favorite)
                    if favRoom and favRoom:GetAttribute("Temperature") then
                        favoriteTempLabel.Text = string.format("Favorite Temp: %.1f°C", favRoom:GetAttribute("Temperature"))
                    end
                end
            end
        end
    end
end)

-- Minimize toggle
local minimized = true
local function updateGui()
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 320, 0, 40), "Out", "Quad", 0.25, true)
        for _, l in pairs(labels) do l.Visible = false end
    else
        mainFrame:TweenSize(UDim2.new(0, 320, 0, yOffset + 10), "Out", "Quad", 0.25, true)
        for _, l in pairs(labels) do l.Visible = true end
    end
end

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    updateGui()
end)

updateGui()

-- Rainbow title text animation
task.spawn(function()
    local hue = 0
    while true do
        title.TextColor3 = Color3.fromHSV(hue, 1, 1)
        hue = (hue + 0.01) % 1
        task.wait(0.03)
    end
end)
-- [End of Script]
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "ButtonTogglesGUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 190)
mainFrame.Position = UDim2.new(0.5, -120, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Button Toggles"
title.Font = Enum.Font.GothamBold
title.TextSize = 24

local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.Text = "-"
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local isMinimized = false
local fullHeight = 190
local minimizedHeight = 40
local buttons = {}

local function createButton(text, yPos)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0.5, -100, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = text
    btn.AutoButtonColor = true
    table.insert(buttons, btn)
    return btn
end

local function toggleMinimize()
    isMinimized = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "-"

    local goalSize = UDim2.new(0, 240, 0, isMinimized and minimizedHeight or fullHeight)
    TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = goalSize}):Play()

    for _, btn in pairs(buttons) do
        local transparency = isMinimized and 1 or 0
        TweenService:Create(btn, TweenInfo.new(0.2), {
            TextTransparency = transparency,
            BackgroundTransparency = transparency
        }):Play()
        btn.Active = not isMinimized
        btn.AutoButtonColor = not isMinimized
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

local espBtn = createButton("ESP: OFF", 45)
local espEnabled = false
local ghostESP

espBtn.MouseButton1Click:Connect(function()
    if isMinimized then return end
    espEnabled = not espEnabled
    espBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    if ghostESP then ghostESP:Destroy() end

    if espEnabled then
        ghostESP = Instance.new("BillboardGui")
        ghostESP.Size = UDim2.new(0, 60, 0, 20)
        ghostESP.AlwaysOnTop = true
        ghostESP.Name = "GhostESP"

        local label = Instance.new("TextLabel", ghostESP)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "Ghost"
        label.Font = Enum.Font.GothamSemibold
        label.TextScaled = true

        task.spawn(function()
            while espEnabled and label do
                for h = 0, 1, 0.02 do
                    label.TextColor3 = Color3.fromHSV(h, 1, 1)
                    task.wait(0.05)
                    if not espEnabled then break end
                end
            end
        end)

        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower() == "ghost" then
                local part = obj:FindFirstChildWhichIsA("BasePart")
                if part then ghostESP.Parent = part break end
            end
        end
    end
end)

local fullbrightBtn = createButton("Fullbright: OFF", 80)
local fullbrightEnabled = false
local oldLightingProps = {}

fullbrightBtn.MouseButton1Click:Connect(function()
    if isMinimized then return end
    fullbrightEnabled = not fullbrightEnabled
    fullbrightBtn.Text = "Fullbright: " .. (fullbrightEnabled and "ON" or "OFF")
    if fullbrightEnabled then
        oldLightingProps = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            Brightness = Lighting.Brightness,
            GlobalShadows = Lighting.GlobalShadows,
            FogEnd = Lighting.FogEnd
        }
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 5
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
    else
        for k, v in pairs(oldLightingProps) do
            Lighting[k] = v
        end
    end
end)

local huntTpBtn = createButton("Hunt TP: OFF", 115)
local huntTpEnabled = false

huntTpBtn.MouseButton1Click:Connect(function()
    if isMinimized then return end
    huntTpEnabled = not huntTpEnabled
    huntTpBtn.Text = "Hunt TP: " .. (huntTpEnabled and "ON" or "OFF")
end)

task.spawn(function()
    Workspace.DescendantAdded:Connect(function(descendant)
        if huntTpEnabled and descendant:IsA("Sound") and descendant.Name == "Hunt" then
            local success, err = pcall(function()
                local pegboard = Workspace:WaitForChild("Map"):WaitForChild("Rooms"):WaitForChild("Base Camp"):WaitForChild("Pegboard")
                local union = pegboard:FindFirstChild("Union")
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                if union and char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = union.CFrame + Vector3.new(0, 3, 0)
                end
            end)
            if not success then warn("Hunt TP failed:", err) end
        end
    end)
end)

local autoBtn = createButton("Pickup & Drop Items", 150)

autoBtn.MouseButton1Click:Connect(function()
    if isMinimized then return end
    local function safeWaitFor(path, name)
        return path:WaitForChild(name, 9e9)
    end

    local function pickup(id)
        local item = safeWaitFor(safeWaitFor(Workspace, "Items"), tostring(id))
        safeWaitFor(safeWaitFor(ReplicatedStorage, "Events"), "RequestItemPickup"):FireServer(item)
        task.wait(0.75)
    end

    local function equipDrop(slot)
        ReplicatedStorage.Events:WaitForChild("RequestItemEquip"):FireServer(slot)
        task.wait(0.75)
        ReplicatedStorage.Events:WaitForChild("RequestItemDrop"):FireServer(slot)
        task.wait(0.75)
    end

    pickup(9)
    pickup(8)

    local ghost = nil
    repeat
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "Ghost" and v:IsA("Model") then ghost = v break end
        end
        task.wait(0.1)
    until ghost

    local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = ghost:GetModelCFrame()
    task.wait(0.75)

    equipDrop("InvSlot2")
    equipDrop("InvSlot1")

    pickup(3)
    equipDrop("InvSlot1")
end)

-- Rainbow Theme Updater
task.spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            local rainbowColor = Color3.fromHSV(hue, 1, 1)
            stroke.Color = rainbowColor
            title.TextColor3 = rainbowColor
            minimizeBtn.TextColor3 = rainbowColor
            for _, btn in pairs(buttons) do
                btn.TextColor3 = rainbowColor
            end
            task.wait(0.05)
        end
    end
end)
