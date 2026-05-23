if not game:IsLoaded() then
	game.Loaded:Wait()
end

if getgenv()["DemonologyUI"] == nil then
	getgenv()["DemonologyUI"] = true
else
	print("Previous gui detected!")
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Previous gui detected!",
		Text = "Please close the previous gui to create the new one",
		Duration = 5
	})
	return
end

-- Instances:

local DemonologyPRO = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Frame = Instance.new("Frame")
local Handprints = Instance.new("TextLabel")
local Temperature = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")
local GhostOrb = Instance.new("TextLabel")
local SpiritBox = Instance.new("TextLabel")
local EMF = Instance.new("TextLabel")
local GhostWriting = Instance.new("TextLabel")
local LaserProjector = Instance.new("TextLabel")
local Wither = Instance.new("TextLabel")
local Ghost = Instance.new("TextLabel")
local CurrentRoom = Instance.new("TextLabel")
local Buttons = Instance.new("Frame")
local GhostEsp = Instance.new("TextButton")
local EscapeHunt = Instance.new("TextButton")
local PlaceStuff = Instance.new("TextButton")
local TurnOnFuse = Instance.new("TextButton")
local AutoSpiritBox = Instance.new("TextButton")
local TakeAPhoto = Instance.new("TextButton")
local UIPadding = Instance.new("UIPadding")
local CheckSpeed = Instance.new("TextButton")
local ToggleLights = Instance.new("TextButton")
local ModeText = Instance.new("TextLabel")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local Frame2 = Instance.new("Frame")
local UIListLayout_2 = Instance.new("UIListLayout")
local Buttons2 = Instance.new("Frame")
local ItemEsp = Instance.new("TextButton")
local UIPadding_2 = Instance.new("UIPadding")
local Speedy = Instance.new("TextButton")
local Infyield = Instance.new("TextButton")
local FullBright = Instance.new("TextButton")
local Take3StarsPhoto = Instance.new("TextButton")
local PlayersEsp = Instance.new("TextButton")
local EvidenceEsp = Instance.new("TextButton")
local Button8 = Instance.new("TextButton")
local Button9 = Instance.new("TextButton")
local PlayerList = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UIListLayout_3 = Instance.new("UIListLayout")
local Template = Instance.new("TextLabel")
local SomeSign = Instance.new("TextLabel")
local NextPage = Instance.new("TextButton")
local LinkFrame = Instance.new("Frame")
local YoutubeImage = Instance.new("ImageLabel")
local YoutubeCopy = Instance.new("TextButton")
local YoutubeTextBox = Instance.new("TextBox")
local DiscordImage = Instance.new("ImageLabel")
local DiscordCopy = Instance.new("TextButton")
local DiscordTextBox = Instance.new("TextBox")
local TextLabel = Instance.new("TextLabel")
local Minimize = Instance.new("TextButton")
local Close = Instance.new("TextButton")
local Link = Instance.new("TextButton")
local LinkImage = Instance.new("ImageLabel")

--Properties:

DemonologyPRO.Name = "DemonologyPRO"
if game:GetService("RunService"):IsStudio() then
	DemonologyPRO.Parent = game:GetService("Players").LocalPlayer.PlayerGui
else
	local Success = pcall(function()
		DemonologyPRO.Parent = (gethui and gethui()) or (syn and syn.protect_gui and syn.protect_gui(DemonologyPRO)) or game:GetService("CoreGui")
	end)

	if not Success then
		DemonologyPRO.Parent = game:GetService("CoreGui")
	end
end
DemonologyPRO.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
DemonologyPRO.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = DemonologyPRO
MainFrame.Active = true
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.500
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0.437394619, 0, 0.684366703, 0)

Frame.Parent = MainFrame
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, 0, 0.481276333, 0)
Frame.Size = UDim2.new(1, 0, 0.992771089, 0)

Handprints.Name = "Handprints"
Handprints.Parent = Frame
Handprints.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Handprints.BackgroundTransparency = 1.000
Handprints.BorderColor3 = Color3.fromRGB(0, 0, 0)
Handprints.BorderSizePixel = 0
Handprints.LayoutOrder = 1
Handprints.Size = UDim2.new(1, 0, 0.0703883469, 0)
Handprints.Font = Enum.Font.SourceSans
Handprints.Text = "Handprints: No"
Handprints.TextColor3 = Color3.fromRGB(255, 0, 0)
Handprints.TextScaled = true
Handprints.TextSize = 14.000
Handprints.TextWrapped = true
Handprints.TextXAlignment = Enum.TextXAlignment.Left

Temperature.Name = "Temperature"
Temperature.Parent = Frame
Temperature.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Temperature.BackgroundTransparency = 1.000
Temperature.BorderColor3 = Color3.fromRGB(0, 0, 0)
Temperature.BorderSizePixel = 0
Temperature.LayoutOrder = 8
Temperature.Size = UDim2.new(1, 0, 0.0703883469, 0)
Temperature.Font = Enum.Font.SourceSans
Temperature.Text = "Temperature: 0C"
Temperature.TextColor3 = Color3.fromRGB(255, 0, 0)
Temperature.TextScaled = true
Temperature.TextSize = 14.000
Temperature.TextWrapped = true
Temperature.TextXAlignment = Enum.TextXAlignment.Left

UIListLayout.Parent = Frame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

GhostOrb.Name = "GhostOrb"
GhostOrb.Parent = Frame
GhostOrb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GhostOrb.BackgroundTransparency = 1.000
GhostOrb.BorderColor3 = Color3.fromRGB(0, 0, 0)
GhostOrb.BorderSizePixel = 0
GhostOrb.LayoutOrder = 3
GhostOrb.Size = UDim2.new(1, 0, 0.0703883469, 0)
GhostOrb.Font = Enum.Font.SourceSans
GhostOrb.Text = "Ghost Orb: No"
GhostOrb.TextColor3 = Color3.fromRGB(255, 0, 0)
GhostOrb.TextScaled = true
GhostOrb.TextSize = 14.000
GhostOrb.TextWrapped = true
GhostOrb.TextXAlignment = Enum.TextXAlignment.Left

SpiritBox.Name = "SpiritBox"
SpiritBox.Parent = Frame
SpiritBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpiritBox.BackgroundTransparency = 1.000
SpiritBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpiritBox.BorderSizePixel = 0
SpiritBox.LayoutOrder = 2
SpiritBox.Size = UDim2.new(1, 0, 0.0703883469, 0)
SpiritBox.Font = Enum.Font.SourceSans
SpiritBox.Text = "Spirit Box: No"
SpiritBox.TextColor3 = Color3.fromRGB(255, 0, 0)
SpiritBox.TextScaled = true
SpiritBox.TextSize = 14.000
SpiritBox.TextWrapped = true
SpiritBox.TextXAlignment = Enum.TextXAlignment.Left

EMF.Name = "EMF"
EMF.Parent = Frame
EMF.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
EMF.BackgroundTransparency = 1.000
EMF.BorderColor3 = Color3.fromRGB(0, 0, 0)
EMF.BorderSizePixel = 0
EMF.LayoutOrder = 7
EMF.Size = UDim2.new(1, 0, 0.0703883469, 0)
EMF.Font = Enum.Font.SourceSans
EMF.Text = "EMF level: 0"
EMF.TextColor3 = Color3.fromRGB(255, 0, 0)
EMF.TextScaled = true
EMF.TextSize = 14.000
EMF.TextWrapped = true
EMF.TextXAlignment = Enum.TextXAlignment.Left

GhostWriting.Name = "GhostWriting"
GhostWriting.Parent = Frame
GhostWriting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GhostWriting.BackgroundTransparency = 1.000
GhostWriting.BorderColor3 = Color3.fromRGB(0, 0, 0)
GhostWriting.BorderSizePixel = 0
GhostWriting.LayoutOrder = 4
GhostWriting.Size = UDim2.new(1, 0, 0.0703883469, 0)
GhostWriting.Font = Enum.Font.SourceSans
GhostWriting.Text = "Ghost Writing: No"
GhostWriting.TextColor3 = Color3.fromRGB(255, 0, 0)
GhostWriting.TextScaled = true
GhostWriting.TextSize = 14.000
GhostWriting.TextWrapped = true
GhostWriting.TextXAlignment = Enum.TextXAlignment.Left

LaserProjector.Name = "LaserProjector"
LaserProjector.Parent = Frame
LaserProjector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LaserProjector.BackgroundTransparency = 1.000
LaserProjector.BorderColor3 = Color3.fromRGB(0, 0, 0)
LaserProjector.BorderSizePixel = 0
LaserProjector.LayoutOrder = 5
LaserProjector.Size = UDim2.new(1, 0, 0.0703883469, 0)
LaserProjector.Font = Enum.Font.SourceSans
LaserProjector.Text = "Laser Projector: No"
LaserProjector.TextColor3 = Color3.fromRGB(255, 0, 0)
LaserProjector.TextScaled = true
LaserProjector.TextSize = 14.000
LaserProjector.TextWrapped = true
LaserProjector.TextXAlignment = Enum.TextXAlignment.Left

Wither.Name = "Wither"
Wither.Parent = Frame
Wither.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Wither.BackgroundTransparency = 1.000
Wither.BorderColor3 = Color3.fromRGB(0, 0, 0)
Wither.BorderSizePixel = 0
Wither.LayoutOrder = 6
Wither.Position = UDim2.new(-0.0849315077, 0, 0.443333328, 0)
Wither.Size = UDim2.new(1, 0, 0.0703883469, 0)
Wither.Font = Enum.Font.SourceSans
Wither.Text = "Wither: No"
Wither.TextColor3 = Color3.fromRGB(255, 0, 0)
Wither.TextScaled = true
Wither.TextSize = 14.000
Wither.TextWrapped = true
Wither.TextXAlignment = Enum.TextXAlignment.Left

Ghost.Name = "Ghost"
Ghost.Parent = Frame
Ghost.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Ghost.BackgroundTransparency = 1.000
Ghost.BorderColor3 = Color3.fromRGB(0, 0, 0)
Ghost.BorderSizePixel = 0
Ghost.LayoutOrder = 8
Ghost.Size = UDim2.new(1, 0, 0.0703883469, 0)
Ghost.Font = Enum.Font.SourceSans
Ghost.Text = "Ghost: Male | Age 69 | Favorite room: ..."
Ghost.TextColor3 = Color3.fromRGB(255, 255, 255)
Ghost.TextScaled = true
Ghost.TextSize = 14.000
Ghost.TextWrapped = true
Ghost.TextXAlignment = Enum.TextXAlignment.Left

CurrentRoom.Name = "CurrentRoom"
CurrentRoom.Parent = Frame
CurrentRoom.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CurrentRoom.BackgroundTransparency = 1.000
CurrentRoom.BorderColor3 = Color3.fromRGB(0, 0, 0)
CurrentRoom.BorderSizePixel = 0
CurrentRoom.LayoutOrder = 9
CurrentRoom.Size = UDim2.new(1, 0, 0.0703883469, 0)
CurrentRoom.Font = Enum.Font.SourceSans
CurrentRoom.Text = "Current room: ..."
CurrentRoom.TextColor3 = Color3.fromRGB(255, 255, 255)
CurrentRoom.TextScaled = true
CurrentRoom.TextSize = 14.000
CurrentRoom.TextWrapped = true
CurrentRoom.TextXAlignment = Enum.TextXAlignment.Left

Buttons.Name = "Buttons"
Buttons.Parent = Frame
Buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Buttons.BackgroundTransparency = 1.000
Buttons.BorderColor3 = Color3.fromRGB(0, 0, 0)
Buttons.BorderSizePixel = 0
Buttons.LayoutOrder = 99
Buttons.Size = UDim2.new(1, 0, 0.240291268, 0)

GhostEsp.Name = "GhostEsp"
GhostEsp.Parent = Buttons
GhostEsp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GhostEsp.BorderColor3 = Color3.fromRGB(0, 0, 0)
GhostEsp.BorderSizePixel = 0
GhostEsp.Position = UDim2.new(0.0433734953, 0, 0.07856334, 0)
GhostEsp.Size = UDim2.new(0.200000003, 0, 0.270000011, 0)
GhostEsp.Font = Enum.Font.SourceSans
GhostEsp.Text = "Ghost esp"
GhostEsp.TextColor3 = Color3.fromRGB(0, 0, 0)
GhostEsp.TextScaled = true
GhostEsp.TextSize = 14.000
GhostEsp.TextWrapped = true

EscapeHunt.Name = "EscapeHunt"
EscapeHunt.Parent = Buttons
EscapeHunt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
EscapeHunt.BorderColor3 = Color3.fromRGB(0, 0, 0)
EscapeHunt.BorderSizePixel = 0
EscapeHunt.Position = UDim2.new(0.274698794, 0, 0.07856334, 0)
EscapeHunt.Size = UDim2.new(0.200000003, 0, 0.270000011, 0)
EscapeHunt.Font = Enum.Font.SourceSans
EscapeHunt.Text = "Hunt escape"
EscapeHunt.TextColor3 = Color3.fromRGB(0, 0, 0)
EscapeHunt.TextScaled = true
EscapeHunt.TextSize = 14.000
EscapeHunt.TextWrapped = true

PlaceStuff.Name = "PlaceStuff"
PlaceStuff.Parent = Buttons
PlaceStuff.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlaceStuff.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlaceStuff.BorderSizePixel = 0
PlaceStuff.Position = UDim2.new(0.51566273, 0, 0.07856334, 0)
PlaceStuff.Size = UDim2.new(0.200000003, 0, 0.270000011, 0)
PlaceStuff.Font = Enum.Font.SourceSans
PlaceStuff.Text = "Place stuffs near ghost"
PlaceStuff.TextColor3 = Color3.fromRGB(0, 0, 0)
PlaceStuff.TextScaled = true
PlaceStuff.TextSize = 14.000
PlaceStuff.TextWrapped = true

TurnOnFuse.Name = "TurnOnFuse"
TurnOnFuse.Parent = Buttons
TurnOnFuse.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TurnOnFuse.BorderColor3 = Color3.fromRGB(0, 0, 0)
TurnOnFuse.BorderSizePixel = 0
TurnOnFuse.Position = UDim2.new(0.0433734953, 0, 0.588563442, 0)
TurnOnFuse.Size = UDim2.new(0.200000003, 0, 0.270000011, 0)
TurnOnFuse.Font = Enum.Font.SourceSans
TurnOnFuse.Text = "Turn on fuse"
TurnOnFuse.TextColor3 = Color3.fromRGB(0, 0, 0)
TurnOnFuse.TextScaled = true
TurnOnFuse.TextSize = 14.000
TurnOnFuse.TextWrapped = true

AutoSpiritBox.Name = "AutoSpiritBox"
AutoSpiritBox.Parent = Buttons
AutoSpiritBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoSpiritBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
AutoSpiritBox.BorderSizePixel = 0
AutoSpiritBox.Position = UDim2.new(0.274698794, 0, 0.588563442, 0)
AutoSpiritBox.Size = UDim2.new(0.200000003, 0, 0.270000011, 0)
AutoSpiritBox.Font = Enum.Font.SourceSans
AutoSpiritBox.Text = "Auto spirit box"
AutoSpiritBox.TextColor3 = Color3.fromRGB(0, 0, 0)
AutoSpiritBox.TextScaled = true
AutoSpiritBox.TextSize = 14.000
AutoSpiritBox.TextWrapped = true

TakeAPhoto.Name = "TakeAPhoto"
TakeAPhoto.Parent = Buttons
TakeAPhoto.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TakeAPhoto.BorderColor3 = Color3.fromRGB(0, 0, 0)
TakeAPhoto.BorderSizePixel = 0
TakeAPhoto.Position = UDim2.new(0.51566273, 0, 0.588563442, 0)
TakeAPhoto.Size = UDim2.new(0.200000003, 0, 0.270000011, 0)
TakeAPhoto.Font = Enum.Font.SourceSans
TakeAPhoto.Text = "Take a photo ghost"
TakeAPhoto.TextColor3 = Color3.fromRGB(0, 0, 0)
TakeAPhoto.TextScaled = true
TakeAPhoto.TextSize = 14.000
TakeAPhoto.TextWrapped = true

UIPadding.Parent = Buttons
UIPadding.PaddingTop = UDim.new(0.100000001, 0)

CheckSpeed.Name = "CheckSpeed"
CheckSpeed.Parent = Buttons
CheckSpeed.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckSpeed.BorderColor3 = Color3.fromRGB(0, 0, 0)
CheckSpeed.BorderSizePixel = 0
CheckSpeed.Position = UDim2.new(0.756626606, 0, 0.07856334, 0)
CheckSpeed.Size = UDim2.new(0.200000003, 0, 0.270000011, 0)
CheckSpeed.Font = Enum.Font.SourceSans
CheckSpeed.Text = "Check speed: 1s"
CheckSpeed.TextColor3 = Color3.fromRGB(0, 0, 0)
CheckSpeed.TextScaled = true
CheckSpeed.TextSize = 14.000
CheckSpeed.TextWrapped = true

ToggleLights.Name = "ToggleLights"
ToggleLights.Parent = Buttons
ToggleLights.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleLights.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleLights.BorderSizePixel = 0
ToggleLights.Position = UDim2.new(0.756626606, 0, 0.583613813, 0)
ToggleLights.Size = UDim2.new(0.200000003, 0, 0.270000011, 0)
ToggleLights.Font = Enum.Font.SourceSans
ToggleLights.Text = "Toggle all lights"
ToggleLights.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleLights.TextScaled = true
ToggleLights.TextSize = 14.000
ToggleLights.TextWrapped = true

ModeText.Name = "ModeText"
ModeText.Parent = MainFrame
ModeText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ModeText.BackgroundTransparency = 1.000
ModeText.BorderColor3 = Color3.fromRGB(0, 0, 0)
ModeText.BorderSizePixel = 0
ModeText.Position = UDim2.new(-0.00100000005, 0, 1, 0)
ModeText.Size = UDim2.new(0.5, 0, 0.0599999987, 0)
ModeText.Font = Enum.Font.SourceSansBold
ModeText.Text = "Difficulty: Unknow"
ModeText.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeText.TextScaled = true
ModeText.TextSize = 14.000
ModeText.TextStrokeTransparency = 0.000
ModeText.TextWrapped = true
ModeText.TextXAlignment = Enum.TextXAlignment.Left

UIAspectRatioConstraint.Parent = MainFrame

Frame2.Name = "Frame2"
Frame2.Parent = MainFrame
Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
Frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame2.BackgroundTransparency = 1.000
Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame2.BorderSizePixel = 0
Frame2.Position = UDim2.new(0.5, 0, 0.50810802, 0)
Frame2.Size = UDim2.new(1, 0, 0.939107656, 0)
Frame2.Visible = false

UIListLayout_2.Parent = Frame2
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Bottom

Buttons2.Name = "Buttons2"
Buttons2.Parent = Frame2
Buttons2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Buttons2.BackgroundTransparency = 1.000
Buttons2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Buttons2.BorderSizePixel = 0
Buttons2.LayoutOrder = 99
Buttons2.Size = UDim2.new(1, 0, 0.400000006, 0)

ItemEsp.Name = "ItemEsp"
ItemEsp.Parent = Buttons2
ItemEsp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ItemEsp.BorderColor3 = Color3.fromRGB(0, 0, 0)
ItemEsp.BorderSizePixel = 0
ItemEsp.Position = UDim2.new(0.0457770601, 0, 0.401964247, 0)
ItemEsp.Size = UDim2.new(0.230000004, 0, 0.200000003, 0)
ItemEsp.Font = Enum.Font.SourceSans
ItemEsp.Text = "Item esp"
ItemEsp.TextColor3 = Color3.fromRGB(0, 0, 0)
ItemEsp.TextScaled = true
ItemEsp.TextSize = 14.000
ItemEsp.TextWrapped = true

UIPadding_2.Parent = Buttons2
UIPadding_2.PaddingTop = UDim.new(0.100000001, 0)

Speedy.Name = "Speedy"
Speedy.Parent = Buttons2
Speedy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Speedy.BorderColor3 = Color3.fromRGB(0, 0, 0)
Speedy.BorderSizePixel = 0
Speedy.Position = UDim2.new(0.701454997, 0, 0.0305505246, 0)
Speedy.Size = UDim2.new(0.230000004, 0, 0.200000003, 0)
Speedy.Font = Enum.Font.SourceSans
Speedy.Text = "Speed: 10"
Speedy.TextColor3 = Color3.fromRGB(0, 0, 0)
Speedy.TextScaled = true
Speedy.TextSize = 14.000
Speedy.TextWrapped = true

Infyield.Name = "Infyield"
Infyield.Parent = Buttons2
Infyield.AnchorPoint = Vector2.new(0.5, 0.5)
Infyield.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Infyield.BorderColor3 = Color3.fromRGB(0, 0, 0)
Infyield.BorderSizePixel = 0
Infyield.Position = UDim2.new(0.488692522, 0, 0.131094635, 0)
Infyield.Size = UDim2.new(0.230000004, 0, 0.200000003, 0)
Infyield.Font = Enum.Font.SourceSans
Infyield.Text = "Load infinite yield"
Infyield.TextColor3 = Color3.fromRGB(0, 0, 0)
Infyield.TextScaled = true
Infyield.TextSize = 14.000
Infyield.TextWrapped = true

FullBright.Name = "FullBright"
FullBright.Parent = Buttons2
FullBright.AnchorPoint = Vector2.new(0.5, 0.5)
FullBright.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FullBright.BorderColor3 = Color3.fromRGB(0, 0, 0)
FullBright.BorderSizePixel = 0
FullBright.Position = UDim2.new(0.16127266, 0, 0.131095499, 0)
FullBright.Size = UDim2.new(0.230000004, 0, 0.200000003, 0)
FullBright.Font = Enum.Font.SourceSans
FullBright.Text = "Full bright"
FullBright.TextColor3 = Color3.fromRGB(0, 0, 0)
FullBright.TextScaled = true
FullBright.TextSize = 14.000
FullBright.TextWrapped = true

Take3StarsPhoto.Name = "Take3StarsPhoto"
Take3StarsPhoto.Parent = Buttons2
Take3StarsPhoto.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Take3StarsPhoto.BorderColor3 = Color3.fromRGB(0, 0, 0)
Take3StarsPhoto.BorderSizePixel = 0
Take3StarsPhoto.Position = UDim2.new(0.699892104, 0, 0.401964247, 0)
Take3StarsPhoto.Size = UDim2.new(0.230000004, 0, 0.200000003, 0)
Take3StarsPhoto.Font = Enum.Font.SourceSans
Take3StarsPhoto.Text = "Take 3 stars photo"
Take3StarsPhoto.TextColor3 = Color3.fromRGB(0, 0, 0)
Take3StarsPhoto.TextScaled = true
Take3StarsPhoto.TextSize = 14.000
Take3StarsPhoto.TextWrapped = true

PlayersEsp.Name = "PlayersEsp"
PlayersEsp.Parent = Buttons2
PlayersEsp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayersEsp.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayersEsp.BorderSizePixel = 0
PlayersEsp.Position = UDim2.new(0.371627718, 0, 0.401964247, 0)
PlayersEsp.Size = UDim2.new(0.230000004, 0, 0.200000003, 0)
PlayersEsp.Font = Enum.Font.SourceSans
PlayersEsp.Text = "Players esp"
PlayersEsp.TextColor3 = Color3.fromRGB(0, 0, 0)
PlayersEsp.TextScaled = true
PlayersEsp.TextSize = 14.000
PlayersEsp.TextWrapped = true

EvidenceEsp.Name = "EvidenceEsp"
EvidenceEsp.Parent = Buttons2
EvidenceEsp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
EvidenceEsp.BorderColor3 = Color3.fromRGB(0, 0, 0)
EvidenceEsp.BorderSizePixel = 0
EvidenceEsp.Position = UDim2.new(0.0457770601, 0, 0.759845376, 0)
EvidenceEsp.Size = UDim2.new(0.230000004, 0, 0.200000003, 0)
EvidenceEsp.Font = Enum.Font.SourceSans
EvidenceEsp.Text = "Handprints, Orb esp"
EvidenceEsp.TextColor3 = Color3.fromRGB(0, 0, 0)
EvidenceEsp.TextScaled = true
EvidenceEsp.TextSize = 14.000
EvidenceEsp.TextWrapped = true

Button8.Name = "Button8"
Button8.Parent = Buttons2
Button8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button8.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button8.BorderSizePixel = 0
Button8.Position = UDim2.new(0.370035648, 0, 0.759845376, 0)
Button8.Size = UDim2.new(0.230000004, 0, 0.200000003, 0)
Button8.Font = Enum.Font.SourceSans
Button8.Text = "Coming soon..."
Button8.TextColor3 = Color3.fromRGB(0, 0, 0)
Button8.TextScaled = true
Button8.TextSize = 14.000
Button8.TextWrapped = true

Button9.Name = "Button9"
Button9.Parent = Buttons2
Button9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Button9.BorderColor3 = Color3.fromRGB(0, 0, 0)
Button9.BorderSizePixel = 0
Button9.Position = UDim2.new(0.699133813, 0, 0.759845376, 0)
Button9.Size = UDim2.new(0.230000004, 0, 0.200000003, 0)
Button9.Font = Enum.Font.SourceSans
Button9.Text = "Coming soon..."
Button9.TextColor3 = Color3.fromRGB(0, 0, 0)
Button9.TextScaled = true
Button9.TextSize = 14.000
Button9.TextWrapped = true

PlayerList.Name = "PlayerList"
PlayerList.Parent = Frame2
PlayerList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerList.BackgroundTransparency = 1.000
PlayerList.BorderColor3 = Color3.fromRGB(0, 0, 0)
PlayerList.BorderSizePixel = 0
PlayerList.Position = UDim2.new(0, 0, 0.000996189541, 0)
PlayerList.Size = UDim2.new(1, 0, 0.600000024, 0)

Title.Name = "Title"
Title.Parent = PlayerList
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.LayoutOrder = -1
Title.Size = UDim2.new(1, 0, 0.129999995, 0)
Title.Font = Enum.Font.SourceSans
Title.Text = "Player enegry:"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextScaled = true
Title.TextSize = 14.000
Title.TextWrapped = true
Title.TextXAlignment = Enum.TextXAlignment.Left

UIListLayout_3.Parent = PlayerList
UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

Template.Name = "Template"
Template.Parent = PlayerList
Template.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Template.BackgroundTransparency = 1.000
Template.BorderColor3 = Color3.fromRGB(0, 0, 0)
Template.BorderSizePixel = 0
Template.Size = UDim2.new(1, 0, 0.129999995, 0)
Template.Visible = false
Template.Font = Enum.Font.SourceSans
Template.Text = "Name(Display): 80.22%"
Template.TextColor3 = Color3.fromRGB(255, 255, 255)
Template.TextScaled = true
Template.TextSize = 14.000
Template.TextWrapped = true
Template.TextXAlignment = Enum.TextXAlignment.Left

SomeSign.Name = "SomeSign"
SomeSign.Parent = MainFrame
SomeSign.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SomeSign.BackgroundTransparency = 1.000
SomeSign.BorderColor3 = Color3.fromRGB(0, 0, 0)
SomeSign.BorderSizePixel = 0
SomeSign.Position = UDim2.new(0, 0, 0.0385542177, 0)
SomeSign.Size = UDim2.new(1, 0, 0.0599999987, 0)
SomeSign.ZIndex = 999
SomeSign.Font = Enum.Font.SourceSansBold
SomeSign.Text = "Script by Ducko355"
SomeSign.TextColor3 = Color3.fromRGB(255, 255, 255)
SomeSign.TextScaled = true
SomeSign.TextSize = 14.000
SomeSign.TextStrokeTransparency = 0.000
SomeSign.TextWrapped = true
SomeSign.TextXAlignment = Enum.TextXAlignment.Right

NextPage.Name = "NextPage"
NextPage.Parent = MainFrame
NextPage.AnchorPoint = Vector2.new(1, 0)
NextPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NextPage.BorderColor3 = Color3.fromRGB(0, 0, 0)
NextPage.BorderSizePixel = 0
NextPage.Position = UDim2.new(1, 0, 1, 0)
NextPage.Size = UDim2.new(0.5, 0, 0.0599999987, 0)
NextPage.Font = Enum.Font.SourceSans
NextPage.Text = "Next page"
NextPage.TextColor3 = Color3.fromRGB(0, 0, 0)
NextPage.TextScaled = true
NextPage.TextSize = 14.000
NextPage.TextWrapped = true

LinkFrame.Name = "LinkFrame"
LinkFrame.Parent = MainFrame
LinkFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LinkFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LinkFrame.BackgroundTransparency = 1.000
LinkFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
LinkFrame.BorderSizePixel = 0
LinkFrame.Position = UDim2.new(0.5, 0, 0.481276333, 0)
LinkFrame.Size = UDim2.new(1, 0, 0.992771089, 0)
LinkFrame.Visible = false
LinkFrame.ZIndex = 99

YoutubeImage.Name = "YoutubeImage"
YoutubeImage.Parent = LinkFrame
YoutubeImage.AnchorPoint = Vector2.new(0.5, 0.5)
YoutubeImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
YoutubeImage.BackgroundTransparency = 1.000
YoutubeImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
YoutubeImage.BorderSizePixel = 0
YoutubeImage.Position = UDim2.new(0.168959603, 0, 0.296862572, 0)
YoutubeImage.Size = UDim2.new(0.241370872, 0, 0.243128419, 0)
YoutubeImage.Image = "rbxassetid://16250076424"

YoutubeCopy.Name = "YoutubeCopy"
YoutubeCopy.Parent = LinkFrame
YoutubeCopy.AnchorPoint = Vector2.new(0.5, 1)
YoutubeCopy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
YoutubeCopy.BorderColor3 = Color3.fromRGB(0, 0, 0)
YoutubeCopy.BorderSizePixel = 0
YoutubeCopy.Position = UDim2.new(0.6361444, 0, 0.416132927, 0)
YoutubeCopy.Size = UDim2.new(0.362056315, 0, 0.0729385242, 0)
YoutubeCopy.Font = Enum.Font.SourceSans
YoutubeCopy.Text = "Copy"
YoutubeCopy.TextColor3 = Color3.fromRGB(0, 0, 0)
YoutubeCopy.TextScaled = true
YoutubeCopy.TextSize = 14.000
YoutubeCopy.TextWrapped = true

YoutubeTextBox.Name = "YoutubeTextBox"
YoutubeTextBox.Parent = LinkFrame
YoutubeTextBox.AnchorPoint = Vector2.new(0.5, 0.5)
YoutubeTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
YoutubeTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
YoutubeTextBox.BorderSizePixel = 0
YoutubeTextBox.Position = UDim2.new(0.628000021, 0, 0.25, 0)
YoutubeTextBox.Size = UDim2.new(0.603427172, 0, 0.0850949436, 0)
YoutubeTextBox.Font = Enum.Font.SourceSans
YoutubeTextBox.Text = "https://www.youtube.com/channel/UCSMOQh8gGh1dCiwEY9ce2Uw"
YoutubeTextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
YoutubeTextBox.TextScaled = true
YoutubeTextBox.TextSize = 14.000
YoutubeTextBox.TextWrapped = true

DiscordImage.Name = "DiscordImage"
DiscordImage.Parent = LinkFrame
DiscordImage.AnchorPoint = Vector2.new(0.5, 0.5)
DiscordImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DiscordImage.BackgroundTransparency = 1.000
DiscordImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
DiscordImage.BorderSizePixel = 0
DiscordImage.Position = UDim2.new(0.178614438, 0, 0.671280324, 0)
DiscordImage.Size = UDim2.new(0.241370872, 0, 0.206659153, 0)
DiscordImage.Image = "rbxassetid://10367063073"

DiscordCopy.Name = "DiscordCopy"
DiscordCopy.Parent = LinkFrame
DiscordCopy.AnchorPoint = Vector2.new(0.5, 1)
DiscordCopy.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DiscordCopy.BorderColor3 = Color3.fromRGB(0, 0, 0)
DiscordCopy.BorderSizePixel = 0
DiscordCopy.Position = UDim2.new(0.64579922, 0, 0.790550649, 0)
DiscordCopy.Size = UDim2.new(0.362056315, 0, 0.0729385242, 0)
DiscordCopy.Font = Enum.Font.SourceSans
DiscordCopy.Text = "Copy"
DiscordCopy.TextColor3 = Color3.fromRGB(0, 0, 0)
DiscordCopy.TextScaled = true
DiscordCopy.TextSize = 14.000
DiscordCopy.TextWrapped = true

DiscordTextBox.Name = "DiscordTextBox"
DiscordTextBox.Parent = LinkFrame
DiscordTextBox.AnchorPoint = Vector2.new(0.5, 0.5)
DiscordTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DiscordTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
DiscordTextBox.BorderSizePixel = 0
DiscordTextBox.Position = UDim2.new(0.637654901, 0, 0.624417722, 0)
DiscordTextBox.Size = UDim2.new(0.603427172, 0, 0.0850949436, 0)
DiscordTextBox.Font = Enum.Font.SourceSans
DiscordTextBox.Text = "https://discord.gg/mNTEpwnkZC"
DiscordTextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
DiscordTextBox.TextScaled = true
DiscordTextBox.TextSize = 14.000
DiscordTextBox.TextWrapped = true

TextLabel.Parent = MainFrame
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(-0.00058093702, 0, -0.0207512919, 0)
TextLabel.Size = UDim2.new(0.75, 0, 0.0599999987, 0)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Demonology evicence ui pro v1.4.2"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

Minimize.Name = "Minimize"
Minimize.Parent = TextLabel
Minimize.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
Minimize.BorderSizePixel = 0
Minimize.Position = UDim2.new(1.13838589, 0, 0, 0)
Minimize.Size = UDim2.new(0.114285715, 0, 1, 0)
Minimize.Font = Enum.Font.SourceSans
Minimize.Text = "_"
Minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
Minimize.TextScaled = true
Minimize.TextSize = 14.000
Minimize.TextWrapped = true

Close.Name = "Close"
Close.Parent = TextLabel
Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(1.24850094, 0, 3.06918935e-07, 0)
Close.Size = UDim2.new(0.0856072083, 0, 0.99999994, 0)
Close.Font = Enum.Font.SourceSans
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(0, 0, 0)
Close.TextScaled = true
Close.TextSize = 14.000
Close.TextWrapped = true

Link.Name = "Link"
Link.Parent = TextLabel
Link.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Link.BorderColor3 = Color3.fromRGB(0, 0, 0)
Link.BorderSizePixel = 0
Link.Position = UDim2.new(0.999999881, 0, 0, 0)
Link.Size = UDim2.new(0.140000001, 0, 1, 0)
Link.Font = Enum.Font.SourceSans
Link.Text = ""
Link.TextColor3 = Color3.fromRGB(0, 0, 0)
Link.TextScaled = true
Link.TextSize = 14.000
Link.TextTransparency = 1.000
Link.TextWrapped = true

LinkImage.Name = "LinkImage"
LinkImage.Parent = Link
LinkImage.AnchorPoint = Vector2.new(0.5, 0.5)
LinkImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LinkImage.BackgroundTransparency = 1.000
LinkImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
LinkImage.BorderSizePixel = 0
LinkImage.Position = UDim2.new(0.5, 0, 0.5, 0)
LinkImage.Size = UDim2.new(0.553106368, 0, 1, 0)
LinkImage.Image = "rbxassetid://115736032752379"
LinkImage.ImageColor3 = Color3.fromRGB(0, 0, 0)

if not game:GetService("RunService"):IsStudio() then
	DemonologyPRO.Name = "ScreenGui"
end

local IsUiClosed = false

task.spawn(function() --rainbow title
	while true do
		for h = 0, 1, 0.02 do
			TextLabel.TextColor3 = Color3.fromHSV(h, 1, 1)
			task.wait(0.1)
		end
		
		if IsUiClosed then
			break
		end
	end
end)

local BillboardGui = Instance.new("BillboardGui")
local TextLabel = Instance.new("TextLabel")
local HL = Instance.new("Highlight")

BillboardGui.Enabled = false
HL.Enabled = false
--------------------------------------------------------------
------------------------SCRIPT--------------------------------
--------------------------------------------------------------
local RS = game:GetService("RunService")
local PS = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local plr = PS.LocalPlayer

local CheckSpeedNum = 1

local LightToggleStatus = false

local IsEscapeHunt = false
local AutoSpiritBoxToggle = false

local PlayersEspToggle = false

local OldLightingList = {
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	Brightness = Lighting.Brightness,
	GlobalShadows = Lighting.GlobalShadows,
	FogEnd = Lighting.FogEnd
}

local ItemEspList = {}

local EvidenceEspToggle = false
local EvidenceEspList = {}

local Func
local Func2
local FuncEvi

Close.MouseButton1Click:Connect(function()
	IsUiClosed = true
	PlayersEspToggle = false
	
	EvidenceEspToggle = false
	UpdateEvidenceEsp()
	
	for _, v in pairs(ItemEspList) do
		task.spawn(function()
			v:Destroy()
		end)
	end
	
	if BillboardGui ~= nil and HL ~= nil then
		BillboardGui:Destroy()
		HL:Destroy()
	end
	
	Lighting.Ambient = OldLightingList.Ambient
	Lighting.OutdoorAmbient = OldLightingList.OutdoorAmbient
	Lighting.Brightness = OldLightingList.Brightness
	Lighting.GlobalShadows = OldLightingList.GlobalShadows
	Lighting.FogEnd = OldLightingList.FogEnd

	DemonologyPRO:Destroy()
	Func:Disconnect()
	Func2:Disconnect()
	FuncEvi:Disconnect()

	getgenv()["DemonologyUI"] = nil
	
	task.spawn(function()
		plr.Character.Humanoid.WalkSpeed = 10
	end)
	
	task.spawn(function()
		task.wait(.5)
		UpdatePlrEsp()
		task.wait(.5)
		UpdatePlrEsp()
		task.wait(.5)
		UpdatePlrEsp()
	end)
end)

local OldFrameVi = nil
local OldFrame2Vi = nil
Minimize.MouseButton1Click:Connect(function()
	if MainFrame.Transparency == 1 then
		Frame.Visible = OldFrameVi
		Frame2.Visible = OldFrame2Vi
		if Frame.Visible == false and Frame2.Visible == false then
			LinkFrame.Visible = false
			Frame.Visible = true
		end
		MainFrame.Transparency = 0.5
		MainFrame.Active = true
		NextPage.Visible = true
		ModeText.Visible = true
	else
		OldFrameVi = Frame.Visible
		OldFrame2Vi = Frame2.Visible
		task.wait()
		Frame.Visible = false
		Frame2.Visible = false
		MainFrame.Transparency = 1
		MainFrame.Active = false
		NextPage.Visible = false
		LinkFrame.Visible = false
		Link.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ModeText.Visible = false
	end
end)

------------------------------------------
-------------MAIN FUNCTIONS---------------
------------------------------------------

--some functions
function CheckInventory(ItemName)
	local Found = false
	local InvSlotNum = nil
	for _, obj in ipairs(plr.PlayerGui.Hotbar.Slots:GetChildren()) do
		if obj:IsA("Frame") and string.find(string.lower(obj.Name), "invslot") then
			if obj.ItemName.Text == ItemName then
				Found = true

				local str = obj.Name
				local num = tonumber(str:match("%d+"))
				InvSlotNum = num
			end
		end
	end
	return Found, InvSlotNum
end
local str = "InvSlot"
local num = tonumber(str:match("%d+"))

function FindItem(ItemName)
	local Found = false
	local Model = nil

	local ItemFolder = workspace.Items

	for _, v in pairs(ItemFolder:GetChildren()) do
		if v:IsA("Model") and v:GetAttribute("ItemName") then
			if v:GetAttribute("ItemName") == ItemName then
				Found = true
				Model = v
			end
		end
	end

	return Found, Model
end

function ActiveItem()
	local ItemModel = nil

	local Chara = plr.Character
	if Chara then
		for _, v in pairs(Chara:GetChildren()) do
			if v:IsA("Model") or tonumber(v.Name) then
				ItemModel = v
				if v:GetAttribute("Enabled") ~= true then
					local Handle = v:FindFirstChild("Handle")
					if Handle then
						game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ToggleItemState"):FireServer(ItemModel)
						break
					end
				end
			end

		end
	end

	return true, ItemModel
end

function EquipItem(SlotNum)
	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RequestItemEquip"):FireServer("InvSlot" .. tostring(SlotNum))
	return true
end

function PickupItem(Model)
	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RequestItemPickup"):FireServer(Model)
	return true
end

function DropItem(SlotNum)
	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RequestItemDrop"):FireServer("InvSlot" .. tostring(SlotNum))
	return true
end

function CopyToClipboard(Texts)
	task.spawn(function()
		local ClipboardFunc = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
		local ConvertToString = tostring(game.JobId)
		ClipboardFunc(ConvertToString)
	end)
end

function GhostHuntingInfo()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Ghost hunting!",
		Text = "This action cannot be performed.",
		Duration = 3
	})
end

function CantTakePhotoInfo()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Cannot take a photo!",
		Text = "There's' nothing to take a photo, try again after a ghost hunt!",
		Duration = 3
	})
end

function AlreadyTakenGhostPhotoInfo()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "-Info-",
		Text = "A photo of the ghost has already been taken!",
		Duration = 3
	})
end

function CopiedInfo()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "-Info-",
		Text = "Link copied!",
		Icon = "rbxassetid://115736032752379",
		Duration = 3
	})
end

function PhotoCamNotFoundInfo()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "-Info-",
		Text = "There is not photo camera here!",
		Duration = 3
	})
end

function EquipPhotoCamera()
	local Found, InvSlotNum = CheckInventory("Photo Camera")
	if not CheckInventory("Photo Camera") then
		local Found, Model = FindItem("Photo Camera")
		if Found and Model then
			PickupItem(Model)
			task.wait(0.5)
			local Found, InvSlotNum = CheckInventory("Photo Camera")
			if Found then
				EquipItem(InvSlotNum)
				task.wait(0.5)
				
				return true
			end
		end
	else
		EquipItem(InvSlotNum)
		task.wait(0.5)
		
		return true
	end
	
	return
end
--some functions

local function TpOutside()
	local success, err = pcall(function()
		local pegboard = workspace:WaitForChild("Map"):WaitForChild("Rooms"):WaitForChild("Base Camp"):WaitForChild("Pegboard")
		local union = pegboard:FindFirstChild("Union")
		local char = plr.Character or plr.CharacterAdded:Wait()
		if union and char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = union.CFrame + Vector3.new(0, 3, 0)
		end
	end)
	if not success then warn("Hunt TP failed:", err) end
end

--Auto escape hunt
Func2 = workspace.DescendantAdded:Connect(function(descendant)
	if IsEscapeHunt and descendant:IsA("Sound") and descendant.Name == "Hunt" then
		TpOutside()
	end
end)

-- Room Tracking & Temps
local ghostModel = workspace:WaitForChild("Ghost", 15)
if not ghostModel then
	warn("Find ghost model failed")
	return end
local ghostPart = ghostModel:FindFirstChildWhichIsA("BasePart")
local roomsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Rooms")
if not ghostPart or not roomsFolder then 
	warn("Find rooms failed")
	return end

local AlreadyCreated = false
local function CreateGhostEsp()
	if not AlreadyCreated then
		AlreadyCreated = true

		BillboardGui = Instance.new("BillboardGui")
		TextLabel = Instance.new("TextLabel")
		HL = Instance.new("Highlight")

		BillboardGui.Parent = game:GetService("CoreGui")
		BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		BillboardGui.Active = true
		BillboardGui.AlwaysOnTop = true
		BillboardGui.Size = UDim2.new(0, 60, 0, 60)
		BillboardGui.LightInfluence = 0
		BillboardGui.Brightness = 1
		BillboardGui.Adornee = ghostModel

		TextLabel.Parent = BillboardGui
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.Text = "Ghost"
		TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		TextLabel.TextScaled = true
		TextLabel.TextSize = 14.000
		TextLabel.TextWrapped = true
		TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.TextStrokeTransparency = 0

		HL.Parent = ghostModel
		HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		HL.OutlineColor = Color3.fromRGB(255, 0, 0)
		HL.FillTransparency = 1
		HL.OutlineTransparency = 0
		HL.Adornee = ghostModel
	else
		BillboardGui.Enabled = not BillboardGui.Enabled
		HL.Enabled = not HL.Enabled
	end
end

local function TpToGhost()
	local Chara = plr.Character
	if Chara then
		Chara:PivotTo(ghostModel:GetPivot())
	end
end

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

local function ToggleLightNow(Toggle)
	local Rooms = workspace:WaitForChild("Map"):WaitForChild("Rooms")
	for _, Room in pairs(Rooms:GetChildren()) do
		if Room:GetAttribute("LightsOn") ~= Toggle then
			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UseLightSwitch"):FireServer(Room)
		end
	end
end
local function ToggleAllDaLights()
	if LightToggleStatus == false then
		LightToggleStatus = true
		ToggleLightNow(LightToggleStatus)
	else
		LightToggleStatus = false
		ToggleLightNow(LightToggleStatus)
	end
end

local function FireSpiritBox()
	local args = {
		"Are you far away?",
		"Are you near?",
		"Where are you?",
		"What do you want?",
		"When did you cross over?",
		"Are you in the room with me?",
		"Do you want us to leave?",
		"When did you pass away?",
		"What is your goal?",
		"Why are you here?",
		"How long ago did you die?",
		"Is there a ghost here?"
	}
	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AskSpiritBoxFromUI"):FireServer(args[math.random(1, #args)])
end

local DelaySBTick = tick()
local function UseSpiritBox()
	local ghostModel = workspace:WaitForChild("Ghost")
	local Chara = plr.Character
	if Chara and AutoSpiritBoxToggle and ghostModel:GetAttribute("Hunting") ~= true then
		Chara:PivotTo(ghostModel:GetPivot() * CFrame.new(0, 0, 10))
	else
		if Chara and AutoSpiritBoxToggle then
			TpOutside()
		end
	end

	if tick() - DelaySBTick > 0.5 and AutoSpiritBoxToggle and ghostModel:GetAttribute("Hunting") ~= true then
		DelaySBTick = tick()

		local Found, InvSlotNum = CheckInventory("Spirit Box")
		if not CheckInventory("Spirit Box") then
			local Found, Model = FindItem("Spirit Box")
			if Found and Model then
				PickupItem(Model)
				task.wait(0.35)
				ActiveItem()
				task.wait(0.5)
				local Found, InvSlotNum = CheckInventory("Spirit Box")
				if Found then
					EquipItem(InvSlotNum)
					task.wait(0.5)
					FireSpiritBox()
				end
			end
		else
			EquipItem(InvSlotNum)
			task.wait(0.35)
			ActiveItem()
			task.wait(0.35)
			FireSpiritBox()
		end
	end
end

local function UpdatePlrEnegry()
	for _, v in pairs(PlayerList:GetChildren()) do
		if v.Name == "Template" then
			v:Destroy()
		end
	end

	for _, plr in pairs(PS:GetPlayers()) do
		if plr:GetAttribute("Energy") ~= nil then
			local Clone = Template:Clone()
			Clone.Parent = PlayerList
			Clone.Visible = true
			if plr.Name == plr.DisplayName then
				Clone.Text = plr.Name .. ": " .. tostring(math.floor(plr:GetAttribute("Energy"))) .. "%"
			else
				Clone.Text = plr.Name .. "(" .. plr.DisplayName .. "): " .. tostring(math.floor(plr:GetAttribute("Energy"))) .. "%"
			end

		end
	end
end

function UpdatePlrEsp()
	if PlayersEspToggle then
		for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
			if plr.Character then
				local HumanoidRootPart = plr.Character:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart then
					local Esp1 = HumanoidRootPart:FindFirstChild("Ducko355PlrBil")
					local Esp2 = HumanoidRootPart:FindFirstChild("Ducko355PlrEsp")

					task.spawn(function() -- invisble player if they died
						if plr:GetAttribute("Dead") == true then
							for _, v in pairs(plr.Character:GetDescendants()) do
								if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
									v.Transparency = 0
								end

								if v.Name == "Ducko355PlrBil" then
									local Txt = v:FindFirstChild("TextLabel")
									if Txt then
										Txt.Text = plr.DisplayName .. "(Dead)"
									end
								end
							end
						end
					end)

					if not Esp1 and not Esp2 then
						local BillboardGui = Instance.new("BillboardGui")
						local TextLabel = Instance.new("TextLabel")
						local HL = Instance.new("Highlight")

						BillboardGui.Name = "Ducko355PlrBil"
						BillboardGui.Parent = HumanoidRootPart
						BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
						BillboardGui.Active = true
						BillboardGui.AlwaysOnTop = true
						BillboardGui.Size = UDim2.new(0, 100, 0, 40)
						BillboardGui.LightInfluence = 0
						BillboardGui.Brightness = 1
						BillboardGui.Adornee = HumanoidRootPart

						TextLabel.Parent = BillboardGui
						TextLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
						TextLabel.BackgroundTransparency = 1.000
						TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
						TextLabel.BorderSizePixel = 0
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.Font = Enum.Font.SourceSans
						TextLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
						TextLabel.TextScaled = true
						TextLabel.TextSize = 14.000
						TextLabel.TextWrapped = true
						TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
						TextLabel.TextStrokeTransparency = 0
						TextLabel.Text = plr.DisplayName

						HL.Name = "Ducko355PlrEsp"
						HL.Parent = HumanoidRootPart
						HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						HL.OutlineColor = Color3.fromRGB(0, 170, 255)
						HL.FillTransparency = 1
						HL.OutlineTransparency = 0
						HL.Adornee = plr.Character
					end
				end
			end
		end
	else
		for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
			if plr.Character then
				local HumanoidRootPart = plr.Character:FindFirstChild("HumanoidRootPart")
				if HumanoidRootPart then
					local Esp1 = HumanoidRootPart:FindFirstChild("Ducko355PlrBil")
					local Esp2 = HumanoidRootPart:FindFirstChild("Ducko355PlrEsp")

					if Esp1 then
						Esp1:Destroy()
					end

					if Esp2 then
						Esp2:Destroy()
					end
				end
			end
		end
	end
end

local function FixLinkTextBoxes()
	YoutubeTextBox.Text = "https://www.youtube.com/channel/UCSMOQh8gGh1dCiwEY9ce2Uw"
	DiscordTextBox.Text = "https://discord.gg/mNTEpwnkZC"
end
YoutubeTextBox.Changed:Connect(FixLinkTextBoxes)
DiscordTextBox.Changed:Connect(FixLinkTextBoxes)

function UpdateEvidenceEsp()
	for _, v in pairs(EvidenceEspList) do
		task.spawn(function()
			v:Destroy()
		end)
	end

	if EvidenceEspToggle then
		for _, obj in ipairs(workspace.Handprints:GetDescendants()) do
			if obj:IsA("BasePart") then
				local BillboardGui = Instance.new("BillboardGui")

				table.insert(EvidenceEspList, BillboardGui)
				table.insert(EvidenceEspList, HL)

				BillboardGui.Name = "Ducko355HandprintsBil"
				BillboardGui.Parent = game:GetService("CoreGui")
				BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				BillboardGui.Active = true
				BillboardGui.AlwaysOnTop = true
				BillboardGui.Size = UDim2.new(1, 0, 1, 0)
				BillboardGui.LightInfluence = 0
				BillboardGui.Brightness = 1
				BillboardGui.Adornee = obj
				BillboardGui.StudsOffset = Vector3.new(0, 1, 0)

				local ImageLabelFromSG = nil

				for _, v in pairs(obj:GetDescendants()) do
					if v:IsA("ImageLabel") then
						ImageLabelFromSG = v:Clone()
					end
				end

				if ImageLabelFromSG ~= nil then
					local ImageLabel = ImageLabelFromSG
					ImageLabel.Parent = BillboardGui
					ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
					ImageLabel.BackgroundTransparency = 1.000
					ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					ImageLabel.BorderSizePixel = 0
					ImageLabel.ImageTransparency = 0
					ImageLabel.Size = UDim2.new(1, 0, 1, 0)
				end
			end
		end

		local GhostOrbPart = nil
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name == "GhostOrb" then
				GhostOrbPart = obj
				GhostOrbPart.Transparency = 0
				break
			end
		end

		if GhostOrbPart then
			local BillboardGui = Instance.new("BillboardGui")
			local TextLabel = Instance.new("TextLabel")
			local HL = Instance.new("Highlight")

			table.insert(EvidenceEspList, BillboardGui)
			table.insert(EvidenceEspList, HL)

			BillboardGui.Name = "Ducko355OrbBil"
			BillboardGui.Parent = game:GetService("CoreGui")
			BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			BillboardGui.Active = true
			BillboardGui.AlwaysOnTop = true
			BillboardGui.Size = UDim2.new(3, 0, 3, 0)
			BillboardGui.LightInfluence = 0
			BillboardGui.Brightness = 1
			BillboardGui.Adornee = GhostOrbPart
			BillboardGui.StudsOffset = Vector3.new(0, 1, 0)

			TextLabel.Parent = BillboardGui
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Size = UDim2.new(1, 0, 1, 0)
			TextLabel.Font = Enum.Font.SourceSans
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextScaled = true
			TextLabel.TextSize = 14.000
			TextLabel.TextWrapped = true
			TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.TextStrokeTransparency = 0
			TextLabel.Text = "Orb"

			HL.Name = "Ducko355OrbEsp"
			HL.Parent = game:GetService("CoreGui")
			HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			HL.OutlineColor = Color3.fromRGB(255, 255, 255)
			HL.FillTransparency = 1
			HL.OutlineTransparency = 0
			HL.Adornee = GhostOrbPart
		end
	end
end
task.spawn(function()
	local Folder = workspace:WaitForChild("Handprints")
	FuncEvi = Folder.ChildAdded:Connect(function()
		UpdateEvidenceEsp()
	end)
end)

---------------------------------------
-------Check Functions-----------------
---------------------------------------
local function TrackTemp()
	local Temp = 100
	local TempRoom = nil

	for _, room in ipairs(roomsFolder:GetChildren()) do
		if room:GetAttribute("Temperature") ~= nil then
			if room:GetAttribute("Temperature") < Temp then --find the lowest temp
				Temp = room:GetAttribute("Temperature")
				TempRoom = room
			end
		end
	end

	return Temp, TempRoom
end

local function CheckHandprints()
	local found = false
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and (
			obj.Name == "Handprint1" or
				obj.Name == "Handprint2" or
				obj.Name == "Footprint" or
				obj.Name == "Footprint1"
			) then
			found = true
		end
	end

	return found
end

local function CheckGhostOrb()
	local found = false
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "GhostOrb" then
			found = true
			break
		end
	end

	return found
end

local function CheckEMF()
	local Level = 0
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Folder") and obj.Name == "Indicators" then
			for _, v in pairs(obj:GetChildren()) do
				if v:IsA("BasePart") and v.Material == Enum.Material.Neon and tonumber(v.Name) > Level then
					Level = tonumber(v.Name)
				end
			end
		end
	end
	return Level
end

local function CheckWither()
	local Found = false
	for _, obj in ipairs(workspace.Items:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "Petals" then
			if obj.Color == Color3.new(0,0,0) then
				Found = true
			end
		end
	end

	return Found
end

local function CheckGhostWriting()
	local Found = false

	for _, obj in ipairs(workspace.Items:GetDescendants()) do
		if obj:IsA("Decal") then
			local Model = obj:FindFirstAncestorWhichIsA("Model")
			if Model and Model:GetAttribute("ItemName") == "Spirit Book" then
				if obj.Texture ~= "" then
					Found = true
				end
			end
		end
	end

	return Found
end

local function CheckSpiritBox()
	local Found = false

	local GhostText = plr.PlayerGui.Subtitles.Holder.TextLabel.Text
	if #GhostText:gsub("%s+", "") >= 3 then
		Found = true
	end

	return Found
end

local LowestTemp = 100
local LowestTempRoom = nil
local HighestEMFLevel = 1

local OldTick = tick()
Func = RS.Heartbeat:Connect(function()
	UseSpiritBox()
	if tick() - OldTick > CheckSpeedNum then --delay 0.2s
		OldTick = tick()
		
		ModeText.Text = "Difficulty: " .. tostring(workspace:GetAttribute("Difficulty"))
		Take3StarsPhoto.Text = "Take 3 stars photo (" .. tostring(workspace:GetAttribute("PhotosTaken")) .. "/6)"
		
		FixLinkTextBoxes()
		UpdatePlrEnegry()
		UpdatePlrEsp()

		local Temp, TempRoom = TrackTemp()
		local HandprintsCheck = CheckHandprints()
		local GhostOrbCheck = CheckGhostOrb()
		local EMFLevelCheck = CheckEMF()
		local WitherCheck = CheckWither()
		local SpiritBoxCheck = CheckSpiritBox()
		local GhostWritingCheck = CheckGhostWriting()

		local GhostHunting = ghostModel:GetAttribute("Hunting")
		local GhostFavRoom = ghostModel:GetAttribute("FavoriteRoom")
		local GhostCurrentRoom = ghostModel:GetAttribute("CurrentRoom")
		local GhostAge = ghostModel:GetAttribute("Age")
		local GhostGender = ghostModel:GetAttribute("Gender")

		local InLaser = ghostModel:GetAttribute("InLaser")
		local LaserVisible = ghostModel:GetAttribute("InLaser")

		if GhostGender and GhostAge and GhostFavRoom then
			if GhostHunting == true then
				Ghost.Text = "Ghost(Hunting): "..GhostGender.." | Age: "..tostring(GhostAge).." | Fav room: "..GhostFavRoom
				Ghost.TextColor3 = Color3.fromRGB(255, 0, 0)
			else
				Ghost.Text = "Ghost: "..GhostGender.." | Age: "..tostring(GhostAge).." | Favorite room: "..GhostFavRoom
				Ghost.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		else
			if GhostHunting == true then
				Ghost.Text = "Ghost: Hunting"
				Ghost.TextColor3 = Color3.fromRGB(255, 0, 0)
			else
				Ghost.Text = "Ghost: Chilling"
				Ghost.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end

		if GhostCurrentRoom then
			CurrentRoom.Text = "Current room: " .. GhostCurrentRoom
		end

		if Temp and TempRoom then
			if Temp < LowestTemp then
				LowestTemp = Temp
				LowestTempRoom = TempRoom
				Temperature.Text = string.format("Temperature: %.1f°C", LowestTemp) .. " (" .. tostring(LowestTempRoom.Name) .. ")"
				if LowestTemp < 0 then
					Temperature.TextColor3 = Color3.fromRGB(0, 255, 0)
				end
			end
		end

		if HandprintsCheck then
			Handprints.Text = "Handprints: Yes"
			Handprints.TextColor3 = Color3.fromRGB(0, 255, 0)
		end

		if GhostOrbCheck then
			GhostOrb.Text = "GhostOrb: Yes"
			GhostOrb.TextColor3 = Color3.fromRGB(0, 255, 0)
		end

		if InLaser and LaserVisible then
			LaserProjector.Text = "Laser Projector: Yes"
			LaserProjector.TextColor3 = Color3.fromRGB(0, 255, 0)
		end

		if EMFLevelCheck > HighestEMFLevel then
			HighestEMFLevel = EMFLevelCheck
			if EMFLevelCheck == 5 then
				EMF.Text = "EMF level: " .. tostring(HighestEMFLevel)
				EMF.TextColor3 = Color3.fromRGB(0, 255, 0)
			end
		else
			if HighestEMFLevel ~= 5 then
				EMF.Text = "EMF level: " .. tostring(HighestEMFLevel)
			end
		end

		if WitherCheck then
			Wither.Text = "Wither: Yes"
			Wither.TextColor3 = Color3.fromRGB(0, 255, 0)
		end

		if SpiritBoxCheck then
			SpiritBox.Text = "Spirit Box: Yes"
			SpiritBox.TextColor3 = Color3.fromRGB(0, 255, 0)
		end

		if GhostWritingCheck then
			GhostWriting.Text = "Ghost Writing: Yes"
			GhostWriting.TextColor3 = Color3.fromRGB(0, 255, 0)
		end
	end
end)

GhostEsp.MouseButton1Click:Connect(function()
	CreateGhostEsp()

	if BillboardGui.Enabled == false then
		GhostEsp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	else
		GhostEsp.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	end
end)

EscapeHunt.MouseButton1Click:Connect(function()
	if IsEscapeHunt == false then
		IsEscapeHunt = true
		EscapeHunt.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		if ghostModel:GetAttribute("Hunting") then
			TpOutside()
		end
	else
		IsEscapeHunt = false
		EscapeHunt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
end)

TurnOnFuse.MouseButton1Click:Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ToggleFuseBox"):FireServer()
end)

AutoSpiritBox.MouseButton1Click:Connect(function()
	if AutoSpiritBoxToggle == false then
		AutoSpiritBoxToggle = true
		AutoSpiritBox.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	else
		AutoSpiritBoxToggle = false
		AutoSpiritBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		task.wait(0.2)
		TpOutside()
	end
end)

local db = false
PlaceStuff.MouseButton1Click:Connect(function()
	if ghostModel:GetAttribute("Hunting") == true or db == true then
		GhostHuntingInfo()
		return
	end
	
	db = true

	TpToGhost()
	
	task.wait(0.1)
	EquipItem(1)
	task.wait(0.1)
	DropItem(1)
	task.wait(0.1)

	EquipItem(1)
	task.wait(0.1)
	DropItem(1)
	task.wait(0.1)

	EquipItem(1)
	task.wait(0.1)
	DropItem(1)

	task.wait(0.2)

	local Found, Model = FindItem("Cross")
	if Found then
		PickupItem(Model)
	end
	task.wait(0.35)
	local Found, Model = FindItem("Cross")
	if Found then
		PickupItem(Model)
	end
	task.wait(0.35)
	local Found, Model = FindItem("Flower Pot")
	if Found then
		PickupItem(Model)
	end

	task.wait(0.5)--start drop


	EquipItem(1)
	task.wait(0.35)
	ActiveItem()
	task.wait(0.35)
	DropItem(1)
	task.wait(0.35)

	EquipItem(1)
	task.wait(0.35)
	ActiveItem()
	task.wait(0.35)
	DropItem(1)
	task.wait(0.35)

	EquipItem(1)
	task.wait(0.35)
	ActiveItem()
	task.wait(0.35)
	DropItem(1)

	--2nd drop round
	task.wait(0.5)

	local Found, Model = FindItem("Laser Projector")
	if Found then
		PickupItem(Model)
	end
	task.wait(0.35)
	local Found, Model = FindItem("EMF Reader")
	if Found then
		PickupItem(Model)
	end
	task.wait(0.35)
	local Found, Model = FindItem("Spirit Book")
	if Found then
		PickupItem(Model)
	end

	--local Found, Model = FindItem("Flower Pot")
	--if Found then
	--	PickupItem(Model)
	--end

	task.wait(0.5)--start drop

	EquipItem(1)
	task.wait(0.6)
	ActiveItem()
	task.wait(0.5)
	DropItem(1)
	task.wait(0.35)

	EquipItem(1)
	task.wait(0.6)
	ActiveItem()
	task.wait(0.5)
	DropItem(1)
	task.wait(0.35)

	EquipItem(1)
	task.wait(0.35)
	ActiveItem()
	task.wait(0.35)
	DropItem(1)
	task.wait(0.35)
	
	TpOutside()
	db = false
end)

local db2 = false
local function TakePhoto()
	if db2 == false then
		db2 = true
		local args = {
			CFrame.new(-20.164939880371094, -26.56522560119629, -79.07072448730469, -0.5815881490707397, 0.007826663553714752, 0.8134461045265198, 0.03132324293255806, 0.9994276762008667, 0.012779034674167633, -0.8128805160522461, 0.03291187435388565, -0.5815004706382751),
			{
				Stars = 3,
				Type = "Ghost",
				Object = workspace:WaitForChild("Ghost"),
				Reward = 24
			}
		}
		game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("TakePhotoWithCamera"):FireServer(unpack(args))
	
	else
		AlreadyTakenGhostPhotoInfo()
	end
end
TakeAPhoto.MouseButton1Click:Connect(function()
	if EquipPhotoCamera() then
		TakePhoto()
	end
end)

local Numbers = {0, 0.1, 0.2, 0.5, 1, 1.5, 2, 5, 10}
local index = 5
CheckSpeed.MouseButton1Click:Connect(function()
	index = index + 1
	if index > #Numbers then
		index = 1
	end
	CheckSpeedNum = Numbers[index]
	CheckSpeed.Text = "Check speed: " .. tostring(Numbers[index]) .. "s"
end)

ToggleLights.MouseButton1Click:Connect(function()
	if LightToggleStatus == false then
		ToggleLights.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	else
		ToggleLights.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
	ToggleAllDaLights()
end)

local Nextpagetoggle = false

NextPage.MouseButton1Click:Connect(function()
	if Nextpagetoggle == false then
		Nextpagetoggle = true
		Frame.Visible = false
		Frame2.Visible = true
		LinkFrame.Visible = false
		Link.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	else
		Nextpagetoggle = false
		Frame.Visible = true
		Frame2.Visible = false
		LinkFrame.Visible = false
		Link.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
end)

local ItemEspToggle = false

ItemEsp.MouseButton1Click:Connect(function()
	if ItemEspToggle == false then
		ItemEspToggle = true
		ItemEsp.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Model") and v:GetAttribute("ItemName") ~= nil then
				local BillboardGui = Instance.new("BillboardGui")
				local TextLabel = Instance.new("TextLabel")
				local HL = Instance.new("Highlight")
				
				table.insert(ItemEspList, BillboardGui)
				table.insert(ItemEspList, HL)

				BillboardGui.Name = "Ducko355ItemBil"
				BillboardGui.Adornee = v
				BillboardGui.Parent = v
				BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				BillboardGui.Active = true
				BillboardGui.AlwaysOnTop = true
				BillboardGui.Size = UDim2.new(0, 100, 0, 40)
				BillboardGui.LightInfluence = 0
				BillboardGui.Brightness = 1

				TextLabel.Parent = BillboardGui
				TextLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Size = UDim2.new(1, 0, 1, 0)
				TextLabel.Font = Enum.Font.SourceSans
				TextLabel.Text = v:GetAttribute("ItemName")
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextScaled = true
				TextLabel.TextSize = 14.000
				TextLabel.TextWrapped = true
				TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.TextStrokeTransparency = 0

				HL.Name = "Ducko355ItemEsp"
				HL.Parent = v
				HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				HL.OutlineColor = Color3.fromRGB(255, 170, 0)
				HL.FillTransparency = 1
				HL.OutlineTransparency = 0
				HL.Adornee = v
			end
		end
	else
		ItemEspToggle = false
		ItemEsp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		
		for _, v in pairs(ItemEspList) do
			v:Destroy()
		end
	end
end)

local SpeedNumbers = {0, 5, 10, 16, 20, 30, 40, 50, 80, 100}
local Speedindex = 3
Speedy.MouseButton1Click:Connect(function()
	Speedindex = Speedindex + 1
	if Speedindex > #SpeedNumbers then
		Speedindex = 1
	end
	plr.Character.Humanoid.WalkSpeed = SpeedNumbers[Speedindex]
	Speedy.Text = "Speed: " .. tostring(SpeedNumbers[Speedindex])
end)

Infyield.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

local FullBrightToggle = false
FullBright.MouseButton1Click:Connect(function()
	if FullBrightToggle == false then
		FullBrightToggle = true
		FullBright.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		Lighting.Ambient = Color3.new(1, 1, 1)
		Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		Lighting.Brightness = 3
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 100000
	else
		FullBrightToggle = false
		FullBright.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Lighting.Ambient = OldLightingList.Ambient
		Lighting.OutdoorAmbient = OldLightingList.OutdoorAmbient
		Lighting.Brightness = OldLightingList.Brightness
		Lighting.GlobalShadows = OldLightingList.GlobalShadows
		Lighting.FogEnd = OldLightingList.FogEnd
	end
end)

Link.MouseButton1Click:Connect(function()
	if LinkFrame.Visible == false then
		OldFrameVi = Frame.Visible
		OldFrame2Vi = Frame2.Visible
		task.wait()
		LinkFrame.Visible = true
		Frame.Visible = false
		Frame2.Visible = false
		Link.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	else
		LinkFrame.Visible = false
		Frame.Visible = OldFrameVi
		Frame2.Visible = OldFrame2Vi
		Link.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
end)

YoutubeCopy.MouseButton1Click:Connect(function()
	CopiedInfo()
	CopyToClipboard(YoutubeTextBox.Text)
end)

DiscordCopy.MouseButton1Click:Connect(function()
	CopiedInfo()
	CopyToClipboard(DiscordTextBox.Text)
end)

PlayersEsp.MouseButton1Click:Connect(function()
	if PlayersEspToggle == false then
		PlayersEspToggle = true
		PlayersEsp.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	else
		PlayersEspToggle = false
		PlayersEsp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
end)


local function AlreadyTakenCheck(Obj)
	local AlreadyTaken = false
	if Obj:GetAttribute("Ducko355AlreadyTakenPhoto") == true then
		AlreadyTaken = true
	end
	return AlreadyTaken
end
local db3 = false
Take3StarsPhoto.MouseButton1Click:Connect(function()
	if ghostModel:GetAttribute("Hunting") == true then
		GhostHuntingInfo()
		return
	end
	
	if db3 == false and EquipPhotoCamera() then
		db3 = true
		
		local Item = nil
		local ItemType = nil
		--Find burnt cross first
		for _, v in pairs(workspace.Items:GetChildren()) do
			if v:GetAttribute("DisplayName") == "Burnt Cross" then
				if not AlreadyTakenCheck(v) then
					v:SetAttribute("Ducko355AlreadyTakenPhoto", true)
					Item = v
					ItemType = "BurntCross"
					game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetPivot() * CFrame.new(0, 1, 0)
					break
				end
			end
		end

		--if no more burnt cross to take a photo then do this
		if ItemType == nil and Item == nil then
			for _, v in pairs(workspace.Interactables:GetChildren()) do
				if v:GetAttribute("PhotoRewardAvailable") == true then
					if not AlreadyTakenCheck(v) then
						v:SetAttribute("Ducko355AlreadyTakenPhoto", true)
						Item = v
						ItemType = "Interaction"
						game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetPivot() * CFrame.new(0, 1, 0)
						break
					end
				end
			end
		end

		if ItemType == "BurntCross" and Item ~= nil then
			local args = {
				workspace.CurrentCamera.CFrame,
				{
					Stars = 3,
					Type = "BurntCross",
					Object = Item,
					Reward = 12
				}
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("TakePhotoWithCamera"):FireServer(unpack(args))

		end

		if ItemType == "Interaction" and Item ~= nil then
			local args = {
				workspace.CurrentCamera.CFrame,
				{
					Stars = 3,
					Type = "Interaction",
					Object = Item,
					Reward = 8
				}
			}
			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("TakePhotoWithCamera"):FireServer(unpack(args))

		end

		if Item == nil and ItemType == nil then
			CantTakePhotoInfo()
		end
		
		task.wait(1)
		
		TpOutside()
		
		task.wait(1)
		
		db3 = false
	end
end)

EvidenceEsp.MouseButton1Click:Connect(function()
	if EvidenceEspToggle == false then
		EvidenceEspToggle = true
		EvidenceEsp.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	else
		EvidenceEspToggle = false
		EvidenceEsp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end

	UpdateEvidenceEsp()
end)

--Auto start the game: just open the main door
task.spawn(function()
	task.wait(30)
	local ExitDoorModel = nil

	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v.Name == "ExitDoor" then
			ExitDoorModel = v
			if v:GetAttribute("DoorClosed") ~= false then
				game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ClientChangeDoorState"):FireServer(ExitDoorModel:WaitForChild("Door"))
			else
				break
			end
		end
	end
end)
