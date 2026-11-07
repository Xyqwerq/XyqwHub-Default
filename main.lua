-- ========== XyqwHub | DEFAULT MODE (v7.6.5) ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local HUB_NAME = "XyqwHub"
local VERSION = "7.6.5 Default"
local OWNER_IDS = {4396977722, 8527910367}
local BETA_IDS = {9686718765, 3701387385}

-- Безопасные настройки
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
local ANTI_KICK_MESSAGES = GetSetting("akmsg", true)
local ANTI_KICK_LOGS = {}

local CONFIG_FOLDER = "XyqwHub"
local FAV_FILE = CONFIG_FOLDER .. "/FavScripts/favorites.json"
local RCT_FILE = CONFIG_FOLDER .. "/RctScripts/recent.json"
local CUSTOM_COLOR_FILE = CONFIG_FOLDER .. "/CustomColor/custom_color.json"
local AUTOEXEC_FILE = CONFIG_FOLDER .. "/AutoExecute/autoexec.json"
local SETTINGS_FILE = CONFIG_FOLDER .. "/Settings/settings.json"
local ORDER_FILE = CONFIG_FOLDER .. "/Settings/order.json"
local SESSION_FILE = CONFIG_FOLDER .. "/Session/last_jobid.txt"
local XYQWHUB_URL = "https://raw.githubusercontent.com/Xyqwerq/XyqwHub-Default/main/main.lua"

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
    if makefolder and not isfolder(CONFIG_FOLDER .. "/CustomColor") then makefolder(CONFIG_FOLDER .. "/CustomColor") end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/AutoExecute") then makefolder(CONFIG_FOLDER .. "/AutoExecute") end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/Settings") then makefolder(CONFIG_FOLDER .. "/Settings") end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/Session") then makefolder(CONFIG_FOLDER .. "/Session") end
    if makefolder and not isfolder(CONFIG_FOLDER .. "/Logs") then makefolder(CONFIG_FOLDER .. "/Logs") end
end)

FAVORITES = LoadTable(FAV_FILE)
RECENT = LoadTable(RCT_FILE)
AUTOEXEC = LoadTable(AUTOEXEC_FILE)
ORDER = LoadTable(ORDER_FILE)

pcall(function() if writefile then writefile(CONFIG_FOLDER .. "/Logs/session.txt", "active") end end)

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
local RED_MAIN = currentTheme.MAIN
local RED_DARK = currentTheme.DARK
local RED_BG = currentTheme.BG
local RED_TITLE = currentTheme.TITLE
local URL_OK = Color3.fromRGB(0, 255, 100)
local URL_BAD = Color3.fromRGB(255, 50, 50)
local URL_UNKNOWN = Color3.fromRGB(150, 150, 150)
local URL_CHECKING = Color3.fromRGB(255, 200, 0)

local LANG = { EN = {}, RU = {} }
LANG.EN = {
    Loaded = "loaded", Error = "error", Search = "Search...", CustomPlaceholder = "Paste URL...",
    RunCustom = "Run", JobIdCopied = "JobId copied!", ScriptExecuted = "Script executed!",
    OwnerWelcome = "Welcome, my father :3", BetaWelcome = "Glad you're here, tester <3",
    TagRemoved = "Tag removed!", LangChanged = "Language changed to English",
    FavShared = "Favorites shared!", RctShared = "Recent shared!", LoadstringCopied = "Loadstring copied!",
    ColorReset = "Color reset", ColorShared = "Color copied!", AutoExecOn = "Auto-Execute: ON", AutoExecOff = "Auto-Execute: OFF",
    KeybindChanged = "Auto-Hide keybind: ", UrlCheckStarted = "Testing URLs...", UrlCheckDone = "URL test complete!",
    WelcomeTitle = "Welcome to XyqwHub!", ClickXToClose = "Click X to close", PlayersTitle = "Players", ServerTitle = "Server Info",
    CustomTitle = "Custom Script", CustomColorTitle = "Custom Color", ChangeLogTitle = "ChangeLog",
    SettingsTitle = "Settings", Apply = "Apply", Reset = "Reset", ShareColor = "Share Color",
    CopyJobId = "Copy JobId", Rejoin = "Rejoin", ServerHop = "ServerHop", TPToSmall = "TP to Small",
    RemoveTags = "Remove Tags", ShareFav = "Share Favorite Scripts", ShareRct = "Share Recent Scripts",
    TestURLs = "Test URLs", SettingsBtn = "Settings", Destroy = "Destroy XyqwHub", ResetOrder = "Reset Order",
    PlaceId = "PlaceId", JobId = "JobId", Players = "Players", Creator = "Creator",
    Presets = "Presets", AutoHideBind = "Auto-Hide keybind:", ShareHub = "Share XyqwHub",
    HideTopBar = "Hide Top Bar", HideTopBarOn = "Hide Top Bar: ON", HideTopBarOff = "Hide Top Bar: OFF",
    OrderSaved = "Order saved!", OrderReset = "Order reset!", AntiKickOn = "AntiKick: ON", AntiKickOff = "AntiKick: OFF",
    AutoReinjectOn = "Auto-Reinject: ON", AutoReinjectOff = "Auto-Reinject: OFF",
    ReinjectQueued = "XyqwHub will reload after teleport", ReinjectNotSupported = "Auto-Reinject not supported",
    ExecutorInfoTitle = "Executor Info", RunUNCTest = "Run UNC Test", RunSUNCTest = "Run sUNC Test",
    Testing = "Testing...", TestResult = "Result", RejoinLastSession = "Rejoin Last Session",
    ChangeLogText = [[XyqwHub ChangeLog
========================================
Version 7.6.5 DEFAULT MODE
========================================
- Восстановлен полный интерфейс.
- Все 48 скриптов и темы.
XyqwHub 7.6.5]],
}
LANG.RU = { Loaded = "загружен", Error = "ошибка", Search = "Поиск...", CustomPlaceholder = "Ссылка...", RunCustom = "Запустить", JobIdCopied = "JobId скопирован!", ScriptExecuted = "Скрипт выполнен!", OwnerWelcome = "Welcome, my father :3", BetaWelcome = "Glad you're here, tester <3", TagRemoved = "Тег убран!", LangChanged = "Язык изменён на Русский", FavShared = "Избранное скопировано!", RctShared = "Недавние скопированы!", LoadstringCopied = "Loadstring скопирован!", ColorReset = "Цвет сброшен", ColorShared = "Цвет скопирован!", AutoExecOn = "Авто-запуск: ВКЛ", AutoExecOff = "Авто-запуск: ВЫКЛ", KeybindChanged = "Бинд Auto-Hide: ", UrlCheckStarted = "Проверка URL...", UrlCheckDone = "Проверка завершена!", WelcomeTitle = "Добро пожаловать в XyqwHub!", ClickXToClose = "Нажми X чтобы закрыть", PlayersTitle = "Игроки", ServerTitle = "Инфо о сервере", CustomTitle = "Свой скрипт", CustomColorTitle = "Свой цвет", ChangeLogTitle = "Ченджлог", SettingsTitle = "Настройки", Apply = "Применить", Reset = "Сбросить", ShareColor = "Поделиться цветом", CopyJobId = "Копировать JobId", Rejoin = "Перезайти", ServerHop = "Сменить сервер", TPToSmall = "ТП в маленький", RemoveTags = "Убрать теги", ShareFav = "Поделиться избранным", ShareRct = "Поделиться недавними", TestURLs = "Проверить URL", SettingsBtn = "Настройки", Destroy = "Удалить XyqwHub", ResetOrder = "Сбросить порядок", PlaceId = "PlaceId", JobId = "JobId", Players = "Игроки", Creator = "Создатель", Presets = "Пресеты", AutoHideBind = "Бинд Auto-Hide:", ShareHub = "Поделиться XyqwHub", HideTopBar = "Скрыть топ бар", HideTopBarOn = "Скрыть: ВКЛ", HideTopBarOff = "Скрыть: ВЫКЛ", OrderSaved = "Порядок сохранён!", OrderReset = "Порядок сброшен!", AntiKickOn = "AntiKick: ВКЛ", AntiKickOff = "AntiKick: ВЫКЛ", AutoReinjectOn = "Auto-Reinject: ВКЛ", AutoReinjectOff = "Auto-Reinject: ВЫКЛ", ReinjectQueued = "XyqwHub перезагрузится после телепорта", ReinjectNotSupported = "Auto-Reinject не поддерживается", ExecutorInfoTitle = "Инфо об экзекьюторе", RunUNCTest = "Запустить UNC тест", RunSUNCTest = "Запустить sUNC тест", Testing = "Тестирование...", TestResult = "Результат", RejoinLastSession = "Rejoin Last Session", ChangeLogText = "Версия 7.6.5: Полный интерфейс." }

for _, lang in ipairs({"UK", "BE", "KK"}) do LANG[lang] = LANG.EN end

local function _(key) return LANG[LANG_CODE] and LANG[LANG_CODE][key] or LANG.EN[key] or key end
local function ShowRobloxNotification(text, duration)
    duration = duration or 4
    pcall(function() StarterGui:SetCore("SendNotification", {Title = HUB_NAME, Text = tostring(text), Duration = duration}) end)
end

local function QueueReinject()
    if not GetSetting("autoreinject", true) then return false end
    local restoreCode = 'task.wait(3)\nif rawget(_G, "XyqwHubRunning") then rawset(_G, "XyqwHubRunning", nil) end\nloadstring(game:HttpGet("' .. XYQWHUB_URL .. '"))()'
    local queued = false
    pcall(function() if typeof(queue_on_teleport) == "function" then queue_on_teleport(restoreCode); queued=true end end)
    if queued then ShowRobloxNotification(_("ReinjectQueued"), 3) end
    return queued
end

local heartbeatTasks, renderTasks = {}, {}
local heartbeatConnection, renderConnection = nil, nil
local function AddHeartbeatTask(fn) table.insert(heartbeatTasks, fn); if not heartbeatConnection then heartbeatConnection = RunService.Heartbeat:Connect(function(dt) for _, task in ipairs(heartbeatTasks) do pcall(task, dt) end end) end end
local function AddRenderTask(fn) table.insert(renderTasks, fn); if not renderConnection then renderConnection = RunService.RenderStepped:Connect(function(dt) for _, task in ipairs(renderTasks) do pcall(task, dt) end end) end end

local function MakeResizable(frame, minW, minH, maxW, maxH)
    minW, minH, maxW, maxH = minW or 200, minH or 150, maxW or 900, maxH or 1000
    local handle = Instance.new("TextButton")
    handle.Name = "R" .. math.random(100, 999); handle.Size = UDim2.new(0, 12, 0, 12); handle.Position = UDim2.new(1, -12, 1, -12)
    handle.BackgroundColor3 = RED_MAIN; handle.Text = ""; handle.BorderSizePixel = 0; handle.ZIndex = 200; handle.Parent = frame; handle.AutoButtonColor = false
    local resizing, rsStart, rsSize = false, nil, nil
    handle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; rsStart = input.Position; rsSize = frame.Size end end)
    UserInputService.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - rsStart; frame.Size = UDim2.new(0, math.clamp(rsSize.X.Offset + delta.X, minW, maxW), 0, math.clamp(rsSize.Y.Offset + delta.Y, minH, maxH)) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end end)
end

local function MakeDraggable(frame, dragPart)
    dragPart = dragPart or frame
    local dragging, dragStart, startPos = false, nil, nil
    dragPart.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = frame.Position end end)
    dragPart.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
end

-- ========== СПИСОК СКРИПТОВ ==========
local JJS_URL = "https://raw.githubusercontent.com/Xyqwerq/JJS-SCRIPT/main/jjs_script.lua"
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
    {Name = "Jujutsu Sheninagouns", Category = "Misc", URL = JJS_URL},
    {Name = "Free Cam", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-Free-cam-script-pc-and-mobile-223089"},
    {Name = "Doors (Abysall)", Category = "Misc", URL = "https://rawscripts.net/raw/DOORS-Abysall-hub-OP-205906"},
    {Name = "Doors V2 (Copy)", Category = "Misc", URL = "SPECIAL_COPY_DOORS_V2"},
    {Name = "Doors V3 (Cheesy)", Category = "Misc", URL = "https://raw.githubusercontent.com/doram44/cheesy/refs/heads/main/cheesy.lua"},
    {Name = "Doors v4", Category = "Misc", URL = "https://raw.githubusercontent.com/sillyleo67/Doors/refs/heads/main/Twinkhook.lua"},
    {Name = "Fling Gui", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-fling-gui-99753"},
    {Name = "Infinite Yield", Category = "Misc", URL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {Name = "Walk on walls", Category = "Misc", URL = "https://rawscripts.net/raw/The-patience-obby-Universal-Walk-on-walls-18129"},
    {Name = "AetherX (Death Penalty)", Category = "Misc", URL = "https://api.luarmor.net/files/v3/loaders/8c08b8f2252eec7dbb77d253d269bb65.lua"},
    {Name = "Voidware (INK/99N/Forsaken)", Category = "Misc", URL = "https://files.vapevoidware.xyz/VapeVoidware/VW-Add/main/loader.lua"},
    {Name = "LaLol Hub (B4ckd0or)", Category = "Misc", URL = "https://raw.githubusercontent.com/Miygteet/Hacker101/refs/heads/main/LALOL-Backdoor-Secure.lua"},
    {Name = "FTAP", Category = "Misc", URL = "https://api.jnkie.com/api/v1/luascripts/public/4078649e4397f0e2cdaddde241d69bfd67b2b7107917891384735129c85cae18/download"},
    {Name = "MinhNat Hub (TSB)", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-MinhNhat-Tsb-62161"},
    {Name = "BC9 (UTG)", Category = "Misc", URL = "https://rawscripts.net/raw/untitled-tag-game-BC9-UTG-MENU-116806"},
    {Name = "FTAP (WITH KEY!!)", Category = "Misc", URL = "https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua"},
    {Name = "RadiumHub (Pressure)", Category = "Misc", URL = "https://rawscripts.net/raw/UPDATE-Pressure-God-Mode-Auto-Loot-ESP-Full-Bright-No-Eyefestation-224409"},
    {Name = "Steal an egg", Category = "Misc", URL = "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"},
    {Name = "Universal script", Category = "Misc", URL = "https://raw.githubusercontent.com/fleecelolll/Fleece-s-Utility-Panel/refs/heads/main/Script.lua"},
    {Name = "Corridor", Category = "Misc", URL = "https://saga2015.b-cdn.net/corridor.luau"},
    {Name = "BloxStrike", Category = "Misc", URL = "https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/BloxStrike.lua"},
    {Name = "RIVALS", Category = "Misc", URL = "https://raw.githubusercontent.com/imshrak/rivals/refs/heads/main/main"},
    {Name = "Troll script", Category = "Misc", URL = "https://mois7.xyz/loader"},
    {Name = "Death Order [SIMON]", Category = "Misc", URL = "https://rawscripts.net/raw/Death-Order:-Simon-Says-BEST-DEATH-ORDER-SCRIPT-226542"},
    {Name = "DropKick", Category = "Misc", URL = "https://raw.githubusercontent.com/yes-d3v-scripts/drop-kick-fling/refs/heads/main/script"},
    {Name = "Evade", Category = "Misc", URL = "https://github.com/imc72s/LaztDex/raw/refs/heads/main/EvadeScriptLaztDex"},
    {Name = "A dusty trip", Category = "Misc", URL = "https://raw.githubusercontent.com/BalintTheDevXBack/Games/refs/heads/main/aDustyTrip"},
    {Name = "A dusty trip v2", Category = "Misc", URL = "https://raw.githubusercontent.com/VoxlarWIP/Src/refs/heads/main/adustytrip.lua"},
    {Name = "bLockman's minesweaper", Category = "Misc", URL = "https://pastefy.app/T5XIfiMo/raw"},
    {Name = "Cheating during test", Category = "Misc", URL = "https://files.catbox.moe/pkulzc.txt"},
    {Name = "Adopt me", Category = "Misc", URL = "https://raw.githubusercontent.com/JaxRol/ZeroPoint/refs/heads/main/KeySystem"},
    {Name = "Piggy Item Grabber", Category = "Misc", URL = "https://rawscripts.net/raw/Piggy-Item-grabber-246165"},
    {Name = "Piggy Bots Control", Category = "Misc", URL = "https://robloxscripts.com/raw/control-piggy-bots"},
}

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

-- ========== UI БАЗА ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XyqwHub_" .. math.random(100000, 999999)
screenGui.ResetOnSpawn = false; screenGui.IgnoreGuiInset = true
pcall(function() if gethui then screenGui.Parent = gethui() end end)
if not screenGui.Parent then pcall(function() screenGui.Parent = CoreGui end) end
if not screenGui.Parent then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local globalDrag = false
local topBar = Instance.new("TextButton")
topBar.Size = UDim2.new(0, 420, 0, 24); topBar.Position = UDim2.new(0.5, -210, 0, 10)
topBar.BackgroundColor3 = RED_BG; topBar.BorderSizePixel = 2; topBar.BorderColor3 = RED_MAIN; topBar.Text = ""; topBar.AutoButtonColor = false; topBar.Parent = screenGui

local topBarText = Instance.new("TextLabel")
topBarText.Size = UDim2.new(1, -50, 1, 0); topBarText.Position = UDim2.new(0, 5, 0, 0); topBarText.BackgroundTransparency = 1
topBarText.Font = Enum.Font.GothamBold; topBarText.TextSize = 12; topBarText.TextColor3 = RED_MAIN; topBarText.TextXAlignment = Enum.TextXAlignment.Left; topBarText.Text = "..."; topBarText.Parent = topBar

task.spawn(function() while topBarText.Parent do topBarText.Text = string.format("%s | %s | FPS: %d", GetExecutorName(), Players.LocalPlayer.Name, fpsValue); task.wait(1) end end)

local hideTopBtn = Instance.new("TextButton")
hideTopBtn.Size = UDim2.new(0, 45, 1, 0); hideTopBtn.Position = UDim2.new(1, -45, 0, 0)
hideTopBtn.BackgroundColor3 = RED_DARK; hideTopBtn.TextColor3 = RED_MAIN; hideTopBtn.Text = "H"
hideTopBtn.Font = Enum.Font.GothamBold; hideTopBtn.BorderSizePixel = 1; hideTopBtn.BorderColor3 = RED_MAIN; hideTopBtn.Parent = topBar; hideTopBtn.AutoButtonColor = false

local dockButton = Instance.new("TextButton")
dockButton.Size = UDim2.new(0, 90, 0, 26); dockButton.Position = UDim2.new(0.5, -45, 0.05, 42)
dockButton.BackgroundColor3 = RED_BG; dockButton.TextColor3 = RED_MAIN; dockButton.Text = HUB_NAME; dockButton.TextScaled = true
dockButton.Font = Enum.Font.GothamBold; dockButton.BorderSizePixel = 2; dockButton.BorderColor3 = RED_MAIN
dockButton.Parent = screenGui; dockButton.Visible = false; dockButton.AutoButtonColor = false; dockButton.ZIndex = 999

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 340); mainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
mainFrame.BackgroundColor3 = RED_BG; mainFrame.BorderSizePixel = 3; mainFrame.BorderColor3 = RED_MAIN; mainFrame.Parent = screenGui

local function OpenGui() mainFrame.Visible = true; dockButton.Visible = false end
local function CloseGui() mainFrame.Visible = false; dockButton.Visible = true end
dockButton.MouseButton1Click:Connect(OpenGui)

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30); titleBar.BackgroundColor3 = RED_TITLE; titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 70, 1, 0); titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1; titleLabel.Text = HUB_NAME; titleLabel.TextColor3 = RED_MAIN; titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.BackgroundColor3 = RED_DARK; closeButton.TextColor3 = RED_MAIN; closeButton.Text = "X"
closeButton.TextScaled = true; closeButton.Font = Enum.Font.GothamBold; closeButton.BorderSizePixel = 1; closeButton.BorderColor3 = RED_MAIN; closeButton.Parent = titleBar; closeButton.AutoButtonColor = false
closeButton.MouseButton1Click:Connect(CloseGui)

local langButton = Instance.new("TextButton")
langButton.BackgroundColor3 = RED_DARK; langButton.TextColor3 = RED_MAIN; langButton.Text = LANG_CODE
langButton.TextScaled = true; langButton.Font = Enum.Font.GothamBold; langButton.BorderSizePixel = 1; langButton.BorderColor3 = RED_MAIN; langButton.Parent = titleBar; langButton.AutoButtonColor = false

local serverBtn = Instance.new("TextButton")
serverBtn.BackgroundColor3 = RED_DARK; serverBtn.TextColor3 = RED_MAIN; serverBtn.Text = "S"
serverBtn.TextScaled = true; serverBtn.Font = Enum.Font.GothamBold; serverBtn.BorderSizePixel = 1; serverBtn.BorderColor3 = RED_MAIN; serverBtn.Parent = titleBar; serverBtn.AutoButtonColor = false

local playerBtn = Instance.new("TextButton")
playerBtn.BackgroundColor3 = RED_DARK; playerBtn.TextColor3 = RED_MAIN; playerBtn.Text = "P"
playerBtn.TextScaled = true; playerBtn.Font = Enum.Font.GothamBold; playerBtn.BorderSizePixel = 1; playerBtn.BorderColor3 = RED_MAIN; playerBtn.Parent = titleBar; playerBtn.AutoButtonColor = false

local customBtn = Instance.new("TextButton")
customBtn.BackgroundColor3 = RED_DARK; customBtn.TextColor3 = RED_MAIN; customBtn.Text = "C"
customBtn.TextScaled = true; customBtn.Font = Enum.Font.GothamBold; customBtn.BorderSizePixel = 1; customBtn.BorderColor3 = RED_MAIN; customBtn.Parent = titleBar; customBtn.AutoButtonColor = false

local changelogButton = Instance.new("TextButton")
changelogButton.BackgroundColor3 = RED_DARK; changelogButton.TextColor3 = RED_MAIN; changelogButton.Text = "CL"
changelogButton.TextScaled = true; changelogButton.Font = Enum.Font.GothamBold; changelogButton.BorderSizePixel = 1; changelogButton.BorderColor3 = RED_MAIN; changelogButton.Parent = titleBar; changelogButton.AutoButtonColor = false

local themeBtn = Instance.new("TextButton")
themeBtn.BackgroundColor3 = RED_DARK; themeBtn.TextColor3 = RED_MAIN; themeBtn.Text = "Th"
themeBtn.TextScaled = true; themeBtn.Font = Enum.Font.GothamBold; themeBtn.BorderSizePixel = 1; themeBtn.BorderColor3 = RED_MAIN; themeBtn.Parent = titleBar; themeBtn.AutoButtonColor = false

local colorBtn = Instance.new("TextButton")
colorBtn.BackgroundColor3 = RED_DARK; colorBtn.TextColor3 = RED_MAIN; colorBtn.Text = "CC"
colorBtn.TextScaled = true; colorBtn.Font = Enum.Font.GothamBold; colorBtn.BorderSizePixel = 1; colorBtn.BorderColor3 = RED_MAIN; colorBtn.Parent = titleBar; colorBtn.AutoButtonColor = false

local HEADER_BUTTONS = {themeBtn, colorBtn, changelogButton, customBtn, playerBtn, serverBtn, langButton, closeButton}
local HEADER_SHORT_TEXT = {"Th", "CC", "CL", "C", "P", "S", "EN", "X"}
local HEADER_LONG_TEXT  = {"Theme", "Custom Color", "ChangeLog", "Custom", "Players", "Server", "EN/RU", "X"}
local HEADER_SHORT_W = {22, 24, 26, 22, 22, 22, 28, 22}
local HEADER_LONG_W  = {55, 105, 85, 70, 70, 65, 55, 22}

local function UpdateHeaderLayout()
    if not mainFrame or mainFrame.AbsoluteSize.X == 0 then task.wait() end
    local w = mainFrame.AbsoluteSize.X
    if w == 0 then w = mainFrame.Size.X.Offset end
    local useLong = w >= 550
    local titleW = 70
    local buttons = HEADER_BUTTONS
    local count = #buttons
    local gap = 1
    local widths = {}
    local totalW = titleW + 6
    for i = 1, count do local bw = useLong and HEADER_LONG_W[i] or HEADER_SHORT_W[i]; widths[i] = bw; totalW = totalW + bw + gap end
    if totalW > w then useLong = false; totalW = titleW + 6; for i = 1, count do widths[i] = HEADER_SHORT_W[i]; totalW = totalW + widths[i] + gap end end
    local xRight = w - 1
    local xIdx = count
    local xW = widths[xIdx]
    buttons[xIdx].Size = UDim2.new(0, xW, 0.8, 0); buttons[xIdx].Position = UDim2.new(1, -xW - 1, 0.1, 0)
    xRight = xRight - xW - gap
    for i = count - 1, 1, -1 do local bw = widths[i]; buttons[i].Size = UDim2.new(0, bw, 0.8, 0); buttons[i].Position = UDim2.new(1, -(w - xRight) - bw, 0.1, 0); xRight = xRight - bw - gap end
    for i = 1, count do buttons[i].Text = useLong and HEADER_LONG_TEXT[i] or HEADER_SHORT_TEXT[i] end
    langButton.Text = LANG_CODE
end

local searchBar = Instance.new("TextBox")
searchBar.Size = UDim2.new(1, -50, 0, 24); searchBar.Position = UDim2.new(0, 5, 0, 35)
searchBar.BackgroundColor3 = RED_DARK; searchBar.PlaceholderText = _("Search"); searchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBar.Text = ""; searchBar.TextColor3 = RED_MAIN; searchBar.TextSize = 12; searchBar.Font = Enum.Font.Gotham
searchBar.TextXAlignment = Enum.TextXAlignment.Left; searchBar.ClearTextOnFocus = false; searchBar.BorderSizePixel = 1; searchBar.BorderColor3 = RED_MAIN; searchBar.Parent = mainFrame

local infoBtn = Instance.new("TextButton")
infoBtn.Size = UDim2.new(0, 40, 0, 24); infoBtn.Position = UDim2.new(1, -45, 0, 35)
infoBtn.BackgroundColor3 = RED_DARK; infoBtn.TextColor3 = RED_MAIN; infoBtn.Text = "Info"; infoBtn.TextScaled = true
infoBtn.Font = Enum.Font.GothamBold; infoBtn.BorderSizePixel = 1; infoBtn.BorderColor3 = RED_MAIN; infoBtn.Parent = mainFrame; infoBtn.AutoButtonColor = false

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -10, 0, 24); tabBar.Position = UDim2.new(0, 5, 0, 64)
tabBar.BackgroundTransparency = 1; tabBar.Parent = mainFrame

local TAB_LIST = {"All", "BB", "MM2", "INK", "Misc", "Fav", "Rct"}
local TAB_LONG = {All = "All", BB = "BladeBall", MM2 = "MM2", INK = "INK", Misc = "Misc", Fav = "Favorite", Rct = "Recent"}
local TAB_SHORT = {All = "All", BB = "BB", MM2 = "MM2", INK = "INK", Misc = "Misc", Fav = "Fav", Rct = "Rct"}
local tabButtons = {}
local currentTab = "All"

local function SwitchTab(name)
    currentTab = name
    for n, btn in pairs(tabButtons) do
        if n == name then btn.BackgroundColor3 = RED_MAIN; btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else btn.BackgroundColor3 = RED_DARK; btn.TextColor3 = RED_MAIN end
        btn.BorderColor3 = RED_MAIN
    end
    task.wait(0.01)
    if _G.RefreshButtons then _G.RefreshButtons() end
end

for i, name in ipairs(TAB_LIST) do
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name; btn.BackgroundColor3 = RED_DARK; btn.TextColor3 = RED_MAIN; btn.Text = TAB_SHORT[name]
    btn.TextScaled = true; btn.Font = Enum.Font.GothamBold; btn.BorderSizePixel = 1; btn.BorderColor3 = RED_MAIN; btn.Parent = tabBar; btn.AutoButtonColor = false
    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
end

local function UpdateTabLayout()
    local w = mainFrame.AbsoluteSize.X
    if w == 0 then w = mainFrame.Size.X.Offset end
    local useLong = w >= 500
    local count = #TAB_LIST
    local gap = 1
    local totalGap = (count - 1) * gap
    local eachW = (w - 10 - totalGap) / count
    for i, name in ipairs(TAB_LIST) do
        local btn = tabButtons[name]
        btn.Size = UDim2.new(0, eachW, 1, 0); btn.Position = UDim2.new(0, (i - 1) * (eachW + gap), 0, 0)
        btn.Text = useLong and TAB_LONG[name] or TAB_SHORT[name]
    end
end

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -98); scrollFrame.Position = UDim2.new(0, 5, 0, 93)
scrollFrame.BackgroundTransparency = 1; scrollFrame.BorderSizePixel = 0; scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4; scrollFrame.ScrollBarImageColor3 = RED_MAIN; scrollFrame.Parent = mainFrame

local buttons = {}
local buttonHeight = 34

local function UpdateScriptButtonLayout()
    local w = mainFrame.AbsoluteSize.X
    if w == 0 then w = mainFrame.Size.X.Offset end
    local useLong = w >= 500
    for _, entry in ipairs(buttons) do
        entry.AutoBtn.Text = AUTOEXEC[entry.Data.Name] and (useLong and "On" or "✓") or (useLong and "Auto" or "▶")
        entry.Star.Text = FAVORITES[entry.Data.Name] and (useLong and "Fav+" or "★") or (useLong and "Fav" or "☆")
    end
end

local function TweenColor(obj, prop, targetColor, time)
    time = time or 0.15
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[prop] = targetColor})
    tween:Play(); return tween
end

local function SaveOrder()
    local order = {}
    for _, entry in ipairs(buttons) do table.insert(order, entry.Data.Name) end
    ORDER = order; SetSetting("order", ORDER); SaveTable(ORDER_FILE, order)
end

local function ApplyOrderFromFile()
    if #ORDER == 0 then return end
    local orderMap = {}
    for i, name in ipairs(ORDER) do orderMap[name] = i end
    table.sort(buttons, function(a, b) local ai = orderMap[a.Data.Name] or 9999; local bi = orderMap[b.Data.Name] or 9999; return ai < bi end)
end

local function CreateScriptButton(data)
    local container = Instance.new("Frame")
    container.Name = "Script_" .. data.Name; container.Size = UDim2.new(1, -10, 0, 32); container.Position = UDim2.new(0, 5, 0, 0)
    container.BackgroundColor3 = RED_BG; container.BorderSizePixel = 2; container.BorderColor3 = RED_MAIN; container.ZIndex = 1; container.Parent = scrollFrame

    local dragStrip = Instance.new("Frame")
    dragStrip.Size = UDim2.new(0, 25, 1, 0); dragStrip.Position = UDim2.new(0, 0, 0, 0)
    dragStrip.BackgroundColor3 = RED_MAIN; dragStrip.BackgroundTransparency = 0.6; dragStrip.BorderSizePixel = 0; dragStrip.ZIndex = 2; dragStrip.Parent = container

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 6, 0, 6); statusDot.Position = UDim2.new(0, 12, 0.5, -3)
    statusDot.BackgroundColor3 = URL_UNKNOWN; statusDot.BorderSizePixel = 0; statusDot.ZIndex = 3; statusDot.Parent = container

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -95, 1, 0); btn.Position = UDim2.new(0, 30, 0, 0); btn.BackgroundTransparency = 1
    btn.TextColor3 = RED_MAIN; btn.Text = data.Name; btn.TextSize = 17; btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left; btn.TextTruncate = Enum.TextTruncate.AtEnd; btn.ZIndex = 2; btn.Parent = container; btn.AutoButtonColor = false

    local autoBtn = Instance.new("TextButton")
    autoBtn.Size = UDim2.new(0, 24, 1, 0); autoBtn.Position = UDim2.new(1, -52, 0, 0)
    autoBtn.BackgroundColor3 = RED_BG; autoBtn.TextColor3 = RED_MAIN; autoBtn.Text = "▶"; autoBtn.TextScaled = true
    autoBtn.Font = Enum.Font.GothamBold; autoBtn.BorderSizePixel = 1; autoBtn.BorderColor3 = RED_MAIN; autoBtn.ZIndex = 2; autoBtn.Parent = container; autoBtn.AutoButtonColor = false
    if AUTOEXEC[data.Name] then autoBtn.Text = "✓"; autoBtn.BackgroundColor3 = RED_MAIN; autoBtn.TextColor3 = Color3.fromRGB(0, 0, 0) end
    autoBtn.MouseButton1Click:Connect(function()
        if AUTOEXEC[data.Name] then AUTOEXEC[data.Name] = nil; TweenColor(autoBtn, "BackgroundColor3", RED_BG); autoBtn.TextColor3 = RED_MAIN; ShowRobloxNotification(data.Name .. " — " .. _("AutoExecOff"), 3)
        else AUTOEXEC[data.Name] = true; TweenColor(autoBtn, "BackgroundColor3", RED_MAIN); autoBtn.TextColor3 = Color3.fromRGB(0, 0, 0); ShowRobloxNotification(data.Name .. " — " .. _("AutoExecOn"), 3) end
        SetSetting("autoexec", AUTOEXEC); SaveTable(AUTOEXEC_FILE, AUTOEXEC); UpdateScriptButtonLayout()
    end)

    local star = Instance.new("TextButton")
    star.Size = UDim2.new(0, 24, 1, 0); star.Position = UDim2.new(1, -26, 0, 0)
    star.BackgroundColor3 = RED_BG; star.TextColor3 = RED_MAIN; star.Text = "☆"; star.TextScaled = true
    star.Font = Enum.Font.GothamBold; star.BorderSizePixel = 1; star.BorderColor3 = RED_MAIN; star.ZIndex = 2; star.Parent = container; star.AutoButtonColor = false
    if FAVORITES[data.Name] then star.Text = "★" end
    star.MouseButton1Click:Connect(function()
        if FAVORITES[data.Name] then FAVORITES[data.Name] = nil; star.Text = "☆"
        else FAVORITES[data.Name] = true; star.Text = "★" end
        SetSetting("fav", FAVORITES); SaveTable(FAV_FILE, FAVORITES); UpdateScriptButtonLayout()
    end)

    btn.MouseEnter:Connect(function() TweenColor(container, "BackgroundColor3", RED_DARK, 0.12) end)
    btn.MouseLeave:Connect(function() TweenColor(container, "BackgroundColor3", RED_BG, 0.15) end)

    local isRunning, lastRun, blockClick = false, 0, false
    btn.MouseButton1Click:Connect(function()
        if blockClick or isRunning then return end
        local now = tick()
        if now - lastRun < 1.5 then return end
        lastRun = now; isRunning = true; TweenColor(container, "BackgroundColor3", RED_MAIN, 0.1)
        
        for i, name in ipairs(RECENT) do if name == data.Name then table.remove(RECENT, i) break end end
        table.insert(RECENT, 1, data.Name)
        while #RECENT > 5 do table.remove(RECENT) end
        SetSetting("recent", RECENT); SaveTable(RCT_FILE, RECENT)

        if data.URL == "SPECIAL_COPY_DOORS_V2" then
            local scriptText = 'getgenv().SCRIPT_KEY = "KEYLESS"\nloadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/abd3cc54d2dc7de4a091fb19c8f4ea9e15e939e7ecc88b475e6956e8af94ad6f/download"))()'
            pcall(function() setclipboard(scriptText) end); ShowRobloxNotification("Doors V2 - copied", 5)
        else
            local success = pcall(function() loadstring(game:HttpGet(data.URL))() end)
            if success then ShowRobloxNotification(data.Name .. " - " .. _("ScriptExecuted"), 3) else ShowRobloxNotification(data.Name .. " - " .. _("Error"), 5) end
        end
        task.wait(0.3); TweenColor(container, "BackgroundColor3", RED_BG, 0.15); isRunning = false
    end)

    local dragging, dragStart, originalPos, holdTask = false, nil, nil, nil
    dragStrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if globalDrag then return end
            blockClick = true
            holdTask = task.delay(0.35, function()
                if not dragging and not globalDrag then
                    dragging = true; globalDrag = true; blockClick = true; dragStart = input.Position; originalPos = container.Position
                    scrollFrame.ScrollingEnabled = false; dragStrip.BackgroundTransparency = 0
                    TweenColor(container, "BorderColor3", RED_MAIN, 0.15); TweenColor(container, "BackgroundColor3", RED_DARK, 0.15)
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            container.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale, originalPos.Y.Offset + delta.Y); container.ZIndex = 10
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if holdTask then pcall(function() task.cancel(holdTask) end) holdTask = nil end
            if dragging then
                blockClick = true; dragging = false; globalDrag = false; container.ZIndex = 1; scrollFrame.ScrollingEnabled = true; dragStrip.BackgroundTransparency = 0.6
                TweenColor(container, "BorderColor3", RED_MAIN, 0.15); TweenColor(container, "BackgroundColor3", RED_BG, 0.15)
                local curY = container.AbsolutePosition.Y - scrollFrame.AbsolutePosition.Y + scrollFrame.CanvasPosition.Y
                local targetIdx = math.clamp(math.floor(curY / buttonHeight) + 1, 1, #buttons)
                local curIdx = 1
                for i, e in ipairs(buttons) do if e.Container == container then curIdx = i break end end
                if curIdx ~= targetIdx then local entry = table.remove(buttons, curIdx); table.insert(buttons, targetIdx, entry); SaveOrder(); ShowRobloxNotification(_("OrderSaved"), 2) end
                if _G.RefreshButtons then _G.RefreshButtons() end
                task.wait(0.05); blockClick = false
            end
        end
    end)

    table.insert(buttons, {Container = container, Btn = btn, Star = star, AutoBtn = autoBtn, Data = data, StatusDot = statusDot, DragStrip = dragStrip})
end

ApplyOrderFromFile()
for _, data in ipairs(SCRIPTS) do CreateScriptButton(data) end
ApplyOrderFromFile()

_G.RefreshButtons = function()
    local search = string.lower(searchBar.Text)
    for _, entry in ipairs(buttons) do
        local show = true
        if currentTab == "Fav" then if not FAVORITES[entry.Data.Name] then show = false end
        elseif currentTab == "Rct" then local found = false; for _, n in ipairs(RECENT) do if n == entry.Data.Name then found = true break end end; if not found then show = false end
        elseif currentTab ~= "All" then if entry.Data.Category ~= currentTab then show = false end end
        if show and search ~= "" and not string.find(string.lower(entry.Data.Name), search, 1, true) then show = false end
        entry.Container.Visible = show
    end
    local visible = 0
    for _, entry in ipairs(buttons) do if entry.Container.Visible then entry.Container.Position = UDim2.new(0, 5, 0, visible * buttonHeight + 5); visible = visible + 1 end end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, visible * buttonHeight + 20)
end
_G.RefreshButtons()
searchBar:GetPropertyChangedSignal("Text"):Connect(function() if _G.RefreshButtons then _G.RefreshButtons() end end)

-- ========== TITLE BAR DRAG ==========
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mousePos = input.Position
        local function IsOverButton(btn) if not btn then return false end; local p = btn.AbsolutePosition; local s = btn.AbsoluteSize; return mousePos.X >= p.X and mousePos.X <= p.X + s.X and mousePos.Y >= p.Y and mousePos.Y <= p.Y + s.Y end
        if IsOverButton(changelogButton) or IsOverButton(langButton) or IsOverButton(closeButton) or IsOverButton(themeBtn) or IsOverButton(customBtn) or IsOverButton(playerBtn) or IsOverButton(serverBtn) or IsOverButton(colorBtn) then return end
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
    end
end)
titleBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- ========== MAIN RESIZE ==========
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 14, 0, 14); resizeHandle.Position = UDim2.new(1, -14, 1, -14); resizeHandle.BackgroundColor3 = RED_MAIN; resizeHandle.Text = ""; resizeHandle.BorderSizePixel = 0; resizeHandle.Parent = mainFrame
local resizing, rsStart, rsSize = false, nil, nil
resizeHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; rsStart = input.Position; rsSize = mainFrame.Size end end)
UserInputService.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - rsStart; local nx = math.clamp(rsSize.X.Offset + delta.X, 280, 900); local ny = math.clamp(rsSize.Y.Offset + delta.Y, 340, 1000); mainFrame.Size = UDim2.new(0, nx, 0, ny); UpdateTabLayout(); UpdateScriptButtonLayout(); UpdateHeaderLayout() end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end end)

-- ========== CHANGELOG ==========
local function ShowChangeLog()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 350); frame.Position = UDim2.new(0.5, -175, 0.5, -175)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Parent = screenGui
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = "ChangeLog"; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.Parent = frame
    local drag = Instance.new("TextButton"); drag.Size = UDim2.new(1, -35, 0, 30); drag.Position = UDim2.new(0, 2, 0, 3); drag.BackgroundTransparency = 1; drag.Text = ""; drag.Parent = frame; MakeDraggable(frame, drag)
    local close = Instance.new("TextButton"); close.Size = UDim2.new(0, 30, 0, 28); close.Position = UDim2.new(1, -35, 0, 2); close.BackgroundTransparency = 1; close.Text = "X"; close.TextColor3 = RED_MAIN; close.Font = Enum.Font.GothamBold; close.Parent = frame; close.MouseButton1Click:Connect(function() frame:Destroy() end)
    local scroll = Instance.new("ScrollingFrame"); scroll.Size = UDim2.new(1, -10, 1, -45); scroll.Position = UDim2.new(0, 5, 0, 35); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 1500); scroll.Parent = frame
    local text = Instance.new("TextLabel"); text.Size = UDim2.new(1, -10, 0, 1490); text.Position = UDim2.new(0, 5, 0, 5); text.BackgroundTransparency = 1; text.TextColor3 = RED_MAIN; text.TextWrapped = true; text.TextXAlignment = Enum.TextXAlignment.Left; text.TextYAlignment = Enum.TextYAlignment.Top; text.TextSize = 12; text.Font = Enum.Font.Gotham; text.Text = _("ChangeLogText"); text.Parent = scroll
    MakeResizable(frame, 250, 200, 900, 1000)
end
changelogButton.MouseButton1Click:Connect(ShowChangeLog)

-- ========== LANGUAGE ==========
langButton.MouseButton1Click:Connect(function()
    local langs = {"EN", "RU"}; local idx = 1
    for i, l in ipairs(langs) do if l == LANG_CODE then idx = i break end end
    idx = idx + 1; if idx > #langs then idx = 1 end
    LANG_CODE = langs[idx]; SetSetting("lang", LANG_CODE); langButton.Text = LANG_CODE
    searchBar.PlaceholderText = _("Search"); ShowRobloxNotification(_("LangChanged"), 3); UpdateHeaderLayout()
end)

-- ========== PLAYER LIST ==========
playerBtn.MouseButton1Click:Connect(function()
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(0, 350, 0, 400); frame.Position = UDim2.new(0.5, -175, 0.5, -200)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Parent = screenGui
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = "Players (" .. #Players:GetPlayers() .. ")"; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.Parent = frame
    local drag = Instance.new("TextButton"); drag.Size = UDim2.new(1, -35, 0, 30); drag.Position = UDim2.new(0, 2, 0, 3); drag.BackgroundTransparency = 1; drag.Text = ""; drag.Parent = frame; MakeDraggable(frame, drag)
    local close = Instance.new("TextButton"); close.Size = UDim2.new(0, 30, 0, 28); close.Position = UDim2.new(1, -35, 0, 2); close.BackgroundTransparency = 1; close.Text = "X"; close.TextColor3 = RED_MAIN; close.Font = Enum.Font.GothamBold; close.Parent = frame; close.MouseButton1Click:Connect(function() frame:Destroy() end)
    local scroll = Instance.new("ScrollingFrame"); scroll.Size = UDim2.new(1, -10, 1, -45); scroll.Position = UDim2.new(0, 5, 0, 35); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 25 + 10); scroll.Parent = frame
    local y = 5
    for _, p in ipairs(Players:GetPlayers()) do
        local l = Instance.new("TextLabel"); l.Size = UDim2.new(1, -10, 0, 22); l.Position = UDim2.new(0, 5, 0, y); l.BackgroundColor3 = RED_DARK; l.TextColor3 = RED_MAIN; l.Text = p.Name .. " | " .. p.UserId; l.TextScaled = true; l.Font = Enum.Font.Gotham; l.Parent = scroll; y = y + 25
    end
    MakeResizable(frame, 250, 200, 900, 1000)
end)

-- ========== SERVER INFO ==========
serverBtn.MouseButton1Click:Connect(function()
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(0, 350, 0, 400); frame.Position = UDim2.new(0.5, -175, 0.5, -200)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Parent = screenGui
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = "Server Info"; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.Parent = frame
    local drag = Instance.new("TextButton"); drag.Size = UDim2.new(1, -35, 0, 30); drag.Position = UDim2.new(0, 2, 0, 3); drag.BackgroundTransparency = 1; drag.Text = ""; drag.Parent = frame; MakeDraggable(frame, drag)
    local close = Instance.new("TextButton"); close.Size = UDim2.new(0, 30, 0, 28); close.Position = UDim2.new(1, -35, 0, 2); close.BackgroundTransparency = 1; close.Text = "X"; close.TextColor3 = RED_MAIN; close.Font = Enum.Font.GothamBold; close.Parent = frame; close.MouseButton1Click:Connect(function() frame:Destroy() end)
    local info = Instance.new("TextLabel"); info.Size = UDim2.new(1, -20, 0, 110); info.Position = UDim2.new(0, 10, 0, 40); info.BackgroundTransparency = 1; info.TextColor3 = RED_MAIN; info.TextWrapped = true; info.TextXAlignment = Enum.TextXAlignment.Left; info.Text = "PlaceId: " .. game.PlaceId .. "\nJobId: " .. game.JobId .. "\nPlayers: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers; info.Font = Enum.Font.Gotham; info.Parent = frame
    local copy = Instance.new("TextButton"); copy.Size = UDim2.new(1, -20, 0, 30); copy.Position = UDim2.new(0, 10, 0, 158); copy.BackgroundColor3 = RED_MAIN; copy.TextColor3 = Color3.fromRGB(0,0,0); copy.Text = "Copy JobId"; copy.Font = Enum.Font.GothamBold; copy.Parent = frame; copy.MouseButton1Click:Connect(function() setclipboard(game.JobId); ShowRobloxNotification("Copied!", 2) end)
    MakeResizable(frame, 280, 300, 700, 700)
end)

-- ========== CUSTOM SCRIPT ==========
customBtn.MouseButton1Click:Connect(function()
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(0, 350, 0, 175); frame.Position = UDim2.new(0.5, -175, 0.5, -87)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Parent = screenGui
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = "Custom Script"; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.Parent = frame
    local drag = Instance.new("TextButton"); drag.Size = UDim2.new(1, -35, 0, 30); drag.Position = UDim2.new(0, 2, 0, 3); drag.BackgroundTransparency = 1; drag.Text = ""; drag.Parent = frame; MakeDraggable(frame, drag)
    local close = Instance.new("TextButton"); close.Size = UDim2.new(0, 30, 0, 28); close.Position = UDim2.new(1, -35, 0, 2); close.BackgroundTransparency = 1; close.Text = "X"; close.TextColor3 = RED_MAIN; close.Font = Enum.Font.GothamBold; close.Parent = frame; close.MouseButton1Click:Connect(function() frame:Destroy() end)
    local input = Instance.new("TextBox"); input.Size = UDim2.new(1, -20, 0, 36); input.Position = UDim2.new(0, 10, 0, 40); input.BackgroundColor3 = RED_DARK; input.TextColor3 = RED_MAIN; input.PlaceholderText = "Paste URL..."; input.PlaceholderColor3 = Color3.fromRGB(150,150,150); input.Font = Enum.Font.Gotham; input.Parent = frame
    local run = Instance.new("TextButton"); run.Size = UDim2.new(1, -20, 0, 36); run.Position = UDim2.new(0, 10, 0, 100); run.BackgroundColor3 = RED_MAIN; run.TextColor3 = Color3.fromRGB(0,0,0); run.Text = "Run"; run.Font = Enum.Font.GothamBold; run.Parent = frame
    run.MouseButton1Click:Connect(function()
        local url = input.Text:match('game:HttpGet%s*%(%s*["\']([^"\']+)["\']') or input.Text
        local success = pcall(function() loadstring(game:HttpGet(url))() end)
        if success then ShowRobloxNotification("Executed!", 3) else ShowRobloxNotification("Error!", 3) end
    end)
    MakeResizable(frame, 250, 150, 700, 500)
end)

-- ========== CUSTOM COLOR ==========
colorBtn.MouseButton1Click:Connect(function()
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(0, 280, 0, 380); frame.Position = UDim2.new(0.5, -140, 0.5, -190)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Parent = screenGui
    local title = Instance.new("TextLabel"); title.Size = UDim2.new(1, -60, 0, 22); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = "Custom Color"; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.Parent = frame
    local drag = Instance.new("TextButton"); drag.Size = UDim2.new(1, -35, 0, 24); drag.Position = UDim2.new(0, 2, 0, 3); drag.BackgroundTransparency = 1; drag.Text = ""; drag.Parent = frame; MakeDraggable(frame, drag)
    local close = Instance.new("TextButton"); close.Size = UDim2.new(0, 24, 0, 22); close.Position = UDim2.new(1, -28, 0, 4); close.BackgroundTransparency = 1; close.Text = "X"; close.TextColor3 = RED_MAIN; close.Font = Enum.Font.GothamBold; close.Parent = frame; close.MouseButton1Click:Connect(function() frame:Destroy() end)
    
    local preview = Instance.new("Frame"); preview.Size = UDim2.new(1, -20, 0, 36); preview.Position = UDim2.new(0, 10, 0, 32); preview.BackgroundColor3 = RED_MAIN; preview.BorderSizePixel = 2; preview.BorderColor3 = RED_MAIN; preview.Parent = frame
    local tempColor = {r = 255, g = 0, b = 0}
    
    local function UpdateAll() preview.BackgroundColor3 = Color3.fromRGB(tempColor.r, tempColor.g, tempColor.b) end

    local function MakeSlider(label, yPos, channel)
        local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0, 20, 0, 18); lbl.Position = UDim2.new(0, 10, 0, yPos); lbl.BackgroundTransparency = 1; lbl.TextColor3 = RED_MAIN; lbl.Text = label; lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
        local valLbl = Instance.new("TextLabel"); valLbl.Size = UDim2.new(0, 40, 0, 18); valLbl.Position = UDim2.new(1, -50, 0, yPos); valLbl.BackgroundTransparency = 1; valLbl.TextColor3 = RED_MAIN; valLbl.Text = tostring(tempColor[channel]); valLbl.Font = Enum.Font.Gotham; valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl.Parent = frame
        local slider = Instance.new("Frame"); slider.Size = UDim2.new(1, -100, 0, 12); slider.Position = UDim2.new(0, 35, 0, yPos + 3); slider.BackgroundColor3 = RED_DARK; slider.BorderSizePixel = 1; slider.BorderColor3 = RED_MAIN; slider.Parent = frame
        local fill = Instance.new("Frame"); fill.Size = UDim2.new(tempColor[channel] / 255, 0, 1, 0); fill.BackgroundColor3 = RED_MAIN; fill.BorderSizePixel = 0; fill.Parent = slider
        local drag = false
        local function UpdateFromX(mouseX) local rel = math.clamp((mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1); local v = math.floor(rel * 255); tempColor[channel] = v; fill.Size = UDim2.new(rel, 0, 1, 0); valLbl.Text = tostring(v); UpdateAll() end
        slider.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = true; UpdateFromX(input.Position.X) end end)
        UserInputService.InputChanged:Connect(function(input) if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateFromX(input.Position.X) end end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    end
    MakeSlider("R", 76, "r"); MakeSlider("G", 100, "g"); MakeSlider("B", 124, "b")

    local applyBtn = Instance.new("TextButton"); applyBtn.Size = UDim2.new(1, -20, 0, 28); applyBtn.Position = UDim2.new(0, 10, 0, 308); applyBtn.BackgroundColor3 = RED_MAIN; applyBtn.TextColor3 = Color3.fromRGB(0, 0, 0); applyBtn.Text = "Apply"; applyBtn.Font = Enum.Font.GothamBold; applyBtn.Parent = frame
    applyBtn.MouseButton1Click:Connect(function()
        THEMES.Custom.MAIN = Color3.fromRGB(tempColor.r, tempColor.g, tempColor.b)
        THEMES.Custom.DARK = Color3.fromRGB(math.floor(tempColor.r * 0.15), math.floor(tempColor.g * 0.15), math.floor(tempColor.b * 0.15))
        RED_MAIN, RED_DARK = THEMES.Custom.MAIN, THEMES.Custom.DARK
        mainFrame.BorderColor3 = RED_MAIN; titleBar.BackgroundColor3 = RED_BG; titleLabel.TextColor3 = RED_MAIN
        ShowRobloxNotification("Custom Color applied!", 3); frame:Destroy()
    end)
    MakeResizable(frame, 280, 350, 600, 800)
end)

-- ========== THEME BUTTON ==========
local themeOrder = {"Red", "Blue", "Green", "Purple", "Pink", "Orange", "Cyan", "Yellow", "Lime", "Magenta", "White", "Rainbow", "Custom"}
local themeIndex = 1; for i, name in ipairs(themeOrder) do if name == THEME_NAME then themeIndex = i break end end
themeBtn.MouseButton1Click:Connect(function()
    themeIndex = themeIndex + 1; if themeIndex > #themeOrder then themeIndex = 1 end
    local t = THEMES[themeOrder[themeIndex]]; RED_MAIN, RED_DARK, RED_BG, RED_TITLE = t.MAIN, t.DARK, t.BG, t.TITLE
    mainFrame.BackgroundColor3 = RED_BG; mainFrame.BorderColor3 = RED_MAIN; titleBar.BackgroundColor3 = RED_TITLE; titleLabel.TextColor3 = RED_MAIN
    closeButton.BackgroundColor3 = RED_DARK; closeButton.TextColor3 = RED_MAIN; closeButton.BorderColor3 = RED_MAIN
    langButton.BackgroundColor3 = RED_DARK; langButton.TextColor3 = RED_MAIN; langButton.BorderColor3 = RED_MAIN
    playerBtn.BackgroundColor3 = RED_DARK; playerBtn.TextColor3 = RED_MAIN; playerBtn.BorderColor3 = RED_MAIN
    serverBtn.BackgroundColor3 = RED_DARK; serverBtn.TextColor3 = RED_MAIN; serverBtn.BorderColor3 = RED_MAIN
    customBtn.BackgroundColor3 = RED_DARK; customBtn.TextColor3 = RED_MAIN; customBtn.BorderColor3 = RED_MAIN
    changelogButton.BackgroundColor3 = RED_DARK; changelogButton.TextColor3 = RED_MAIN; changelogButton.BorderColor3 = RED_MAIN
    themeBtn.BackgroundColor3 = RED_DARK; themeBtn.TextColor3 = RED_MAIN; themeBtn.BorderColor3 = RED_MAIN
    colorBtn.BackgroundColor3 = RED_DARK; colorBtn.TextColor3 = RED_MAIN; colorBtn.BorderColor3 = RED_MAIN
    infoBtn.BackgroundColor3 = RED_DARK; infoBtn.TextColor3 = RED_MAIN; infoBtn.BorderColor3 = RED_MAIN
    scrollFrame.ScrollBarImageColor3 = RED_MAIN
    for _, c in ipairs(scrollFrame:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = RED_BG; c.TextColor3 = RED_MAIN; c.BorderColor3 = RED_MAIN end end
    ShowRobloxNotification("Theme: " .. themeOrder[themeIndex], 2)
end)

-- ========== DESTROY ==========
destroyBtnMain.MouseButton1Click:Connect(function()
    ShowRobloxNotification("XyqwHub Destroyed!", 2)
    pcall(function() if delfile then delfile(CONFIG_FOLDER .. "/Logs/session.txt") end end)
    screenGui:Destroy()
end)

UpdateTabLayout(); UpdateScriptButtonLayout(); UpdateHeaderLayout(); SwitchTab("All")
task.spawn(function() task.wait(1); ShowRobloxNotification("XyqwHub Default Loaded!", 4) end)
