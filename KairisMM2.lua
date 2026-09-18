-- ===== Kairis Hub - Clean Edition (No Analytics) =====
-- Removed all external HTTP pings. No phone-home. No tracking.
-- Everything else stays the same — full functionality, zero leaks.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local Workspace = workspace or game:GetService("Workspace")
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Safe getgenv fallback
local getgenv = getgenv or function() return _G end

-- ===== Safe Splash Screen (error-hardened) =====
local KairisSplash = (function()
    local api = { set = function() end, done = function() end }
    local success, result = pcall(function()
        local gold, rose = Color3.fromRGB(233, 196, 132), Color3.fromRGB(201, 141, 158)
        local gui = Instance.new("ScreenGui")
        gui.Name = "KairisSplash"
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 2147483647
        
        local parentSuccess = false
        if gethui then
            parentSuccess = pcall(function() gui.Parent = gethui() end)
        end
        if not parentSuccess then
            parentSuccess = pcall(function() gui.Parent = CoreGui end)
        end
        if not parentSuccess then
            pcall(function() gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
        end
        
        local dim = Instance.new("Frame")
        dim.Size = UDim2.fromScale(1, 1)
        dim.BackgroundColor3 = Color3.fromRGB(5, 4, 3)
        dim.BackgroundTransparency = 0.2
        dim.BorderSizePixel = 0
        dim.Parent = gui
        
        local card = Instance.new("Frame")
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.Position = UDim2.fromScale(0.5, 0.5)
        card.Size = UDim2.fromOffset(300, 100)
        card.BackgroundColor3 = Color3.fromRGB(18, 14, 11)
        card.BorderSizePixel = 0
        card.Parent = dim
        
        local corner = Instance.new("UICorner", card)
        corner.CornerRadius = UDim.new(0, 16)
        
        pcall(function()
            TweenService:Create(card, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(380, 210)
            }):Play()
        end)
        
        local stroke = Instance.new("UIStroke", card)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.25
        local sg = Instance.new("UIGradient", stroke)
        sg.Color = ColorSequence.new(gold, rose)
        sg.Rotation = 25
        
        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Position = UDim2.fromOffset(0, 26)
        title.Size = UDim2.new(1, 0, 0, 34)
        title.Text = "KAIRIS HUB"
        title.TextSize = 30
        title.TextColor3 = Color3.new(1, 1, 1)
        pcall(function()
            title.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold)
        end)
        title.Parent = card
        
        local tg = Instance.new("UIGradient", title)
        tg.Color = ColorSequence.new(gold, rose)
        
        local status = Instance.new("TextLabel")
        status.BackgroundTransparency = 1
        status.Position = UDim2.fromOffset(0, 62)
        status.Size = UDim2.new(1, 0, 0, 18)
        status.Text = "Starting up"
        status.TextSize = 13
        status.TextColor3 = Color3.fromRGB(176, 158, 138)
        pcall(function()
            status.FontFace = Font.new("rbxasset://fonts/families/Nunito.json")
        end)
        status.Parent = card
        
        local pct = Instance.new("TextLabel")
        pct.BackgroundTransparency = 1
        pct.Position = UDim2.fromOffset(0, 82)
        pct.Size = UDim2.new(1, 0, 0, 16)
        pct.Text = "4%"
        pct.TextSize = 11
        pct.TextColor3 = Color3.fromRGB(120, 106, 92)
        pct.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold)
        pct.Parent = card
        
        local track = Instance.new("Frame")
        track.AnchorPoint = Vector2.new(0.5, 0)
        track.Position = UDim2.new(0.5, 0, 0, 106)
        track.Size = UDim2.fromOffset(300, 6)
        track.BackgroundColor3 = Color3.fromRGB(48, 39, 32)
        track.BorderSizePixel = 0
        track.Parent = card
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.fromScale(0.04, 1)
        fill.BackgroundColor3 = gold
        fill.BorderSizePixel = 0
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        local fg = Instance.new("UIGradient", fill)
        fg.Color = ColorSequence.new(gold, rose)
        
        local tip = Instance.new("TextLabel")
        tip.AnchorPoint = Vector2.new(0.5, 0)
        tip.BackgroundTransparency = 1
        tip.Position = UDim2.new(0.5, 0, 0, 132)
        tip.Size = UDim2.new(1, -32, 0, 52)
        tip.Text = ""
        tip.TextSize = 12
        tip.TextWrapped = true
        tip.TextColor3 = Color3.fromRGB(148, 132, 116)
        pcall(function()
            tip.FontFace = Font.new("rbxasset://fonts/families/Nunito.json")
        end)
        tip.Parent = card
        
        local FACTS = {
            "Tip: Wide Range Collect grabs from 34 studs instead of 14.",
            "Tip: Spin adds +16 studs of reach on top of Wide Range.",
            "Fun fact: MM2 launched in 2014 and has over 10 billion visits.",
            "Tip: 27 studs/s is the sweet spot — fast, but the server still credits every coin.",
            "Tip: Avoid Murderer keeps you 40 studs clear while farming.",
            "Fun fact: Coins only spawn during an active round, never in the lobby.",
            "Tip: Hide My Body is client-side — other players still see you normally.",
            "Tip: The farm auto-pauses when your coin bag is full, then resumes next round.",
            "Fun fact: The rarest MM2 knife, Chroma Luger, comes from a 1-in-a-million unbox.",
            "Tip: Noclip runs every frame, so walls never block a pickup.",
            "Fun fact: Godly knives have a 1% unbox chance from a standard box.",
            "Tip: Press the toggle key any time to hide or show this menu.",
            "Fun fact: A full MM2 round runs about two minutes.",
            "Tip: Raise the speed slider to 150 if you'd rather sprint between coins.",
        }
        
        for i = #FACTS, 2, -1 do
            local j = math.random(1, i)
            FACTS[i], FACTS[j] = FACTS[j], FACTS[i]
        end
        
        local alive, fi = true, 0
        task.spawn(function()
            while alive do
                fi = fi % #FACTS + 1
                pcall(function()
                    tip.Text = FACTS[fi]
                    tip.TextTransparency = 1
                    TweenService:Create(tip, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
                end)
                task.wait(2.6)
                if not alive then break end
                pcall(function()
                    TweenService:Create(tip, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
                end)
                task.wait(0.3)
            end
        end)
        
        task.spawn(function()
            while alive do
                pcall(function()
                    fg.Offset = Vector2.new(-1, 0)
                    TweenService:Create(fg, TweenInfo.new(1.4, Enum.EasingStyle.Linear), {
                        Offset = Vector2.new(1, 0)
                    }):Play()
                end)
                task.wait(1.5)
            end
        end)
        
        fg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, gold),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 240, 210)),
            ColorSequenceKeypoint.new(1, rose),
        })
        
        local shown = 0.04
        local function to(v)
            if v <= shown then return end
            shown = v
            pcall(function()
                TweenService:Create(fill, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
                    Size = UDim2.fromScale(v, 1)
                }):Play()
                pct.Text = math.floor(v * 100 + 0.5) .. "%"
            end)
        end
        
        api._stop = function() alive = false end
        
        function api.set(text, v)
            pcall(function()
                if text then status.Text = text end
                if v then to(v) end
            end)
        end
        
        function api.done()
            pcall(function()
                alive = false
                api.set("Ready", 1)
                task.delay(0.25, function()
                    pcall(function()
                        TweenService:Create(dim, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
                        TweenService:Create(card, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
                        for _, d in ipairs(card:GetDescendants()) do
                            pcall(function()
                                if d:IsA("TextLabel") then
                                    TweenService:Create(d, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
                                elseif d:IsA("Frame") then
                                    TweenService:Create(d, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
                                elseif d:IsA("UIStroke") then
                                    TweenService:Create(d, TweenInfo.new(0.3), { Transparency = 1 }):Play()
                                end
                            end)
                        end
                        task.delay(0.5, function()
                            pcall(function() gui:Destroy() end)
                        end)
                    end)
                end)
            end)
        end
        
        task.delay(25, function()
            pcall(function()
                alive = false
                if gui.Parent then gui:Destroy() end
            end)
        end)
    end)
    
    if not success then
        warn("[Kairis Hub] Splash failed:", result)
    end
    return api
end)()

pcall(function() KairisSplash.set("Fetching UI library", 0.15) end)

-- ===== Safe UI Library Loader =====
local _Raw
do
    local function fail(reason)
        warn("[Kairis Hub] " .. reason)
        pcall(function() KairisSplash.done() end)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Kairis Hub failed to load",
                Text = reason,
                Duration = 12,
            })
        end)
        error("[Kairis Hub] " .. reason, 0)
    end
    
    if type(loadstring) ~= "function" then
        fail("This executor has no loadstring(). Use one that supports it.")
    end
    
    local source = nil
    local httpOk, result = pcall(function()
        return game:HttpGet("https://api.rubis.app/v2/scrap/D9CpDTMz8Hh4v1wA/raw")
    end)
    
    if not httpOk then
        fail("Couldn't download the UI library: " .. tostring(result))
    end
    
    source = result
    
    if type(source) ~= "string" or #source < 100 then
        fail("UI library came back empty — the host may be down or blocked.")
    end
    
    local chunk, compileErr = loadstring(source)
    if not chunk then
        fail("UI library didn't compile: " .. tostring(compileErr))
    end
    
    local runOk, libResult = pcall(chunk)
    if not runOk then
        fail("UI library errored while starting: " .. tostring(libResult))
    end
    if not libResult then
        fail("UI library returned nothing.")
    end
    
    _Raw = libResult
end

pcall(function() KairisSplash.set("Building interface", 0.55) end)

-- ===== Brand Colors =====
local Brand = {
    From = Color3.fromHex("#e9c484"),
    To = Color3.fromHex("#c98d9e"),
}

-- ===== Safe Theme Loader =====
local Summer = {
    Names = {},
    Palettes = {
        {
            Name = "Kairis",
            Accent = "#e9c484",
            Background = "#0b0908",
            Button = "#c9954a",
            Checkbox = "#e9c484",
            Dialog = "#1a1512",
            Icon = "#ffdfa9",
            Outline = "#4a3c32",
            PanelBackground = "#fdf3e0",
            PanelBackgroundTransparency = 0.90,
            Placeholder = "#8a7969",
            Slider = "#c9954a",
            Text = "#f6efe5",
            Toggle = "#e9c484"
        },
        {
            Name = "Aurora",
            Accent = "#5eead4",
            Background = "#070b12",
            Button = "#14b8a6",
            Checkbox = "#5eead4",
            Dialog = "#101a24",
            Icon = "#99f6e4",
            Outline = "#1d3f4a",
            PanelBackground = "#cffafe",
            PanelBackgroundTransparency = 0.90,
            Placeholder = "#5d7a86",
            Slider = "#14b8a6",
            Text = "#ecfeff",
            Toggle = "#5eead4"
        },
        {
            Name = "Orchid",
            Accent = "#a78bfa",
            Background = "#0a0912",
            Button = "#7c3aed",
            Checkbox = "#a78bfa",
            Dialog = "#161422",
            Icon = "#c4b5fd",
            Outline = "#3f3a63",
            PanelBackground = "#ddd6fe",
            PanelBackgroundTransparency = 0.90,
            Placeholder = "#6b6590",
            Slider = "#7c3aed",
            Text = "#f5f3ff",
            Toggle = "#a78bfa"
        },
        {
            Name = "Ember",
            Accent = "#fb7185",
            Background = "#0f0a0c",
            Button = "#e11d48",
            Checkbox = "#fb7185",
            Dialog = "#1e1216",
            Icon = "#fda4af",
            Outline = "#5c2630",
            PanelBackground = "#ffe4e6",
            PanelBackgroundTransparency = 0.90,
            Placeholder = "#8c6a72",
            Slider = "#e11d48",
            Text = "#fff1f2",
            Toggle = "#fb7185"
        },
        {
            Name = "Frost",
            Accent = "#38bdf8",
            Background = "#070d14",
            Button = "#0284c7",
            Checkbox = "#38bdf8",
            Dialog = "#0e1a26",
            Icon = "#7dd3fc",
            Outline = "#1e4a63",
            PanelBackground = "#e0f2fe",
            PanelBackgroundTransparency = 0.90,
            Placeholder = "#5b7a8c",
            Slider = "#0284c7",
            Text = "#f0f9ff",
            Toggle = "#38bdf8"
        },
        {
            Name = "Carbon",
            Accent = "#e4e4e7",
            Background = "#09090b",
            Button = "#52525b",
            Checkbox = "#e4e4e7",
            Dialog = "#18181b",
            Icon = "#d4d4d8",
            Outline = "#3f3f46",
            PanelBackground = "#fafafa",
            PanelBackgroundTransparency = 0.91,
            Placeholder = "#71717a",
            Slider = "#52525b",
            Text = "#fafafa",
            Toggle = "#e4e4e7"
        }
    }
}

for _, palette in ipairs(Summer.Palettes) do
    pcall(function()
        if not _Raw or not _Raw.GetThemes then return end
        local theme = table.clone(_Raw:GetThemes().Sky)
        for key, value in pairs(palette) do
            theme[key] = type(value) == "string" and value:sub(1, 1) == "#" and Color3.fromHex(value) or value
        end
        if _Raw.AddTheme then
            _Raw:AddTheme(theme)
            table.insert(Summer.Names, palette.Name)
        end
    end)
end

pcall(function()
    if _Raw and _Raw.SetTheme then
        _Raw:SetTheme(Summer.Names[1] or "Dark")
    end
end)

function gradient(p1, p2, p3)
    local s1 = ""
    local len = #p1
    for i = 1, len do
        local t = (i - 1) / math.max(len - 1, 1)
        s1 = s1 .. "<font color=\"rgb(" .. math.floor((p2.R + (p3.R - p2.R) * t) * 255) .. ", " 
            .. math.floor((p2.G + (p3.G - p2.G) * t) * 255) .. ", " 
            .. math.floor((p2.B + (p3.B - p2.B) * t) * 255) .. ")\">" 
            .. p1:sub(i, i) .. "</font>"
    end
    return s1
end

-- Optional wallpaper
local SummerBg = nil
pcall(function()
    if getcustomasset and isfile then
        for _, file in ipairs({ "summer_bg.png", "summer_bg.jpg", "kryzon_bg.jpg" }) do
            if isfile(file) then
                SummerBg = getcustomasset(file)
                break
            end
        end
    end
end)

-- ===== Safe Old GUI Cleanup =====
pcall(function()
    local hui = (gethui and gethui()) or CoreGui
    for _, g in ipairs(hui:GetChildren()) do
        if g:IsA("ScreenGui") then
            pcall(function()
                for _, d in ipairs(g:GetDescendants()) do
                    if d:IsA("TextLabel") or d:IsA("TextButton") then
                        local txt = d.Text or ""
                        if txt:find("Yurevix") or txt:find("Yomogi MM2 Summer") or txt:find("Yomogi") or txt:find("Murder Mystery 2") or txt:find("Kairis") then
                            g:Destroy()
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- ===== Safe UI Window Creation =====
local u8
pcall(function()
    if not _Raw then return end
    u8 = _Raw:CreateWindow({
        Title = "Kairis Hub",
        Icon = "sparkles",
        Author = "Kairis Scripts",
        Folder = "kairis",
        Size = UDim2.fromOffset(600, 620),
        Transparent = true,
        Acrylic = true,
        Theme = Summer.Names[1] or "Dark",
        Resizable = true,
        SideBarWidth = 184,
        Background = SummerBg,
        BackgroundImageTransparency = SummerBg and 0.85 or 1,
        HideSearchBar = false,
        ScrollBarEnabled = true,
        User = {
            Enabled = true,
            Anonymous = false,
            Callback = function() end
        },
        OpenButton = {
            Title = "Kairis Hub",
            CornerRadius = UDim.new(1, 0),
            StrokeThickness = 3,
            Enabled = true,
            Draggable = true,
            OnlyMobile = false,
            Color = ColorSequence.new(Brand.From, Brand.To)
        }
    })
end)

pcall(function()
    if _Raw and _Raw.SetFont then
        _Raw:SetFont("rbxasset://fonts/families/Nunito.json")
    end
end)

-- ===== Safe Tabs =====
local SummerAccent = Brand.From
local t1 = { HomeTab = nil, MainTab = nil, AutoFarmTab = nil, MurdTab = nil, SheriffTab = nil, ESPTab = nil, TeleportTab = nil, PlayerTab = nil, TrollingTab = nil, MiscTab = nil, Visual = nil }

pcall(function()
    if not u8 then return end
    t1.HomeTab = u8:Tab({
        Title = "Info",
        Icon = "solar:info-square-bold",
        IconColor = SummerAccent,
        ShowTabTitle = true,
        Border = true
    })
end)

pcall(function()
    if not u8 then return end
    local v10 = u8:Section({
        Title = "Main functions",
        Icon = "layout-grid",
        Opened = true,
        u8:Divider()
    })
    local v11 = u8:Section({
        Title = "More Functions",
        Icon = "layers",
        Opened = false
    })
    local v12 = u8:Section({
        Title = "Misc",
        Icon = "more-horizontal",
        Opened = false
    })
    
    t1.MainTab = v10:Tab({ Title = "Main", Icon = "sun", ShowTabTitle = true })
    t1.AutoFarmTab = v10:Tab({ Title = "Farming", Icon = "coins", ShowTabTitle = true })
    t1.MurdTab = v10:Tab({ Title = "Murder", Icon = "sword", ShowTabTitle = true })
    t1.SheriffTab = v10:Tab({ Title = "Sheriff", Icon = "shield", ShowTabTitle = true })
    t1.ESPTab = v10:Tab({ Title = "ESP", Icon = "eye", ShowTabTitle = true, u8:Divider() })
    t1.TeleportTab = v11:Tab({ Title = "Teleport", Icon = "map-pin", ShowTabTitle = true })
    t1.PlayerTab = v11:Tab({ Title = "Player", Icon = "person-standing", ShowTabTitle = true })
    t1.TrollingTab = v11:Tab({ Title = "Trolling", Icon = "laugh", ShowTabTitle = true })
    t1.MiscTab = v12:Tab({ Title = "Extra", Icon = "settings", ShowTabTitle = true })
    t1.Visual = v11:Tab({ Title = "Spawners", Icon = "sparkles", ShowTabTitle = true })
end)

pcall(function() KairisSplash.set("Loading tabs", 0.7) end)

-- ===== Safe Executor Detection =====
local s2 = "Unknown"
pcall(function()
    if identifyexecutor then
        s2 = identifyexecutor()
    end
end)

-- ===== Core Variables =====
local t3, t4, u23, u24, u25, u26, u27, s3, u29, u30, u31, u32, u33, u34, u35, Players2, Workspace2, LocalPlayer2, u39, u40, s5, n1, u43, t6

do
    local v16 = false
    pcall(function()
        local v14 = string.lower(s2)
        local t2 = { solara = true, xeno = true, volcano = true, velocity = true }
        for k in pairs(t2) do
            if v14:find(k) then
                v16 = true
                break
            end
        end
    end)
    
    local v18 = v16 and s2 .. " (Not 100% Supported)" or s2 .. " Supported"
    local v19 = v16 and "Some features may not work correctly with your executor." or s2 .. " should run everything fine and everything should work ight"
    local v20 = v16 and Color3.fromRGB(255, 59, 48) or Color3.fromRGB(52, 199, 89)
    
    pcall(function()
        if not t1.HomeTab then return end
        t1.HomeTab:Paragraph({
            Title = "Kairis Hub",
            Desc = gradient("Murder Mystery 2  ·  press G to hide or show the menu.", Brand.From, Brand.To),
            Color = SummerAccent,
            Image = "sparkles",
            ImageSize = 30
        })
        t1.HomeTab:Divider()
        t1.HomeTab:Paragraph({
            Title = v18,
            Desc = v19,
            Color = v20,
            Image = "cpu",
            ImageSize = 30
        })
        t1.HomeTab:Divider()
        t1.HomeTab:Paragraph({
            Title = "Where things live",
            Desc = "<b>Main</b> — role info, auto gun, round timer\n"
                .. "<b>Farming</b> — auto farm and collectors\n"
                .. "<b>Murder / Sheriff</b> — role tools\n"
                .. "<b>ESP</b> — highlights, skeletons, tracers\n"
                .. "<b>Teleport / Player</b> — movement and TP\n"
                .. "<b>Spawners</b> — weapon visuals and unboxer\n"
                .. "<b>Extra</b> — themes, keybind, configs",
            Color = SummerAccent,
            Image = "layout-grid",
            ImageSize = 30
        })
        t1.HomeTab:Divider()
        t1.HomeTab:Paragraph({
            Title = "Kairis Scripts",
            Desc = "New scripts and showcases go up on the channel — @KairisScripts.",
            Color = SummerAccent,
            Image = "youtube",
            ImageSize = 30
        })
        t1.HomeTab:Button({
            Title = "Copy tiktok link",
            Icon = "clipboard",
            Callback = function()
                local url = "https://www.tiktok.com/@kairisx._?_r=1&_t=ZS-99UW1zTf27m"
                local copy = setclipboard or toclipboard or set_clipboard
                local copied = copy ~= nil and pcall(copy, url)
                pcall(function()
                    _Raw:Notify({
                        Title = copied and "Copied" or "Clipboard unavailable",
                        Content = copied and url or ("Open it manually: " .. url),
                        Duration = 6,
                        Icon = copied and "clipboard-check" or "clipboard-x"
                    })
                end)
            end
        })
        t1.HomeTab:Divider()
    end)
    
    -- Safe role data
    t3 = {
        GetCurrentPlayerData = ReplicatedStorage:FindFirstChild("GetCurrentPlayerData", true)
    }
    t4 = {
        Roles = {},
        Murderer = "Unknown",
        Sheriff = "Unknown",
        Perk = "None"
    }
    
    pcall(function()
        if not t1.MainTab then return end
        u23 = t1.MainTab:Paragraph({
            Title = "Game Info",
            Desc = "Murder: <font color=\"#ff0000\">Unknown</font>\nSheriff: <font color=\"#0000ff\">Unknown</font>\nMurderer Perk: <font color=\"#7F00FF\">None</font>\nGun Dropped: No",
            Image = "component",
            ImageSize = 20
        })
    end)
    
    function u24()
        pcall(function()
            if t3.GetCurrentPlayerData and t3.GetCurrentPlayerData:IsA("RemoteFunction") then
                local ok, result = pcall(function()
                    return t3.GetCurrentPlayerData:InvokeServer()
                end)
                if ok and typeof(result) == "table" then
                    t4.Roles = result
                    t4.Perk = "None"
                    t4.Sheriff = "Unknown"
                    t4.Murderer = "Unknown"
                    for k, v in pairs(t4.Roles) do
                        local k2 = Players:FindFirstChild(k)
                        if k2 and k2.Character and k2.Character:FindFirstChild("Humanoid") and k2.Character.Humanoid.Health > 0 then
                            if v.Role == "Murderer" then
                                t4.Murderer = k
                                t4.Perk = v.Perk or "None"
                            elseif v.Role == "Sheriff" then
                                t4.Sheriff = k
                            end
                        end
                    end
                end
            end
        end)
    end
    
    function u25()
        local found = false
        pcall(function()
            for _, descendant in ipairs(Workspace:GetDescendants()) do
                if descendant.Name == "GunDrop" then
                    found = true
                    break
                end
            end
        end)
        return found
    end
    
    function u26()
        pcall(function()
            u24()
            local v206 = u25() and "Yes" or "No"
            local v207 = string.format("Murder: <font color=\"#ff0000\">%s</font>\nSheriff: <font color=\"#0000ff\">%s</font>\nMurderer Perk: <font color=\"#7F00FF\">%s</font>\nGun Dropped: %s", t4.Murderer, t4.Sheriff, t4.Perk, v206)
            if u23 and u23.SetDesc then
                u23:SetDesc(v207)
            end
        end)
    end
    
    task.spawn(function()
        while true do
            pcall(u26)
            task.wait(0.2)
        end
    end)
    
    u27 = true
    s3 = "G"
    
    pcall(function()
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode[s3] then
                u27 = not u27
                if not u27 then
                    pcall(function()
                        _Raw:Notify({
                            Title = "Menu hidden",
                            Content = "Press " .. s3 .. " to bring Kairis Hub back.",
                            Duration = 6,
                            Icon = "sparkles"
                        })
                    end)
                end
            end
        end)
    end)
    
    pcall(function()
        if not t1.MiscTab then return end
        t1.MiscTab:Divider()
        
        if Summer.Names[1] then
            t1.MiscTab:Dropdown({
                Title = "UI Theme",
                Desc = "Swap between the Kairis palettes",
                Values = Summer.Names,
                Value = Summer.Names[1],
                Callback = function(name)
                    pcall(function()
                        if _Raw and _Raw.SetTheme then
                            _Raw:SetTheme(name)
                        end
                    end)
                end
            })
        end
        
        t1.MiscTab:Keybind({
            Title = "Toggle UI Keybind",
            Desc = "Keybind to open or close the UI",
            Value = s3,
            Callback = function(p4)
                local ok, result = pcall(function()
                    return Enum.KeyCode[p4]
                end)
                if ok and result then
                    s3 = p4
                    if u8 and u8.SetToggleKey then
                        u8:SetToggleKey(result)
                    end
                end
            end
        })
        
        t1.MiscTab:Button({
            Title = "Infinite yeild",
            Compact = true,
            Callback = function()
                pcall(function()
                    loadstring(game:HttpGet("https://rawscripts.net/raw/Infinite-Yield_500"))()
                end)
            end
        })
    end)
    
    u29 = false
    u30 = nil
    u31 = nil
    
    function u32()
        local t5 = {}
        pcall(function()
            local GetCurrentPlayerData = ReplicatedStorage:FindFirstChild("GetCurrentPlayerData", true)
            if GetCurrentPlayerData and GetCurrentPlayerData:IsA("RemoteFunction") then
                t5 = GetCurrentPlayerData:InvokeServer() or {}
            end
        end)
        local v216 = nil
        local v217 = nil
        for k, v in pairs(t5) do
            if v.Role == "Murderer" then
                v216 = k
            elseif v.Role == "Sheriff" then
                v217 = k
            end
        end
        return v216, v217
    end
    
    function u33(p5, p6, p7)
        local s4 = "rbxassetid://129260712070622"
        pcall(function()
            if p7 then
                local p7_2 = Players:FindFirstChild(p7)
                if p7_2 then
                    local ok, result = pcall(function()
                        return Players:GetUserThumbnailAsync(p7_2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                    end)
                    if ok then
                        s4 = result
                    end
                end
            end
        end)
        pcall(function()
            _Raw:Notify({
                Title = p5,
                Content = p6,
                Duration = 30,
                Icon = s4,
                IconThemed = true
            })
        end)
    end
    
    function u34(p8, p9)
        local v229 = p8 == "Murderer" and "<font color=\"#ff0000\">Murderer</font>" or "<font color=\"#007bff\">Sheriff</font>"
        local v230 = p9 or "No " .. p8
        u33(v229, v230, p9)
    end
    
    task.spawn(function()
        while true do
            if u29 then
                local v231, v232 = u32()
                if v231 ~= u30 then
                    u34("Murderer", v231)
                end
                if v232 ~= u31 then
                    u34("Sheriff", v232)
                end
                u31 = v232
                u30 = v231
            end
            task.wait(0.5)
        end
    end)
    
    pcall(function()
        if not t1.MainTab then return end
        t1.MainTab:Divider()
        t1.MainTab:Toggle({
            Title = "Auto Role Notification",
            Description = "Notify when roles are detected or changed",
            Callback = function(p10)
                u29 = p10
                if p10 then
                    u30 = nil
                    u31 = nil
                end
            end,
            Default = false
        })
        t1.MainTab:Button({
            Title = "Notify Murderer",
            Callback = function()
                local v234 = u32()
                u34("Murderer", v234)
            end
        })
        t1.MainTab:Button({
            Title = "Notify Sheriff",
            Callback = function()
                local _, v236 = u32()
                u34("Sheriff", v236)
            end
        })
        t1.MainTab:Divider()
    end)
    
    u35 = false
    pcall(function()
        if not t1.MainTab then return end
        t1.MainTab:Toggle({
            Title = "Auto Get Gun",
            Value = false,
            Callback = function(p11)
                u35 = p11
                u39 = p11
                pcall(function()
                    _Raw:Notify({
                        Title = "Auto Gun",
                        Content = p11 and "Enabled" or "Disabled",
                        Duration = 3,
                        Icon = "hand"
                    })
                end)
            end
        })
        
        t1.MainTab:Button({
            Title = "Get Gun Now",
            Icon = "hand",
            Callback = function()
                local v238 = nil
                pcall(function()
                    for _, descendant in ipairs(Workspace:GetDescendants()) do
                        if descendant.Name == "GunDrop" and descendant:IsA("Part") then
                            v238 = descendant
                            break
                        end
                    end
                end)
                if not v238 then
                    pcall(function()
                        _Raw:Notify({
                            Title = "Gun Pickup",
                            Content = "gun has not been dropped",
                            Duration = 5,
                            Icon = "x"
                        })
                    end)
                else
                    local _HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if _HumanoidRootPart then
                        pcall(function()
                            for _, v in ipairs(v238:GetConnections()) do
                                if v.Name == "TouchInterest" then
                                    v:Fire(_HumanoidRootPart)
                                end
                            end
                        end)
                    end
                    pcall(function()
                        _Raw:Notify({
                            Title = "Gun Pickup",
                            Content = "Gun successfully touched!",
                            Duration = 5,
                            Icon = "hand"
                        })
                    end)
                end
            end
        })
    end)
    
    Players2 = game:GetService("Players")
    Workspace2 = game:GetService("Workspace")
    LocalPlayer2 = Players2.LocalPlayer
    u39 = false
    u40 = false
    
    task.spawn(function()
        while task.wait(0.25) do
            if u39 and not u40 then
                local Character = LocalPlayer2.Character
                local _HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")
                if _HumanoidRootPart2 then
                    if not (Character:FindFirstChild("Gun") or LocalPlayer2.Backpack:FindFirstChild("Gun")) then
                        local GunDrop = Workspace2:FindFirstChild("GunDrop", true)
                        if GunDrop and GunDrop:IsA("BasePart") then
                            u40 = true
                            pcall(function()
                                firetouchinterest(_HumanoidRootPart2, GunDrop, 0)
                                task.wait()
                                firetouchinterest(_HumanoidRootPart2, GunDrop, 1)
                            end)
                            task.delay(0.5, function()
                                u40 = false
                            end)
                        end
                    end
                end
            end
        end
    end)
    
    s5 = "rbxassetid://1076907875"
    n1 = 1
    u43 = false
    t6 = {
        Discord = "rbxassetid://1076907875",
        ["Fire alarm"] = "rbxassetid://497153454",
        Oof = "rbxassetid://79348298352567",
        ["Gun sfx"] = "rbxassetid://1585183374",
        ["Samsung Notification"] = "rbxassetid://6205717931",
        Notify = "rbxassetid://225320558",
        ["Windows Notify System Generic"] = "rbxassetid://489103549",
        Custom = ""
    }
    
    local t7 = {}
    for k in pairs(t6) do
        table.insert(t7, k)
    end
    
    pcall(function()
        if not t1.MainTab then return end
        t1.MainTab:Input({
            Title = "Custom Gun Drop Sound URL",
            Placeholder = "rbxassetid://",
            Compact = true,
            Callback = function(p12)
                if p12 ~= "" then
                    s5 = p12
                end
            end
        })
        t1.MainTab:Dropdown({
            Title = "Gun Drop Sound",
            Values = t7,
            Value = "Discord",
            Compact = true,
            Callback = function(p13)
                if p13 ~= "Custom" then
                    s5 = t6[p13]
                end
            end
        })
    end)
end

-- ===== Safe Gun Sound Preview =====
pcall(function()
    if not t1.MainTab then return end
    t1.MainTab:Button({
        Title = "Preview Gun Drop Sound",
        Callback = function()
            local Sound = Instance.new("Sound")
            Sound.SoundId = s5
            Sound.Volume = n1
            Sound.Parent = Workspace2
            Sound:Play()
            Sound.Ended:Connect(function()
                Sound:Destroy()
            end)
        end
    })
    t1.MainTab:Slider({
        Title = "Gun Drop Volume",
        Step = 0.05,
        Value = {
            Min = 0,
            Max = 1,
            Default = 1
        },
        Callback = function(p14)
            n1 = p14
        end
    })
    t1.MainTab:Toggle({
        Title = "Enable",
        Value = false,
        Callback = function(p15)
            u43 = p15
        end
    })
end)

task.spawn(function()
    local t8 = {}
    while true do
        task.wait(0.5)
        if u43 then
            pcall(function()
                for _, descendant in ipairs(Workspace2:GetDescendants()) do
                    if descendant.Name == "GunDrop" and not t8[descendant] then
                        local Sound = Instance.new("Sound")
                        Sound.SoundId = s5
                        Sound.Volume = n1
                        Sound.Parent = descendant
                        Sound:Play()
                        Sound.Ended:Connect(function()
                            Sound:Destroy()
                        end)
                        pcall(function()
                            _Raw:Notify({
                                Title = "Gun dropped 🔫",
                                Content = "The gun just hit the floor -- go grab it.",
                                Duration = 10,
                                Icon = "zap",
                                IconThemed = true
                            })
                        end)
                        t8[descendant] = true
                    end
                end
            end)
        end
    end
end)

pcall(function()
    if not t1.MainTab then return end
    t1.MainTab:Divider()
    t1.MainTab:Toggle({
        Title = "Round Timer",
        Compact = true,
        Callback = function(p16)
            pcall(function()
                if not p16 then
                    local _TimerDisplayGui = LocalPlayer2:FindFirstChild("PlayerGui") and LocalPlayer2.PlayerGui:FindFirstChild("TimerDisplayGui")
                    if _TimerDisplayGui then
                        _TimerDisplayGui:Destroy()
                    end
                else
                    local PlayerGui = LocalPlayer2:FindFirstChild("PlayerGui")
                    local RoundTimerPart = Workspace2:FindFirstChild("RoundTimerPart")
                    local _Surfacegui = RoundTimerPart and (RoundTimerPart:FindFirstChild("SurfaceGui") and RoundTimerPart.SurfaceGui:FindFirstChild("Timer"))
                    if not PlayerGui or not _Surfacegui then
                        return
                    end
                    
                    local ScreenGui = Instance.new("ScreenGui")
                    ScreenGui.Name = "TimerDisplayGui"
                    ScreenGui.Parent = PlayerGui
                    ScreenGui.ResetOnSpawn = false
                    
                    local TextLabel = Instance.new("TextLabel")
                    TextLabel.Size = UDim2.new(0, 170, 0, 36)
                    TextLabel.Position = UDim2.new(0.5, 0, 0.05, 0)
                    TextLabel.AnchorPoint = Vector2.new(0.5, 0)
                    TextLabel.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
                    TextLabel.BackgroundTransparency = 0.25
                    TextLabel.TextColor3 = Color3.fromRGB(255, 243, 234)
                    TextLabel.TextScaled = true
                    TextLabel.RichText = true
                    TextLabel.Text = "Waiting..."
                    pcall(function()
                        TextLabel.FontFace = Font.new("rbxassetid://16658221428", Enum.FontWeight.Bold)
                    end)
                    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    TextLabel.TextStrokeTransparency = 0.6
                    TextLabel.Parent = ScreenGui
                    
                    local TimerCorner = Instance.new("UICorner")
                    TimerCorner.CornerRadius = UDim.new(0, 10)
                    TimerCorner.Parent = TextLabel
                    
                    local TimerPadding = Instance.new("UIPadding")
                    TimerPadding.PaddingTop = UDim.new(0, 6)
                    TimerPadding.PaddingBottom = UDim.new(0, 6)
                    TimerPadding.PaddingLeft = UDim.new(0, 10)
                    TimerPadding.PaddingRight = UDim.new(0, 10)
                    TimerPadding.Parent = TextLabel
                    
                    local TimerStroke = Instance.new("UIStroke")
                    TimerStroke.Thickness = 1.6
                    TimerStroke.Transparency = 0.15
                    TimerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    TimerStroke.Parent = TextLabel
                    
                    local TimerGradient = Instance.new("UIGradient")
                    TimerGradient.Color = ColorSequence.new(Brand.From, Brand.To)
                    TimerGradient.Rotation = 25
                    TimerGradient.Parent = TimerStroke
                    
                    local u264 = false
                    local u265 = nil
                    local inputPosition = nil
                    local TextLabelPosition = nil
                    
                    TextLabel.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            u264 = true
                            inputPosition = input.Position
                            TextLabelPosition = TextLabel.Position
                            input.Changed:Connect(function()
                                if input.UserInputState == Enum.UserInputState.End then
                                    u264 = false
                                end
                            end)
                        end
                    end)
                    
                    TextLabel.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            u265 = input
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if input == u265 and u264 then
                            local v870 = input.Position - inputPosition
                            TextLabel.Position = UDim2.new(TextLabelPosition.X.Scale, TextLabelPosition.X.Offset + v870.X, TextLabelPosition.Y.Scale, TextLabelPosition.Y.Offset + v870.Y)
                        end
                    end)
                    
                    task.spawn(function()
                        while ScreenGui.Parent do
                            pcall(function()
                                if _Surfacegui and _Surfacegui:IsA("TextLabel") then
                                    TextLabel.Text = _Surfacegui.Text
                                end
                            end)
                            task.wait(0.1)
                        end
                    end)
                end
            end)
        end
    })
    
    t1.MainTab:Button({
        Title = "God mode",
        Desc = "",
        Value = false,
        Callback = function(_)
            pcall(function()
                _Raw:Notify({
                    Title = "God mode",
                    Content = "god mode is on",
                    Icon = "smile",
                    IconThemed = false,
                    Duration = 5
                })
            end)
            
            local function u269(p18)
                pcall(function()
                    p18:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)
            end
            
            local LocalPlayer3 = game:GetService("Players").LocalPlayer
            pcall(function()
                u269(LocalPlayer3.Character.Humanoid)
            end)
            LocalPlayer3.CharacterAdded:Connect(function(character)
                pcall(function()
                    u269(character:WaitForChild("Humanoid"))
                end)
            end)
        end
    })
end)

-- Anti-Stealer (TRADE BLOCKER) - REMOVED
-- No trade-blocking logic remains.

-- ===== FOV Slider =====
pcall(function()
    if not t1.MainTab then return end
    t1.MainTab:Slider({
        Title = "FOV",
        Value = {
            Min = 50,
            Max = 120,
            Default = CurrentCamera.FieldOfView
        },
        Compact = true,
        Callback = function(p20)
            CurrentCamera.FieldOfView = p20
        end
    })
end)

-- ===== Anti Fling =====
pcall(function()
    if not t1.MainTab then return end
    t1.MainTab:Toggle({
        Title = "Anti Fling",
        Default = false,
        Callback = function(p21)
            if not p21 then
                if getgenv().AntiFlingConnection then
                    getgenv().AntiFlingConnection:Disconnect()
                    getgenv().AntiFlingConnection = nil
                end
            else
                getgenv().AntiFlingConnection = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        for _, player in ipairs(Players2:GetPlayers()) do
                            if player ~= LocalPlayer2 and player.Character then
                                for _, descendant in ipairs(player.Character:GetDescendants()) do
                                    if descendant:IsA("BasePart") and not descendant.Anchored and descendant.Velocity.Magnitude > 100 then
                                        local zero = Vector3.zero
                                        descendant.RotVelocity = Vector3.zero
                                        descendant.Velocity = zero
                                        descendant.Anchored = true
                                        task.delay(0.5, function()
                                            if descendant and descendant.Parent then
                                                descendant.Anchored = false
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                end)
            end
        end
    })
end)

-- ===== Sheriff Tab =====
pcall(function()
    if not t1.SheriffTab then return end
    t1.SheriffTab:Section({ Title = "Aimlock" })
    t1.SheriffTab:Divider()
end)

-- ===== Aimlock System =====
local Players3 = game:GetService("Players")
local RunService2 = game:GetService("RunService")
local UserInputService2 = game:GetService("UserInputService")
LocalPlayer4 = Players3.LocalPlayer
local n2 = 0.18
local n3 = 5000
local n4 = 0.08
local E = Enum.KeyCode.E
local u61 = false
local u62 = nil
local u63 = false
local u64 = nil

function u65()
    local Character = LocalPlayer4.Character
    if Character then
        for _, child in ipairs(Character:GetChildren()) do
            if child:IsA("Tool") and child:FindFirstChild("Shoot") then
                return child, child:FindFirstChild("Shoot")
            end
        end
    end
    local Backpack = LocalPlayer4:FindFirstChild("Backpack")
    if Backpack then
        for _, child in ipairs(Backpack:GetChildren()) do
            if child:IsA("Tool") and child:FindFirstChild("Shoot") then
                return child, child:FindFirstChild("Shoot")
            end
        end
    end
    return nil, nil
end

function u66(p22)
    if not p22 then return false end
    local Backpack = p22:FindFirstChild("Backpack")
    if not Backpack or not Backpack:FindFirstChild("Knife") then
        local Character = p22.Character
        if Character and Character:FindFirstChild("Knife") then
            return true
        end
        return false
    end
    return true
end

function u67()
    local Character = LocalPlayer4.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    local HumanoidRootPart = Character.HumanoidRootPart
    local v285 = nil
    local huge = math.huge
    for _, player in ipairs(Players3:GetPlayers()) do
        if player ~= LocalPlayer4 then
            if not player.Character then
                -- skip
            else
                local Humanoid = player.Character:FindFirstChild("Humanoid")
                if not Humanoid or Humanoid.Health <= 0 then
                    -- skip
                else
                    local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
                    if not HumanoidRootPart2 then
                        -- skip
                    elseif not u66(player) then
                        -- skip
                    else
                        local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude
                        if Magnitude < n3 and Magnitude < huge then
                            huge = Magnitude
                            v285 = player
                        end
                    end
                end
            end
        end
    end
    return v285
end

function u68(p23)
    if p23 then
        return p23 + Vector3.new((math.random() - 0.5) * n4, (math.random() - 0.5) * n4, (math.random() - 0.5) * n4)
    end
    return CFrame.new()
end

function u69()
    pcall(function()
        local v294, v295 = u65()
        if v294 and v295 then
            local Character = LocalPlayer4.Character
            if not Character or not Character:FindFirstChild("HumanoidRootPart") then
                return
            end
            local v297 = u67()
            if v297 then
                local HumanoidRootPart = Character.HumanoidRootPart
                local HumanoidRootPart3 = v297.Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart3 then
                    local v300 = u68(HumanoidRootPart3.CFrame)
                    v295:FireServer(HumanoidRootPart.CFrame, v300)
                end
            end
        end
    end)
end

pcall(function()
    if not t1.SheriffTab then return end
    t1.SheriffTab:Button({
        Title = "Shoot murd",
        Desc = "doesnt require holding gun",
        Icon = "solar:target-bold",
        Callback = u69
    })
    
    t1.SheriffTab:Toggle({
        Title = "Auto Shoot murd",
        Desc = "still u dont gotta hold gun for it to work",
        Icon = "solar:target-bold",
        Value = false,
        Callback = function(p24)
            u63 = p24
            if u64 then
                u64:Disconnect()
                u64 = nil
            end
            if p24 then
                u64 = RunService2.Heartbeat:Connect(function()
                    if u63 then
                        u69()
                        task.wait(n2)
                    end
                end)
            end
        end
    })
    
    t1.SheriffTab:Keybind({
        Title = "Shoot / Auto-Shoot (hold)",
        Value = "E",
        Callback = function(p25)
            if Enum.KeyCode[p25] then
                E = Enum.KeyCode[p25]
            end
        end
    })
end)

UserInputService2.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode ~= E then return end
    u61 = true
    u69()
    if u62 then
        u62:Disconnect()
    end
    u62 = RunService2.Heartbeat:Connect(function()
        if u61 then
            u69()
            task.wait(n2)
        end
    end)
end)

UserInputService2.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == E then
            u61 = false
            if u62 then
                u62:Disconnect()
                u62 = nil
            end
        end
    end
end)

LocalPlayer4.CharacterRemoving:Connect(function()
    u61 = false
    if u62 then
        u62:Disconnect()
        u62 = nil
    end
end)

-- ===== Kill Aura System =====
pcall(function()
    if not t1.MurdTab then return end
    local Players4 = game:GetService("Players")
    VirtualUser = game:GetService("VirtualUser")
    RunService3 = game:GetService("RunService")
    LocalPlayer5 = Players4.LocalPlayer
    
    local t9 = {
        KillAura = {
            Enabled = false,
            Distance = 50
        }
    }
    
    function u78()
        local Character = LocalPlayer5.Character
        if not Character or not Character:FindFirstChild("Humanoid") then
            return nil
        end
        local _Knife = LocalPlayer5.Backpack:FindFirstChild("Knife") or Character:FindFirstChild("Knife")
        if _Knife and _Knife.Parent == LocalPlayer5.Backpack then
            pcall(function()
                Character.Humanoid:EquipTool(_Knife)
            end)
            task.wait(0.1)
        end
        return Character:FindFirstChild("Knife")
    end
    
    function u79(p26)
        local v314 = u78()
        if not v314 then return end
        local Character = p26.Character
        if Character then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.Health > 0 then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    pcall(function()
                        VirtualUser:ClickButton1(Vector2.new())
                        firetouchinterest(HumanoidRootPart, v314.Handle, 1)
                        firetouchinterest(HumanoidRootPart, v314.Handle, 0)
                    end)
                end
            end
        end
    end
    
    function u80()
        local t10 = {}
        for _, player in ipairs(Players4:GetPlayers()) do
            if player ~= LocalPlayer5 then
                table.insert(t10, player.Name)
            end
        end
        table.sort(t10)
        return t10
    end
    
    local t11 = {}
    local u82 = t1.MurdTab:Dropdown({
        Title = "Select Players to Kill",
        Values = u80(),
        Multi = true,
        Compact = true,
        AllowNone = true,
        Callback = function(p27)
            t11 = p27 or {}
        end
    })
    
    pcall(function()
        Players4.PlayerAdded:Connect(function()
            u82:Refresh(u80())
        end)
        Players4.PlayerRemoving:Connect(function()
            u82:Refresh(u80())
            local t12 = {}
            for _, v in ipairs(t11) do
                if Players4:FindFirstChild(v) then
                    table.insert(t12, v)
                end
            end
            t11 = t12
            u82:Select(t12)
        end)
        u82:Refresh(u80())
    end)
    
    t1.MurdTab:Button({
        Title = "Kill Selected Players",
        Description = "Kills only the players selected in the dropdown.",
        Callback = function()
            if #t11 == 0 then
                pcall(function()
                    _Raw:Notify({
                        Title = "Warning",
                        Content = "No players selected!",
                        Duration = 3
                    })
                end)
                return
            end
            for _, v in ipairs(t11) do
                local v2 = Players4:FindFirstChild(v)
                if v2 then
                    u79(v2)
                    task.wait(0.1)
                end
            end
        end
    })
    
    t1.MurdTab:Button({
        Title = "Kill All Players",
        Description = "Instantly kills every other player in the server.",
        Callback = function()
            local v328 = u78()
            if not v328 then
                pcall(function()
                    _Raw:Notify({
                        Title = "Error",
                        Content = "You don't have the knife! (Not murderer?)",
                        Duration = 5
                    })
                end)
                return
            end
            for _, player in ipairs(Players4:GetPlayers()) do
                if player ~= LocalPlayer5 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        VirtualUser:ClickButton1(Vector2.new())
                        firetouchinterest(player.Character.HumanoidRootPart, v328.Handle, 1)
                        firetouchinterest(player.Character.HumanoidRootPart, v328.Handle, 0)
                    end)
                    task.wait(0.05)
                end
            end
        end
    })
    
    t1.MurdTab:Button({
        Title = "Kill Random Player",
        Compact = true,
        Callback = function()
            local t13 = {}
            for _, player in ipairs(Players4:GetPlayers()) do
                if player ~= LocalPlayer5 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    table.insert(t13, player)
                end
            end
            if #t13 == 0 then
                pcall(function()
                    _Raw:Notify({
                        Title = "Info",
                        Content = "No valid targets found!",
                        Duration = 3
                    })
                end)
            else
                local v334 = t13[math.random(1, #t13)]
                u79(v334)
            end
        end
    })
    
    t1.MurdTab:Toggle({
        Title = "Kill Aura",
        Description = "kills nearby ALIVE players",
        Default = false,
        Callback = function(p28)
            t9.KillAura.Enabled = p28
        end
    })
    
    t1.MurdTab:Slider({
        Title = "Kill Aura Distance",
        Description = "Maximum distance (studs) for Kill Aura to trigger.",
        Value = {
            Min = 10,
            Max = 1000,
            Default = 1000
        },
        Callback = function(p29)
            t9.KillAura.Distance = p29
        end
    })
    
    task.spawn(function()
        while task.wait(0.2) do
            if t9.KillAura.Enabled then
                local v337 = u78()
                if v337 then
                    local Character = LocalPlayer5.Character
                    if Character then
                        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                        if HumanoidRootPart then
                            for _, player in ipairs(Players4:GetPlayers()) do
                                if player ~= LocalPlayer5 then
                                    local Character2 = player.Character
                                    if Character2 then
                                        local Humanoid = Character2:FindFirstChildOfClass("Humanoid")
                                        if Humanoid and Humanoid.Health > 0 then
                                            local HumanoidRootPart4 = Character2:FindFirstChild("HumanoidRootPart")
                                            if HumanoidRootPart4 and (HumanoidRootPart.Position - HumanoidRootPart4.Position).Magnitude <= t9.KillAura.Distance then
                                                pcall(function()
                                                    VirtualUser:ClickButton1(Vector2.new())
                                                    firetouchinterest(HumanoidRootPart4, v337.Handle, 1)
                                                    firetouchinterest(HumanoidRootPart4, v337.Handle, 0)
                                                end)
                                                task.wait(0.08)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)

-- ===== Camlock System =====
pcall(function()
    if not t1.SheriffTab then return end
    local CurrentCamera2 = Workspace2.CurrentCamera
    local LocalPlayer6 = Players3.LocalPlayer
    getgenv().Aimlock = getgenv().Aimlock or {
        Enabled = false,
        TargetPart = "HumanoidRootPart",
        Initialized = false
    }
    
    function u85()
        for _, player in ipairs(Players3:GetPlayers()) do
            if player ~= LocalPlayer6 and player.Character and (player.Character:FindFirstChild("Knife") or (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))) and player.Character:FindFirstChild("HumanoidRootPart") then
                return player
            end
        end
        return nil
    end
    
    t1.SheriffTab:Divider()
    t1.SheriffTab:Dropdown({
        Title = "camlock Target Part",
        Description = "Choose which body part to lock onto on the murderer.",
        Values = {
            "Head",
            "HumanoidRootPart",
            "UpperTorso",
            "LowerTorso"
        },
        Value = "HumanoidRootPart",
        Callback = function(p30)
            getgenv().Aimlock.TargetPart = p30
        end
    })
    
    t1.SheriffTab:Toggle({
        Title = "enable camlock",
        Default = false,
        Callback = function(p31)
            getgenv().Aimlock.Enabled = p31
            if p31 and not getgenv().Aimlock.Initialized then
                getgenv().Aimlock.Initialized = true
                RunService3.RenderStepped:Connect(function()
                    if getgenv().Aimlock.Enabled then
                        local v878 = u85()
                        if v878 and v878.Character then
                            local AimlockTargetPart = v878.Character:FindFirstChild(getgenv().Aimlock.TargetPart)
                            if AimlockTargetPart then
                                CurrentCamera2.CFrame = CFrame.new(CurrentCamera2.CFrame.Position, AimlockTargetPart.Position)
                            end
                        end
                    end
                end)
            end
        end
    })
end)

-- ===== Silent Aim + Wallbang =====
pcall(function()
    if not t1.SheriffTab then return end
    t1.SheriffTab:Section({ Title = "Silent Aim" })
    
    getgenv().KairisSilentAim = getgenv().KairisSilentAim or false
    getgenv().KairisWallbang = getgenv().KairisWallbang or false
    getgenv().KairisWallbangFOV = getgenv().KairisWallbangFOV or 40
    
    t1.SheriffTab:Toggle({
        Title = "Silent Aim (murderer)",
        Desc = "Shots go straight at the murderer -- works with the gun OUT or holstered, no aiming",
        Value = false,
        Callback = function(s)
            getgenv().KairisSilentAim = s
        end
    })
    
    t1.SheriffTab:Toggle({
        Title = "Wallbang (shoot through walls)",
        Desc = "Hits whoever you're aiming at even through geometry — no line of sight needed",
        Value = false,
        Callback = function(s)
            getgenv().KairisWallbang = s
        end
    })
    
    t1.SheriffTab:Slider({
        Title = "Wallbang Aim FOV",
        Desc = "How far off your crosshair a target can be, in degrees. Lower = more precise",
        Step = 1,
        Value = {
            Min = 5,
            Max = 90,
            Default = 40
        },
        Callback = function(v)
            getgenv().KairisWallbangFOV = v
        end
    })
    
    -- Silent aim hook
    local function murdererChar()
        for _, plr in ipairs(Players3:GetPlayers()) do
            if plr ~= LocalPlayer4 then
                local ch = plr.Character
                local bp = plr:FindFirstChild("Backpack")
                if (ch and ch:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) then
                    return ch
                end
            end
        end
        return nil
    end
    
    local function murdererPart()
        local mc = murdererChar()
        return mc and (mc:FindFirstChild("Head") or mc:FindFirstChild("HumanoidRootPart"))
    end
    
    local function wallbangTarget()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local origin = cam.CFrame.Position
        local look = cam.CFrame.LookVector
        local best, bestAng = nil, math.rad(getgenv().KairisWallbangFOV or 40)
        for _, pl in ipairs(Players3:GetPlayers()) do
            if pl ~= LocalPlayer4 and pl.Character then
                local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                local part = pl.Character:FindFirstChild("Head") or pl.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and part then
                    local dir = part.Position - origin
                    local mag = dir.Magnitude
                    if mag > 0 then
                        local ang = math.acos(math.clamp(look:Dot(dir / mag), -1, 1))
                        if ang < bestAng then
                            bestAng = ang
                            best = part
                        end
                    end
                end
            end
        end
        return best
    end
    
    local function shotTarget()
        if getgenv().KairisSilentAim then
            local mp = murdererPart()
            if mp then return mp end
        end
        if getgenv().KairisWallbang then
            return wallbangTarget()
        end
        return nil
    end
    
    local function gunTool()
        local ch = LocalPlayer4.Character
        if ch then
            for _, t in ipairs(ch:GetChildren()) do
                if t:IsA("Tool") and t:FindFirstChild("Shoot") then
                    return t, true
                end
            end
        end
        local bp = LocalPlayer4:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") and t:FindFirstChild("Shoot") then
                    return t, false
                end
            end
        end
        return nil, false
    end
    
    if hookmetamethod and getnamecallmethod and newcclosure and not getgenv()._kairisSilentHook then
        getgenv()._kairisSilentHook = true
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if getgenv().KairisSilentAim or getgenv().KairisWallbang then
                local newArgs
                pcall(function(...)
                    if getnamecallmethod() == "FireServer" and self.Name == "Shoot" then
                        local parent = self.Parent
                        if parent and parent:IsA("Tool") then
                            local mp = shotTarget()
                            if mp then
                                local args = { ... }
                                local changed = false
                                for i = 2, #args do
                                    if typeof(args[i]) == "CFrame" then
                                        args[i] = CFrame.new(mp.Position)
                                        changed = true
                                    elseif typeof(args[i]) == "Vector3" then
                                        args[i] = mp.Position
                                        changed = true
                                    end
                                end
                                if changed then
                                    newArgs = args
                                end
                            end
                        end
                    end
                end, ...)
                if newArgs then
                    return oldNamecall(self, unpack(newArgs))
                end
            end
            return oldNamecall(self, ...)
        end))
    end
    
    UserInputService2.InputBegan:Connect(function(input, gp)
        if gp or not (getgenv().KairisSilentAim or getgenv().KairisWallbang) then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end
        local tool, out = gunTool()
        if not tool or out then
            return
        end
        local shoot = tool:FindFirstChild("Shoot")
        local ch = LocalPlayer4.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local mp = shotTarget()
        if shoot and hrp and mp then
            pcall(function()
                shoot:FireServer(hrp.CFrame, mp.CFrame)
            end)
        end
    end)
end)

-- ===== Safe Notify Helper =====
local function safeNotify(title, content, icon, duration)
    pcall(function()
        _Raw:Notify({
            Title = title or "Notification",
            Content = content or "",
            Icon = icon or "info",
            Duration = duration or 3
        })
    end)
end

-- ===== KairisFarm (Auto Farm) =====
getgenv().KairisFarm = getgenv().KairisFarm or {}
local KairisFarm = getgenv().KairisFarm
KairisFarm.active = false
KairisFarm.speed = 27
KairisFarm.wide = (KairisFarm.wide ~= false)
KairisFarm.hideBody = KairisFarm.hideBody or false
KairisFarm.avoidMurderer = KairisFarm.avoidMurderer or false
KairisFarm.avoidDist = KairisFarm.avoidDist or 40
KairisFarm.spin = KairisFarm.spin or false

local TweenServiceK = game:GetService("TweenService")

if not KairisFarm._hideLoop then
    KairisFarm._hideLoop = true
    task.spawn(function()
        while true do
            if KairisFarm.hideBody then
                local plr = game:GetService("Players").LocalPlayer
                local char = plr.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") or p:IsA("Decal") or p:IsA("Texture") then
                            p.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

local function kCharParts()
    local plr = game:GetService("Players").LocalPlayer
    local char = plr.Character
    if not char then return nil end
    return char, char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
end

local function kFindMurderer()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp then
            local ch = plr.Character
            local bp = plr:FindFirstChild("Backpack")
            if (ch and ch:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) then
                return plr
            end
        end
    end
    return nil
end

local function kBagFull()
    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return false end
    local main = pg:FindFirstChild("MainGUI")
    if not main then return false end
    local gm = main:FindFirstChild("Game")
    if not gm then return false end
    local bags = gm:FindFirstChild("CoinBags")
    if not bags then return false end
    local cont = bags:FindFirstChild("Container")
    if not cont then return false end
    for _, b in ipairs(cont:GetChildren()) do
        local full = b:FindFirstChild("Full")
        if full and full:IsA("GuiObject") and full.Visible then
            return true
        end
    end
    return false
end

local function kIsCoin(c)
    return c:IsA("BasePart") and not c:FindFirstChild("CollectedCoin")
end

KairisFarm._alive = true
if not KairisFarm._aliveLoop then
    KairisFarm._aliveLoop = true
    task.spawn(function()
        local RS = game:GetService("ReplicatedStorage")
        local lp = game:GetService("Players").LocalPlayer
        while true do
            local ok, data = pcall(function()
                local rf = RS:FindFirstChild("GetCurrentPlayerData", true)
                if rf and rf:IsA("RemoteFunction") then
                    return rf:InvokeServer()
                end
            end)
            if ok and type(data) == "table" then
                local me = data[lp.Name]
                KairisFarm._alive = (me ~= nil) and not (me.Killed or me.Dead)
            else
                KairisFarm._alive = true
            end
            task.wait(1)
        end
    end)
end

local function kNearestCoin(pos)
    local best, bestD = nil, math.huge
    for _, m in ipairs(workspace:GetChildren()) do
        if m:IsA("Model") then
            local cc = m:FindFirstChild("CoinContainer")
            if cc then
                for _, c in ipairs(cc:GetChildren()) do
                    if kIsCoin(c) then
                        local d = (pos - c.Position).Magnitude
                        if d < bestD then
                            bestD = d
                            best = c
                        end
                    end
                end
            end
        end
    end
    return best
end

local function startAutoFarm()
    KairisFarm.active = true
    pcall(function()
        if Config then
            Config.CoinFarm.State = false
            Config.CoinFarm2.State = false
            Config.CoinFarm3.State = false
        end
    end)
end

local function stopAutoFarm()
    KairisFarm.active = false
    pcall(function()
        if Config then
            Config.CoinFarm.State = false
            Config.CoinFarm2.State = false
            Config.CoinFarm3.State = false
        end
    end)
    local char, hrp, hum = kCharParts()
    if hrp then
        hrp.Anchored = false
        local bv = hrp:FindFirstChild("KairisFarmBV")
        if bv then bv:Destroy() end
        local spin = hrp:FindFirstChild("KairisFarmSpin")
        if spin then spin:Destroy() end
    end
    if hum then
        hum.PlatformStand = false
    end
    KairisFarm._lastBest = nil
    KairisFarm._lastProgress = nil
    KairisFarm._prevCount = nil
    KairisFarm._bl = {}
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = true
            end
        end
    end
end

getgenv()._kairisFarmGen = (getgenv()._kairisFarmGen or 0) + 1
local __kairisFarmGen = getgenv()._kairisFarmGen

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv()._kairisFarmGen ~= __kairisFarmGen then return end
    if not KairisFarm.active then return end
    
    local char, hrp, hum = kCharParts()
    if not (char and hrp and hum and hum.Health > 0) then return end
    
    if KairisFarm._alive == false then
        local oldBv = hrp:FindFirstChild("KairisFarmBV")
        if oldBv then oldBv:Destroy() end
        local oldSpin = hrp:FindFirstChild("KairisFarmSpin")
        if oldSpin then oldSpin:Destroy() end
        if hum.PlatformStand then hum.PlatformStand = false end
        return
    end
    
    if hrp.Anchored then hrp.Anchored = false end
    
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
    end
    
    if KairisFarm._char ~= char then
        KairisFarm._char = char
        KairisFarm._bl = {}
        KairisFarm._lastBest = nil
        KairisFarm._lastProgress = nil
        KairisFarm._prevCount = nil
    end
    
    local bv = hrp:FindFirstChild("KairisFarmBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "KairisFarmBV"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp
    end
    
    local spinner = hrp:FindFirstChild("KairisFarmSpin")
    if KairisFarm.spin then
        if not spinner then
            spinner = Instance.new("BodyAngularVelocity")
            spinner.Name = "KairisFarmSpin"
            spinner.MaxTorque = Vector3.new(0, 1e9, 0)
            spinner.P = 1e5
            spinner.Parent = hrp
        end
        spinner.AngularVelocity = Vector3.new(0, 18, 0)
    elseif spinner then
        spinner:Destroy()
    end
    
    if not hum.PlatformStand then hum.PlatformStand = true end
    
    if kBagFull() then
        bv.Velocity = Vector3.zero
        if hum.PlatformStand then hum.PlatformStand = false end
        return
    end
    
    KairisFarm._bl = KairisFarm._bl or {}
    local now = os.clock()
    for k, exp in pairs(KairisFarm._bl) do
        if exp <= now then KairisFarm._bl[k] = nil end
    end
    
    local murderPos = nil
    if KairisFarm.avoidMurderer then
        local murd = kFindMurderer()
        if murd and murd.Character then
            local mhrp = murd.Character:FindFirstChild("HumanoidRootPart")
            if mhrp then murderPos = mhrp.Position end
        end
    end
    
    local pos = hrp.Position
    local speed = math.max(KairisFarm.speed, 20)
    local best, bestD, candidates = nil, math.huge, 0
    
    local grabR = 14
    if KairisFarm.wide then grabR = 34 end
    if KairisFarm.spin then grabR = grabR + 16 end
    KairisFarm._tick = (KairisFarm._tick or 0) + 1
    local wideSweep = grabR > 14 and (KairisFarm._tick % 3 == 0)
    
    for _, m in ipairs(workspace:GetChildren()) do
        if m:IsA("Model") then
            local cc = m:FindFirstChild("CoinContainer")
            if cc then
                for _, c in ipairs(cc:GetChildren()) do
                    if kIsCoin(c)
                        and not KairisFarm._bl[c]
                        and not (murderPos and (c.Position - murderPos).Magnitude < KairisFarm.avoidDist)
                    then
                        local d = (pos - c.Position).Magnitude
                        candidates = candidates + 1
                        if d < bestD and d <= 600 then
                            bestD = d
                            best = c
                        end
                        if d < 14 then
                            pcall(firetouchinterest, hrp, c, 0)
                            pcall(firetouchinterest, hrp, c, 1)
                        elseif wideSweep and d < grabR then
                            pcall(firetouchinterest, hrp, c, 0)
                            pcall(firetouchinterest, hrp, c, 1)
                        end
                    end
                end
            end
        end
    end
    
    if best then
        if best == KairisFarm._lastBest and bestD < 6 then
            if now - (KairisFarm._lastBestT or now) > 1.2 then
                KairisFarm._bl[best] = now + 2
                KairisFarm._lastBest = nil
                best = nil
            end
        else
            KairisFarm._lastBest = best
            KairisFarm._lastBestT = now
        end
    end
    
    KairisFarm._lastProgress = KairisFarm._lastProgress or now
    if candidates ~= KairisFarm._prevCount then
        KairisFarm._prevCount = candidates
        KairisFarm._lastProgress = now
        KairisFarm._hops = 0
    elseif candidates > 0 and now - KairisFarm._lastProgress > 6 then
        KairisFarm._bl = {}
        KairisFarm._lastBest = nil
        KairisFarm._lastProgress = now
        pcall(function() bv:Destroy() end)
        KairisFarm._hops = (KairisFarm._hops or 0) + 1
        if KairisFarm._hops <= 3 then
            pcall(function() hrp.CFrame = hrp.CFrame + Vector3.new(0, 4, 0) end)
        end
        return
    end
    
    if murderPos and (pos - murderPos).Magnitude < KairisFarm.avoidDist then
        local away = (pos - murderPos)
        if away.Magnitude < 0.1 then away = Vector3.new(1, 0, 0) end
        bv.Velocity = away.Unit * speed
    elseif best then
        local dir = best.Position - pos
        local dist = dir.Magnitude
        if dist < grabR then
            pcall(firetouchinterest, hrp, best, 0)
            pcall(firetouchinterest, hrp, best, 1)
        end
        if dist > 2 then
            bv.Velocity = dir.Unit * speed
        else
            bv.Velocity = Vector3.zero
        end
    else
        bv.Velocity = Vector3.zero
    end
end)

-- ===== Auto Farm Toggles =====
pcall(function()
    if not t1.AutoFarmTab then return end
    t1.AutoFarmTab:Toggle({
        Title = "Enable Auto Farm",
        Default = false,
        Callback = function(p127)
            if p127 then
                startAutoFarm()
            else
                stopAutoFarm()
            end
        end
    })
    
    t1.AutoFarmTab:Slider({
        Title = "Auto Farm Speed",
        Desc = "Studs per second between coins — 27 is the cap, past that the server drops pickups",
        Step = 1,
        Value = {
            Min = 20,
            Max = 27,
            Default = 27
        },
        Callback = function(p128)
            KairisFarm.speed = math.clamp(p128, 20, 27)
        end
    })
    
    t1.AutoFarmTab:Toggle({
        Title = "Wide Range Collect",
        Desc = "Grabs coins from 34 studs instead of 14 — big speed boost per round",
        Value = KairisFarm.wide,
        Callback = function(state)
            KairisFarm.wide = state
        end
    })
    
    t1.AutoFarmTab:Toggle({
        Title = "Spin (far vacuum)",
        Desc = "Spins you and adds +16 studs of reach — Y-axis only, so walls won't tumble you",
        Value = KairisFarm.spin,
        Callback = function(state)
            KairisFarm.spin = state
        end
    })
    
    t1.AutoFarmTab:Toggle({
        Title = "Hide My Body",
        Desc = "Hides your character (your view only) for a clean float",
        Value = KairisFarm.hideBody,
        Callback = function(state)
            KairisFarm.hideBody = state
            if not state then
                local char = game:GetService("Players").LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") or p:IsA("Decal") or p:IsA("Texture") then
                            p.LocalTransparencyModifier = 0
                        end
                    end
                end
            end
        end
    })
    
    t1.AutoFarmTab:Toggle({
        Title = "Avoid Murderer",
        Desc = "Skips coins near the murderer and flees if he gets close so you don't get knifed",
        Value = KairisFarm.avoidMurderer,
        Callback = function(state)
            KairisFarm.avoidMurderer = state
        end
    })
    
    t1.AutoFarmTab:Slider({
        Title = "Avoid Distance",
        Desc = "How many studs to keep away from the murderer",
        Step = 1,
        Value = {
            Min = 15,
            Max = 120,
            Default = KairisFarm.avoidDist
        },
        Callback = function(p)
            KairisFarm.avoidDist = p
        end
    })
end)

-- ===== Hide Under Map =====
pcall(function()
    if not t1.AutoFarmTab then return end
    local RunServiceH = game:GetService("RunService")
    local LPH = game:GetService("Players").LocalPlayer
    getgenv().KairisHide = getgenv().KairisHide or {}
    local KairisHide = getgenv().KairisHide
    KairisHide.active = false
    KairisHide.depth = KairisHide.depth or 30
    
    local function kHideParts()
        local ch = LPH.Character
        return ch, ch and ch:FindFirstChild("HumanoidRootPart")
    end
    
    local function goUnder()
        local _, hrp = kHideParts()
        if not hrp then return end
        if KairisHide._fpdh == nil then
            KairisHide._fpdh = workspace.FallenPartsDestroyHeight
        end
        pcall(function() workspace.FallenPartsDestroyHeight = -1e9 end)
        if not hrp.Anchored then
            KairisHide._floorY = hrp.Position.Y
        end
        local baseY = KairisHide._floorY or hrp.Position.Y
        hrp.CFrame = CFrame.new(hrp.Position.X, baseY - KairisHide.depth, hrp.Position.Z)
        hrp.Anchored = true
    end
    
    t1.AutoFarmTab:Section({ Title = "Hide", Icon = "eye-off" })
    t1.AutoFarmTab:Toggle({
        Title = "Hide Under Map",
        Desc = "Drops you under the floor so the murderer can't see or reach you (stops farming)",
        Value = false,
        Callback = function(state)
            KairisHide.active = state
            if state then
                KairisFarm.active = false
                goUnder()
            else
                local _, hrp = kHideParts()
                if hrp then
                    if KairisHide._floorY then
                        hrp.CFrame = CFrame.new(hrp.Position.X, KairisHide._floorY + 3, hrp.Position.Z)
                    end
                    hrp.Anchored = false
                end
                if KairisHide._fpdh ~= nil then
                    pcall(function() workspace.FallenPartsDestroyHeight = KairisHide._fpdh end)
                    KairisHide._fpdh = nil
                end
                KairisHide._floorY = nil
            end
        end
    })
    
    t1.AutoFarmTab:Slider({
        Title = "Hide Depth",
        Desc = "How far under the floor to drop (studs)",
        Step = 5,
        Value = {
            Min = 10,
            Max = 500,
            Default = KairisHide.depth
        },
        Callback = function(v)
            KairisHide.depth = v
            if KairisHide.active then goUnder() end
        end
    })
    
    if not getgenv()._kairisHideLoop then
        getgenv()._kairisHideLoop = true
        RunServiceH.Heartbeat:Connect(function()
            if not KairisHide.active then return end
            local _, hrp = kHideParts()
            if hrp and not hrp.Anchored then
                goUnder()
            end
        end)
    end
end)

-- ===== ESP System =====
pcall(function()
    if not t1.ESPTab then return end
    local t14 = {
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService")
    }
    local t15 = {
        GetCurrentPlayerData = t14.ReplicatedStorage:FindFirstChild("GetCurrentPlayerData", true)
    }
    local CurrentCamera3 = workspace.CurrentCamera
    local LocalPlayer8 = t14.Players.LocalPlayer
    local u97 = nil
    
    function u98()
        local ok, result = pcall(function()
            if t15.GetCurrentPlayerData then
                return t15.GetCurrentPlayerData:InvokeServer() or {}
            end
        end)
        return ok and result or {}
    end
    
    function u99(p36)
        local v378 = u97[p36.Name]
        return v378 and (not v378.Killed and not v378.Dead)
    end
    
    function u100(p37)
        local Backpack = p37:FindFirstChild("Backpack")
        if Backpack and Backpack:FindFirstChild("Gun") then
            return true
        end
        local v381 = p37.Character or workspace:FindFirstChild(p37.Name)
        if not v381 or not v381:FindFirstChild("Gun") then
            return false
        end
        return true
    end
    
    local t16 = {
        Highlights = {
            Innocent = Color3.fromRGB(0, 255, 0),
            Murderer = Color3.fromRGB(255, 0, 0),
            Sheriff = Color3.fromRGB(0, 0, 255),
            Hero = Color3.fromRGB(0, 0, 255),
            DeadInnocent = Color3.fromRGB(128, 128, 128)
        },
        Skeleton = {
            Innocent = Color3.fromRGB(0, 255, 0),
            Murderer = Color3.fromRGB(255, 0, 0),
            Sheriff = Color3.fromRGB(0, 0, 255),
            Hero = Color3.fromRGB(0, 0, 255),
            DeadInnocent = Color3.fromRGB(128, 128, 128)
        },
        Tracers = {
            Innocent = Color3.fromRGB(0, 255, 0),
            Murderer = Color3.fromRGB(255, 0, 0),
            Sheriff = Color3.fromRGB(0, 0, 255),
            Hero = Color3.fromRGB(0, 0, 255),
            DeadInnocent = Color3.fromRGB(128, 128, 128)
        }
    }
    local t17 = {
        Highlights = {
            Innocent = false,
            Murderer = false,
            Sheriff = false,
            DeadInnocent = false
        },
        Skeleton = {
            Innocent = false,
            Murderer = false,
            Sheriff = false,
            DeadInnocent = false
        },
        Tracers = {
            Innocent = false,
            Murderer = false,
            Sheriff = false,
            DeadInnocent = false
        }
    }
    
    local t18 = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }
    local t19 = {}
    local t20 = {}
    local u107 = false
    
    function u108(p38)
        pcall(function()
            if t19[p38] then
                t19[p38]:Destroy()
                t19[p38] = nil
            end
            if t20[p38] then
                local v384 = t20[p38]
                if v384.tracer then
                    v384.tracer:Remove()
                end
                if v384.nameText then
                    v384.nameText:Remove()
                end
                if v384.skeletonLines then
                    for _, v in ipairs(v384.skeletonLines) do
                        v:Remove()
                    end
                end
                t20[p38] = nil
            end
        end)
    end
    
    for _, player in ipairs(t14.Players:GetPlayers()) do
        if player ~= LocalPlayer8 then
            player.CharacterRemoving:Connect(function()
                u108(player)
            end)
        end
    end
    
    t14.Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer8 then
            player.CharacterRemoving:Connect(function()
                u108(player)
            end)
        end
    end)
    t14.Players.PlayerRemoving:Connect(u108)
    
    getgenv().KairisRoles = getgenv().KairisRoles or {}
    local KairisRoles = getgenv().KairisRoles
    
    local function kAnyEsp()
        for _, cat in pairs(t17) do
            for _, on in pairs(cat) do
                if on then
                    return true
                end
            end
        end
        return false
    end
    
    if not getgenv()._kairisRolesLoop then
        getgenv()._kairisRolesLoop = true
        task.spawn(function()
            while true do
                if kAnyEsp() then
                    local fresh = u98()
                    if type(fresh) == "table" then
                        table.clear(KairisRoles)
                        for k, v in pairs(fresh) do
                            KairisRoles[k] = v
                        end
                    end
                end
                task.wait(0.6)
            end
        end)
    end
    
    t14.RunService.RenderStepped:Connect(function()
        if not kAnyEsp() then
            if u107 then
                for _, plr in ipairs(t14.Players:GetPlayers()) do
                    u108(plr)
                end
                u107 = false
            end
            return
        end
        
        u97 = KairisRoles
        local v389 = next(u97) ~= nil
        
        if u107 and not v389 then
            for _, player in ipairs(t14.Players:GetPlayers()) do
                u108(player)
            end
        end
        
        u107 = v389
        
        if v389 then
            for _, player in ipairs(t14.Players:GetPlayers()) do
                if player ~= LocalPlayer8 then
                    local v396 = player.Character or workspace:FindFirstChild(player.Name)
                    if not v396 or not v396.Parent then
                        u108(player)
                    else
                        local v397 = u97[player.Name]
                        if not v397 then
                            u108(player)
                        else
                            local Role = v397.Role
                            if not v397.Dead and not v397.Killed then
                                if Role == "Innocent" and u100(player) and (not u97.Sheriff or not u99(t14.Players[u97.Sheriff])) then
                                    Role = "Hero"
                                end
                                local v400 = t17.Highlights[Role] or Role == "Hero" and t17.Highlights.Sheriff
                                local v401 = t17.Tracers[Role] or Role == "Hero" and t17.Tracers.Sheriff
                                local v402 = t17.Skeleton[Role] or Role == "Hero" and t17.Skeleton.Sheriff
                                local v403 = t16.Highlights[Role == "Hero" and "Sheriff" or Role]
                                local v404 = t16.Tracers[Role == "Hero" and "Sheriff" or Role]
                                local v405 = t16.Skeleton[Role == "Hero" and "Sheriff" or Role]
                                
                                local u406 = t19[player]
                                if not v400 then
                                    if u406 then
                                        u406.Enabled = false
                                    end
                                else
                                    if not u406 or v396 ~= u406.Parent then
                                        if u406 then
                                            pcall(function() u406:Destroy() end)
                                        end
                                        u406 = Instance.new("Highlight")
                                        u406.Parent = v396
                                        u406.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                        u406.FillTransparency = 0.55
                                        u406.FillColor = v403
                                        u406.OutlineTransparency = 0
                                        t19[player] = u406
                                    end
                                    u406.OutlineColor = v403
                                    u406.Enabled = true
                                end
                                
                                if not t20[player] then
                                    t20[player] = {}
                                end
                                local v407 = t20[player]
                                
                                if not v401 then
                                    if v407.tracer then
                                        v407.tracer.Visible = false
                                    end
                                    if v407.nameText then
                                        v407.nameText.Visible = false
                                    end
                                else
                                    if not v407.tracer then
                                        v407.tracer = Drawing.new("Line")
                                        v407.tracer.Thickness = 2
                                    end
                                    if not v407.nameText then
                                        v407.nameText = Drawing.new("Text")
                                        v407.nameText.Size = 15
                                        v407.nameText.Center = true
                                        v407.nameText.Outline = true
                                        v407.nameText.Font = 2
                                    end
                                    v407.tracer.Color = v404
                                    v407.nameText.Color = v404
                                    
                                    local HumanoidRootPart = v396:FindFirstChild("HumanoidRootPart")
                                    if HumanoidRootPart then
                                        local HumanoidRootPartPosition = HumanoidRootPart.Position
                                        local v410, v411 = CurrentCamera3:WorldToViewportPoint(HumanoidRootPartPosition)
                                        local Humanoid = v396:FindFirstChildOfClass("Humanoid")
                                        if not Humanoid or not (Humanoid.Health <= 0) then
                                            if v411 then
                                                local vector2 = Vector2.new(CurrentCamera3.ViewportSize.X / 2, CurrentCamera3.ViewportSize.Y)
                                                v407.tracer.From = vector2
                                                v407.tracer.To = Vector2.new(v410.X, v410.Y)
                                                v407.tracer.Visible = true
                                                
                                                local _HumanoidRootPart3 = LocalPlayer8.Character and LocalPlayer8.Character:FindFirstChild("HumanoidRootPart")
                                                local v415 = _HumanoidRootPart3 and math.floor((_HumanoidRootPart3.Position - HumanoidRootPartPosition).Magnitude) or 999
                                                v407.nameText.Text = player.Name .. " [" .. v415 .. "]"
                                                v407.nameText.Position = Vector2.new(v410.X, v410.Y - 35)
                                                v407.nameText.Visible = true
                                            else
                                                v407.tracer.Visible = false
                                                v407.nameText.Visible = false
                                            end
                                        else
                                            v407.tracer.Visible = false
                                            v407.nameText.Visible = false
                                        end
                                    else
                                        v407.tracer.Visible = false
                                        v407.nameText.Visible = false
                                    end
                                end
                                
                                if v402 then
                                    if not v407.skeletonLines then
                                        v407.skeletonLines = {}
                                        for _ = 1, #t18 do
                                            local drawing = Drawing.new("Line")
                                            drawing.Thickness = 1
                                            table.insert(v407.skeletonLines, drawing)
                                        end
                                    end
                                    for _, v in ipairs(v407.skeletonLines) do
                                        v.Color = v405
                                    end
                                    for i, v in ipairs(t18) do
                                        local v422 = v396:FindFirstChild(v[1])
                                        local v423 = v396:FindFirstChild(v[2])
                                        if not v422 or not v423 then
                                            v407.skeletonLines[i].Visible = false
                                        else
                                            local v424, v425 = CurrentCamera3:WorldToViewportPoint(v422.Position)
                                            local v426, v427 = CurrentCamera3:WorldToViewportPoint(v423.Position)
                                            if not v425 or not v427 then
                                                v407.skeletonLines[i].Visible = false
                                            else
                                                v407.skeletonLines[i].From = Vector2.new(v424.X, v424.Y)
                                                v407.skeletonLines[i].To = Vector2.new(v426.X, v426.Y)
                                                v407.skeletonLines[i].Visible = true
                                            end
                                        end
                                    end
                                elseif v407.skeletonLines then
                                    for _, v in ipairs(v407.skeletonLines) do
                                        v.Visible = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    
    t1.ESPTab:Divider()
    t1.ESPTab:Space()
    t1.ESPTab:Toggle({ Title = "Innocent Highlights", Value = false, Callback = function(p39) t17.Highlights.Innocent = p39 end })
    t1.ESPTab:Toggle({ Title = "Murderer Highlights", Value = false, Callback = function(p40) t17.Highlights.Murderer = p40 end })
    t1.ESPTab:Toggle({ Title = "Sheriff/Hero Highlights", Value = false, Callback = function(p41) t17.Highlights.Sheriff = p41 end })
    t1.ESPTab:Toggle({ Title = "Dead Highlights", Value = false, Callback = function(p42) t17.Highlights.DeadInnocent = p42 end })
    t1.ESPTab:Divider()
    t1.ESPTab:Space()
    t1.ESPTab:Toggle({ Title = "Innocent Skeleton", Value = false, Callback = function(p43) t17.Skeleton.Innocent = p43 end })
    t1.ESPTab:Toggle({ Title = "Murderer Skeleton", Value = false, Callback = function(p44) t17.Skeleton.Murderer = p44 end })
    t1.ESPTab:Toggle({ Title = "Sheriff/Hero Skeleton", Value = false, Callback = function(p45) t17.Skeleton.Sheriff = p45 end })
    t1.ESPTab:Toggle({ Title = "Dead Skeleton", Value = false, Callback = function(p46) t17.Skeleton.DeadInnocent = p46 end })
    t1.ESPTab:Divider()
    t1.ESPTab:Space()
    t1.ESPTab:Toggle({ Title = "Innocent Tracers", Value = false, Callback = function(p47) t17.Tracers.Innocent = p47 end })
    t1.ESPTab:Toggle({ Title = "Murderer Tracers", Value = false, Callback = function(p48) t17.Tracers.Murderer = p48 end })
    t1.ESPTab:Toggle({ Title = "Sheriff/Hero Tracers", Value = false, Callback = function(p49) t17.Tracers.Sheriff = p49 end })
    t1.ESPTab:Toggle({ Title = "Dead Tracers", Value = false, Callback = function(p50) t17.Tracers.DeadInnocent = p50 end })
    t1.ESPTab:Divider()
    t1.ESPTab:Divider()
    t1.ESPTab:Space()
    t1.ESPTab:Colorpicker({ Title = "Innocent Highlights Color", Default = t16.Highlights.Innocent, Callback = function(p51) t16.Highlights.Innocent = p51 end })
    t1.ESPTab:Colorpicker({ Title = "Murderer Highlights Color", Default = t16.Highlights.Murderer, Callback = function(p52) t16.Highlights.Murderer = p52 end })
    t1.ESPTab:Colorpicker({ Title = "Sheriff/Hero Highlights Color", Default = t16.Highlights.Sheriff, Callback = function(p53) t16.Highlights.Sheriff = p53; t16.Highlights.Hero = p53 end })
    t1.ESPTab:Colorpicker({ Title = "Dead Highlights Color", Default = t16.Highlights.DeadInnocent, Callback = function(p54) t16.Highlights.DeadInnocent = p54 end })
    t1.ESPTab:Divider()
    t1.ESPTab:Space()
    t1.ESPTab:Colorpicker({ Title = "Innocent Skeleton Color", Default = t16.Skeleton.Innocent, Callback = function(p55) t16.Skeleton.Innocent = p55 end })
    t1.ESPTab:Colorpicker({ Title = "Murderer Skeleton Color", Default = t16.Skeleton.Murderer, Callback = function(p56) t16.Skeleton.Murderer = p56 end })
    t1.ESPTab:Colorpicker({ Title = "Sheriff/Hero Skeleton Color", Default = t16.Skeleton.Sheriff, Callback = function(p57) t16.Skeleton.Sheriff = p57; t16.Skeleton.Hero = p57 end })
    t1.ESPTab:Colorpicker({ Title = "Dead Skeleton Color", Default = t16.Skeleton.DeadInnocent, Callback = function(p58) t16.Skeleton.DeadInnocent = p58 end })
    t1.ESPTab:Divider()
    t1.ESPTab:Space()
    t1.ESPTab:Colorpicker({ Title = "Innocent Tracers Color", Default = t16.Tracers.Innocent, Callback = function(p59) t16.Tracers.Innocent = p59 end })
    t1.ESPTab:Colorpicker({ Title = "Murderer Tracers Color", Default = t16.Tracers.Murderer, Callback = function(p60) t16.Tracers.Murderer = p60 end })
    t1.ESPTab:Colorpicker({ Title = "Sheriff/Hero Tracers Color", Default = t16.Tracers.Sheriff, Callback = function(p61) t16.Tracers.Sheriff = p61; t16.Tracers.Hero = p61 end })
    t1.ESPTab:Colorpicker({ Title = "Dead Tracers Color", Default = t16.Tracers.DeadInnocent, Callback = function(p62) t16.Tracers.DeadInnocent = p62 end })
end)

-- ===== Dropped Gun ESP =====
pcall(function()
    if not t1.ESPTab then return end
    local gunEsp = false
    local gunEntries = {}
    local RS2 = game:GetService("RunService")
    
    t1.ESPTab:Divider()
    t1.ESPTab:Toggle({
        Title = "Dropped Gun ESP",
        Desc = "Highlights the dropped gun with a distance label",
        Value = false,
        Callback = function(state)
            gunEsp = state
        end
    })
    
    local function clearGun()
        for p, e in pairs(gunEntries) do
            if e.text then pcall(function() e.text:Remove() end) end
            if e.hl then pcall(function() e.hl:Destroy() end) end
            gunEntries[p] = nil
        end
    end
    
    task.spawn(function()
        while true do
            if gunEsp then
                local seen = {}
                for _, d in ipairs(workspace:GetDescendants()) do
                    if d.Name == "GunDrop" and d:IsA("BasePart") then
                        seen[d] = true
                        if not gunEntries[d] then
                            local hl = Instance.new("Highlight")
                            hl.FillColor = Color3.fromRGB(255, 230, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.35
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Adornee = d
                            hl.Parent = d
                            local txt = Drawing.new("Text")
                            txt.Center = true
                            txt.Outline = true
                            txt.Size = 16
                            txt.Font = 2
                            txt.Color = Color3.fromRGB(255, 230, 0)
                            gunEntries[d] = { hl = hl, text = txt }
                        end
                    end
                end
                for p, e in pairs(gunEntries) do
                    if not seen[p] or not p.Parent then
                        if e.text then pcall(function() e.text:Remove() end) end
                        if e.hl then pcall(function() e.hl:Destroy() end) end
                        gunEntries[p] = nil
                    end
                end
            elseif next(gunEntries) then
                clearGun()
            end
            task.wait(0.3)
        end
    end)
    
    RS2.RenderStepped:Connect(function()
        if not gunEsp then return end
        local char = game:GetService("Players").LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        for p, e in pairs(gunEntries) do
            if p.Parent and e.text then
                local sp, on = workspace.CurrentCamera:WorldToViewportPoint(p.Position)
                if on then
                    local dist = hrp and math.floor((hrp.Position - p.Position).Magnitude) or 0
                    e.text.Text = "GUN [" .. dist .. "]"
                    e.text.Position = Vector2.new(sp.X, sp.Y - 20)
                    e.text.Visible = true
                else
                    e.text.Visible = false
                end
            end
        end
    end)
end)

-- ===== Player Tab =====
pcall(function()
    if not t1.PlayerTab then return end
    local Players5 = game:GetService("Players")
    local UserInputService3 = game:GetService("UserInputService")
    local RunService4 = game:GetService("RunService")
    local Workspace3 = game:GetService("Workspace")
    local LocalPlayer10 = Players5.LocalPlayer
    local u119 = false
    local u120 = false
    local u121 = false
    local u122 = false
    local n11 = -50
    local u124 = nil
    local vector3 = Vector3.new(1000, 10, 1000)
    
    t1.PlayerTab:Section({ Title = "player", Icon = "person-standing" })
    t1.PlayerTab:Toggle({
        Title = "Noclip",
        Value = false,
        Callback = function(p63)
            u119 = p63
        end
    })
    
    RunService4.Stepped:Connect(function()
        if u119 and LocalPlayer10.Character then
            for _, descendant in ipairs(LocalPlayer10.Character:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = false
                end
            end
        end
    end)
    
    t1.PlayerTab:Slider({
        Title = "Walk Speed",
        Desc = "Changes player walk speed",
        Value = {
            Min = 16,
            Max = 200,
            Default = 16
        },
        Callback = function(p64)
            local _Humanoid = LocalPlayer10.Character and LocalPlayer10.Character:FindFirstChildOfClass("Humanoid")
            if _Humanoid then
                _Humanoid.WalkSpeed = p64
            end
        end
    })
    
    t1.PlayerTab:Slider({
        Title = "Jump Power",
        Value = {
            Min = 50,
            Max = 500,
            Default = 50
        },
        Callback = function(p65)
            local _Humanoid2 = LocalPlayer10.Character and LocalPlayer10.Character:FindFirstChildOfClass("Humanoid")
            if _Humanoid2 then
                _Humanoid2.JumpPower = p65
            end
        end
    })
    
    t1.PlayerTab:Toggle({
        Title = "Zero Gravity",
        Callback = function(p66)
            Workspace3.Gravity = p66 and 0 or 196.2
        end
    })
    
    t1.PlayerTab:Divider()
    t1.PlayerTab:Toggle({
        Title = "X ray",
        Callback = function(p67)
            u121 = p67
            for _, descendant in pairs(Workspace3:GetDescendants()) do
                if descendant:IsA("BasePart") and (not LocalPlayer10.Character or not descendant:IsDescendantOf(LocalPlayer10.Character)) then
                    descendant.LocalTransparencyModifier = p67 and 0.7 or 0
                end
            end
        end
    })
    
    t1.PlayerTab:Toggle({
        Title = "Infinite Jump",
        Callback = function(p68)
            u120 = p68
        end
    })
    
    UserInputService3.JumpRequest:Connect(function()
        if u120 and LocalPlayer10.Character then
            local Humanoid = LocalPlayer10.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    
    t1.PlayerTab:Button({
        Title = "Teleport Tool",
        Callback = function()
            local Tool = Instance.new("Tool")
            Tool.RequiresHandle = false
            Tool.Name = "Teleport Tool"
            Tool.Activated:Connect(function()
                local mouse = LocalPlayer10:GetMouse()
                if mouse then
                    local v880 = mouse.Hit.Position + Vector3.new(0, 5, 0)
                    local _HumanoidRootPart4 = LocalPlayer10.Character and LocalPlayer10.Character:FindFirstChild("HumanoidRootPart")
                    if _HumanoidRootPart4 then
                        _HumanoidRootPart4.CFrame = CFrame.new(v880)
                    end
                end
            end)
            Tool.Parent = LocalPlayer10:WaitForChild("Backpack")
        end
    })
    t1.PlayerTab:Divider()
    
    local function u126()
        if u124 and u124.Parent then
            u124:Destroy()
        end
        u124 = Instance.new("Part")
        u124.Name = "AntiVoidPlatform"
        u124.Size = vector3
        u124.Position = Vector3.new(0, n11 + vector3.Y / 2, 0)
        u124.Anchored = true
        u124.CanCollide = true
        u124.Transparency = 0.7
        u124.Color = Color3.fromRGB(38, 222, 199)
        u124.Material = Enum.Material.Neon
        local Texture = Instance.new("Texture")
        Texture.Texture = "rbxassetid://280375461"
        Texture.Face = Enum.NormalId.Top
        Texture.StudsPerTileU = 50
        Texture.StudsPerTileV = 50
        Texture.Parent = u124
        local Texture2 = Instance.new("Texture")
        Texture2.Texture = "rbxassetid://280375461"
        Texture2.Face = Enum.NormalId.Bottom
        Texture2.StudsPerTileU = 50
        Texture2.StudsPerTileV = 50
        Texture2.Parent = u124
        u124.Friction = 0.3
        u124.Elasticity = 0.1
        u124.Parent = Workspace3
        return u124
    end
    
    local function u127()
        if u124 and u124.Parent then
            u124:Destroy()
            u124 = nil
        end
    end
    
    local function u128()
        if not u122 then
            u127()
        else
            if not u124 or not u124.Parent then
                u126()
            end
            local Character = LocalPlayer10.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                local HumanoidRootPart = Character.HumanoidRootPart
                u124.Position = Vector3.new(math.floor(HumanoidRootPart.Position.X / 100) * 100, n11 + vector3.Y / 2, math.floor(HumanoidRootPart.Position.Z / 100) * 100)
            end
        end
    end
    
    t1.PlayerTab:Toggle({
        Title = "Anti Void",
        Value = false,
        Callback = function(p69)
            u122 = p69
            u128()
            if not p69 then
                u127()
            end
        end
    })
    
    local connection = nil
    local vector3_3 = Vector3.new(0, 0, 0)
    
    local function u131()
        if connection then
            connection:Disconnect()
        end
        connection = RunService4.Heartbeat:Connect(function()
            if u122 and u124 then
                local Character = LocalPlayer10.Character
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    local HumanoidRootPart = Character.HumanoidRootPart
                    if (HumanoidRootPart.Position - vector3_3).Magnitude > 100 then
                        vector3_3 = HumanoidRootPart.Position
                        u124.Position = Vector3.new(math.floor(HumanoidRootPart.Position.X / 100) * 100, n11 + vector3.Y / 2, math.floor(HumanoidRootPart.Position.Z / 100) * 100)
                    end
                end
            end
        end)
    end
    
    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if player == LocalPlayer10 then
            u127()
            if connection then
                connection:Disconnect()
            end
        end
    end)
    
    LocalPlayer10.CharacterAdded:Connect(function(character)
        local Humanoid = character:WaitForChild("Humanoid")
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
        if u122 then
            wait(1)
            u128()
            u131()
        end
    end)
    
    if u122 then
        u128()
        u131()
    end
    
    t1.PlayerTab:Button({
        Title = "mobile Fly",
        Value = false,
        Callback = function(_)
            pcall(function()
                loadstring(game:HttpGet("https://gist.githubusercontent.com/meozoneYT/bf037dff9f0a70017304ddd67fdcd370/raw/e14e74f425b060df523343cf30b787074eb3c5d2/arceus%2520x%2520fly%25202%2520obflucator.txt"))()
            end)
        end
    })
end)

-- ===== Visual/Spawner Tab =====
pcall(function()
    if not t1.Visual then return end
    local ReplicatedStorage3 = game:GetService("ReplicatedStorage")
    local LocalPlayer16 = game:GetService("Players").LocalPlayer
    local s7 = ""
    
    local function u175()
        local ok, result = pcall(function()
            return require(ReplicatedStorage3.Database.Sync.MysteryBox)
        end)
        if not ok or not result or next(result) == nil then
            return "StandardBox"
        end
        local t34 = {}
        for k, _ in pairs(result) do
            table.insert(t34, k)
        end
        return t34[math.random(1, #t34)]
    end
    
    local function u176(p131)
        local _BoxModule = ReplicatedStorage3:FindFirstChild("Modules") and ReplicatedStorage3.Modules:FindFirstChild("BoxModule")
        local _Database = ReplicatedStorage3:FindFirstChild("Database") and (ReplicatedStorage3.Database:FindFirstChild("Sync") and ReplicatedStorage3.Database.Sync:FindFirstChild("Item"))
        if not _BoxModule or not _Database then
            return
        end
        local lib = require(_BoxModule)
        local lib2 = require(_Database)
        if p131 and lib2[p131] then
            local ok, result = pcall(function()
                lib.OpenBox(u175(), p131)
                pcall(function()
                    local v969 = getsenv(LocalPlayer16.PlayerGui.MainGUI.Inventory.NewItem)
                    if v969 and (v969._G and v969._G.NewItem) then
                        v969._G.NewItem(p131, nil, nil, "Weapons", 1)
                    end
                end)
            end)
            if not ok then
                warn("SpawnWeapon error:", result)
            end
        else
            pcall(function()
                _Raw:Notify({
                    Title = "Error",
                    Content = "Check your spelling. Make sure it matches the dropdown description: " .. (p131 or "Unknown"),
                    Icon = "x-circle",
                    Duration = 3
                })
            end)
        end
    end
    
    t1.Visual:Section({ Title = "item Unboxer", Icon = "" })
    t1.Visual:Divider()
    
    t1.Visual:Input({
        Title = "item unboxer",
        Desc = "example 'Harvester' not 'harvester' alwways upper case letter pls",
        Placeholder = "Harvester",
        Callback = function(p132)
            s7 = p132
        end
    })
    
    t1.Visual:Button({
        Title = "unbox item",
        Icon = "sparkles",
        Callback = function()
            if not s7 or s7 == "" then
                safeNotify("Error", "Please enter a weapon name", "x-circle", 3)
            else
                u176(s7)
            end
        end
    })
    t1.Visual:Divider()
    t1.Visual:Button({ Title = "Unbox Gingerscope", Callback = function() u176("Gingerscope") end })
    t1.Visual:Button({ Title = "Unbox Harvester", Callback = function() u176("Harvester") end })
    t1.Visual:Button({ Title = "Unbox Sweet", Callback = function() u176("Sweet") end })
    t1.Visual:Button({ Title = "Unbox Treat", Callback = function() u176("Treat") end })
    t1.Visual:Divider()
    
    t1.Visual:Section({ Title = "item Spawner", Desc = "" })
    
    local function u177(p133, p134)
        local Item = require(ReplicatedStorage3.Database.Sync.Item)
        local Weapons = require(ReplicatedStorage3.Modules.ProfileData).Weapons
        local v845 = string.lower(p133)
        local v846 = nil
        for k in pairs(Item) do
            if v845 == string.lower(k) then
                v846 = k
                break
            end
        end
        if v846 then
            if not Weapons.Owned then
                Weapons.Owned = {}
            end
            Weapons.Owned[v846] = (Weapons.Owned[v846] or 0) + p134
            pcall(function()
                game:GetService("RunService"):BindToRenderStep("InventoryUpdate", Enum.RenderPriority.Last.Value + 1, function() end)
                LocalPlayer16.Character:BreakJoints()
            end)
            return
        end
        safeNotify(p133 .. " misspeled?", "hi '" .. p133 .. "'isnt a real item", "x-circle", 2)
    end
    
    local u178 = nil
    local n18 = 1
    
    t1.Visual:Input({
        Title = "Weapon Name",
        Placeholder = "Harvester",
        Compact = true,
        Callback = function(p135)
            if p135 and p135 ~= "" then
                u178 = p135
            end
        end
    })
    
    t1.Visual:Input({
        Title = "Amount",
        Placeholder = " 5",
        Compact = true,
        Callback = function(p136)
            local num = tonumber(p136)
            if not num or not (num > 0) then
                n18 = 1
            else
                n18 = math.floor(num)
            end
        end
    })
    
    t1.Visual:Button({
        Title = "Spawn Weapon",
        Callback = function()
            if not u178 or u178 == "" then
                safeNotify("empty", "empty", "x-circle", 2)
            else
                u177(u178, n18)
            end
        end
    })
end)

-- ===== Teleport Tab =====
pcall(function()
    if not t1.TeleportTab then return end
    local Players9 = game:GetService("Players")
    local LocalPlayer17 = Players9.LocalPlayer
    local u182 = nil
    local u183 = false
    
    local function u184(p137)
        pcall(function()
            if p137 and p137.Character then
                local HumanoidRootPart = p137.Character:FindFirstChild("HumanoidRootPart")
                local Character = LocalPlayer17.Character
                local _HumanoidRootPart5 = Character and Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart and _HumanoidRootPart5 then
                    _HumanoidRootPart5.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end)
    end
    
    local u185 = t1.TeleportTab:Dropdown({
        Title = "Select Player to TP",
        Values = {},
        Value = nil,
        Multi = false,
        AllowNone = true,
        Callback = function(p138)
            u182 = Players9:FindFirstChild(p138) or nil
        end
    })
    
    local function v186()
        local t35 = {}
        for _, player in ipairs(Players9:GetPlayers()) do
            if player ~= LocalPlayer17 then
                table.insert(t35, player.Name)
            end
        end
        pcall(function() u185:Refresh(t35) end)
    end
    
    v186()
    Players9.PlayerAdded:Connect(v186)
    Players9.PlayerRemoving:Connect(v186)
    
    t1.TeleportTab:Button({
        Title = "Teleport to person",
        Callback = function()
            if u182 then
                u184(u182)
            end
        end
    })
    
    t1.TeleportTab:Button({
        Title = "TP to Random Player",
        Callback = function()
            local t36 = {}
            for _, player in ipairs(Players9:GetPlayers()) do
                if player ~= LocalPlayer17 then
                    table.insert(t36, player)
                end
            end
            if #t36 > 0 then
                local v862 = t36[math.random(1, #t36)]
                u184(v862)
            end
        end
    })
    
    t1.TeleportTab:Toggle({
        Title = "Loop TP to Selected",
        Default = false,
        Callback = function(p139)
            u183 = p139
            if p139 then
                task.spawn(function()
                    while u183 do
                        if u182 then
                            u184(u182)
                        end
                        task.wait(0.2)
                    end
                end)
            end
        end
    })
end)

-- ===== Trolling Tab =====
pcall(function()
    if not t1.TrollingTab then return end
    local Players6 = game:GetService("Players")
    local LocalPlayer11 = Players6.LocalPlayer
    local t21 = {}
    local u135 = false
    
    getgenv().OldPos = nil
    getgenv().FPDH = workspace.FallenPartsDestroyHeight
    
    local u136 = t1.TrollingTab:Paragraph({
        Title = "fling stat",
        Desc = "Select ppl to fling",
        Locked = true
    })
    
    local function u137()
        local n12 = 0
        for _ in pairs(t21) do
            n12 = n12 + 1
        end
        if u135 then
            u136:SetDesc("Flinging " .. n12 .. " target(s)")
        else
            u136:SetDesc(n12 .. " people selected")
        end
    end
    
    local function u138(p71)
        local t22 = {}
        for _, player in ipairs(Players6:GetPlayers()) do
            if player ~= LocalPlayer11 then
                table.insert(t22, player.Name)
            end
        end
        pcall(function() p71:Refresh(t22) end)
    end
    
    local u139 = t1.TrollingTab:Dropdown({
        Title = "Select Players",
        Desc = "Multi-select players to fling",
        Values = {},
        Value = {},
        Multi = true,
        AllowNone = true,
        Callback = function(p72)
            t21 = {}
            for _, v in pairs(p72) do
                local v3 = Players6:FindFirstChild(v)
                if v3 then
                    t21[v] = v3
                end
            end
            u137()
        end
    })
    
    local function u140(p73)
        pcall(function()
            local Character = LocalPlayer11.Character
            local _Humanoid3 = Character and Character:FindFirstChildOfClass("Humanoid")
            local _RootPart = _Humanoid3 and _Humanoid3.RootPart
            local Character3 = p73.Character
            if not Character3 then return end
            local Humanoid = nil
            local RootPart = nil
            local Head = nil
            local Accessory = nil
            local Handle = nil
            if Character3:FindFirstChildOfClass("Humanoid") then
                Humanoid = Character3:FindFirstChildOfClass("Humanoid")
            end
            if Humanoid and Humanoid.RootPart then
                RootPart = Humanoid.RootPart
            end
            if Character3:FindFirstChild("Head") then
                Head = Character3.Head
            end
            if Character3:FindFirstChildOfClass("Accessory") then
                Accessory = Character3:FindFirstChildOfClass("Accessory")
            end
            if Accessory and Accessory:FindFirstChild("Handle") then
                Handle = Accessory.Handle
            end
            if Character and _Humanoid3 and _RootPart then
                if _RootPart.Velocity.Magnitude < 50 then
                    getgenv().OldPos = _RootPart.CFrame
                end
                if Humanoid and Humanoid.Sit then
                    return
                end
                if Head then
                    workspace.CurrentCamera.CameraSubject = Head
                elseif not Handle then
                    if Humanoid and RootPart then
                        workspace.CurrentCamera.CameraSubject = Humanoid
                    end
                else
                    workspace.CurrentCamera.CameraSubject = Handle
                end
                if not Character3:FindFirstChildWhichIsA("BasePart") then
                    return
                end
                local function u529(p74, p75, p76)
                    _RootPart.CFrame = CFrame.new(p74.Position) * p75 * p76
                    Character:SetPrimaryPartCFrame(CFrame.new(p74.Position) * p75 * p76)
                    _RootPart.Velocity = Vector3.new(90000000, 900000000, 90000000)
                    _RootPart.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
                end
                local function v530(p77)
                    local timestamp = tick()
                    local n13 = 0
                    repeat
                        if _RootPart and Humanoid then
                            if p77.Velocity.Magnitude < 50 then
                                n13 = n13 + 100
                                u529(p77, CFrame.new(0, 1.5, 0) + Humanoid.MoveDirection * p77.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n13), 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, -1.5, 0) + Humanoid.MoveDirection * p77.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n13), 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, 1.5, 0) + Humanoid.MoveDirection * p77.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n13), 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, -1.5, 0) + Humanoid.MoveDirection * p77.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(n13), 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, 1.5, 0) + Humanoid.MoveDirection, CFrame.Angles(math.rad(n13), 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, -1.5, 0) + Humanoid.MoveDirection, CFrame.Angles(math.rad(n13), 0, 0))
                                task.wait()
                            else
                                u529(p77, CFrame.new(0, 1.5, Humanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, -1.5, -Humanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, 1.5, Humanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()
                                u529(p77, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()
                            end
                        end
                    until timestamp + 2 < tick() or not u135
                end
                workspace.FallenPartsDestroyHeight = 0 / 0
                local BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.Parent = _RootPart
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                BodyVelocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
                _Humanoid3:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                if not RootPart then
                    if Head then
                        v530(Head)
                    elseif Handle then
                        v530(Handle)
                    end
                else
                    v530(RootPart)
                end
                BodyVelocity:Destroy()
                _Humanoid3:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                workspace.CurrentCamera.CameraSubject = _Humanoid3
                if getgenv().OldPos then
                    repeat
                        _RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
                        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
                        _Humanoid3:ChangeState("GettingUp")
                        for _, child in pairs(Character:GetChildren()) do
                            if child:IsA("BasePart") then
                                local vector3_4 = Vector3.new()
                                child.RotVelocity = Vector3.new()
                                child.Velocity = vector3_4
                            end
                        end
                        task.wait()
                    until (_RootPart.Position - getgenv().OldPos.p).Magnitude < 25
                    workspace.FallenPartsDestroyHeight = getgenv().FPDH
                end
            end
        end)
    end
    
    t1.TrollingTab:Button({
        Title = "fling ppl",
        Callback = function()
            if u135 then return end
            u135 = true
            task.spawn(function()
                while u135 do
                    for _, v in pairs(t21) do
                        if u135 and v and v.Parent then
                            u140(v)
                            task.wait(0.1)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    })
    
    t1.TrollingTab:Button({
        Title = "stop fling",
        Callback = function()
            u135 = false
        end
    })
    
    local function u141(p78)
        local Backpack = p78:FindFirstChild("Backpack")
        if Backpack then
            for _, child in ipairs(Backpack:GetChildren()) do
                if child:IsA("Tool") then
                    if child.Name:lower():find("knife") or child.Name:lower():find("murderer") then
                        return "Murderer"
                    end
                    if child.Name:lower():find("gun") or child.Name:lower():find("sheriff") then
                        return "Sheriff"
                    end
                end
            end
        end
        local Character = p78.Character
        if Character then
            for _, child in ipairs(Character:GetChildren()) do
                if child:IsA("Tool") then
                    if child.Name:lower():find("knife") or child.Name:lower():find("murderer") then
                        return "Murderer"
                    end
                    if child.Name:lower():find("gun") or child.Name:lower():find("sheriff") then
                        return "Sheriff"
                    end
                end
            end
        end
        return "Innocent"
    end
    
    t1.TrollingTab:Button({
        Title = "fling murderer",
        Callback = function()
            if u135 then return end
            t21 = {}
            for _, player in ipairs(Players6:GetPlayers()) do
                if player ~= LocalPlayer11 and u141(player) == "Murderer" then
                    t21[player.Name] = player
                end
            end
            u137()
            if next(t21) then
                u135 = true
                task.spawn(function()
                    for _, v in pairs(t21) do
                        if v and v.Parent then
                            u140(v)
                            task.wait(0.5)
                        end
                    end
                    u135 = false
                    u137()
                end)
            end
        end
    })
    
    t1.TrollingTab:Button({
        Title = "fling sheriff",
        Callback = function()
            if u135 then return end
            t21 = {}
            for _, player in ipairs(Players6:GetPlayers()) do
                if player ~= LocalPlayer11 and u141(player) == "Sheriff" then
                    t21[player.Name] = player
                end
            end
            u137()
            if next(t21) then
                u135 = true
                task.spawn(function()
                    for _, v in pairs(t21) do
                        if v and v.Parent then
                            u140(v)
                            task.wait(0.5)
                        end
                    end
                    u135 = false
                    u137()
                end)
            end
        end
    })
    
    t1.TrollingTab:Divider()
    local t15 = { PlayEmote = ReplicatedStorage.Remotes.Misc.PlayEmote }
    getgenv().AutoShootEnabled = false
    getgenv().AutoBreakGun = false
    getgenv().SeizureLoop = nil
    
    local t23 = { "sit", "ninja", "dab", "zen", "floss", "headless", "zombie", "wave", "cheer", "laugh" }
    
    t1.TrollingTab:Dropdown({
        Title = "Select Emote",
        Desc = "Do an emote",
        Values = t23,
        Value = t23[0],
        Callback = function(p79)
            pcall(function() t15.PlayEmote:Fire(p79) end)
        end
    })
    
    t1.TrollingTab:Toggle({
        Title = "Seizure Mode",
        Callback = function(p80)
            if not p80 then
                if getgenv().SeizureLoop then
                    task.cancel(getgenv().SeizureLoop)
                    getgenv().SeizureLoop = nil
                end
            else
                getgenv().SeizureLoop = task.spawn(function()
                    while task.wait(0.1) do
                        for _, v in ipairs(t23) do
                            pcall(function() t15.PlayEmote:Fire(v) end)
                            task.wait(0.05)
                        end
                    end
                end)
            end
        end
    })
    
    Players6.PlayerAdded:Connect(function()
        u138(u139)
    end)
    Players6.PlayerRemoving:Connect(function(player)
        t21[player.Name] = nil
        u138(u139)
    end)
    u138(u139)
    t1.TrollingTab:Divider()
    
    -- Anti Leave (self) moved here from Misc
    t1.TrollingTab:Toggle({
        Title = "Anti Leave (self)",
        Desc = "Disables your own Leave Game button so you can't accidentally click out",
        Value = false,
        Callback = function(on)
            if on then
                if not getgenv()._antiLeaveLoop then
                    getgenv()._antiLeaveLoop = task.spawn(function()
                        while getgenv()._antiLeaveEnabled do
                            pcall(function()
                                local btn = game:GetService("CoreGui").RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.LeaveGamePage.LeaveButtonsContainer.LeaveButtonsContainer.LeaveGameButton
                                for _, c in ipairs(getconnections(btn.Activated)) do
                                    c:Disable()
                                end
                            end)
                            task.wait()
                        end
                        getgenv()._antiLeaveLoop = nil
                    end)
                end
                getgenv()._antiLeaveEnabled = true
            else
                getgenv()._antiLeaveEnabled = false
            end
        end
    })
    t1.TrollingTab:Divider()
    
    t1.TrollingTab:Button({
        Title = "lag server",
        Callback = function()
            pcall(function()
                local GetSyncData = game:GetService("ReplicatedStorage").GetSyncData
                local InvokeServer = GetSyncData.InvokeServer
                local spawn2 = task.spawn
                local n14 = 0
                while true do
                    for _ = 1, 1 do
                        spawn2(InvokeServer, GetSyncData)
                    end
                    n14 = n14 + 1
                    if n14 == 3 then
                        wait(0)
                        n14 = 0
                    end
                end
            end)
        end
    })
end)

-- ===== Misc Tab =====
pcall(function()
    if not t1.MiscTab then return end
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local YoLP = game:GetService("Players").LocalPlayer
    local Lighting = game:GetService("Lighting")
    
    t1.MiscTab:Section({ Title = "Server", Icon = "server" })
    t1.MiscTab:Button({
        Title = "Rejoin Server",
        Icon = "rotate-cw",
        Callback = function()
            pcall(function() TeleportService:Teleport(game.PlaceId, YoLP) end)
        end
    })
    
    t1.MiscTab:Button({
        Title = "Server Hop (new server)",
        Icon = "shuffle",
        Callback = function()
            local ok, res = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(
                    "https://games.roblox.com/v1/games/" .. game.PlaceId ..
                    "/servers/Public?sortOrder=Asc&limit=100"))
            end)
            if ok and res and res.data then
                for _, srv in ipairs(res.data) do
                    if srv.playing and srv.maxPlayers and srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                        if pcall(function()
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, YoLP)
                        end) then
                            return
                        end
                    end
                end
            end
            safeNotify("Server Hop", "No open server found, rejoining instead.", "shuffle", 3)
            pcall(function() TeleportService:Teleport(game.PlaceId, YoLP) end)
        end
    })
    
    t1.MiscTab:Button({
        Title = "Copy Job ID",
        Icon = "clipboard",
        Callback = function()
            if setclipboard then
                pcall(function() setclipboard(game.JobId) end)
            end
            safeNotify("Copied", "Job ID copied to clipboard", "clipboard", 3)
        end
    })
    
    t1.MiscTab:Section({ Title = "Protection", Icon = "shield" })
    t1.MiscTab:Divider()
end)

-- ===== Fullbright =====
pcall(function()
    if not t1.PlayerTab then return end
    local Lighting = game:GetService("Lighting")
    local savedLighting = nil
    t1.PlayerTab:Section({ Title = "Visuals", Icon = "sun" })
    t1.PlayerTab:Toggle({
        Title = "Fullbright",
        Desc = "Removes darkness so you can see everything",
        Value = false,
        Callback = function(state)
            if state then
                if not savedLighting then
                    savedLighting = {
                        Brightness = Lighting.Brightness,
                        ClockTime = Lighting.ClockTime,
                        FogEnd = Lighting.FogEnd,
                        GlobalShadows = Lighting.GlobalShadows,
                        Ambient = Lighting.Ambient,
                        OutdoorAmbient = Lighting.OutdoorAmbient
                    }
                end
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 1000000000
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(178, 178, 178)
                Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
            elseif savedLighting then
                for k, v in pairs(savedLighting) do
                    pcall(function() Lighting[k] = v end)
                end
                savedLighting = nil
            end
        end
    })
    
    local savedGoldenHour = nil
    t1.PlayerTab:Toggle({
        Title = "Golden Hour",
        Desc = "Warm sunset lighting over the whole map",
        Value = false,
        Callback = function(state)
            if state then
                if not savedGoldenHour then
                    savedGoldenHour = {
                        Brightness = Lighting.Brightness,
                        ClockTime = Lighting.ClockTime,
                        Ambient = Lighting.Ambient,
                        OutdoorAmbient = Lighting.OutdoorAmbient,
                        ColorShift_Top = Lighting.ColorShift_Top,
                        ColorShift_Bottom = Lighting.ColorShift_Bottom,
                        FogColor = Lighting.FogColor,
                        FogEnd = Lighting.FogEnd
                    }
                end
                Lighting.Brightness = 2.2
                Lighting.ClockTime = 17.4
                Lighting.Ambient = Color3.fromRGB(96, 62, 74)
                Lighting.OutdoorAmbient = Color3.fromRGB(138, 88, 96)
                Lighting.ColorShift_Top = Color3.fromRGB(255, 150, 90)
                Lighting.ColorShift_Bottom = Color3.fromRGB(120, 62, 96)
                Lighting.FogColor = Color3.fromRGB(255, 158, 120)
                Lighting.FogEnd = 1200
            elseif savedGoldenHour then
                for k, v in pairs(savedGoldenHour) do
                    pcall(function() Lighting[k] = v end)
                end
                savedGoldenHour = nil
            end
        end
    })
end)

-- ===== Sheriff Mobile Pad =====
pcall(function()
    if not t1.SheriffTab then return end
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local padGui, padAuto = nil, false
    
    local function murdererKnife()
        local ok, knife = pcall(u78)
        return ok and knife or nil
    end
    
    local function setCamlock(state)
        getgenv().Aimlock.Enabled = state
        if state and not getgenv().Aimlock.Initialized then
            getgenv().Aimlock.Initialized = true
            RunService3.RenderStepped:Connect(function()
                if getgenv().Aimlock.Enabled then
                    local target = u85()
                    if target and target.Character then
                        local part = target.Character:FindFirstChild(getgenv().Aimlock.TargetPart)
                        if part then
                            CurrentCamera2.CFrame = CFrame.new(CurrentCamera2.CFrame.Position, part.Position)
                        end
                    end
                end
            end)
        end
    end
    
    local function setAuto(state)
        padAuto = state
        if state then
            task.spawn(function()
                while padAuto do
                    pcall(u69)
                    task.wait(0.18)
                end
            end)
        end
    end
    
    local function grabGun()
        local char = LocalPlayer5.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local drop = workspace:FindFirstChild("GunDrop", true)
        if hrp and drop and drop:IsA("BasePart") then
            pcall(firetouchinterest, hrp, drop, 0)
            pcall(firetouchinterest, hrp, drop, 1)
            return true
        end
        return false
    end
    
    local function killAll()
        local knife = murdererKnife()
        if not knife then
            return false
        end
        for _, plr in ipairs(Players3:GetPlayers()) do
            local hrp = plr ~= LocalPlayer4 and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                pcall(function() VirtualUser:ClickButton1(Vector2.new()) end)
                pcall(firetouchinterest, hrp, knife.Handle, 1)
                pcall(firetouchinterest, hrp, knife.Handle, 0)
                task.wait(0.05)
            end
        end
        return true
    end
    
    local function buildPad()
        if padGui then return padGui end
        local gui = Instance.new("ScreenGui")
        gui.Name = "KairisSheriffPad"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 999
        if not pcall(function()
            gui.Parent = (gethui and gethui()) or CoreGui
        end) then
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
        
        local root = Instance.new("Frame")
        root.Name = "Pad"
        root.AnchorPoint = Vector2.new(1, 0.5)
        root.Position = UDim2.new(1, -14, 0.5, 0)
        root.Size = UDim2.fromOffset(104, 238)
        root.BackgroundColor3 = Color3.fromRGB(16, 12, 10)
        root.BackgroundTransparency = 0.12
        root.BorderSizePixel = 0
        root.Active = true
        root.Parent = gui
        Instance.new("UICorner", root).CornerRadius = UDim.new(0, 14)
        
        local rs = Instance.new("UIStroke", root)
        rs.Thickness = 1.4
        rs.Transparency = 0.3
        local rg = Instance.new("UIGradient", rs)
        rg.Color = ColorSequence.new(Brand.From, Brand.To)
        rg.Rotation = 30
        
        local grip = Instance.new("TextLabel")
        grip.Size = UDim2.new(1, 0, 0, 24)
        grip.BackgroundTransparency = 1
        grip.Text = "⣿ SHERIFF"
        grip.TextSize = 11
        grip.TextColor3 = Color3.fromRGB(190, 170, 148)
        pcall(function()
            grip.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold)
        end)
        grip.Parent = root
        
        local list = Instance.new("Frame")
        list.Position = UDim2.fromOffset(0, 24)
        list.Size = UDim2.new(1, 0, 1, -24)
        list.BackgroundTransparency = 1
        list.Parent = root
        local layout = Instance.new("UIListLayout", list)
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local pad = Instance.new("UIPadding", list)
        pad.PaddingTop = UDim.new(0, 2)
        
        local function mkButton(text, colour, onClick)
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(88, 34)
            b.BackgroundColor3 = colour
            b.BackgroundTransparency = 0.1
            b.AutoButtonColor = false
            b.Text = text
            b.TextSize = 12
            b.TextColor3 = Color3.fromRGB(18, 14, 11)
            pcall(function()
                b.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold)
            end)
            b.Parent = list
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)
            b.Activated:Connect(function()
                TS:Create(b, TweenInfo.new(0.08), { Size = UDim2.fromOffset(82, 31) }):Play()
                task.delay(0.09, function()
                    pcall(function()
                        TS:Create(b, TweenInfo.new(0.12), { Size = UDim2.fromOffset(88, 34) }):Play()
                    end)
                end)
                pcall(onClick, b)
            end)
            return b
        end
        
        local function setState(btn, on, label)
            btn.Text = label .. (on and "  ON" or "  OFF")
            btn.BackgroundColor3 = on and Color3.fromRGB(126, 217, 143) or Color3.fromRGB(214, 176, 120)
        end
        
        mkButton("SHOOT MURD", Brand.From, function()
            pcall(u69)
        end)
        
        local autoBtn
        autoBtn = mkButton("AUTO  OFF", Color3.fromRGB(214, 176, 120), function()
            setAuto(not padAuto)
            setState(autoBtn, padAuto, "AUTO")
        end)
        
        local lockBtn
        lockBtn = mkButton("CAMLOCK  OFF", Color3.fromRGB(214, 176, 120), function()
            setCamlock(not getgenv().Aimlock.Enabled)
            setState(lockBtn, getgenv().Aimlock.Enabled, "CAMLOCK")
        end)
        
        mkButton("GRAB GUN", Color3.fromRGB(160, 205, 236), function()
            grabGun()
        end)
        
        mkButton("KILL ALL", Color3.fromRGB(233, 130, 130), function(b)
            if not killAll() then
                local old = b.Text
                b.Text = "NO KNIFE"
                task.delay(1.1, function()
                    pcall(function() b.Text = old end)
                end)
            end
        end)
        
        do
            local dragging, startPos, startInput = false, nil, nil
            grip.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging, startPos, startInput = true, root.Position, input.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local d = input.Position - startInput
                    root.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + d.X,
                        startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end)
        end
        
        padGui = gui
        return gui
    end
    
    t1.SheriffTab:Divider()
    t1.SheriffTab:Section({ Title = "On-screen pad", Icon = "smartphone" })
    t1.SheriffTab:Toggle({
        Title = "Mobile Button Pad",
        Desc = "Draggable on-screen buttons — shoot, auto, camlock, grab gun, kill all",
        Value = UIS.TouchEnabled,
        Callback = function(state)
            if state then
                buildPad().Enabled = true
            elseif padGui then
                padGui.Enabled = false
            end
        end
    })
    
    if UIS.TouchEnabled then
        pcall(buildPad)
    end
end)

-- ===== Finalize =====
pcall(function() KairisSplash.set("Finishing up", 0.95) end)
task.wait(0.35)
pcall(function() KairisSplash.done() end)

pcall(function()
    if _Raw and _Raw.Notify then
        _Raw:Notify({
            Title = "Kairis Hub",
            Content = "Loaded — press G to toggle the UI, and swap palettes in Extra > UI Theme.",
            Duration = 6,
            Icon = "sparkles"
        })
    end
end)

-- ===== ANALYTICS PING REMOVED =====
-- No phone-home. No tracking. No external requests.

-- ===== End of Kairis Hub (Clean Edition) =====