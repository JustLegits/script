--[[
Demonic Hub Loader
This script is now open-source as of 11/21/2024.
Join our Discord: https://dsc.gg/demonichubv2
--]]


-- Fluent -> Progress translator hook
-- (yeah ik, lazy ahh hook but if it ain't broke don't fix it)
local f2p
local function LoadFluentHook()
    local fluentWatermark = "--[[\r\n    Fluent Interface Suite\r\n    This script is not intended to be modified.\r\n    To view the source code, see the 'src' folder on GitHub!\r\n\r\n    Author: dawid\r\n    License: MIT\r\n    GitHub: https://github.com/dawid-scripts/Fluent\r\n--]]"

    local oldLoadstring = loadstring
    loadstring = function(...)
        local scriptStr = ...
        if string.find(scriptStr, fluentWatermark, 1, true) then
            return f2p
        end
        return oldLoadstring(...)
    end
end

local GuiOfChoice
local ClipboardFunc = setclipboard or toclipboard or set_clipboard or Clipboard and Clipboard.set or CopyString


local function LoadHub()
    -- Yeah this thing (ER:LC) - has to be in the loader for... reasons.
    if game.PlaceId == 2534724415 then
        if getgenv().Bypassed == nil then
            getgenv().Bypassed = true
            local part = Instance.new("Part", game.Workspace)
            part.Anchored = true
            part.CFrame = CFrame.new(Vector3.new(-462, 12, -444))
            part.Size = Vector3.new(100, 1, 100)

            local ScriptContext = game:GetService("ScriptContext")

            for i,v in pairs(getconnections(ScriptContext.Error)) do
                v:Disable()
            end

            local network = game.ReplicatedStorage.Modules.Network

            old = hookmetamethod(game, "__index",function(key, value)
                if getcallingscript() == network then
                    return delay(math.huge())
                end

                return old(key, value)
            end)
        end
    end


    -- Create loading screen
    local TweenService = game:GetService("TweenService")

    local LoaderGui = Instance.new("ScreenGui")
    LoaderGui.Parent = game.CoreGui
    LoaderGui.Name = "Loader"
    local LoaderBg = Instance.new("Frame")
    LoaderBg.Size = UDim2.fromOffset(400, 200)
    LoaderBg.Position = UDim2.fromScale(0.5, 0.5)
    LoaderBg.AnchorPoint = Vector2.one * 0.5 -- todo: benchmark
    LoaderBg.BackgroundTransparency = 0.25
    LoaderBg.ClipsDescendants = true
    Instance.new("UICorner", LoaderBg)
    LoaderBg.Parent = LoaderGui
    local SexyGradient = Instance.new("UIGradient")
    SexyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0.5)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 0.5, 0))
    })
    SexyGradient.Rotation = 90
    SexyGradient.Parent = LoaderBg
    local HubLogo = Instance.new("ImageLabel")
    HubLogo.Size = UDim2.fromOffset(100, 100)
    HubLogo.Image = "rbxassetid://16755289922"
    HubLogo.Position = UDim2.fromScale(0.5, 0.5)
    HubLogo.AnchorPoint = Vector2.one * 0.5 -- todo: benchmark
    HubLogo.BackgroundTransparency = 1
    HubLogo.Parent = LoaderBg
    local HubText = Instance.new("TextLabel")
    HubText.Size = UDim2.fromScale(1, 1)
    HubText.Text = "<b>Demonic</b> Hub"
    HubText.RichText = true
    HubText.TextSize = 40
    HubText.Font = Enum.Font.Montserrat
    HubText.TextColor3 = Color3.new(1, 1, 1)
    HubText.Position = UDim2.fromScale(0.5, 0.5)
    HubText.AnchorPoint = Vector2.one * 0.5 -- todo: benchmark
    HubText.BackgroundTransparency = 1
    HubText.TextTransparency = 1
    HubText.Parent = LoaderBg
    local TopLabel = Instance.new("TextLabel")
    TopLabel.Size = UDim2.new(1, 0, 0, 50)
    TopLabel.Text = "Loading..."
    TopLabel.TextSize = 14
    TopLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
    TopLabel.TextColor3 = Color3.new(1, 1, 1)
    TopLabel.BackgroundTransparency = 1
    TopLabel.Parent = LoaderBg
    local BotLabel = Instance.new("TextLabel")
    BotLabel.Size = UDim2.new(1, 0, 0, 50)
    BotLabel.Position = UDim2.fromScale(0, 1)
    BotLabel.AnchorPoint = Vector2.yAxis
    BotLabel.Text = ({
        "Greetings, mortal!",
        "Warming up...",
        "Join our Discord! dsc.gg/demonichubv2",
        "Hell-o there!",
        "Unleashing the demons..."
    })[math.random(1, 5)]
    BotLabel.TextSize = 14
    BotLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
    BotLabel.TextColor3 = Color3.new(1, 1, 1)
    BotLabel.BackgroundTransparency = 1
    BotLabel.Parent = LoaderBg
    local ProgressBarClip = Instance.new("Frame")
    ProgressBarClip.BackgroundTransparency = 1
    ProgressBarClip.Size = UDim2.new(1, 0, 0, 8)
    ProgressBarClip.ClipsDescendants = true
    ProgressBarClip.Parent = LoaderBg
    local ProgressBar = Instance.new("Frame")
    ProgressBar.BackgroundColor3 = Color3.new(1, 0, 0.5)
    --ProgressBar.Size = UDim2.fromScale(0, 2)
    Instance.new("UICorner", ProgressBar)
    ProgressBar.Parent = ProgressBarClip

    TweenService:Create(HubLogo, TweenInfo.new(4, Enum.EasingStyle.Back, Enum.EasingDirection.In, -1, true), {ImageTransparency = 10}):Play()
    TweenService:Create(HubText, TweenInfo.new(4, Enum.EasingStyle.Back, Enum.EasingDirection.In, -1, true), {TextTransparency = -10}):Play()


    -- Load the assets
    --[[
    At minimum 3 scripts without key sys:
    Demonic UI Library
    Fluent -> Demonic UI Translator (if applicable)
    This Game's Script
    
    At minimum 5 scripts with key sys:
    Notify Module
    Panda-Pelican Key System
    Demonic UI Library
    Fluent -> Demonic UI Translator (if applicable)
    This Game's Script
    --]]

    local Games = { -- Old games with legacy UI are here
        [3367801828] = "https://raw.githubusercontent.com/Alan0947383/Starving-Artist/main/Protected_5961203781966799.lua.txt",
        [4924516231] = "https://raw.githubusercontent.com/Alan0947383/Si/main/%C3%91eje",
        [4850069859] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/Protected_2681690995407557.lua.txt",
        [2463681758] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/Protected_1657187750888170.lua.txt",
        [4290156271] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/Protected_4925462867409545.lua.txt",
        [3967853925] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/Protected_8283385440560045.lua.txt",
        [4777817887] = "https://raw.githubusercontent.com/Alan0947383/Si/main/Protected_3057554732589237.lua.txt",
        [4891819020] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/Protected_3406929768708524.lua.txt",
        [1176784616] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [5004586661] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/Protected_8275630821642050.lua.txt",
        [3825332406] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Protected_8681698493352034.lua.txt",
        [1268927906] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [5084346631] = "https://raw.githubusercontent.com/Alan0947383/Sceipt/main/Protected_6104127350297687.lua.txt",
        [4966177615] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_8381859233335395.lua.txt",
        [3476371299] = "https://raw.githubusercontent.com/Alan0947383/Starving-Artist/main/Protected_7100361731424888.lua.txt",
        [4740395866] = "https://raw.githubusercontent.com/Alan0947383/Sceipt/main/Protected_8372297767879308.lua.txt",
        [5133949457] = "https://raw.githubusercontent.com/Alan0947383/NOBRO/main/Protected_1171215695658233.lua.txt",
        [2795379888] = "https://raw.githubusercontent.com/Alan0947383/Daddy-dad/main/Protected_8938208422607303.lua.txt",
        [5092677388] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Tx3Obf_1655.lua.txt",
        [1119466531] = "https://raw.githubusercontent.com/Alan0947383/Script/main/Protected_1136044717756863.lua.txt",
        [3437355615] = "https://raw.githubusercontent.com/Alan0947383/NOBRO/main/Protected_4650768380869194.lua.txt",
        [4997576846] = "https://raw.githubusercontent.com/Alan0947383/Si/main/Protected_8656464779741282.lua.txt",
        [279565647] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Protected_4965359631779267.lua.txt",
        [1720936166] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Protected_8603934828393872.lua.txt",
        [4795326392] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Protected_8002148043809685.lua.txt",
        [5369041526] = "https://raw.githubusercontent.com/Alan0947383/Webiwabo/main/Protected_2316481146645602.lua.txt",
        [5315788173] = "https://raw.githubusercontent.com/Alan0947383/Sceipt/main/Protected_9420288731611243.lua.txt",
        [5263201286] = "https://raw.githubusercontent.com/Alan0947383/Webiwabo/main/Protected_5534351083085459.lua.txt",
        [5454107027] = "https://raw.githubusercontent.com/Alan0947383/E/main/Protected_3692448943322290.lua.txt",
        [5184742769] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/Protected_5085697523046855.lua.txt",
        [5300677688] = "https://raw.githubusercontent.com/Alan0947383/Daddy/main/Protected_9635750815542599.lua.txt",
        [5510084750] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_7870413447301490.lua.txt",
        [5379493222] = "https://raw.githubusercontent.com/Alan0947383/Web/main/Protected_4754294343286402.lua.txt",
        [5650953811] = "https://raw.githubusercontent.com/Alan0947383/Nrezgam/main/Protected_9762347694916566.lua.txt",
        [5504560478] = "https://raw.githubusercontent.com/Alan0947383/Nrezgam/main/Protected_4785523856894885.lua.txt",
        [5944511907] = "https://raw.githubusercontent.com/Alan0947383/Nrezgam/main/Protected_3432066847523166.lua.txt",
        [5591160428] = "https://raw.githubusercontent.com/Alan0947383/Sceipt/main/Protected_9531557592417844.lua.txt",
        [5252919404] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_1522750820094663.lua.txt",
        [2331157949] = "https://raw.githubusercontent.com/Alan0947383/DadSponso/main/Protected_3569063412811514.lua.txt",
        [66654135] = "https://raw.githubusercontent.com/Alan0947383/Daddy-dad/main/Protected_2229840851576053.lua.txt",
        [1526814825] = "https://raw.githubusercontent.com/Alan0947383/Quantumix-Networks/main/Protected_4205650682104571.lua%20(1).txt",
        [4438020625] = "https://raw.githubusercontent.com/Alan0947383/Starving-Artist/main/Protected_9958818432885059.lua.txt",
        [4984260245] = "https://raw.githubusercontent.com/Alan0947383/Games/main/Protected_6382869324058001.lua.txt",
        [5188624491] = "https://raw.githubusercontent.com/Alan0947383/Games/main/Protected_8846464779210284.lua.txt",
        [5440820902] = "https://raw.githubusercontent.com/Alan0947383/Daddy-dad/main/Protected_4283656671627086.lua.txt",
        [3164075108] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [2426874309] = "https://raw.githubusercontent.com/Alan0947383/Si/main/Protected_7825987766784382.lua.txt",
        [903807016] = "https://raw.githubusercontent.com/Alan0947383/Quantumix-Networks/main/Protected_3263222660280185.lua.txt",
        [1415710834] = "https://raw.githubusercontent.com/Alan0947383/Quantumix-Networks/main/Protected_2313122183703587.lua.txt",
        [5405139138] = "https://raw.githubusercontent.com/Alan0947383/Quantumix-Networks/main/Protected_7294437628503856.lua.txt",
        [5732570193] = "https://raw.githubusercontent.com/Alan0947383/Starving-Artist/main/Protected_6388934473431519.lua.txt",
        [4012406005] = "https://raw.githubusercontent.com/Alan0947383/Quantumix-Networks/main/Protected_2558554299247274.lua.txt",
        [2382284116] = "https://raw.githubusercontent.com/Alan0947383/Games/main/Protected_5934247617138625.lua.txt",
        [1776914212] = "https://raw.githubusercontent.com/Alan0947383/Quantumix-Networks/main/Protected_5738090012004114.lua.txt",
        [5690744826] = "https://raw.githubusercontent.com/Alan0947383/Quantumix-Networks/main/Protected_8645852491926860.lua.txt",
        [1160789089] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_6432195520995751.lua.txt",
        [1888174103] = "https://raw.githubusercontent.com/Alan0947383/Games/main/Protected_4137266859943316.lua.txt",
        [2114144926] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_8502550453694657.lua.txt",
        [4592143244] = "https://raw.githubusercontent.com/Alan0947383/Quantumix-Networks/main/Protected_1385121065062812.lua.txt",
        [4444526080] = "https://raw.githubusercontent.com/Alan0947383/Quantumix-Networks/main/Protected_3517075793996011.lua.txt",
        [5655637737] = "https://raw.githubusercontent.com/Alan0947383/Batman/main/Protected_8297489647252768.lua.txt",
        [5527053167] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_3786209983794885.lua.txt",
        [5650396773] = "https://raw.githubusercontent.com/Alan0947383/Sceipt/main/Protected_2422444589943913.lua.txt",
        [5638624623] = "https://raw.githubusercontent.com/Alan0947383/Batman/main/Protected_5245377241908856.lua.txt",
        [1016936714] = "https://raw.githubusercontent.com/Alan0947383/Games/main/Protected_6572093315327546.lua.txt",
        [5321619756] = "https://raw.githubusercontent.com/Alan0947383/NOBRO/main/Protected_2679138632601495.lua.txt",
        [5690246134] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_8453009989022232.lua.txt",
        [3256689155] = "https://raw.githubusercontent.com/Alan0947383/DadSponso/main/Luable-Obfuscator_Verion-Encryption_Id-1227523790196445218.lua.txt",
        [5677613211] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [5751238941] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_3743785966678709.lua.txt",
        [8501383242] = "https://raw.githubusercontent.com/Alan0947383/Important/main/77_X4RPQ.lua.txt",
        [2633076999] = "https://raw.githubusercontent.com/Alan0947383/Games/main/77_C5IPZUSJW53.lua.txt",
        [5766474023] = "https://raw.githubusercontent.com/Alan0947383/Si/main/77_OMY9SQ6ULW.lua.txt",
        [9704927237] = "https://raw.githubusercontent.com/Prosexy/F/main/77_QX2JE4LILMPU7A.lua.txt",
        [1782832995] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [3457700596] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [5675104029] = "https://raw.githubusercontent.com/Prosexy/F/main/77_O9Q4G4JOAON8.lua.txt",
        [4568630521] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [3525075510] = "https://raw.githubusercontent.com/Prosexy/F/main/77_OPP0QTACHIDFU1.lua.txt",
        [5200655965] = "https://raw.githubusercontent.com/Prosexy/F/main/77_J5JCX7.lua%20(1).txt",
        [5567917599] = "https://raw.githubusercontent.com/Prosexy/F/main/77_RZ93YAWV.lua.txt",
        [5954484868] = "https://raw.githubusercontent.com/Prosexy/F/main/77_FGRT8Q8ENMO.lua.txt",
        [3508322461] = "https://raw.githubusercontent.com/Prosexy/F/main/77_LYZ44E7.lua.txt",
        [5747480325] = "https://raw.githubusercontent.com/Prosexy/F/main/77_7C6GERQ.lua.txt",
        [4724071612] = "https://raw.githubusercontent.com/Prosexy/F/main/77_9YNNS4N6M.lua.txt",
        [1451439645] = "https://raw.githubusercontent.com/Prosexy/F/main/77_W7NNB.lua.txt",
        [4855369361] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/77_RY4DKP412.lua.txt",
        [3965173814] = "https://raw.githubusercontent.com/Alan0947383/E/main/Protected_7636735536006261.lua.txt",
        [4886369361] = "https://raw.githubusercontent.com/Alan0947383/E/main/Protected_9716953918674203.lua.txt",
        [4509896324] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [5329077236] = "https://raw.githubusercontent.com/Alan0947383/DadSponso/main/Protected_8006538686694284.lua.txt",
        [5107841430] = "https://raw.githubusercontent.com/Alan0947383/E/main/Protected_3199830321051868.lua.txt",
        [5530985540] = "https://raw.githubusercontent.com/Alan0947383/E/main/Protected_6994043622068759.lua.txt",
        [2429242760] = "https://raw.githubusercontent.com/Alan0947383/NOBRO/main/Protected_4134003975235398.lua.txt",
        [1531130248] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Protected_2523634588778779.lua.txt",
        [5380927916] = "https://raw.githubusercontent.com/Alan0947383/Nrezgam/main/Protected_7143155165319345.lua%20(1).txt",
        [4201418016] = "https://raw.githubusercontent.com/Alan0947383/Nrezgam/main/Protected_6370626173347436.lua.txt",
        [73885730] = "https://raw.githubusercontent.com/Alan0947383/Starving-Artist/main/Protected_5495171337695488.lua.txt",
        [4979437722] = "https://raw.githubusercontent.com/Alan0947383/Script/main/Protected_1711573047964761.lua.txt",
        [3541611379] = "https://raw.githubusercontent.com/Alan0947383/NOBRO/main/Protected_1420061771536853.lua.txt",
        [16139895491] = "https://raw.githubusercontent.com/Alan0947383/Nrezgam/main/Protected_4038515180561797.lua.txt",
        [4459068662] = "https://raw.githubusercontent.com/Alan0947383/Nrezgam/main/Protected_6213117296942844.lua.txt",
        [4538598064] = "https://raw.githubusercontent.com/Alan0947383/Nrezgam/main/Protected_7345632992152827.lua.txt",
        [5422507366] = "https://raw.githubusercontent.com/Alan0947383/Nrezgam/main/Protected_9289311256253440.lua.txt",
        [1037979853] = "https://raw.githubusercontent.com/Alan0947383/Web/main/Protected_4649824632538637.lua.txt",
        [3633410608] = "https://raw.githubusercontent.com/Alan0947383/Daddy/main/Protected_4394947032958284.lua.txt",
        [5361032378] = "https://raw.githubusercontent.com/Alan0947383/DadSponso/main/Protected_3896323033799344.lua.txt",
        [4337094233] = "https://raw.githubusercontent.com/Alan0947383/Starving-Artist/main/Protected_6606053521941670.lua.txt",
        [5565260329] = "https://raw.githubusercontent.com/Alan0947383/Webiwabo/main/Protected_4545471853558622.lua.txt",
        [5269127662] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_6756406981039467.lua.txt",
        [5184146090] = "https://raw.githubusercontent.com/Alan0947383/Daddy/main/Protected_1804738344493693.lua.txt",
        [2820580801] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Protected_8014136027451654.lua.txt",
        [2820580801] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Protected_2886843259179568.lua.txt",
        [4938220315] = "https://raw.githubusercontent.com/Alan0947383/Webiwabo/main/Protected_9637992958163555.lua.txt",
        [5365729763] = "https://raw.githubusercontent.com/Alan0947383/Important/main/Protected_3100605997134071.lua.txt",
        [301549746] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Protected_3598114981737733.lua.txt",
        [2331157949] = "https://raw.githubusercontent.com/Alan0947383/DadSponso/main/Protected_3569063412811514.lua.txt",
        [3713854848] = "https://raw.githubusercontent.com/Alan0947383/Coems/main/Protected_1259706287546367.lua.txt",
        [5799867123] = "https://raw.githubusercontent.com/Prosexy/F/main/77_YVT4A.lua.txt",
        [1147304238] = "https://raw.githubusercontent.com/Alan0947383/Important2/main/Protected_5661913663966891.lua.txt",
        [1650291138] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/77_KOF4HMBT4IQZF.lua.txt",
        [5656903219] = "https://raw.githubusercontent.com/Prosexy/F/main/77_YOGN417.lua.txt",
        [3808081382] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [5990372955] = "https://raw.githubusercontent.com/Prosexy/F/main/77_0ZHZIG1EG3.lua.txt",
        [210851291] = "https://raw.githubusercontent.com/Alan0947383/Script/main/77_TCGF7JHZBJDY.lua.txt",
        [848145103] = "https://raw.githubusercontent.com/Alan0947383/Batman/main/77_UCFVL.lua.txt",
        [5170731021] = "https://raw.githubusercontent.com/Alan0947383/Games/main/77_Z7E0WAZY.lua.txt",
        [5991139138] = "https://raw.githubusercontent.com/Prosexy/F/main/77_NI8EIK9XS.lua.txt",
        [5972059550] = "https://raw.githubusercontent.com/Alan0947383/Coemssjsns/main/77_A0NZM4EL7.lua.txt",
        [2961111240] = "https://raw.githubusercontent.com/Alan0947383/Webiwabo/main/77_EH0T7DKAZ1QLD.lua.txt",
        [3213362013] = "https://raw.githubusercontent.com/Alan0947383/E/main/77_18KTCEVQTUQES.lua.txt",
        [5479908441] = "https://raw.githubusercontent.com/Alan0947383/Daddy-dad/main/77_B5F9NEC77RDV.txt",
        [5976020326] = "https://raw.githubusercontent.com/Prosexy/F/main/77_F6GOEY.txt",
        [6040823996] = "https://raw.githubusercontent.com/Prosexy/F/main/77_HIAG8Y2EJKB5.txt",
        [6061766680] = "https://raw.githubusercontent.com/Prosexy/F/main/77_NX95BH3T.txt",
        [3936365689] = "https://raw.githubusercontent.com/Prosexy/F/main/77_KK52FWUOLX.txt",
        [2655311011] = "https://raw.githubusercontent.com/Prosexy/F/main/77_5QQ503.txt",
        [3990106548] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua",
        [5901557156] = "https://raw.githubusercontent.com/Prosexy/F/main/77_ROFMMLOC.txt",
        [5521255650] = "https://raw.githubusercontent.com/Prosexy/F/main/77_LSO22QS.txt",
        [5754877170] = "https://raw.githubusercontent.com/Prosexy/F/main/77_JBHNJ.txt",
        [6174407103] = "https://raw.githubusercontent.com/Prosexy/F/main/77_W6F9E21ZRH.txt",
        -- Games that exclusively use Progress start below
        [3756501373] = "https://raw.githubusercontent.com/Prosexy/F/main/77_34G0Y.txt",
        [5985126622] = "https://raw.githubusercontent.com/Prosexy/F/main/77_8BUVLPADR8CX6.txt",
        [6216468795] = "https://raw.githubusercontent.com/Prosexy/F/main/77_KRMECA1MO0.txt",
        [4572323622] = "https://raw.githubusercontent.com/Prosexy/F/main/77_17OH0Q35.txt",
        [6149138290] = "https://raw.githubusercontent.com/Prosexy/F/main/77_QNE3CGU70.txt",
        [5924989485] = "https://raw.githubusercontent.com/Prosexy/F/main/77_YTMJ2S.txt",
        [5931899687] = "https://raw.githubusercontent.com/Prosexy/F/main/77_D0IHG0IHNS7JV.txt",
        [3110388936] = "https://raw.githubusercontent.com/Prosexy/Bunny/main/Protected_9219599163677822.txt",
        [5868588140] = "https://raw.githubusercontent.com/Prosexy/Bunny/main/77_3VBHJAL7UL.txt",
        [1831550657] = "https://raw.githubusercontent.com/alan11ago/Hub/refs/heads/main/ImpHub.lua"
    }
    local ProgressGames = {
        3756501373, 5985126622, 6216468795, 4572323622, 6149138290,
        5924989485, 5931899687, 3110388936, 5868588140, 1831550657
    }

    local DangerousGames = {
        [3164075108] = "- Auto Collect Dragon Balls\n- (Possibly) Auto Farm", -- Dragon Soul
        -- [3936365689] = "- Auto Collect Dragon Balls", -- Clover Retribution (fixed)
        [5170731021] = "Unknown, people have reported bans in this game.", -- Demon Blade
        [5321619756] = "Using Auto Farm + Kill Aura together causes a detection", -- Bladers: Rebirth
        [3367801828] = "- Copy Art\n- Instant Arts\n(Kicks 5 times then ban)", -- Starving Artists
        [903807016] = "- Teleports", -- Emergency Response: Liberty County
        [1016936714] = "- Autofarming Teleport" -- Your Bizarre Adventure (YBA)
    }

    local GameUrl = Games[game.GameId] or Games[game.PlaceId]

    local moduleQueue = {
        Progress = {"https://raw.githubusercontent.com/cheapsk9/progress/main/beta.lua", "Demonic UI Library"}
    }
    local modules = {}

    if GameUrl then
        moduleQueue.GameScript = {GameUrl, "This Game's Script"}
    else
        moduleQueue.Notify = {"https://raw.githubusercontent.com/x9PSwiftz/Panda/main/Notification.lua", "Notification Module"}
        moduleQueue.NotificationHolder = {"https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua", "Loady Notification Holder"}
        moduleQueue.Notification = {"https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua", "Loady Notification"}
        moduleQueue.Loady = {"https://bitbucket.org/cat__/uis/raw/Loady/Module", "Loady"}
    end
    if not table.find(ProgressGames, game.GameId) then
        moduleQueue.f2p = {"https://raw.githubusercontent.com/cheapsk9/progress/main/f2p.lua", "Fluent -> Demonic UI Translator"}
    end

    local function LoadProgress()
        
        Progress = modules.Progress()
        
        if ClipboardFunc then
            Progress:ShowToast({
                Duration = 10, Title = "Copy To Clipboard",
                Text = "Are you sure you want to copy the server invite to your clipboard?",
                Buttons = {
                    {
                        Title = "Yes",
                        Callback = function() ClipboardFunc("https://dsc.gg/demonichubv2") end
                    },
                    {
                        Title = "No"
                    }
                }
            })
        end

        Progress.Screen.Parent = GuiOfChoice
        Progress.Login.Object.Visible = true
        Progress.Window:Open()

        local danger = DangerousGames[game.GameId]
        if danger then
            Progress.Window:ShowDialog({
                Title = "DANGER!!",
                Text = "Some features of this script are now detected by the game's anti-cheat. Since we no longer maintain this script, we can't disable them.\nThe detected features are shown below, but are not limited to:\n\n" .. danger .. "\n\nWe HIGHLY recommend you close Demonic Hub and Roblox now, or you may risk being banned. Or, you can venture forth into the unknown, but don't say we didn't warn you.\nBY CLICKING \"Enter Danger Zone\" YOU ARE USING DEMONIC HUB SOLELY AT YOUR OWN RISK.",
                Buttons = {
                    {
                        Title = "Close Demonic Hub",
                        Callback = function() Progress.Window:Close() end
                    },
                    {
                        Title = "Enter Danger Zone",
                        Secondary = true
                    }
                }
            })
        end

        local function LoadScript()
            f2p = modules.f2p
            if f2p then
                LoadFluentHook()
                sexyfluent = f2p()
            end

            Progress.Login.Object.Visible = false
            Progress.Hub.Object.Visible = true

            canaccess = "yessir"

            if GameUrl then
                -- Load game script
                local success, err = pcall(modules.GameScript)
                if not success then
                    local dialogTbl = {
                        Title = "Error Loading Script!",
                        Text = "Sorry, but an error is preventing the script for your game from loading properly. This is usually due to an update to the game breaking the script. There is a chance some of the script may still work, but other parts may be broken. Feel free to open a bug report in our Discord server at dsc.gg/demonichubv2\nSorry for the inconvenience! The error is shown below.",
                        CopyBoxText = err,
                        Buttons = {
                            [2] = {
                                Title = "Close Demonic Hub",
                                Callback = function() Progress.Window:Close() end,
                                Secondary = true
                            },
                            [3] = {
                                Title = "Continue Anyway"
                            }
                        }
                    }
                    if ClipboardFunc then
                        dialogTbl.Buttons[1] = {
                            Title = "Copy to Clipboard",
                            Callback = function() ClipboardFunc(err) end,
                        }
                    end
                    Progress.Window:ShowDialog(dialogTbl)
                end
            else
                -- Load loady
                local Notify = modules.Notify()
                modules.NotificationHolder() -- Load notification holder
                local Notification = modules.Notification()
                
                Notify.New("Your game may not be supported!", 15)

                Notification:Notify({
                    Title = "Loading Gui...",
                    Description = "Hi! You should check our supported games, it may not be what you're looking for!"
                },
                {
                    OutlineColor = Color3.fromRGB(41, 1, 1),
                    Time = 5.5, 
                    Type = "option"
                },
                {
                    Image = "http://www.roblox.com/asset/?id=6023426923",
                    ImageColor = Color3.fromRGB(255, 84, 84),
                    Callback = function(State)
                        print(tostring(State))
                    end
                })
                --task.wait(1.5) -- Some executors HATE it when we yield inside a loadstring, ughh
                local Library = modules.Loady()
                local Window = Library:Window("Demonic HUB | V2", function(Script, Func)
                    loadstring(game:HttpGet(Script, true))()
                end, {
                    Translate = false
                })

                Window:Game({
                    Place = 9704927237,
                    Status = "Working",
                    Script = "https://raw.githubusercontent.com/Prosexy/F/main/77_QX2JE4LILMPU7A.lua.txt"
                })

                Window:Game({
                    Place = 8501383242,
                    Status = "Working",
                    Script = "https://raw.githubusercontent.com/Alan0947383/Important/main/77_X4RPQ.lua.txt"
                })

                Window:Game({
                    Place = 12588367314,
                    Status = "Working",
                    Script = "https://raw.githubusercontent.com/Alan0947383/E/main/Protected_7627352893542126.lua.txt"
                })

                Window:Initiate()
            end
        end
        
        task.delay(0.5, LoadScript)
    end


    -- Load everything
    local loadGoal = 0
    local loadCurr = 0
    local function loadUrl(name, module)
        modules[name] = loadstring(game:HttpGet(module[1], true))
        loadCurr = loadCurr + 1
        TopLabel.Text = module[2] .. " (" .. loadCurr .. "/" .. loadGoal .. ")"
        ProgressBar.Size = UDim2.fromScale(loadCurr/loadGoal, 2)
        if loadCurr == loadGoal then
            local LoaderCloseTween = TweenService:Create(LoaderBg, TweenInfo.new(1), {Size = UDim2.fromOffset(0, 200)})
            LoaderCloseTween.Completed:Connect(function()
                LoaderGui:Destroy()
            end)
            LoaderCloseTween:Play()
            LoadProgress()
        end
    end
    for _ in next, moduleQueue do
        loadGoal = loadGoal + 1
    end
    for k, v in next, moduleQueue do
        coroutine.resume(coroutine.create(loadUrl), k, v)
    end
    
end

-- Check for CoreGui access
if pcall(function()
        local Test = Instance.new("ScreenGui")
        Test.Name = "Test"
        Test.Parent = game:GetService("CoreGui")
        Test:Destroy()
    end)
then
    GuiOfChoice = game:GetService("CoreGui")
    LoadHub()
else
    local bindable = Instance.new("BindableFunction")
    bindable.OnInvoke = function(choice)
        if choice == "Yes" then
            LoadHub()
        end
        bindable:Destroy()
        bindable = nil
    end
    GuiOfChoice = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if GuiOfChoice then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Run hub anyway?",
            Text = "No access to CoreGui. This may cause problems in games with sensitive anti-cheats.",
            Icon = "rbxassetid://16755289922",
            Duration = 10,
            Callback = bindable,
            Button1 = "Yes",
            Button2 = "No",
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "This is awkward...",
            Text = "Looks like the developer of the game decided to troll us by removing PlayerGui. Therefore, we can't run the hub.",
            Icon = "rbxassetid://16755289922",
            Duration = 10,
        })
    end
end
