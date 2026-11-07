-- ========== XyqwHub | DEFAULT MODE (v7.7.5) ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local HUB_NAME = "XyqwHub"
local VERSION = "7.7.5 Default"
local OWNER_IDS = {4396977722, 8527910367}
local BETA_IDS = {9686718765, 3701387385}

local function GetSetting(key, default) 
    local ok, val = pcall(function() return shared["Xyqw_" .. key] end)
    if ok and val ~= nil then return val end
    return default 
end
local function SetSetting(key, value) pcall(function() shared["Xyqw_" .. key] = value end) end

local LANG_CODE = GetSetting("lang", "EN")
local THEME_NAME = GetSetting("theme", "Red")
local TOPBAR_HIDDEN = GetSetting("topbar", false)
local FAVORITES = GetSetting("fav", {})
local RECENT = GetSetting("recent", {})
local AUTOEXEC = GetSetting("autoexec", {})
local ORDER = GetSetting("order", {})
local ANTI_KICK_LOGS = {}

local CONFIG_FOLDER = "XyqwHub"
local FAV_FILE = CONFIG_FOLDER .. "/FavScripts/favorites.json"
local RCT_FILE = CONFIG_FOLDER .. "/RctScripts/recent.json"
local AUTOEXEC_FILE = CONFIG_FOLDER .. "/AutoExecute/autoexec.json"
local ORDER_FILE = CONFIG_FOLDER .. "/Settings/order.json"
local SESSION_FILE = CONFIG_FOLDER .. "/Session/last_jobid.txt"

local function SaveTable(path, tbl) pcall(function() if writefile then writefile(path, HttpService:JSONEncode(tbl)) end end) end
local function LoadTable(path)
    local ok, data = pcall(function()
        if readfile and isfile and isfile(path) then return HttpService:JSONDecode(readfile(path)) end
        return nil
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

pcall(function()
    if makefolder and not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/FavScripts") then makefolder(CONFIG_FOLDER .. "/FavScripts") end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/RctScripts") then makefolder(CONFIG_FOLDER .. "/RctScripts") end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/AutoExecute") then makefolder(CONFIG_FOLDER .. "/AutoExecute") end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/Settings") then makefolder(CONFIG_FOLDER .. "/Settings") end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/Session") then makefolder(CONFIG_FOLDER .. "/Session") end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/Logs") then makefolder(CONFIG_FOLDER .. "/Logs") end
end)

FAVORITES = LoadTable(FAV_FILE)
RECENT = LoadTable(RCT_FILE)
AUTOEXEC = LoadTable(AUTOEXEC_FILE)
ORDER = LoadTable(ORDER_FILE)

pcall(function() 
    if writefile then writefile(CONFIG_FOLDER .. "/Logs/session.txt", "active") end 
end)

local THEMES = {
    Red = {MAIN = Color3.fromRGB(255, 0, 0), DARK = Color3.fromRGB(40, 0, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 0, 0)},
    Blue = {MAIN = Color3.fromRGB(0, 140, 255), DARK = Color3.fromRGB(0, 20, 50), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 10, 25)},
    Green = {MAIN = Color3.fromRGB(0, 220, 90), DARK = Color3.fromRGB(0, 40, 15), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 20, 8)},
    Purple = {MAIN = Color3.fromRGB(180, 0, 255), DARK = Color3.fromRGB(30, 0, 45), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(15, 0, 22)},
    Pink = {MAIN = Color3.fromRGB(255, 20, 147), DARK = Color3.fromRGB(45, 0, 25), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 0, 12)},
    Orange = {MAIN = Color3.fromRGB(255, 140, 0), DARK = Color3.fromRGB(45, 25, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 12, 0)},
    Cyan = {MAIN = Color3.fromRGB(0, 255, 255), DARK = Color3.fromRGB(0, 40, 40), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 20, 20)},
    Yellow = {MAIN = Color3.fromRGB(255, 230, 0), DARK = Color3.fromRGB(45, 40, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 20, 0)},
    Lime = {MAIN = Color3.fromRGB(50, 255, 50), DARK = Color3.fromRGB(0, 45, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 22, 0)},
    Magenta = {MAIN = Color3.fromRGB(255, 0, 255), DARK = Color3.fromRGB(45, 0, 45), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 0, 22)},
    White = {MAIN = Color3.fromRGB(255, 255, 255), DARK = Color3.fromRGB(40, 40, 40), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 20, 20)},
    Rainbow = {MAIN = Color3.fromRGB(255, 0, 0), DARK = Color3.fromRGB(40, 0, 40), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 0, 20)},
    Custom = {MAIN = Color3.fromRGB(255, 0, 0), DARK = Color3.fromRGB(40, 0, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 0, 0)},
}

local currentTheme = THEMES[THEME_NAME] or THEMES.Red
local RED_MAIN, RED_DARK, RED_BG, RED_TITLE = currentTheme.MAIN, currentTheme.DARK, currentTheme.BG, currentTheme.TITLE

local function _(key) return key end
local function ShowRobloxNotification(text, duration)
    duration = duration or 4
    pcall(function() StarterGui:SetCore("SendNotification", {Title = HUB_NAME, Text = tostring(text), Duration = duration}) end)
end

-- ========== БЕЗОПАСНЫЙ ANTIKICK ==========
local antiKickActive = false
local antiKickOldKick = nil

local function StartAntiKick()
    if antiKickActive then return end
    getgenv().XyqwAntiKick = true
    local ok = pcall(function()
        if type(hookfunction) ~= "function" then error("No hookfunction") end
        local LP = Players.LocalPlayer
        antiKickOldKick = hookfunction(LP.Kick, function(self, ...)
            if getgenv().XyqwAntiKick then return nil end
            if type(antiKickOldKick) == "function" then return antiKickOldKick(self, ...) end
            return nil
        end)
        antiKickActive = true
    end)
    if not ok then getgenv().XyqwAntiKick = false; antiKickActive = false end
end
task.spawn(function() task.wait(2); StartAntiKick() end)

local function GetRole(plr)
    for _, id in ipairs(OWNER_IDS) do if plr.UserId == id then return "OWNER" end end
    for _, id in ipairs(BETA_IDS) do if plr.UserId == id then return "TESTER" end end
    return nil
end

-- ========== СПИСОК СКРИПТОВ ==========
local SCRIPTS = {
    {Name = "Blade Ball", Category = "BB", URL = "https://raw.githubusercontent.com/joshhhie/rise/refs/heads/main/loader.lua"},
    {Name = "Blade Ball 2", Category = "BB", URL = "https://wings.ac/loader"},
    {Name = "Blade Ball 3", Category = "BB", URL = "https://raw.githubusercontent.com/2xrW/return/refs/heads/main/hub"},
    {Name = "AntiKillParts", Category = "Misc", URL = "https://raw.githubusercontent.com/sovetskii-shashlik/Anti-kill-parts-updated-/refs/heads/main/Anti%20kill%20parts%20by%20Zephyr"},
    {Name = "PulseHub", Category = "Misc", URL = "https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"},
    {Name = "RUNAWAYS", Category = "Misc", URL = "https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/RUNAWAYS.lua"},
    {Name = "Universal FE", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-Universal-FE-Free-keyless-FE-script-242513"},
    {Name = "UwU hub", Category = "INK", URL = "https://raw.githubusercontent.com/platinww/UwU/refs/heads/main/INK-GAME"},
    {Name = "Ringta (INK)", Category = "INK", URL = "https://rawscripts.net/raw/Universal-Script-RINGTA-best-script-for-ink-game-206674"},
    {Name = "AX Scripts (INK)", Category = "INK", URL = "https://officialaxscripts.vercel.app/scripts/AX-Loader.lua"},
    {Name = "FakeVR", Category = "Misc", URL = "https://pastefy.app/MvKHpycG/raw"},
    {Name = "WallHop", Category = "Misc", URL = "https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20script"},
    {Name = "RuzHub (MM2)", Category = "MM2", URL = "https://raw.githubusercontent.com/pruzgar242-rgb/Update/refs/heads/main/out.lua%20(17).txt"},
    {Name = "Kiti (MM2)", Category = "MM2", URL = "https://pastefy.app/gPuS4n3Q/raw"},
    {Name = "CandyWare (MM2)", Category = "MM2", URL = "https://raw.githubusercontent.com/Be1for/Scripts/refs/heads/main/candyware.luau"},
    {Name = "RemainsHub V2", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-RemainsHub-V2-50805"},
    {Name = "R6 Emotes", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-r6-emotes-OPEN-SOURCE-69464"},
    {Name = "Free Cam", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-Free-cam-script-pc-and-mobile-223089"},
    {Name = "Doors (Abysall)", Category = "Misc", URL = "https://rawscripts.net/raw/DOORS-Abysall-hub-OP-205906"},
    {Name = "Doors V2 (Copy)", Category = "Misc", URL = "SPECIAL_COPY_DOORS_V2"},
    {Name = "Doors V3 (Cheesy)", Category = "Misc", URL = "https://raw.githubusercontent.com/doram44/cheesy/refs/heads/main/cheesy.lua"},
    {Name = "Doors v4", Category = "Misc", URL = "https://raw.githubusercontent.com/sillyleo67/Doors/refs/heads/main/Twinkhook.lua"},
    {Name = "Fling Gui", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-fling-gui-99753"},
    {Name = "Infinite Yield", Category = "Misc", URL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {Name = "Walk on walls", Category = "Misc", URL = "https://rawscripts.net/raw/The-patience-obby-Universal-Walk-on-walls-18129"},
    {Name = "AetherX", Category = "Misc", URL = "https://api.luarmor.net/files/v3/loaders/8c08b8f2252eec7dbb77d253d269bb65.lua"},
    {Name = "Voidware", Category = "Misc", URL = "https://files.vapevoidware.xyz/VapeVoidware/VW-Add/main/loader.lua"},
    {Name = "LaLol Hub", Category = "Misc", URL = "https://raw.githubusercontent.com/Miygteet/Hacker101/refs/heads/main/LALOL-Backdoor-Secure.lua"},
    {Name = "FTAP", Category = "Misc", URL = "https://api.jnkie.com/api/v1/luascripts/public/4078649e4397f0e2cdaddde241d69bfd67b2b7107917891384735129c85cae18/download"},
    {Name = "MinhNat Hub", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-MinhNhat-Tsb-62161"},
    {Name = "BC9", Category = "Misc", URL = "https://rawscripts.net/raw/untitled-tag-game-BC9-UTG-MENU-116806"},
    {Name = "RadiumHub", Category = "Misc", URL = "https://rawscripts.net/raw/UPDATE-Pressure-God-Mode-Auto-Loot-ESP-Full-Bright-No-Eyefestation-224409"},
    {Name = "Steal an egg", Category = "Misc", URL = "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"},
    {Name = "Universal script", Category = "Misc", URL = "https://raw.githubusercontent.com/fleecelolll/Fleece-s-Utility-Panel/refs/heads/main/Script.lua"},
    {Name = "Corridor", Category = "Misc", URL = "https://saga2015.b-cdn.net/corridor.luau"},
    {Name = "BloxStrike", Category = "Misc", URL = "https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/BloxStrike.lua"},
    {Name = "RIVALS", Category = "Misc", URL = "https://raw.githubusercontent.com/imshrak/rivals/refs/heads/main/main"},
    {Name = "Troll script", Category = "Misc", URL = "https://mois7.xyz/loader"},
    {Name = "Death Order", Category = "Misc", URL = "https://rawscripts.net/raw/Death-Order:-Simon-Says-BEST-DEATH-ORDER-SCRIPT-226542"},
    {Name = "DropKick", Category = "Misc", URL = "https://raw.githubusercontent.com/yes-d3v-scripts/drop-kick-fling/refs/heads/main/script"},
    {Name = "Evade", Category = "Misc", URL = "https://github.com/imc72s/LaztDex/raw/refs/heads/main/EvadeScriptLaztDex"},
    {Name = "A dusty trip", Category = "Misc", URL = "https://raw.githubusercontent.com/BalintTheDevXBack/Games/refs/heads/main/aDustyTrip"},
    {Name = "A dusty trip v2", Category = "Misc", URL = "https://raw.githubusercontent.com/VoxlarWIP/Src/refs/heads/main/adustytrip.lua"},
    {Name = "minesweaper", Category = "Misc", URL = "https://pastefy.app/T5XIfiMo/raw"},
    {Name = "Cheating test", Category = "Misc", URL = "https://files.catbox.moe/pkulzc.txt"},
    {Name = "Adopt me", Category = "Misc", URL = "https://raw.githubusercontent.com/JaxRol/ZeroPoint/refs/heads/main/KeySystem"},
    {Name = "Piggy Grab", Category = "Misc", URL = "https://rawscripts.net/raw/Piggy-Item-grabber-246165"},
    {Name = "Piggy Bots", Category = "Misc", URL = "https://robloxscripts.com/raw/control-piggy-bots"},
}

-- ========== ИНТЕРФЕЙС ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XyqwHub_" .. math.random(100000, 999999)
screenGui.ResetOnSpawn = false; screenGui.IgnoreGuiInset = true
pcall(function() if gethui then screenGui.Parent = gethui() end end)
if not screenGui.Parent then pcall(function() screenGui.Parent = CoreGui end) end
if not screenGui.Parent then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local dockButton = Instance.new("TextButton")
dockButton.Size = UDim2.new(0, 80, 0, 30); dockButton.Position = UDim2.new(0.5, -40, 0.05, 42)
dockButton.BackgroundColor3 = RED_BG; dockButton.TextColor3 = RED_MAIN; dockButton.Text = "Xyqw"
dockButton.Font = Enum.Font.GothamBold; dockButton.BorderSizePixel = 2; dockButton.BorderColor3 = RED_MAIN
dockButton.Visible = false; dockButton.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 340); mainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
mainFrame.BackgroundColor3 = RED_BG; mainFrame.BorderSizePixel = 2; mainFrame.BorderColor3 = RED_MAIN; mainFrame.Parent = screenGui

local function OpenGui() mainFrame.Visible = true; dockButton.Visible = false end
local function CloseGui() mainFrame.Visible = false; dockButton.Visible = true end
dockButton.MouseButton1Click:Connect(OpenGui)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30); titleBar.BackgroundColor3 = RED_TITLE; titleBar.Parent = mainFrame
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 70, 1, 0); titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1; titleLabel.Text = "XyqwHub"; titleLabel.TextColor3 = RED_MAIN; titleLabel.TextScaled = true; titleLabel.Font = Enum.Font.GothamBold; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 1, 0); closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = RED_DARK; closeButton.TextColor3 = RED_MAIN; closeButton.Text = "X"; closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold; closeButton.BorderSizePixel = 1; closeButton.BorderColor3 = RED_MAIN; closeButton.Parent = titleBar
closeButton.MouseButton1Click:Connect(CloseGui)

local langButton = Instance.new("TextButton")
langButton.Size = UDim2.new(0, 28, 0.8, 0); langButton.Position = UDim2.new(1, -88, 0.1, 0)
langButton.BackgroundColor3 = RED_DARK; langButton.TextColor3 = RED_MAIN; langButton.Text = "EN"; langButton.TextScaled = true
langButton.Font = Enum.Font.GothamBold; langButton.BorderSizePixel = 1; langButton.BorderColor3 = RED_MAIN; langButton.Parent = titleBar

local serverBtn = Instance.new("TextButton")
serverBtn.Size = UDim2.new(0, 22, 0.8, 0); serverBtn.Position = UDim2.new(1, -62, 0.1, 0)
serverBtn.BackgroundColor3 = RED_DARK; serverBtn.TextColor3 = RED_MAIN; serverBtn.Text = "S"; serverBtn.TextScaled = true
serverBtn.Font = Enum.Font.GothamBold; serverBtn.BorderSizePixel = 1; serverBtn.BorderColor3 = RED_MAIN; serverBtn.Parent = titleBar

local playerBtn = Instance.new("TextButton")
playerBtn.Size = UDim2.new(0, 22, 0.8, 0); playerBtn.Position = UDim2.new(1, -86, 0.1, 0)
playerBtn.BackgroundColor3 = RED_DARK; playerBtn.TextColor3 = RED_MAIN; playerBtn.Text = "P"; playerBtn.TextScaled = true
playerBtn.Font = Enum.Font.GothamBold; playerBtn.BorderSizePixel = 1; playerBtn.BorderColor3 = RED_MAIN; playerBtn.Parent = titleBar

local customBtn = Instance.new("TextButton")
customBtn.Size = UDim2.new(0, 22, 0.8, 0); customBtn.Position = UDim2.new(1, -110, 0.1, 0)
customBtn.BackgroundColor3 = RED_DARK; customBtn.TextColor3 = RED_MAIN; customBtn.Text = "C"; customBtn.TextScaled = true
customBtn.Font = Enum.Font.GothamBold; customBtn.BorderSizePixel = 1; customBtn.BorderColor3 = RED_MAIN; customBtn.Parent = titleBar

local changelogButton = Instance.new("TextButton")
changelogButton.Size = UDim2.new(0, 26, 0.8, 0); changelogButton.Position = UDim2.new(1, -138, 0.1, 0)
changelogButton.BackgroundColor3 = RED_DARK; changelogButton.TextColor3 = RED_MAIN; changelogButton.Text = "CL"; changelogButton.TextScaled = true
changelogButton.Font = Enum.Font.GothamBold; changelogButton.BorderSizePixel = 1; changelogButton.BorderColor3 = RED_MAIN; changelogButton.Parent = titleBar

local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0, 22, 0.8, 0); themeBtn.Position = UDim2.new(1, -166, 0.1, 0)
themeBtn.BackgroundColor3 = RED_DARK; themeBtn.TextColor3 = RED_MAIN; themeBtn.Text = "Th"; themeBtn.TextScaled = true
themeBtn.Font = Enum.Font.GothamBold; themeBtn.BorderSizePixel = 1; themeBtn.BorderColor3 = RED_MAIN; themeBtn.Parent = titleBar

local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(0, 24, 0.8, 0); colorBtn.Position = UDim2.new(1, -192, 0.1, 0)
colorBtn.BackgroundColor3 = RED_DARK; colorBtn.TextColor3 = RED_MAIN; colorBtn.Text = "CC"; colorBtn.TextScaled = true
colorBtn.Font = Enum.Font.GothamBold; colorBtn.BorderSizePixel = 1; colorBtn.BorderColor3 = RED_MAIN; colorBtn.Parent = titleBar

local drag, ds, sp = false, nil, nil
titleBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; ds = i.Position; sp = mainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - ds; mainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)

local resize = Instance.new("TextButton")
resize.Size = UDim2.new(0, 14, 0, 14); resize.Position = UDim2.new(1, -14, 1, -14)
resize.BackgroundColor3 = RED_MAIN; resize.Text = ""; resize.BorderSizePixel = 0; resize.Parent = mainFrame
local rs, rss, rssz = false, nil, nil
resize.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then rs = true; rss = i.Position; rssz = mainFrame.Size end end)
UserInputService.InputChanged:Connect(function(i) if rs and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - rss; mainFrame.Size = UDim2.new(0, math.clamp(rssz.X.Offset + d.X, 280, 600), 0, math.clamp(rssz.Y.Offset + d.Y, 340, 600)) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then rs = false end end)

local searchBar = Instance.new("TextBox")
searchBar.Size = UDim2.new(1, -50, 0, 24); searchBar.Position = UDim2.new(0, 5, 0, 35)
searchBar.BackgroundColor3 = RED_DARK; searchBar.PlaceholderText = "Search..."; searchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBar.Text = ""; searchBar.TextColor3 = RED_MAIN; searchBar.TextSize = 12; searchBar.Font = Enum.Font.Gotham
searchBar.TextXAlignment = Enum.TextXAlignment.Left; searchBar.ClearTextOnFocus = false; searchBar.BorderSizePixel = 1; searchBar.BorderColor3 = RED_MAIN; searchBar.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -70); scrollFrame.Position = UDim2.new(0, 5, 0, 64)
scrollFrame.BackgroundTransparency = 1; scrollFrame.BorderSizePixel = 0; scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)
scrollFrame.ScrollBarThickness = 4; scrollFrame.ScrollBarImageColor3 = RED_MAIN; scrollFrame.Parent = mainFrame

local y = 5
for _, data in ipairs(SCRIPTS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32); btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = RED_BG; btn.TextColor3 = RED_MAIN; btn.Text = data.Name
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; btn.BorderSizePixel = 2; btn.BorderColor3 = RED_MAIN; btn.Parent = scrollFrame
    y = y + 36
    btn.MouseButton1Click:Connect(function()
        btn.Text = "Loading..."; btn.TextColor3 = Color3.fromRGB(255, 150, 0)
        task.spawn(function()
            local ok, err = pcall(function()
                if data.URL == "SPECIAL_COPY_DOORS_V2" then
                    setclipboard('getgenv().SCRIPT_KEY = "KEYLESS"\nloadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/abd3cc54d2dc7de4a091fb19c8f4ea9e15e939e7ecc88b475e6956e8af94ad6f/download"))()')
                else loadstring(game:HttpGet(data.URL))() end
            end)
            if ok then btn.Text = data.Name .. " (OK)"; btn.TextColor3 = Color3.fromRGB(0, 255, 100)
            else btn.Text = data.Name .. " (ERR)"; btn.TextColor3 = RED_MAIN end
        end)
    end)
end

searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local s = string.lower(searchBar.Text)
    local vis = 0
    for _, c in ipairs(scrollFrame:GetChildren()) do
        if c:IsA("TextButton") then
            if s == "" or string.find(string.lower(c.Text), s) then
                c.Visible = true; c.Position = UDim2.new(0, 5, 0, vis * 36 + 5); vis = vis + 1
            else c.Visible = false end
        end
    end
end)

-- ========== ОКНА (Кнопки S, P, C, CL, Th, CC) ==========
local function MakeWindow(titleText, size)
    local frame = Instance.new("Frame")
    frame.Size = size or UDim2.new(0, 350, 0, 350); frame.Position = UDim2.new(0.5, -175, 0.5, -175)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Parent = screenGui
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = titleText; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.Parent = frame
    local close = Instance.new("TextButton"); close.Size = UDim2.new(0, 30, 0, 28); close.Position = UDim2.new(1, -35, 0, 2); close.BackgroundTransparency = 1; close.Text = "X"; close.TextColor3 = RED_MAIN; close.Font = Enum.Font.GothamBold; close.Parent = frame; close.MouseButton1Click:Connect(function() frame:Destroy() end)
    return frame
end

local function MakeResizable(frame, minW, minH, maxW, maxH)
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 12, 0, 12); handle.Position = UDim2.new(1, -12, 1, -12)
    handle.BackgroundColor3 = RED_MAIN; handle.Text = ""; handle.BorderSizePixel = 0; handle.Parent = frame
    local resizing, rsStart, rsSize = false, nil, nil
    handle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; rsStart = input.Position; rsSize = frame.Size end end)
    UserInputService.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - rsStart; frame.Size = UDim2.new(0, math.clamp(rsSize.X.Offset + delta.X, minW, maxW), 0, math.clamp(rsSize.Y.Offset + delta.Y, minH, maxH)) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end end)
end

local function MakeDraggable(frame, dragPart)
    local dragging, dragStart, startPos = false, nil, nil
    dragPart.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = frame.Position end end)
    dragPart.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
end

changelogButton.MouseButton1Click:Connect(function()
    local f = MakeWindow("ChangeLog")
    local scroll = Instance.new("ScrollingFrame"); scroll.Size = UDim2.new(1, -10, 1, -45); scroll.Position = UDim2.new(0, 5, 0, 35); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 500); scroll.Parent = f
    local text = Instance.new("TextLabel"); text.Size = UDim2.new(1, -10, 1, 0); text.BackgroundTransparency = 1; text.TextColor3 = RED_MAIN; text.TextWrapped = true; text.TextXAlignment = Enum.TextXAlignment.Left; text.TextYAlignment = Enum.TextYAlignment.Top; text.TextSize = 12; text.Font = Enum.Font.Gotham; text.Text = "XyqwHub v7.7.5\n- Полный интерфейс\n- 48 скриптов\n- Темы"; text.Parent = scroll
end)

playerBtn.MouseButton1Click:Connect(function()
    local f = MakeWindow("Players")
    local scroll = Instance.new("ScrollingFrame"); scroll.Size = UDim2.new(1, -10, 1, -45); scroll.Position = UDim2.new(0, 5, 0, 35); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 25 + 10); scroll.Parent = f
    local y = 5
    for _, p in ipairs(Players:GetPlayers()) do
        local l = Instance.new("TextLabel"); l.Size = UDim2.new(1, -10, 0, 22); l.Position = UDim2.new(0, 5, 0, y); l.BackgroundColor3 = RED_DARK; l.TextColor3 = RED_MAIN; l.Text = p.Name .. " | " .. p.UserId; l.TextScaled = true; l.Font = Enum.Font.Gotham; l.Parent = scroll; y = y + 25
    end
end)

serverBtn.MouseButton1Click:Connect(function()
    local f = MakeWindow("Server Info")
    local l = Instance.new("TextLabel"); l.Size = UDim2.new(1, -20, 0, 100); l.Position = UDim2.new(0, 10, 0, 40); l.BackgroundTransparency = 1; l.TextColor3 = RED_MAIN; l.Text = "PlaceId: " .. game.PlaceId .. "\nJobId: " .. game.JobId .. "\nPlayers: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers; l.Font = Enum.Font.Gotham; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextYAlignment = Enum.TextYAlignment.Top; l.Parent = f
    local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -20, 0, 30); b.Position = UDim2.new(0, 10, 0, 150); b.BackgroundColor3 = RED_MAIN; b.TextColor3 = Color3.fromRGB(0,0,0); b.Text = "Copy JobId"; b.Font = Enum.Font.GothamBold; b.Parent = f
    b.MouseButton1Click:Connect(function() setclipboard(game.JobId); ShowRobloxNotification("Copied!", 2) end)
end)

customBtn.MouseButton1Click:Connect(function()
    local f = MakeWindow("Custom Script", UDim2.new(0, 350, 0, 175))
    local i = Instance.new("TextBox"); i.Size = UDim2.new(1, -20, 0, 36); i.Position = UDim2.new(0, 10, 0, 40); i.BackgroundColor3 = RED_DARK; i.TextColor3 = RED_MAIN; i.PlaceholderText = "URL..."; i.Font = Enum.Font.Gotham; i.Parent = f
    local run = Instance.new("TextButton"); run.Size = UDim2.new(1, -20, 0, 36); run.Position = UDim2.new(0, 10, 0, 100); run.BackgroundColor3 = RED_MAIN; run.TextColor3 = Color3.fromRGB(0,0,0); run.Text = "Run"; run.Font = Enum.Font.GothamBold; run.Parent = f
    run.MouseButton1Click:Connect(function() local ok = pcall(function() loadstring(game:HttpGet(i.Text))() end); ShowRobloxNotification(ok and "Executed!" or "Error!", 3) end)
end)

local themeOrder = {"Red", "Blue", "Green", "Purple", "Pink", "Orange", "Cyan", "Yellow", "Lime", "Magenta", "White"}
local themeIdx = 1
themeBtn.MouseButton1Click:Connect(function()
    themeIdx = themeIdx + 1; if themeIdx > #themeOrder then themeIdx = 1 end
    local t = THEMES[themeOrder[themeIdx]]; RED_MAIN, RED_DARK, RED_BG, RED_TITLE = t.MAIN, t.DARK, t.BG, t.TITLE
    mainFrame.BackgroundColor3 = RED_BG; mainFrame.BorderColor3 = RED_MAIN; titleBar.BackgroundColor3 = RED_TITLE; titleLabel.TextColor3 = RED_MAIN
    closeButton.BackgroundColor3 = RED_DARK; closeButton.TextColor3 = RED_MAIN; closeButton.BorderColor3 = RED_MAIN
    langButton.BackgroundColor3 = RED_DARK; langButton.TextColor3 = RED_MAIN; langButton.BorderColor3 = RED_MAIN
    playerBtn.BackgroundColor3 = RED_DARK; playerBtn.TextColor3 = RED_MAIN; playerBtn.BorderColor3 = RED_MAIN
    serverBtn.BackgroundColor3 = RED_DARK; serverBtn.TextColor3 = RED_MAIN; serverBtn.BorderColor3 = RED_MAIN
    customBtn.BackgroundColor3 = RED_DARK; customBtn.TextColor3 = RED_MAIN; customBtn.BorderColor3 = RED_MAIN
    changelogButton.BackgroundColor3 = RED_DARK; changelogButton.TextColor3 = RED_MAIN; changelogButton.BorderColor3 = RED_MAIN
    themeBtn.BackgroundColor3 = RED_DARK; themeBtn.TextColor3 = RED_MAIN; themeBtn.BorderColor3 = RED_MAIN
    colorBtn.BackgroundColor3 = RED_DARK; colorBtn.TextColor3 = RED_MAIN; colorBtn.BorderColor3 = RED_MAIN
    for _, c in ipairs(scrollFrame:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = RED_BG; c.TextColor3 = RED_MAIN; c.BorderColor3 = RED_MAIN end end
    ShowRobloxNotification("Theme: " .. themeOrder[themeIdx], 2)
end)

colorBtn.MouseButton1Click:Connect(function()
    local f = MakeWindow("Custom Color", UDim2.new(0, 280, 0, 150))
    local prev = Instance.new("Frame"); prev.Size = UDim2.new(1, -20, 0, 36); prev.Position = UDim2.new(0, 10, 0, 40); prev.BackgroundColor3 = RED_MAIN; prev.BorderColor3 = RED_MAIN; prev.Parent = f
    local hex = Instance.new("TextBox"); hex.Size = UDim2.new(1, -20, 0, 24); hex.Position = UDim2.new(0, 10, 0, 85); hex.BackgroundColor3 = RED_DARK; hex.TextColor3 = RED_MAIN; hex.Text = "#FF0000"; hex.Font = Enum.Font.Gotham; hex.Parent = f
    hex.FocusLost:Connect(function()
        local h = hex.Text:gsub("#", "")
        if #h == 6 then local r, g, b = tonumber(h:sub(1,2), 16), tonumber(h:sub(3,4), 16), tonumber(h:sub(5,6), 16); if r and g and b then prev.BackgroundColor3 = Color3.fromRGB(r, g, b); RED_MAIN = Color3.fromRGB(r,g,b); mainFrame.BorderColor3 = RED_MAIN end end
    end)
end)

ShowRobloxNotification("XyqwHub Default Loaded!", 4)
