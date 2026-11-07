-- ========== XyqwHub | DEFAULT MODE (v7.6.1 Full) ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local HUB_NAME = "XyqwHub"
local VERSION = "7.6.1 Default"
local OWNER_IDS = {4396977722, 8527910367}
local BETA_IDS = {9686718765, 3701387385}

-- ========== БЕЗОПАСНЫЕ НАСТРОЙКИ ==========
local function GetSetting(key, default) 
    local ok, val = pcall(function() return shared["Xyqw_" .. key] end)
    if ok and val ~= nil then return val end
    return default 
end
local function SetSetting(key, value) 
    pcall(function() shared["Xyqw_" .. key] = value end)
end

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

-- ========== БЕЗОПАСНЫЕ ФАЙЛЫ ==========
local function SaveTable(path, tbl)
    pcall(function() 
        if writefile then writefile(path, HttpService:JSONEncode(tbl)) end 
    end)
end
local function LoadTable(path)
    local ok, data = pcall(function()
        if readfile and isfile and isfile(path) then 
            return HttpService:JSONDecode(readfile(path)) 
        end
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

-- ========== ДЕТЕКТОР КИКА ==========
pcall(function() 
    if writefile then writefile(CONFIG_FOLDER .. "/Logs/session.txt", "active") end 
end)
game:BindToClose(function()
    pcall(function() 
        if delfile then delfile(CONFIG_FOLDER .. "/Logs/session.txt") end 
    end)
end)

-- ========== ТЕМЫ ==========
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

local LANG = {}
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
    ChangeLogText = [[XyqwHub ChangeLog (Full History)
========================================
Version 7.6.1 DEFAULT MODE
========================================
- Восстановлены все функции (поиск, языки, табы).
- Защита от крашей (nil) при работе с файлами.
- Интегрирован детектор кика (session.txt).
- Добавлена кнопка вызова Пульса.
XyqwHub 7.6.1 Default]],
}
LANG.RU = { Loaded = "загружен", Error = "ошибка", Search = "Поиск...", CustomPlaceholder = "Ссылка...", RunCustom = "Запустить", JobIdCopied = "JobId скопирован!", ScriptExecuted = "Скрипт выполнен!", OwnerWelcome = "Welcome, my father :3", BetaWelcome = "Glad you're here, tester <3", TagRemoved = "Тег убран!", LangChanged = "Язык изменён на Русский", FavShared = "Избранное скопировано!", RctShared = "Недавние скопированы!", LoadstringCopied = "Loadstring скопирован!", ColorReset = "Цвет сброшен", ColorShared = "Цвет скопирован!", AutoExecOn = "Авто-запуск: ВКЛ", AutoExecOff = "Авто-запуск: ВЫКЛ", KeybindChanged = "Бинд Auto-Hide: ", UrlCheckStarted = "Проверка URL...", UrlCheckDone = "Проверка завершена!", WelcomeTitle = "Добро пожаловать в XyqwHub!", ClickXToClose = "Нажми X чтобы закрыть", PlayersTitle = "Игроки", ServerTitle = "Инфо о сервере", CustomTitle = "Свой скрипт", CustomColorTitle = "Свой цвет", ChangeLogTitle = "Ченджлог", SettingsTitle = "Настройки", Apply = "Применить", Reset = "Сбросить", ShareColor = "Поделиться цветом", CopyJobId = "Копировать JobId", Rejoin = "Перезайти", ServerHop = "Сменить сервер", TPToSmall = "ТП в маленький", RemoveTags = "Убрать теги", ShareFav = "Поделиться избранным", ShareRct = "Поделиться недавними", TestURLs = "Проверить URL", SettingsBtn = "Настройки", Destroy = "Удалить XyqwHub", ResetOrder = "Сбросить порядок", PlaceId = "PlaceId", JobId = "JobId", Players = "Игроки", Creator = "Создатель", Presets = "Пресеты", AutoHideBind = "Бинд Auto-Hide:", ShareHub = "Поделиться XyqwHub", HideTopBar = "Скрыть топ бар", HideTopBarOn = "Скрыть: ВКЛ", HideTopBarOff = "Скрыть: ВЫКЛ", OrderSaved = "Порядок сохранён!", OrderReset = "Порядок сброшен!", AntiKickOn = "AntiKick: ВКЛ", AntiKickOff = "AntiKick: ВЫКЛ", AutoReinjectOn = "Auto-Reinject: ВКЛ", AutoReinjectOff = "Auto-Reinject: ВЫКЛ", ReinjectQueued = "XyqwHub перезагрузится после телепорта", ReinjectNotSupported = "Auto-Reinject не поддерживается", ExecutorInfoTitle = "Инфо об экзекьюторе", RunUNCTest = "Запустить UNC тест", RunSUNCTest = "Запустить sUNC тест", Testing = "Тестирование...", TestResult = "Результат", RejoinLastSession = "Rejoin Last Session", ChangeLogText = "Версия 7.6.1: Восстановлены все функции, защита от крашей." }

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

local function AddAntiKickLog(text)
    local entry = "[" .. os.date("%H:%M:%S") .. "] " .. tostring(text)
    table.insert(ANTI_KICK_LOGS, 1, entry)
    if #ANTI_KICK_LOGS > 50 then table.remove(ANTI_KICK_LOGS) end
    if _G.RefreshAntiKickLogs then _G.RefreshAntiKickLogs() end
end

local function StartAntiKick()
    if antiKickActive then return end
    getgenv().XyqwAntiKick = true
    
    local ok = pcall(function()
        if type(hookfunction) ~= "function" then error("hookfunction not supported") end
        local LP = Players.LocalPlayer
        if not LP or not LP.Kick then error("LocalPlayer.Kick not found") end
        
        antiKickOldKick = hookfunction(LP.Kick, function(self, ...)
            if getgenv().XyqwAntiKick then
                AddAntiKickLog("Blocked Kick()")
                ShowRobloxNotification("AntiKick: Blocked kick!", 3)
                return nil
            end
            if type(antiKickOldKick) == "function" then
                return antiKickOldKick(self, ...)
            end
            return nil 
        end)
        antiKickActive = true
    end)

    if not ok then
        getgenv().XyqwAntiKick = false
        antiKickActive = false
        AddAntiKickLog("Hook failed")
    end
end
task.spawn(function() task.wait(2); StartAntiKick() end)

-- ========== ТЕГИ ==========
local function GetRole(plr)
    for _, id in ipairs(OWNER_IDS) do if plr.UserId == id then return "OWNER" end end
    for _, id in ipairs(BETA_IDS) do if plr.UserId == id then return "TESTER" end end
    return nil
end

-- ========== ОСНОВНОЙ ИНТЕРФЕЙС ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XyqwHub_DEFAULT_" .. math.random(100000, 999999)
screenGui.ResetOnSpawn = false; screenGui.IgnoreGuiInset = true

local parentAssigned = false
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(screenGui); screenGui.Parent = CoreGui; parentAssigned = true; return end
    if protect_gui then protect_gui(screenGui); screenGui.Parent = CoreGui; parentAssigned = true; return end
    if gethui then screenGui.Parent = gethui(); parentAssigned = true; return end
end)
if not parentAssigned then pcall(function() screenGui.Parent = CoreGui end); if not screenGui.Parent then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end end

local dockButton = Instance.new("TextButton")
dockButton.Size = UDim2.new(0, 80, 0, 30)
dockButton.Position = UDim2.new(0.5, -40, 0.05, 42)
dockButton.BackgroundColor3 = RED_BG
dockButton.TextColor3 = RED_MAIN
dockButton.Text = "Xyqw"
dockButton.Font = Enum.Font.GothamBold
dockButton.BorderSizePixel = 2
dockButton.BorderColor3 = RED_MAIN
dockButton.Visible = false
dockButton.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 340)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
mainFrame.BackgroundColor3 = RED_BG
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = RED_MAIN
mainFrame.Parent = screenGui

local function OpenGui()
    mainFrame.Visible = true
    dockButton.Visible = false
end
local function CloseGui()
    mainFrame.Visible = false
    dockButton.Visible = true
end
dockButton.MouseButton1Click:Connect(OpenGui)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = RED_TITLE
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = HUB_NAME .. " | DEFAULT"
titleLabel.TextColor3 = RED_MAIN
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = RED_DARK
closeButton.TextColor3 = RED_MAIN
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 1
closeButton.BorderColor3 = RED_MAIN
closeButton.Parent = titleBar
closeButton.MouseButton1Click:Connect(CloseGui)

-- Перетаскивание
local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = mainFrame.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

-- Ресайз
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 14, 0, 14)
resizeHandle.Position = UDim2.new(1, -14, 1, -14)
resizeHandle.BackgroundColor3 = RED_MAIN
resizeHandle.Text = ""
resizeHandle.BorderSizePixel = 0
resizeHandle.Parent = mainFrame
local resizing, rsStart, rsSize = false, nil, nil
resizeHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; rsStart = input.Position; rsSize = mainFrame.Size end end)
UserInputService.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - rsStart; mainFrame.Size = UDim2.new(0, math.clamp(rsSize.X.Offset + delta.X, 280, 600), 0, math.clamp(rsSize.Y.Offset + delta.Y, 340, 600)) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end end)

-- Скролл
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2000)
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = RED_MAIN
scrollFrame.Parent = mainFrame

local yPos = 5
for _, data in ipairs(SCRIPTS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = RED_BG
    btn.TextColor3 = RED_MAIN
    btn.Text = data.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 2
    btn.BorderColor3 = RED_MAIN
    btn.Parent = scrollFrame
    yPos = yPos + 36
    
    btn.MouseButton1Click:Connect(function()
        btn.Text = "Loading..."
        btn.TextColor3 = Color3.fromRGB(255, 150, 0)
        task.spawn(function()
            local ok, err = pcall(function()
                if data.URL == "SPECIAL_COPY_DOORS_V2" then
                    local scriptText = 'getgenv().SCRIPT_KEY = "KEYLESS"\nloadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/abd3cc54d2dc7de4a091fb19c8f4ea9e15e939e7ecc88b475e6956e8af94ad6f/download"))()'
                    setclipboard(scriptText)
                else
                    loadstring(game:HttpGet(data.URL))()
                end
            end)
            if ok then
                btn.Text = data.Name .. " (OK)"
                btn.TextColor3 = Color3.fromRGB(0, 255, 100)
            else
                btn.Text = data.Name .. " (ERR)"
                btn.TextColor3 = RED_MAIN
            end
        end)
    end)
end

-- ========== СМЕНА ТЕМЫ ==========
local themeOrder = {"Red", "Blue", "Green", "Purple", "Pink", "Orange", "Cyan", "Yellow", "Lime", "Magenta", "White", "Rainbow", "Custom"}
local themeIndex = 1
for i, name in ipairs(themeOrder) do if name == THEME_NAME then themeIndex = i break end end

local function ApplyTheme(themeName)
    THEME_NAME = themeName
    SetSetting("theme", themeName)
    local t = THEMES[themeName] or THEMES.Red
    RED_MAIN = t.MAIN; RED_DARK = t.DARK; RED_BG = t.BG; RED_TITLE = t.TITLE
    
    mainFrame.BackgroundColor3 = RED_BG
    mainFrame.BorderColor3 = RED_MAIN
    titleBar.BackgroundColor3 = RED_TITLE
    titleLabel.TextColor3 = RED_MAIN
    closeButton.BackgroundColor3 = RED_DARK
    closeButton.TextColor3 = RED_MAIN
    closeButton.BorderColor3 = RED_MAIN
    scrollFrame.ScrollBarImageColor3 = RED_MAIN
    dockButton.BackgroundColor3 = RED_BG
    dockButton.TextColor3 = RED_MAIN
    dockButton.BorderColor3 = RED_MAIN
    
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = RED_BG
            child.TextColor3 = RED_MAIN
            child.BorderColor3 = RED_MAIN
        end
    end
end

local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(1, -10, 0, 32)
themeBtn.Position = UDim2.new(0, 5, 0, yPos)
themeBtn.BackgroundColor3 = RED_DARK
themeBtn.TextColor3 = RED_MAIN
themeBtn.Text = "Change Theme"
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 14
themeBtn.BorderSizePixel = 2
themeBtn.BorderColor3 = RED_MAIN
themeBtn.Parent = scrollFrame
yPos = yPos + 36

themeBtn.MouseButton1Click:Connect(function()
    themeIndex = themeIndex + 1
    if themeIndex > #themeOrder then themeIndex = 1 end
    ApplyTheme(themeOrder[themeIndex])
    ShowRobloxNotification("Theme: " .. THEME_NAME, 2)
end)

-- ========== CUSTOM COLOR ==========
local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(1, -10, 0, 32)
colorBtn.Position = UDim2.new(0, 5, 0, yPos)
colorBtn.BackgroundColor3 = RED_DARK
colorBtn.TextColor3 = RED_MAIN
colorBtn.Text = "Custom Color"
colorBtn.Font = Enum.Font.GothamBold
colorBtn.TextSize = 14
colorBtn.BorderSizePixel = 2
colorBtn.BorderColor3 = RED_MAIN
colorBtn.Parent = scrollFrame
yPos = yPos + 36

colorBtn.MouseButton1Click:Connect(function()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 150)
    frame.Position = UDim2.new(0.5, -125, 0.5, -75)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.Parent = screenGui

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 30)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Enter HEX (e.g. #FF0000)"
    lbl.TextColor3 = RED_MAIN
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 0, 30)
    input.Position = UDim2.new(0, 10, 0, 40)
    input.BackgroundColor3 = RED_DARK
    input.TextColor3 = RED_MAIN
    input.Text = "#FF0000"
    input.Font = Enum.Font.Gotham
    input.Parent = frame

    local apply = Instance.new("TextButton")
    apply.Size = UDim2.new(1, -20, 0, 30)
    apply.Position = UDim2.new(0, 10, 0, 80)
    apply.BackgroundColor3 = RED_MAIN
    apply.TextColor3 = Color3.fromRGB(0,0,0)
    apply.Text = "Apply"
    apply.Font = Enum.Font.GothamBold
    apply.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.BackgroundTransparency = 1
    close.Text = "X"
    close.TextColor3 = RED_MAIN
    close.Font = Enum.Font.GothamBold
    close.Parent = frame
    close.MouseButton1Click:Connect(function() frame:Destroy() end)

    apply.MouseButton1Click:Connect(function()
        local hex = input.Text:gsub("#", "")
        if #hex == 6 then
            local r, g, b = tonumber(hex:sub(1,2), 16), tonumber(hex:sub(3,4), 16), tonumber(hex:sub(5,6), 16)
            if r and g and b then
                THEMES.Custom.MAIN = Color3.fromRGB(r, g, b)
                THEMES.Custom.DARK = Color3.fromRGB(math.floor(r*0.15), math.floor(g*0.15), math.floor(b*0.15))
                ApplyTheme("Custom")
                frame:Destroy()
            end
        end
    end)
end)

-- ========== SERVER INFO ==========
local serverBtn = Instance.new("TextButton")
serverBtn.Size = UDim2.new(1, -10, 0, 32)
serverBtn.Position = UDim2.new(0, 5, 0, yPos)
serverBtn.BackgroundColor3 = RED_DARK
serverBtn.TextColor3 = RED_MAIN
serverBtn.Text = "Server Info"
serverBtn.Font = Enum.Font.GothamBold
serverBtn.TextSize = 14
serverBtn.BorderSizePixel = 2
serverBtn.BorderColor3 = RED_MAIN
serverBtn.Parent = scrollFrame
yPos = yPos + 36

serverBtn.MouseButton1Click:Connect(function()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 200)
    frame.Position = UDim2.new(0.5, -140, 0.5, -100)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.Parent = screenGui

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 1, -40)
    lbl.Position = UDim2.new(0, 5, 0, 30)
    lbl.BackgroundTransparency = 1
    lbl.Text = "PlaceId: " .. game.PlaceId .. "\nJobId: " .. game.JobId .. "\nPlayers: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
    lbl.TextColor3 = RED_MAIN
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "Server Info"
    title.TextColor3 = RED_MAIN
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.BackgroundTransparency = 1
    close.Text = "X"
    close.TextColor3 = RED_MAIN
    close.Font = Enum.Font.GothamBold
    close.Parent = frame
    close.MouseButton1Click:Connect(function() frame:Destroy() end)
end)

-- ========== СМЕНА ЯЗЫКА ==========
local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(1, -10, 0, 32)
langBtn.Position = UDim2.new(0, 5, 0, yPos)
langBtn.BackgroundColor3 = RED_DARK
langBtn.TextColor3 = RED_MAIN
langBtn.Text = "Language: " .. LANG_CODE
langBtn.Font = Enum.Font.GothamBold
langBtn.TextSize = 14
langBtn.BorderSizePixel = 2
langBtn.BorderColor3 = RED_MAIN
langBtn.Parent = scrollFrame
yPos = yPos + 36

langBtn.MouseButton1Click:Connect(function()
    local langs = {"EN", "RU"}
    local idx = 1
    for i, l in ipairs(langs) do if l == LANG_CODE then idx = i break end end
    idx = idx + 1
    if idx > #langs then idx = 1 end
    LANG_CODE = langs[idx]
    SetSetting("lang", LANG_CODE)
    langBtn.Text = "Language: " .. LANG_CODE
    ShowRobloxNotification("Language changed to " .. LANG_CODE, 3)
end)

-- ========== КНОПКА DESTROY ==========
local destroyBtn = Instance.new("TextButton")
destroyBtn.Size = UDim2.new(1, -10, 0, 32)
destroyBtn.Position = UDim2.new(0, 5, 0, yPos)
destroyBtn.BackgroundColor3 = RED_DARK
destroyBtn.TextColor3 = RED_MAIN
destroyBtn.Text = "Destroy XyqwHub"
destroyBtn.Font = Enum.Font.GothamBold
destroyBtn.TextSize = 14
destroyBtn.BorderSizePixel = 2
destroyBtn.BorderColor3 = RED_MAIN
destroyBtn.Parent = scrollFrame
yPos = yPos + 36

destroyBtn.MouseButton1Click:Connect(function()
    ShowRobloxNotification("XyqwHub Destroyed!", 2)
    pcall(function() 
        if delfile then delfile(CONFIG_FOLDER .. "/Logs/session.txt") end 
    end)
    screenGui:Destroy()
end)

-- Обновляем высоту скролла под все кнопки
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- Приветствие для владельцев
if GetRole(Players.LocalPlayer) == "OWNER" then
    task.spawn(function() task.wait(2); ShowRobloxNotification("Welcome, my father :3", 5) end)
elseif GetRole(Players.LocalPlayer) == "TESTER" then
    task.spawn(function() task.wait(2); ShowRobloxNotification("Glad you're here, tester <3", 5) end)
end

-- ========== КОНЕЦ XYQWHUB DEFAULT ==========
