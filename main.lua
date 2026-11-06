-- ========== XyqwHub | DEFAULT MODE - Версия 7.6.0 ==========
-- Обычная версия Хаба для игр без строгого античита.
-- Использует стандартный GetHttp и CoreGui.

-- 1. Очищаем лог краша, так как скрипт успешно запустился
pcall(function() 
    if delfile and isfile("XyqwHub/Logs/latestlog.txt") then 
        delfile("XyqwHub/Logs/latestlog.txt") 
    end 
end)

local function _s(...) return string.char(...) end
local HUB_NAME = _s(88,121,113,119,72,117,98)
local VERSION = "7.6.0 Default"
local OWNER_IDS = {4396977722, 8527910367}
local BETA_IDS = {9686718765, 3701387385}

local IS_RELAUNCH = (shared.XyqwHubRunning == true)
if IS_RELAUNCH then
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = HUB_NAME, Text = "Already running", Duration = 3}) end)
    return
end
shared.XyqwHubRunning = true

local _settings = {}
local function GetSetting(key, default) if _settings[key] == nil then return default end return _settings[key] end
local function SetSetting(key, value) _settings[key] = value end

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

pcall(function()
    if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
    if not isfolder(CONFIG_FOLDER .. "/FavScripts") then makefolder(CONFIG_FOLDER .. "/FavScripts") end
    if not isfolder(CONFIG_FOLDER .. "/RctScripts") then makefolder(CONFIG_FOLDER .. "/RctScripts") end
    if not isfolder(CONFIG_FOLDER .. "/CustomColor") then makefolder(CONFIG_FOLDER .. "/CustomColor") end
    if not isfolder(CONFIG_FOLDER .. "/AutoExecute") then makefolder(CONFIG_FOLDER .. "/AutoExecute") end
    if not isfolder(CONFIG_FOLDER .. "/Settings") then makefolder(CONFIG_FOLDER .. "/Settings") end
    if not isfolder(CONFIG_FOLDER .. "/Session") then makefolder(CONFIG_FOLDER .. "/Session") end
end)

local function SaveTable(path, tbl)
    pcall(function() if writefile then writefile(path, game:GetService("HttpService"):JSONEncode(tbl)) end end)
end

local function LoadTable(path)
    local ok, data = pcall(function()
        if readfile and isfile and isfile(path) then return game:GetService("HttpService"):JSONDecode(readfile(path)) end
        return nil
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

FAVORITES = LoadTable(FAV_FILE)
RECENT = LoadTable(RCT_FILE)
AUTOEXEC = LoadTable(AUTOEXEC_FILE)
ORDER = LoadTable(ORDER_FILE)

pcall(function()
    if writefile and game.JobId and game.JobId ~= "" then writefile(SESSION_FILE, game.JobId) end
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
if not THEMES[THEME_NAME] then THEME_NAME = "Red" end
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
Version 7.6.0 DEFAULT MODE
========================================
- Обычная версия (без обхода античитов).
- Быстрая загрузка через HttpGet.
- Стандартный интерфейс CoreGui.
- Заголовок изменен на "XyqwHub | DEFAULT MODE!".

========================================
Version 7.4.8 (INDEPENDENT)
========================================
- Собственный тихий байпасс логов.

========================================
Version 7.4.7
========================================
- UI Fix, Full format.

========================================
Version 7.4.6 BAC-6519 BYPASS
========================================
- НОВОЕ: Мгновенный авто-запуск при старте.

========================================
Version 7.4.5 STEALTH
========================================
- NO getgc, NO hookfunction (Adonis-safe).

========================================
Version 7.4.2
========================================
- УДАЛЁН hookmetamethod(game, "__namecall").

========================================
Version 7.4.1
========================================
- Advanced Auto-Reinject (5 fallback).

========================================
Version 7.4.0
========================================
- JJS script replaced, Auto-Rejoin.

========================================
Version 7.3.0
========================================
- Auto-AntiKick, Anti-getgc (REMOVED in 7.4.2).

========================================
Version 7.2.2
========================================
- AntiKick fix, Anti-Detect GUI.

========================================
Version 7.2.0
========================================
- Resizable/draggable windows.

========================================
Version 7.1.0
========================================
- Info button (UNC/sUNC).

========================================
Version 7.0
========================================
- Full changelog.

========================================
Version 6.9
========================================
- Fade animation, GUI size saved.

========================================
Version 6.7
========================================
- Rewritten from scratch, 48 scripts.

========================================
Version 6.3
========================================
- Blacklist removed, drag & drop.

========================================
Version 6.0
========================================
- 5 languages: EN, RU, UK, BE, KK.

========================================
Version 5.4
========================================
- Auto-execute, URL tester, sorting.

========================================
Version 5.1
========================================
- Share Fav/Rct scripts.

========================================
Version 5.0
========================================
- Custom Color instant.

========================================
Version 4.9
========================================
- Welcome smaller, 13 themes.

========================================
Version 4.7
========================================
- Custom Color picker.

========================================
Version 4.0
========================================
- Top bar, search, tabs, favorites, recent.

========================================
Version 3.7
========================================
- Tester tag (blue gradient).

========================================
Version 3.0
========================================
- OWNER tag, debug prints.

========================================
Version 2.9
========================================
- OWNER tag, gradient animation.

========================================
Version 2.7
========================================
- Roblox notifications, ChangeLog button.

========================================
Version 2.4
========================================
- Re-launch protection.

========================================
Version 2.0
========================================
- Auto Execute removed.

========================================
Version 1.9
========================================
- Doors V3 (Cheesy) key.

========================================
Version 1.6
========================================
- Steal an egg, Universal script.

========================================
Version 1.1
========================================
- Language switch (EN/RU).

========================================
Version 1.0
========================================
- First release.

XyqwHub 7.6.0 Default
Made with love by Xyqwerq]],
}
LANG.RU = {
    Loaded = "загружен", Error = "ошибка", Search = "Поиск...", CustomPlaceholder = "Ссылка...",
    RunCustom = "Запустить", JobIdCopied = "JobId скопирован!", ScriptExecuted = "Скрипт выполнен!",
    OwnerWelcome = "Welcome, my father :3", BetaWelcome = "Glad you're here, tester <3",
    TagRemoved = "Тег убран!", LangChanged = "Язык изменён на Русский",
    FavShared = "Избранное скопировано!", RctShared = "Недавние скопированы!",
    LoadstringCopied = "Loadstring скопирован!", ColorReset = "Цвет сброшен", ColorShared = "Цвет скопирован!",
    AutoExecOn = "Авто-запуск: ВКЛ", AutoExecOff = "Авто-запуск: ВЫКЛ",
    KeybindChanged = "Бинд Auto-Hide: ", UrlCheckStarted = "Проверка URL...", UrlCheckDone = "Проверка завершена!",
    WelcomeTitle = "Добро пожаловать в XyqwHub!", ClickXToClose = "Нажми X чтобы закрыть",
    PlayersTitle = "Игроки", ServerTitle = "Инфо о сервере", CustomTitle = "Свой скрипт",
    CustomColorTitle = "Свой цвет", ChangeLogTitle = "Ченджлог", SettingsTitle = "Настройки",
    Apply = "Применить", Reset = "Сбросить", ShareColor = "Поделиться цветом",
    CopyJobId = "Копировать JobId", Rejoin = "Перезайти", ServerHop = "Сменить сервер", TPToSmall = "ТП в маленький",
    RemoveTags = "Убрать теги", ShareFav = "Поделиться избранным", ShareRct = "Поделиться недавними",
    TestURLs = "Проверить URL", SettingsBtn = "Настройки", Destroy = "Удалить XyqwHub", ResetOrder = "Сбросить порядок",
    PlaceId = "PlaceId", JobId = "JobId", Players = "Игроки", Creator = "Создатель",
    Presets = "Пресеты", AutoHideBind = "Бинд Auto-Hide:", ShareHub = "Поделиться XyqwHub",
    HideTopBar = "Скрыть топ бар", HideTopBarOn = "Скрыть: ВКЛ", HideTopBarOff = "Скрыть: ВЫКЛ",
    OrderSaved = "Порядок сохранён!", OrderReset = "Порядок сброшен!", AntiKickOn = "AntiKick: ВКЛ", AntiKickOff = "AntiKick: ВЫКЛ",
    AutoReinjectOn = "Auto-Reinject: ВКЛ", AutoReinjectOff = "Auto-Reinject: ВЫКЛ",
    ReinjectQueued = "XyqwHub перезагрузится после телепорта", ReinjectNotSupported = "Auto-Reinject не поддерживается",
    ExecutorInfoTitle = "Инфо об экзекьюторе", RunUNCTest = "Запустить UNC тест", RunSUNCTest = "Запустить sUNC тест",
    Testing = "Тестирование...", TestResult = "Результат", RejoinLastSession = "Rejoin Last Session",
    ChangeLogText = [[XyqwHub Ченджлог (Полная история)

========================================
Версия 7.6.0 DEFAULT MODE
========================================
- Обычная версия (без обхода античитов).
- Быстрая загрузка через HttpGet.
- Стандартный интерфейс CoreGui.
- Заголовок изменен на "XyqwHub | DEFAULT MODE!".

========================================
Версия 7.4.8 (INDEPENDENT)
========================================
- Тихий байпасс логов.

========================================
Версия 7.4.7
========================================
- UI Fix.

========================================
Версия 7.4.6 BAC-6519 BYPASS
========================================
- Мгновенный авто-запуск.

========================================
Версия 7.4.5 STEALTH
========================================
- NO getgc, NO hookfunction.

========================================
Версия 7.4.2
========================================
- УДАЛЁН hookmetamethod.

========================================
Версия 7.4.1
========================================
- Auto-Reinject.

========================================
Версия 7.4.0
========================================
- JJS replaced.

========================================
Версия 7.3.0
========================================
- Anti-getgc (REMOVED).

========================================
Версия 7.2.2
========================================
- AntiKick fix.

========================================
Версия 7.2.0
========================================
- Resizable.

========================================
Версия 7.1.0
========================================
- Info button.

========================================
Версия 7.0
========================================
- Full changelog.

========================================
Версия 6.9
========================================
- Fade animation.

========================================
Версия 6.7
========================================
- Rewritten, 48 scripts.

========================================
Версия 6.3
========================================
- Blacklist removed.

========================================
Версия 6.0
========================================
- 5 languages.

========================================
Версия 5.4
========================================
- Auto-execute.

========================================
Версия 5.1
========================================
- Share Fav/Rct.

========================================
Версия 5.0
========================================
- Custom Color.

========================================
Версия 4.9
========================================
- 13 themes.

========================================
Версия 4.7
========================================
- Custom Color picker.

========================================
Версия 4.0
========================================
- Top bar, search.

========================================
Версия 3.7
========================================
- Tester tag.

========================================
Версия 3.0
========================================
- OWNER tag.

========================================
Версия 2.9
========================================
- OWNER gradient.

========================================
Версия 2.7
========================================
- Roblox notifications.

========================================
Версия 2.4
========================================
- Re-launch protection.

========================================
Версия 2.0
========================================
- Auto Execute removed.

========================================
Версия 1.9
========================================
- Doors V3 key.

========================================
Версия 1.6
========================================
- Steal an egg.

========================================
Версия 1.1
========================================
- Language switch.

========================================
Версия 1.0
========================================
- First release.

XyqwHub 7.6.0 Default]],
}
LANG.UK = { Loaded = "завантажено", Error = "помилка", Search = "Пошук...", ChangeLogText = [[XyqwHub Default Журнал]] }
LANG.BE = { Loaded = "загружана", Error = "памылка", Search = "Пошук...", ChangeLogText = [[XyqwHub Default Чэйнджлог]] }
LANG.KK = { Loaded = "жүктелді", Error = "қате", Search = "Іздеу...", ChangeLogText = [[XyqwHub Default Өзгерістер]] }

for _, lang in ipairs({"UK", "BE", "KK"}) do
    for k, v in pairs(LANG.EN) do if not LANG[lang][k] then LANG[lang][k] = v end end
end

local function _(key) return LANG[LANG_CODE] and LANG[LANG_CODE][key] or LANG.EN[key] or key end
local function ShowRobloxNotification(text, duration)
    duration = duration or 4
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = HUB_NAME, Text = tostring(text), Duration = duration}) end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ========== СТАНДАРТНЫЙ ANTIKICK ==========
local antiKickActive = false
local antiKickOldKick = nil

local function AddAntiKickLog(text)
    local ok, t = pcall(function() return os.date("%H:%M:%S") end)
    local entry = "[" .. (ok and t or "??:??:??") .. "] " .. tostring(text)
    table.insert(ANTI_KICK_LOGS, 1, entry)
    while #ANTI_KICK_LOGS > 50 do table.remove(ANTI_KICK_LOGS) end
    if _G.RefreshAntiKickLogs then pcall(_G.RefreshAntiKickLogs) end
end

local function StartAntiKick()
    if antiKickActive then return end
    getgenv().XyqwAntiKick = true
    SetSetting("antikick", true)
    
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
            return antiKickOldKick(self, ...)
        end)
        antiKickActive = true
    end)

    if not ok then
        getgenv().XyqwAntiKick = false
        antiKickActive = false
        AddAntiKickLog("Hook failed (Default mode)")
        ShowRobloxNotification("AntiKick: hookfunction unavailable", 4)
    else
        AddAntiKickLog("AntiKick enabled (Default hook)")
    end
end

local function StopAntiKick()
    getgenv().XyqwAntiKick = false
    SetSetting("antikick", false)
    antiKickActive = false
    AddAntiKickLog("AntiKick disabled")
    ShowRobloxNotification(_("AntiKickOff"), 2)
end

getgenv().XyqwAntiKick = false
SetSetting("antikick", false)

task.spawn(function()
    task.wait(2)
    StartAntiKick()
end)

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

-- ========== ТЕГИ ==========
local function IsOwner() for _, id in ipairs(OWNER_IDS) do if Players.LocalPlayer.UserId == id then return true end end return false end
local function IsBeta() for _, id in ipairs(BETA_IDS) do if Players.LocalPlayer.UserId == id then return true end end return false end

local tagsEnabled = true
local activeTags = {}
local function GetRole(plr)
    for _, id in ipairs(OWNER_IDS) do if plr.UserId == id then return "OWNER" end end
    for _, id in ipairs(BETA_IDS) do if plr.UserId == id then return "TESTER" end end
    return nil
end

local function CreateTagForPlayer(plr)
    if not tagsEnabled then return end
    local role = GetRole(plr)
    if not role then return end
    if activeTags[plr] and activeTags[plr].Parent then return end
    local char = plr.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "T" .. math.random(1000, 9999)
    billboard.Size = UDim2.new(0, 160, 0, 20); billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true; billboard.LightInfluence = 0; billboard.MaxDistance = 500; billboard.Adornee = rootPart; billboard.Parent = char
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 18); label.Position = UDim2.new(0.5, -75, 0.5, -9)
    label.BackgroundTransparency = 1; label.Font = Enum.Font.GothamBold; label.TextSize = 14
    label.TextStrokeTransparency = 0; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); label.Parent = billboard
    local gradient = Instance.new("UIGradient")
    if role == "OWNER" then
        label.Text = HUB_NAME .. " OWNER"
        gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))})
    else
        label.Text = HUB_NAME .. " Tester"
        gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 120, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 20, 60)), ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 120, 255))})
    end
    gradient.Parent = label
    local glow = Instance.new("UIStroke")
    glow.Color = role == "OWNER" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 120, 255)
    glow.Thickness = 1; glow.Transparency = 0.3; glow.Parent = label
    task.spawn(function()
        local rotation = 0
        while label.Parent and tagsEnabled do rotation = (rotation + 2) % 360; gradient.Rotation = rotation; task.wait(0.03) end
    end)
    activeTags[plr] = billboard
end

local function RemoveTagForPlayer(plr) if activeTags[plr] then activeTags[plr]:Destroy() activeTags[plr] = nil end end
local function RemoveAllTags()
    tagsEnabled = false
    for plr, tag in pairs(activeTags) do if tag and tag.Parent then tag:Destroy() end end
    activeTags = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            for _, child in ipairs(char:GetChildren()) do if child.Name:sub(1,1) == "T" and child:IsA("BillboardGui") then child:Destroy() end end
        end
    end
end
local function CheckAllPlayers()
    if not tagsEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do if GetRole(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then CreateTagForPlayer(plr) end end
end
local function SetupCharacterTag(plr)
    task.spawn(function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local rootPart = char:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        activeTags[plr] = nil; task.wait(0.5)
        if GetRole(plr) and tagsEnabled then CreateTagForPlayer(plr) end
    end)
end

CheckAllPlayers()
AddHeartbeatTask(CheckAllPlayers)
Players.PlayerAdded:Connect(function(plr) SetupCharacterTag(plr); plr.CharacterAdded:Connect(function() SetupCharacterTag(plr) end) end)
Players.PlayerRemoving:Connect(RemoveTagForPlayer)
for _, plr in ipairs(Players:GetPlayers()) do SetupCharacterTag(plr); plr.CharacterAdded:Connect(function() SetupCharacterTag(plr) end) end

local VirtualUser = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

local fpsValue = 60
local fpsCounter, fpsTime = 0, 0
AddRenderTask(function(dt) fpsCounter = fpsCounter + 1; fpsTime = fpsTime + dt; if fpsTime >= 1 then fpsValue = fpsCounter; fpsCounter = 0; fpsTime = 0 end end)

local function GetPing() local ok, ping = pcall(function() return math.floor(Players.LocalPlayer:GetNetworkPing() * 1000) end); return ok and ping or 0 end
local function GetExecutorName() local ok, name = pcall(function() if identifyexecutor then return identifyexecutor() end return "Unknown" end); return ok and name or "Unknown" end

-- ========== ОБЫЧНЫЙ SCREEN GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XyqwHub_DEFAULT_" .. math.random(100000, 999999)
screenGui.ResetOnSpawn = false; screenGui.IgnoreGuiInset = true; screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; screenGui.DisplayOrder = 999

local parentAssigned = false
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(screenGui); screenGui.Parent = CoreGui; parentAssigned = true; return end
    if protect_gui then protect_gui(screenGui); screenGui.Parent = CoreGui; parentAssigned = true; return end
    if gethui then screenGui.Parent = gethui(); parentAssigned = true; return end
end)
if not parentAssigned then pcall(function() screenGui.Parent = CoreGui end); if not screenGui.Parent then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end end

local globalDrag = false
local topBar = Instance.new("TextButton")
topBar.Name = "TopBar"; topBar.Size = UDim2.new(0, 420, 0, 24); topBar.Position = UDim2.new(0.5, -210, 0, 10)
topBar.BackgroundColor3 = RED_BG; topBar.BorderSizePixel = 2; topBar.BorderColor3 = RED_MAIN; topBar.Text = ""; topBar.AutoButtonColor = false; topBar.Active = true; topBar.Parent = screenGui

local topBarText = Instance.new("TextLabel")
topBarText.Size = UDim2.new(1, -50, 1, 0); topBarText.Position = UDim2.new(0, 5, 0, 0); topBarText.BackgroundTransparency = 1
topBarText.Font = Enum.Font.GothamBold; topBarText.TextSize = 12; topBarText.TextColor3 = RED_MAIN; topBarText.TextXAlignment = Enum.TextXAlignment.Left; topBarText.Text = "..."; topBarText.Parent = topBar

task.spawn(function() while topBarText.Parent do topBarText.Text = string.format("%s | %s | FPS: %d | Ping: %d ms", GetExecutorName(), Players.LocalPlayer.Name, fpsValue, GetPing()); task.wait(1) end end)

local hideTopBtn = Instance.new("TextButton")
hideTopBtn.Name = "H"; hideTopBtn.Size = UDim2.new(0, 45, 1, 0); hideTopBtn.Position = UDim2.new(1, -45, 0, 0)
hideTopBtn.BackgroundColor3 = RED_DARK; hideTopBtn.TextColor3 = RED_MAIN; hideTopBtn.Text = "H"; hideTopBtn.TextScaled = true
hideTopBtn.Font = Enum.Font.GothamBold; hideTopBtn.BorderSizePixel = 1; hideTopBtn.BorderColor3 = RED_MAIN; hideTopBtn.Parent = topBar; hideTopBtn.AutoButtonColor = false

local topBarDragging, topBarDragStart, topBarStartPos = false, nil, nil
topBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then if input.Position.X >= (topBar.AbsolutePosition.X + topBar.AbsoluteSize.X - 45) then return end; topBarDragging = true; topBarDragStart = input.Position; topBarStartPos = topBar.Position end end)
topBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then topBarDragging = false end end)
UserInputService.InputChanged:Connect(function(input) if topBarDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - topBarDragStart; topBar.Position = UDim2.new(topBarStartPos.X.Scale, topBarStartPos.X.Offset + delta.X, topBarStartPos.Y.Scale, topBarStartPos.Y.Offset + delta.Y) end end)

local function UpdateHideTopBtn()
    if TOPBAR_HIDDEN then hideTopBtn.Text = "S"; topBar.BackgroundTransparency = 1; topBar.BorderSizePixel = 0; topBarText.Visible = false
    else hideTopBtn.Text = "H"; topBar.BackgroundTransparency = 0; topBar.BorderSizePixel = 2; topBarText.Visible = true end
end
UpdateHideTopBtn()

hideTopBtn.MouseButton1Click:Connect(function() TOPBAR_HIDDEN = not TOPBAR_HIDDEN; SetSetting("topbar", TOPBAR_HIDDEN); ShowRobloxNotification(TOPBAR_HIDDEN and _("HideTopBarOn") or _("HideTopBarOff"), 2); UpdateHideTopBtn() end)

local dockButton = Instance.new("TextButton")
dockButton.Name = "DockButton"; dockButton.Size = UDim2.new(0, 90, 0, 26); dockButton.Position = UDim2.new(0.5, -45, 0.05, 42)
dockButton.BackgroundColor3 = RED_BG; dockButton.TextColor3 = RED_MAIN; dockButton.Text = HUB_NAME; dockButton.TextScaled = true
dockButton.Font = Enum.Font.GothamBold; dockButton.BorderSizePixel = 2; dockButton.BorderColor3 = RED_MAIN
dockButton.Parent = screenGui; dockButton.Visible = false; dockButton.AutoButtonColor = false; dockButton.Active = true; dockButton.ZIndex = 999

local dockDragging, dockDragStart, dockStartPos, dockDragMoved = false, nil, nil, false
dockButton.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dockDragging = true; dockDragMoved = false; dockDragStart = input.Position; dockStartPos = dockButton.Position end end)
UserInputService.InputChanged:Connect(function(input)
    if dockDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dockDragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then dockDragMoved = true end
        if dockDragMoved then dockButton.Position = UDim2.new(dockStartPos.X.Scale, dockStartPos.X.Offset + delta.X, dockStartPos.Y.Scale, dockStartPos.Y.Offset + delta.Y) end
    end
end)

local savedSize = UDim2.new(0, 280, 0, 340)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "M" .. math.random(1000, 9999); mainFrame.Size = savedSize; mainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
mainFrame.BackgroundColor3 = RED_BG; mainFrame.BorderSizePixel = 3; mainFrame.BorderColor3 = RED_MAIN; mainFrame.ClipsDescendants = false; mainFrame.Active = true; mainFrame.Parent = screenGui

local function OpenGui()
    if mainFrame.Visible then return end
    mainFrame.Visible = true; dockButton.Visible = false; mainFrame.Size = savedSize; mainFrame.BackgroundTransparency = 1
    local tween1 = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    tween1:Play()
    tween1.Completed:Connect(function() UpdateTabLayout(); UpdateScriptButtonLayout(); UpdateHeaderLayout() end)
end

local function CloseGui()
    savedSize = mainFrame.Size
    local tween1 = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    tween1:Play()
    tween1.Completed:Connect(function() mainFrame.Visible = false; dockButton.Visible = true; mainFrame.BackgroundTransparency = 0; mainFrame.Size = savedSize; UpdateTabLayout(); UpdateScriptButtonLayout(); UpdateHeaderLayout() end)
end

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dockDragging and not dockDragMoved then OpenGui() end
        dockDragging = false
    end
end)

local clickBlocker = Instance.new("TextButton")
clickBlocker.Name = "C"; clickBlocker.Size = UDim2.new(1, 0, 1, 0); clickBlocker.BackgroundTransparency = 1
clickBlocker.Text = ""; clickBlocker.Active = true; clickBlocker.AutoButtonColor = false; clickBlocker.ZIndex = 0; clickBlocker.Parent = mainFrame

-- ========== TITLE BAR ==========
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"; titleBar.Size = UDim2.new(1, 0, 0, 30); titleBar.BackgroundColor3 = RED_TITLE; titleBar.BorderSizePixel = 0; titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"; titleLabel.Size = UDim2.new(0, 120, 1, 0); titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1; titleLabel.Text = HUB_NAME .. " | DEFAULT MODE!"; titleLabel.TextColor3 = RED_MAIN; titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold; titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseBtn"; closeButton.BackgroundColor3 = RED_DARK; closeButton.TextColor3 = RED_MAIN; closeButton.Text = "X"
closeButton.TextScaled = true; closeButton.Font = Enum.Font.GothamBold; closeButton.BorderSizePixel = 1; closeButton.BorderColor3 = RED_MAIN; closeButton.Parent = titleBar; closeButton.AutoButtonColor = false

local langButton = Instance.new("TextButton")
langButton.Name = "LangBtn"; langButton.BackgroundColor3 = RED_DARK; langButton.TextColor3 = RED_MAIN; langButton.Text = LANG_CODE
langButton.TextScaled = true; langButton.Font = Enum.Font.GothamBold; langButton.BorderSizePixel = 1; langButton.BorderColor3 = RED_MAIN; langButton.Parent = titleBar; langButton.AutoButtonColor = false

local serverBtn = Instance.new("TextButton")
serverBtn.Name = "ServerBtn"; serverBtn.BackgroundColor3 = RED_DARK; serverBtn.TextColor3 = RED_MAIN; serverBtn.Text = "S"
serverBtn.TextScaled = true; serverBtn.Font = Enum.Font.GothamBold; serverBtn.BorderSizePixel = 1; serverBtn.BorderColor3 = RED_MAIN; serverBtn.Parent = titleBar; serverBtn.AutoButtonColor = false

local playerBtn = Instance.new("TextButton")
playerBtn.Name = "PlayerBtn"; playerBtn.BackgroundColor3 = RED_DARK; playerBtn.TextColor3 = RED_MAIN; playerBtn.Text = "P"
playerBtn.TextScaled = true; playerBtn.Font = Enum.Font.GothamBold; playerBtn.BorderSizePixel = 1; playerBtn.BorderColor3 = RED_MAIN; playerBtn.Parent = titleBar; playerBtn.AutoButtonColor = false

local customBtn = Instance.new("TextButton")
customBtn.Name = "CustomBtn"; customBtn.BackgroundColor3 = RED_DARK; customBtn.TextColor3 = RED_MAIN; customBtn.Text = "C"
customBtn.TextScaled = true; customBtn.Font = Enum.Font.GothamBold; customBtn.BorderSizePixel = 1; customBtn.BorderColor3 = RED_MAIN; customBtn.Parent = titleBar; customBtn.AutoButtonColor = false

local changelogButton = Instance.new("TextButton")
changelogButton.Name = "ChLogBtn"; changelogButton.BackgroundColor3 = RED_DARK; changelogButton.TextColor3 = RED_MAIN; changelogButton.Text = "CL"
changelogButton.TextScaled = true; changelogButton.Font = Enum.Font.GothamBold; changelogButton.BorderSizePixel = 1; changelogButton.BorderColor3 = RED_MAIN; changelogButton.Parent = titleBar; changelogButton.AutoButtonColor = false

local themeBtn = Instance.new("TextButton")
themeBtn.Name = "ThemeBtn"; themeBtn.BackgroundColor3 = RED_DARK; themeBtn.TextColor3 = RED_MAIN; themeBtn.Text = "Th"
themeBtn.TextScaled = true; themeBtn.Font = Enum.Font.GothamBold; themeBtn.BorderSizePixel = 1; themeBtn.BorderColor3 = RED_MAIN; themeBtn.Parent = titleBar; themeBtn.AutoButtonColor = false

local colorBtn = Instance.new("TextButton")
colorBtn.Name = "ColorBtn"; colorBtn.BackgroundColor3 = RED_DARK; colorBtn.TextColor3 = RED_MAIN; colorBtn.Text = "CC"
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
    local titleW = 120
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
searchBar.Name = "SearchBar"; searchBar.Size = UDim2.new(1, -50, 0, 24); searchBar.Position = UDim2.new(0, 5, 0, 35)
searchBar.BackgroundColor3 = RED_DARK; searchBar.PlaceholderText = _("Search"); searchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBar.Text = ""; searchBar.TextColor3 = RED_MAIN; searchBar.TextSize = 12; searchBar.Font = Enum.Font.Gotham
searchBar.TextXAlignment = Enum.TextXAlignment.Left; searchBar.ClearTextOnFocus = false; searchBar.BorderSizePixel = 1; searchBar.BorderColor3 = RED_MAIN; searchBar.Parent = mainFrame

local infoBtn = Instance.new("TextButton")
infoBtn.Name = "InfoBtn"; infoBtn.Size = UDim2.new(0, 40, 0, 24); infoBtn.Position = UDim2.new(1, -45, 0, 35)
infoBtn.BackgroundColor3 = RED_DARK; infoBtn.TextColor3 = RED_MAIN; infoBtn.Text = "Info"; infoBtn.TextScaled = true
infoBtn.Font = Enum.Font.GothamBold; infoBtn.BorderSizePixel = 1; infoBtn.BorderColor3 = RED_MAIN; infoBtn.Parent = mainFrame; infoBtn.AutoButtonColor = false

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"; tabBar.Size = UDim2.new(1, -10, 0, 24); tabBar.Position = UDim2.new(0, 5, 0, 64)
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
scrollFrame.Name = "ScriptScroll"; scrollFrame.Size = UDim2.new(1, -10, 1, -98); scrollFrame.Position = UDim2.new(0, 5, 0, 93)
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
    dragStrip.Name = "DragStrip"; dragStrip.Size = UDim2.new(0, 25, 1, 0); dragStrip.Position = UDim2.new(0, 0, 0, 0)
    dragStrip.BackgroundColor3 = RED_MAIN; dragStrip.BackgroundTransparency = 0.6; dragStrip.BorderSizePixel = 0; dragStrip.ZIndex = 2; dragStrip.Parent = container

    local statusDot = Instance.new("Frame")
    statusDot.Name = "StatusDot"; statusDot.Size = UDim2.new(0, 6, 0, 6); statusDot.Position = UDim2.new(0, 12, 0.5, -3)
    statusDot.BackgroundColor3 = URL_UNKNOWN; statusDot.BorderSizePixel = 0; statusDot.ZIndex = 3; statusDot.Parent = container

    local btn = Instance.new("TextButton")
    btn.Name = "MainBtn"; btn.Size = UDim2.new(1, -95, 1, 0); btn.Position = UDim2.new(0, 30, 0, 0); btn.BackgroundTransparency = 1
    btn.TextColor3 = RED_MAIN; btn.Text = data.Name; btn.TextScaled = false; btn.TextSize = 17; btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left; btn.TextTruncate = Enum.TextTruncate.AtEnd; btn.ZIndex = 2; btn.Parent = container; btn.AutoButtonColor = false

    local autoBtn = Instance.new("TextButton")
    autoBtn.Name = "AutoBtn"; autoBtn.Size = UDim2.new(0, 24, 1, 0); autoBtn.Position = UDim2.new(1, -52, 0, 0)
    autoBtn.BackgroundColor3 = RED_BG; autoBtn.TextColor3 = RED_MAIN; autoBtn.Text = "▶"; autoBtn.TextScaled = true
    autoBtn.Font = Enum.Font.GothamBold; autoBtn.BorderSizePixel = 1; autoBtn.BorderColor3 = RED_MAIN; autoBtn.ZIndex = 2; autoBtn.Parent = container; autoBtn.AutoButtonColor = false
    if AUTOEXEC[data.Name] then autoBtn.Text = "✓"; autoBtn.BackgroundColor3 = RED_MAIN; autoBtn.TextColor3 = Color3.fromRGB(0, 0, 0) end
    autoBtn.MouseButton1Click:Connect(function()
        if AUTOEXEC[data.Name] then
            AUTOEXEC[data.Name] = nil; TweenColor(autoBtn, "BackgroundColor3", RED_BG); autoBtn.TextColor3 = RED_MAIN; ShowRobloxNotification(data.Name .. " — " .. _("AutoExecOff"), 3)
        else
            AUTOEXEC[data.Name] = true; TweenColor(autoBtn, "BackgroundColor3", RED_MAIN); autoBtn.TextColor3 = Color3.fromRGB(0, 0, 0); ShowRobloxNotification(data.Name .. " — " .. _("AutoExecOn"), 3)
        end
        SetSetting("autoexec", AUTOEXEC); SaveTable(AUTOEXEC_FILE, AUTOEXEC); UpdateScriptButtonLayout()
    end)

    local star = Instance.new("TextButton")
    star.Name = "Star"; star.Size = UDim2.new(0, 24, 1, 0); star.Position = UDim2.new(1, -26, 0, 0)
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
        elseif data.URL == JJS_URL then
            ShowRobloxNotification("Хей!! Этот скрипт был сделан мной (Xyqwerq)! Наслаждайся :)", 6); task.wait(1)
            local success = pcall(function() loadstring(game:HttpGet(data.URL))() end)
            if success then ShowRobloxNotification(data.Name .. " - " .. _("ScriptExecuted"), 3) else ShowRobloxNotification(data.Name .. " - " .. _("Error"), 5) end
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
                if curIdx ~= targetIdx then
                    local entry = table.remove(buttons, curIdx); table.insert(buttons, targetIdx, entry); SaveOrder(); ShowRobloxNotification(_("OrderSaved"), 2)
                end
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

-- ========== СПЕЦ-КНОПКИ ВНИЗУ ==========
local removeTagsContainer = Instance.new("Frame")
removeTagsContainer.Size = UDim2.new(1, -10, 0, 32); removeTagsContainer.Position = UDim2.new(0, 5, 0, 0)
removeTagsContainer.BackgroundColor3 = RED_BG; removeTagsContainer.BorderSizePixel = 2; removeTagsContainer.BorderColor3 = RED_MAIN; removeTagsContainer.Parent = scrollFrame; removeTagsContainer.Visible = false

local removeTagsBtn = Instance.new("TextButton")
removeTagsBtn.Size = UDim2.new(1, 0, 1, 0); removeTagsBtn.BackgroundTransparency = 1; removeTagsBtn.Text = _("RemoveTags")
removeTagsBtn.TextColor3 = RED_MAIN; removeTagsBtn.TextScaled = true; removeTagsBtn.Font = Enum.Font.GothamBold; removeTagsBtn.Parent = removeTagsContainer; removeTagsBtn.AutoButtonColor = false
removeTagsBtn.MouseEnter:Connect(function() TweenColor(removeTagsContainer, "BackgroundColor3", RED_DARK, 0.12) end)
removeTagsBtn.MouseLeave:Connect(function() TweenColor(removeTagsContainer, "BackgroundColor3", RED_BG, 0.15) end)
removeTagsBtn.MouseButton1Click:Connect(function() RemoveAllTags(); ShowRobloxNotification(_("TagRemoved"), 3) end)

local shareFavContainer = Instance.new("Frame")
shareFavContainer.Size = UDim2.new(1, -10, 0, 32); shareFavContainer.Position = UDim2.new(0, 5, 0, 0)
shareFavContainer.BackgroundColor3 = RED_BG; shareFavContainer.BorderSizePixel = 2; shareFavContainer.BorderColor3 = RED_MAIN; shareFavContainer.Parent = scrollFrame; shareFavContainer.Visible = false

local shareFavBtn = Instance.new("TextButton")
shareFavBtn.Size = UDim2.new(1, 0, 1, 0); shareFavBtn.BackgroundTransparency = 1; shareFavBtn.Text = _("ShareFav")
shareFavBtn.TextColor3 = RED_MAIN; shareFavBtn.TextScaled = true; shareFavBtn.Font = Enum.Font.GothamBold; shareFavBtn.Parent = shareFavContainer; shareFavBtn.AutoButtonColor = false
shareFavBtn.MouseEnter:Connect(function() TweenColor(shareFavContainer, "BackgroundColor3", RED_DARK, 0.12) end)
shareFavBtn.MouseLeave:Connect(function() TweenColor(shareFavContainer, "BackgroundColor3", RED_BG, 0.15) end)
shareFavBtn.MouseButton1Click:Connect(function()
    local list = {}; for name, _ in pairs(FAVORITES) do table.insert(list, name) end; table.sort(list)
    local text = HUB_NAME .. " - My Favorite Scripts:\n"
    if #list == 0 then text = text .. "(empty)" else for i, name in ipairs(list) do text = text .. i .. ". " .. name .. "\n" end end
    text = text .. "\nGenerated by " .. HUB_NAME .. " " .. VERSION; pcall(function() setclipboard(text) end); ShowRobloxNotification(_("FavShared"), 3)
end)

local shareRctContainer = Instance.new("Frame")
shareRctContainer.Size = UDim2.new(1, -10, 0, 32); shareRctContainer.Position = UDim2.new(0, 5, 0, 0)
shareRctContainer.BackgroundColor3 = RED_BG; shareRctContainer.BorderSizePixel = 2; shareRctContainer.BorderColor3 = RED_MAIN; shareRctContainer.Parent = scrollFrame; shareRctContainer.Visible = false

local shareRctBtn = Instance.new("TextButton")
shareRctBtn.Size = UDim2.new(1, 0, 1, 0); shareRctBtn.BackgroundTransparency = 1; shareRctBtn.Text = _("ShareRct")
shareRctBtn.TextColor3 = RED_MAIN; shareRctBtn.TextScaled = true; shareRctBtn.Font = Enum.Font.GothamBold; shareRctBtn.Parent = shareRctContainer; shareRctBtn.AutoButtonColor = false
shareRctBtn.MouseEnter:Connect(function() TweenColor(shareRctContainer, "BackgroundColor3", RED_DARK, 0.12) end)
shareRctBtn.MouseLeave:Connect(function() TweenColor(shareRctContainer, "BackgroundColor3", RED_BG, 0.15) end)
shareRctBtn.MouseButton1Click:Connect(function()
    local text = HUB_NAME .. " - My Recent Scripts:\n"
    if #RECENT == 0 then text = text .. "(empty)" else for i, name in ipairs(RECENT) do text = text .. i .. ". " .. name .. "\n" end end
    text = text .. "\nGenerated by " .. HUB_NAME .. " " .. VERSION; pcall(function() setclipboard(text) end); ShowRobloxNotification(_("RctShared"), 3)
end)

local urlTestContainer = Instance.new("Frame")
urlTestContainer.Size = UDim2.new(1, -10, 0, 32); urlTestContainer.Position = UDim2.new(0, 5, 0, 0)
urlTestContainer.BackgroundColor3 = RED_BG; urlTestContainer.BorderSizePixel = 2; urlTestContainer.BorderColor3 = RED_MAIN; urlTestContainer.Parent = scrollFrame; urlTestContainer.Visible = false

local urlTestBtn = Instance.new("TextButton")
urlTestBtn.Size = UDim2.new(1, 0, 1, 0); urlTestBtn.BackgroundTransparency = 1; urlTestBtn.Text = _("TestURLs")
urlTestBtn.TextColor3 = RED_MAIN; urlTestBtn.TextScaled = true; urlTestBtn.Font = Enum.Font.GothamBold; urlTestBtn.Parent = urlTestContainer; urlTestBtn.AutoButtonColor = false
urlTestBtn.MouseEnter:Connect(function() TweenColor(urlTestContainer, "BackgroundColor3", RED_DARK, 0.12) end)
urlTestBtn.MouseLeave:Connect(function() TweenColor(urlTestContainer, "BackgroundColor3", RED_BG, 0.15) end)

local settingsContainer = Instance.new("Frame")
settingsContainer.Size = UDim2.new(1, -10, 0, 32); settingsContainer.Position = UDim2.new(0, 5, 0, 0)
settingsContainer.BackgroundColor3 = RED_BG; settingsContainer.BorderSizePixel = 2; settingsContainer.BorderColor3 = RED_MAIN; settingsContainer.Parent = scrollFrame; settingsContainer.Visible = false

local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(1, 0, 1, 0); settingsBtn.BackgroundTransparency = 1; settingsBtn.Text = _("SettingsBtn")
settingsBtn.TextColor3 = RED_MAIN; settingsBtn.TextScaled = true; settingsBtn.Font = Enum.Font.GothamBold; settingsBtn.Parent = settingsContainer; settingsBtn.AutoButtonColor = false
settingsBtn.MouseEnter:Connect(function() TweenColor(settingsContainer, "BackgroundColor3", RED_DARK, 0.12) end)
settingsBtn.MouseLeave:Connect(function() TweenColor(settingsContainer, "BackgroundColor3", RED_BG, 0.15) end)

local resetOrderContainer = Instance.new("Frame")
resetOrderContainer.Size = UDim2.new(1, -10, 0, 32); resetOrderContainer.Position = UDim2.new(0, 5, 0, 0)
resetOrderContainer.BackgroundColor3 = RED_BG; resetOrderContainer.BorderSizePixel = 2; resetOrderContainer.BorderColor3 = RED_MAIN; resetOrderContainer.Parent = scrollFrame; resetOrderContainer.Visible = false

local resetOrderBtn = Instance.new("TextButton")
resetOrderBtn.Size = UDim2.new(1, 0, 1, 0); resetOrderBtn.BackgroundTransparency = 1; resetOrderBtn.Text = _("ResetOrder")
resetOrderBtn.TextColor3 = RED_MAIN; resetOrderBtn.TextScaled = true; resetOrderBtn.Font = Enum.Font.GothamBold; resetOrderBtn.Parent = resetOrderContainer; resetOrderBtn.AutoButtonColor = false
resetOrderBtn.MouseEnter:Connect(function() TweenColor(resetOrderContainer, "BackgroundColor3", RED_DARK, 0.12) end)
resetOrderBtn.MouseLeave:Connect(function() TweenColor(resetOrderContainer, "BackgroundColor3", RED_BG, 0.15) end)
resetOrderBtn.MouseButton1Click:Connect(function()
    ORDER = {}; SetSetting("order", ORDER); SaveTable(ORDER_FILE, {})
    for _, entry in ipairs(buttons) do entry.Container:Destroy() end
    buttons = {}; for _, data in ipairs(SCRIPTS) do CreateScriptButton(data) end
    if _G.RefreshButtons then _G.RefreshButtons() end; ShowRobloxNotification(_("OrderReset"), 3)
end)

local antiKickContainer = Instance.new("Frame")
antiKickContainer.Size = UDim2.new(1, -10, 0, 32); antiKickContainer.Position = UDim2.new(0, 5, 0, 0)
antiKickContainer.BackgroundColor3 = RED_BG; antiKickContainer.BorderSizePixel = 2; antiKickContainer.BorderColor3 = RED_MAIN; antiKickContainer.Parent = scrollFrame; antiKickContainer.Visible = false

local antiKickBtn = Instance.new("TextButton")
antiKickBtn.Name = "AntiKickBtn"; antiKickBtn.Size = UDim2.new(1, 0, 1, 0); antiKickBtn.BackgroundTransparency = 1
antiKickBtn.TextColor3 = RED_MAIN; antiKickBtn.TextScaled = true; antiKickBtn.Font = Enum.Font.GothamBold; antiKickBtn.Parent = antiKickContainer; antiKickBtn.AutoButtonColor = false

local function UpdateAntiKickText()
    if getgenv().XyqwAntiKick then
        antiKickBtn.Text = "AntiKick Settings — ON (Default)"
        antiKickBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        antiKickBtn.Text = "AntiKick Settings — OFF"
        antiKickBtn.TextColor3 = RED_MAIN
    end
end
UpdateAntiKickText()

antiKickBtn.MouseEnter:Connect(function() TweenColor(antiKickContainer, "BackgroundColor3", RED_DARK, 0.12) end)
antiKickBtn.MouseLeave:Connect(function() TweenColor(antiKickContainer, "BackgroundColor3", RED_BG, 0.15) end)

local ShowAntiKickSettings
antiKickBtn.MouseButton1Click:Connect(function() if ShowAntiKickSettings then ShowAntiKickSettings() end end)

local destroyContainer = Instance.new("Frame")
destroyContainer.Size = UDim2.new(1, -10, 0, 32); destroyContainer.Position = UDim2.new(0, 5, 0, 0)
destroyContainer.BackgroundColor3 = RED_BG; destroyContainer.BorderSizePixel = 2; destroyContainer.BorderColor3 = RED_MAIN; destroyContainer.Parent = scrollFrame; destroyContainer.Visible = false

local destroyBtnMain = Instance.new("TextButton")
destroyBtnMain.Size = UDim2.new(1, 0, 1, 0); destroyBtnMain.BackgroundTransparency = 1; destroyBtnMain.Text = _("Destroy")
destroyBtnMain.TextColor3 = RED_MAIN; destroyBtnMain.TextScaled = true; destroyBtnMain.Font = Enum.Font.GothamBold; destroyBtnMain.Parent = destroyContainer; destroyBtnMain.AutoButtonColor = false
destroyBtnMain.MouseEnter:Connect(function() TweenColor(destroyContainer, "BackgroundColor3", RED_DARK, 0.12) end)
destroyBtnMain.MouseLeave:Connect(function() TweenColor(destroyContainer, "BackgroundColor3", RED_BG, 0.15) end)
destroyBtnMain.MouseButton1Click:Connect(function() ShowRobloxNotification(HUB_NAME .. " Destroyed!", 2); shared.XyqwHubRunning = nil; screenGui:Destroy() end)

-- ========== ОКНО ANTIKICK SETTINGS ==========
ShowAntiKickSettings = function()
    local frame = Instance.new("Frame")
    frame.Name = "AKFrame"; frame.Size = UDim2.new(0, 350, 0, 400); frame.Position = UDim2.new(0.5, -175, 0.5, -200)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN; title.Text = "AntiKick Settings"; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false
    MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false
    closeBtn.MouseButton1Click:Connect(function() _G.RefreshAntiKickLogs = nil; frame:Destroy() end)

    local toggleAntiKick = Instance.new("TextButton")
    toggleAntiKick.Size = UDim2.new(1, -20, 0, 34); toggleAntiKick.Position = UDim2.new(0, 10, 0, 40)
    toggleAntiKick.TextColor3 = RED_MAIN; toggleAntiKick.TextScaled = true; toggleAntiKick.Font = Enum.Font.GothamBold; toggleAntiKick.BorderSizePixel = 1; toggleAntiKick.BorderColor3 = RED_MAIN; toggleAntiKick.ZIndex = 51; toggleAntiKick.Parent = frame; toggleAntiKick.AutoButtonColor = false

    local function UpdateToggleAntiKick()
        if getgenv().XyqwAntiKick then toggleAntiKick.Text = "AntiKick: ON (Default Hook)"; toggleAntiKick.TextColor3 = Color3.fromRGB(0, 255, 100); toggleAntiKick.BackgroundColor3 = RED_DARK
        else toggleAntiKick.Text = "AntiKick: OFF"; toggleAntiKick.TextColor3 = RED_MAIN; toggleAntiKick.BackgroundColor3 = RED_BG end
    end
    UpdateToggleAntiKick()

    toggleAntiKick.MouseButton1Click:Connect(function()
        if getgenv().XyqwAntiKick then StopAntiKick() else StartAntiKick() end
        UpdateToggleAntiKick(); UpdateAntiKickText()
    end)

    local toggleMessages = Instance.new("TextButton")
    toggleMessages.Size = UDim2.new(1, -20, 0, 34); toggleMessages.Position = UDim2.new(0, 10, 0, 80)
    toggleMessages.TextColor3 = RED_MAIN; toggleMessages.TextScaled = true; toggleMessages.Font = Enum.Font.GothamBold; toggleMessages.BorderSizePixel = 1; toggleMessages.BorderColor3 = RED_MAIN; toggleMessages.ZIndex = 51; toggleMessages.Parent = frame; toggleMessages.AutoButtonColor = false

    local function UpdateToggleMessages()
        if ANTI_KICK_MESSAGES then toggleMessages.Text = "AntiKick messages: ON"; toggleMessages.TextColor3 = Color3.fromRGB(0, 255, 100); toggleMessages.BackgroundColor3 = RED_DARK
        else toggleMessages.Text = "AntiKick messages: OFF"; toggleMessages.TextColor3 = RED_MAIN; toggleMessages.BackgroundColor3 = RED_BG end
    end
    UpdateToggleMessages()

    toggleMessages.MouseButton1Click:Connect(function()
        ANTI_KICK_MESSAGES = not ANTI_KICK_MESSAGES; SetSetting("akmsg", ANTI_KICK_MESSAGES); UpdateToggleMessages(); ShowRobloxNotification("AntiKick messages: " .. (ANTI_KICK_MESSAGES and "ON" or "OFF"), 2)
    end)

    local methodLbl = Instance.new("TextLabel")
    methodLbl.Size = UDim2.new(1, -20, 0, 14); methodLbl.Position = UDim2.new(0, 10, 0, 120); methodLbl.BackgroundTransparency = 1
    methodLbl.TextColor3 = Color3.fromRGB(150, 150, 150); methodLbl.Text = "Method: Default Kick Hook"; methodLbl.TextSize = 10; methodLbl.Font = Enum.Font.Gotham; methodLbl.TextXAlignment = Enum.TextXAlignment.Left; methodLbl.ZIndex = 51; methodLbl.Parent = frame

    local logsLbl = Instance.new("TextLabel")
    logsLbl.Size = UDim2.new(1, -120, 0, 18); logsLbl.Position = UDim2.new(0, 10, 0, 140); logsLbl.BackgroundTransparency = 1
    logsLbl.TextColor3 = RED_MAIN; logsLbl.Text = "AntiKick logs:"; logsLbl.TextScaled = true; logsLbl.Font = Enum.Font.GothamBold; logsLbl.TextXAlignment = Enum.TextXAlignment.Left; logsLbl.ZIndex = 51; logsLbl.Parent = frame

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0, 100, 0, 18); clearBtn.Position = UDim2.new(1, -110, 0, 140)
    clearBtn.BackgroundColor3 = RED_DARK; clearBtn.TextColor3 = RED_MAIN; clearBtn.Text = "Clear logs"; clearBtn.TextScaled = true; clearBtn.Font = Enum.Font.GothamBold; clearBtn.BorderSizePixel = 1; clearBtn.BorderColor3 = RED_MAIN; clearBtn.ZIndex = 51; clearBtn.Parent = frame; clearBtn.AutoButtonColor = false
    clearBtn.MouseButton1Click:Connect(function() ANTI_KICK_LOGS = {}; if _G.RefreshAntiKickLogs then _G.RefreshAntiKickLogs() end end)

    local logsScroll = Instance.new("ScrollingFrame")
    logsScroll.Size = UDim2.new(1, -20, 1, -170); logsScroll.Position = UDim2.new(0, 10, 0, 160)
    logsScroll.BackgroundColor3 = RED_DARK; logsScroll.BorderSizePixel = 1; logsScroll.BorderColor3 = RED_MAIN; logsScroll.CanvasSize = UDim2.new(0, 0, 0, 0); logsScroll.ScrollBarThickness = 4; logsScroll.ScrollBarImageColor3 = RED_MAIN; logsScroll.ZIndex = 51; logsScroll.Parent = frame

    local logsText = Instance.new("TextLabel")
    logsText.Size = UDim2.new(1, -10, 0, 30); logsText.Position = UDim2.new(0, 5, 0, 5); logsText.BackgroundTransparency = 1
    logsText.TextColor3 = RED_MAIN; logsText.TextWrapped = true; logsText.TextXAlignment = Enum.TextXAlignment.Left; logsText.TextYAlignment = Enum.TextYAlignment.Top; logsText.TextSize = 11; logsText.Font = Enum.Font.Gotham; logsText.Text = "(no logs yet)"; logsText.ZIndex = 52; logsText.Parent = logsScroll

    _G.RefreshAntiKickLogs = function()
        if not logsText.Parent then return end
        if #ANTI_KICK_LOGS == 0 then logsText.Text = "(no logs yet)"; logsText.Size = UDim2.new(1, -10, 0, 30); logsScroll.CanvasSize = UDim2.new(0, 0, 0, 40)
        else logsText.Text = table.concat(ANTI_KICK_LOGS, "\n"); local h = math.max(30, #ANTI_KICK_LOGS * 16 + 20); logsText.Size = UDim2.new(1, -10, 0, h); logsScroll.CanvasSize = UDim2.new(0, 0, 0, h + 10) end
    end
    _G.RefreshAntiKickLogs()
    MakeResizable(frame, 300, 300, 700, 700)
end

-- ========== ОКНО SETTINGS ==========
local ShowSettings
ShowSettings = function()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200); frame.Position = UDim2.new(0.5, -150, 0.5, -100); frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 24); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN; title.Text = _("SettingsTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 26); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false
    MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 24); closeBtn.Position = UDim2.new(1, -30, 0, 4); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local bindLbl = Instance.new("TextLabel")
    bindLbl.Size = UDim2.new(1, -20, 0, 20); bindLbl.Position = UDim2.new(0, 10, 0, 40); bindLbl.BackgroundTransparency = 1
    bindLbl.TextColor3 = RED_MAIN; bindLbl.Text = _("AutoHideBind"); bindLbl.TextScaled = true; bindLbl.Font = Enum.Font.GothamBold; bindLbl.TextXAlignment = Enum.TextXAlignment.Left; bindLbl.ZIndex = 51; bindLbl.Parent = frame

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(1, -20, 0, 30); bindBtn.Position = UDim2.new(0, 10, 0, 64); bindBtn.BackgroundColor3 = RED_DARK
    bindBtn.TextColor3 = RED_MAIN; bindBtn.Text = tostring(GetSetting("bind", "RightShift")) .. " — click to change"; bindBtn.TextScaled = true
    bindBtn.Font = Enum.Font.GothamBold; bindBtn.BorderSizePixel = 1; bindBtn.BorderColor3 = RED_MAIN; bindBtn.ZIndex = 51; bindBtn.Parent = frame; bindBtn.AutoButtonColor = false

    local waiting = false
    local inputConnection = nil
    bindBtn.MouseButton1Click:Connect(function()
        if waiting then return end
        waiting = true; bindBtn.Text = "Press any key..."
        if inputConnection then pcall(function() inputConnection:Disconnect() end) inputConnection = nil end
        inputConnection = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local keyName = input.KeyCode.Name; SetSetting("bind", keyName); bindBtn.Text = keyName .. " — click to change"
                ShowRobloxNotification(_("KeybindChanged") .. keyName, 2); waiting = false
                if inputConnection then pcall(function() inputConnection:Disconnect() end) inputConnection = nil end
            end
        end)
    end)

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -20, 0, 60); hint.Position = UDim2.new(0, 10, 0, 105); hint.BackgroundTransparency = 1
    hint.TextColor3 = Color3.fromRGB(150, 150, 150); hint.Text = "Press bind to hide/show " .. HUB_NAME .. " GUI.\nCurrent: " .. tostring(GetSetting("bind", "RightShift"))
    hint.TextWrapped = true; hint.TextScaled = true; hint.Font = Enum.Font.Gotham; hint.TextXAlignment = Enum.TextXAlignment.Left; hint.TextYAlignment = Enum.TextYAlignment.Top; hint.ZIndex = 51; hint.Parent = frame

    closeBtn.MouseButton1Click:Connect(function() if inputConnection then pcall(function() inputConnection:Disconnect() end) inputConnection = nil end; frame:Destroy() end)
    MakeResizable(frame, 250, 180, 700, 500)
end
settingsBtn.MouseButton1Click:Connect(ShowSettings)

urlTestBtn.MouseButton1Click:Connect(function()
    ShowRobloxNotification(_("UrlCheckStarted"), 2)
    task.spawn(function()
        for _, entry in ipairs(buttons) do
            local data = entry.Data
            if data.URL ~= "SPECIAL_COPY_DOORS_V2" then
                entry.StatusDot.BackgroundColor3 = URL_CHECKING
                local ok = pcall(function() local res = game:HttpGet(data.URL); if res and #res > 0 then return true end; return false end)
                if ok then entry.StatusDot.BackgroundColor3 = URL_OK else entry.StatusDot.BackgroundColor3 = URL_BAD end
                task.wait(0.3)
            end
        end
        ShowRobloxNotification(_("UrlCheckDone"), 3)
    end)
end)

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

    local showAll = (currentTab == "All" and search == ""); local showFav = (currentTab == "Fav"); local showRct = (currentTab == "Rct")
    removeTagsContainer.Visible = showAll; urlTestContainer.Visible = showAll; settingsContainer.Visible = showAll
    resetOrderContainer.Visible = showAll; antiKickContainer.Visible = showAll; destroyContainer.Visible = showAll
    shareFavContainer.Visible = showFav; shareRctContainer.Visible = showRct

    local specialY = visible * buttonHeight + 5
    if showAll then
        removeTagsContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        urlTestContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        settingsContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        resetOrderContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        antiKickContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        destroyContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        visible = visible + 6
    end
    if showFav then shareFavContainer.Position = UDim2.new(0, 5, 0, specialY); visible = visible + 1 end
    if showRct then shareRctContainer.Position = UDim2.new(0, 5, 0, specialY); visible = visible + 1 end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, visible * buttonHeight + 20)
end

_G.RefreshButtons()
searchBar:GetPropertyChangedSignal("Text"):Connect(function() if _G.RefreshButtons then _G.RefreshButtons() end end)

-- ========== CHANGELOG ==========
local function ShowChangeLog()
    local frame = Instance.new("Frame")
    frame.Name = "CLFrame"; frame.Size = UDim2.new(0, 350, 0, 350); frame.Position = UDim2.new(0.5, -175, 0.5, -175)
    frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN; title.Text = _("ChangeLogTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false
    MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -45); scroll.Position = UDim2.new(0, 5, 0, 35); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.CanvasSize = UDim2.new(0, 0, 0, 15000); scroll.ScrollBarThickness = 4; scroll.ScrollBarImageColor3 = RED_MAIN; scroll.ZIndex = 51; scroll.Parent = frame

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -10, 0, 14990); text.Position = UDim2.new(0, 5, 0, 5); text.BackgroundTransparency = 1; text.TextColor3 = RED_MAIN; text.TextWrapped = true; text.TextXAlignment = Enum.TextXAlignment.Left; text.TextYAlignment = Enum.TextYAlignment.Top; text.TextSize = 12; text.Font = Enum.Font.Gotham; text.Text = _("ChangeLogText"); text.ZIndex = 51; text.Parent = scroll

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)
    MakeResizable(frame, 250, 200, 900, 1000)
end
changelogButton.MouseButton1Click:Connect(ShowChangeLog)

-- ========== ЯЗЫК ==========
langButton.MouseButton1Click:Connect(function()
    local langs = {"EN", "RU", "UK", "BE", "KK"}; local idx = 1
    for i, l in ipairs(langs) do if l == LANG_CODE then idx = i break end end
    idx = idx + 1; if idx > #langs then idx = 1 end
    LANG_CODE = langs[idx]; SetSetting("lang", LANG_CODE); langButton.Text = LANG_CODE
    searchBar.PlaceholderText = _("Search"); removeTagsBtn.Text = _("RemoveTags"); shareFavBtn.Text = _("ShareFav"); shareRctBtn.Text = _("ShareRct"); urlTestBtn.Text = _("TestURLs"); settingsBtn.Text = _("SettingsBtn"); resetOrderBtn.Text = _("ResetOrder"); destroyBtnMain.Text = _("Destroy"); UpdateAntiKickText()
    ShowRobloxNotification(_("LangChanged"), 3); UpdateHeaderLayout()
end)

-- ========== PLAYER LIST ==========
local function ShowPlayerList()
    local frame = Instance.new("Frame")
    frame.Name = "PLFrame"; frame.Size = UDim2.new(0, 350, 0, 400); frame.Position = UDim2.new(0.5, -175, 0.5, -200); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("PlayersTitle") .. " (" .. #Players:GetPlayers() .. ")"; title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -45); scroll.Position = UDim2.new(0, 5, 0, 35); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 25 + 10); scroll.ScrollBarThickness = 4; scroll.ScrollBarImageColor3 = RED_MAIN; scroll.ZIndex = 51; scroll.Parent = frame

    local yPos = 5
    for _, plr in ipairs(Players:GetPlayers()) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 22); label.Position = UDim2.new(0, 5, 0, yPos); label.BackgroundColor3 = RED_DARK; label.TextColor3 = RED_MAIN; label.Text = plr.Name .. " | ID: " .. plr.UserId; label.TextScaled = true; label.Font = Enum.Font.Gotham; label.BorderSizePixel = 1; label.BorderColor3 = RED_MAIN; label.ZIndex = 51; label.Parent = scroll
        yPos = yPos + 25
    end
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end); MakeResizable(frame, 250, 200, 900, 1000)
end

-- ========== SERVER INFO ==========
local function ShowServerInfo()
    local frame = Instance.new("Frame")
    frame.Name = "SIFrame"; frame.Size = UDim2.new(0, 350, 0, 400); frame.Position = UDim2.new(0.5, -175, 0.5, -200); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("ServerTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 110); info.Position = UDim2.new(0, 10, 0, 40); info.BackgroundTransparency = 1; info.TextColor3 = RED_MAIN; info.TextWrapped = true; info.TextXAlignment = Enum.TextXAlignment.Left; info.TextYAlignment = Enum.TextYAlignment.Top; info.TextSize = 13; info.Font = Enum.Font.Gotham
    info.Text = _("PlaceId") .. ": " .. game.PlaceId .. "\n" .. _("JobId") .. ": " .. game.JobId .. "\n" .. _("Players") .. ": " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers .. "\n" .. _("Creator") .. ": " .. game.CreatorId
    info.ZIndex = 51; info.Parent = frame

    local function GetServers() local ok, result = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) end); return (ok and result and result.data) and result.data or {} end

    local rejoinBtn = Instance.new("TextButton")
    rejoinBtn.Size = UDim2.new(1, -20, 0, 30); rejoinBtn.Position = UDim2.new(0, 10, 0, 158); rejoinBtn.BackgroundColor3 = RED_DARK; rejoinBtn.TextColor3 = RED_MAIN; rejoinBtn.Text = _("Rejoin"); rejoinBtn.TextScaled = true; rejoinBtn.Font = Enum.Font.GothamBold; rejoinBtn.BorderSizePixel = 1; rejoinBtn.BorderColor3 = RED_MAIN; rejoinBtn.ZIndex = 51; rejoinBtn.Parent = frame; rejoinBtn.AutoButtonColor = false
    rejoinBtn.MouseButton1Click:Connect(function() QueueReinject(); ShowRobloxNotification("Rejoining...", 2); task.wait(0.5); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer) end) end)

    local hopBtn = Instance.new("TextButton")
    hopBtn.Size = UDim2.new(0.5, -13, 0, 30); hopBtn.Position = UDim2.new(0, 10, 0, 194); hopBtn.BackgroundColor3 = RED_DARK; hopBtn.TextColor3 = RED_MAIN; hopBtn.Text = _("ServerHop"); hopBtn.TextScaled = true; hopBtn.Font = Enum.Font.GothamBold; hopBtn.BorderSizePixel = 1; hopBtn.BorderColor3 = RED_MAIN; hopBtn.ZIndex = 51; hopBtn.Parent = frame; hopBtn.AutoButtonColor = false
    hopBtn.MouseButton1Click:Connect(function()
        QueueReinject(); ShowRobloxNotification("Searching...", 3); local servers = GetServers(); if #servers == 0 then ShowRobloxNotification("No servers!", 3) return end
        local target = servers[math.random(1, #servers)]; ShowRobloxNotification("Hopping...", 2); task.wait(0.5); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, Players.LocalPlayer) end)
    end)

    local smallBtn = Instance.new("TextButton")
    smallBtn.Size = UDim2.new(0.5, -13, 0, 30); smallBtn.Position = UDim2.new(0.5, 3, 0, 194); smallBtn.BackgroundColor3 = RED_DARK; smallBtn.TextColor3 = RED_MAIN; smallBtn.Text = _("TPToSmall"); smallBtn.TextScaled = true; smallBtn.Font = Enum.Font.GothamBold; smallBtn.BorderSizePixel = 1; smallBtn.BorderColor3 = RED_MAIN; smallBtn.ZIndex = 51; smallBtn.Parent = frame; smallBtn.AutoButtonColor = false
    smallBtn.MouseButton1Click:Connect(function()
        QueueReinject(); ShowRobloxNotification("Searching...", 3); local servers = GetServers(); if #servers == 0 then ShowRobloxNotification("No servers!", 3) return end
        local best = servers[1]; for _, srv in ipairs(servers) do if srv.playing < best.playing then best = srv end end; ShowRobloxNotification("Teleporting to " .. best.playing .. " players...", 3); task.wait(0.5); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, Players.LocalPlayer) end)
    end)

    local lastSessionBtn = Instance.new("TextButton")
    lastSessionBtn.Size = UDim2.new(1, -20, 0, 30); lastSessionBtn.Position = UDim2.new(0, 10, 0, 232); lastSessionBtn.BackgroundColor3 = RED_DARK; lastSessionBtn.TextColor3 = RED_MAIN; lastSessionBtn.Text = _("RejoinLastSession"); lastSessionBtn.TextScaled = true; lastSessionBtn.Font = Enum.Font.GothamBold; lastSessionBtn.BorderSizePixel = 1; lastSessionBtn.BorderColor3 = RED_MAIN; lastSessionBtn.ZIndex = 51; lastSessionBtn.Parent = frame; lastSessionBtn.AutoButtonColor = false
    lastSessionBtn.MouseButton1Click:Connect(function()
        local ok, savedJob = pcall(function() if readfile and isfile and isfile(SESSION_FILE) then return readfile(SESSION_FILE) end; return nil end)
        if ok and savedJob and savedJob ~= "" and savedJob ~= game.JobId then QueueReinject(); ShowRobloxNotification("Rejoining last server...", 2); task.wait(0.5); pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, savedJob, Players.LocalPlayer) end)
        else ShowRobloxNotification("No saved session", 2) end
    end)

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(1, -20, 0, 30); copyBtn.Position = UDim2.new(0, 10, 0, 270); copyBtn.BackgroundColor3 = RED_MAIN; copyBtn.TextColor3 = Color3.fromRGB(0, 0, 0); copyBtn.Text = _("CopyJobId"); copyBtn.TextScaled = true; copyBtn.Font = Enum.Font.GothamBold; copyBtn.BorderSizePixel = 0; copyBtn.ZIndex = 51; copyBtn.Parent = frame; copyBtn.AutoButtonColor = false
    copyBtn.MouseButton1Click:Connect(function() pcall(function() setclipboard(game.JobId) end); ShowRobloxNotification(_("JobIdCopied"), 2) end)

    local reinjectBtn = Instance.new("TextButton")
    reinjectBtn.Size = UDim2.new(1, -20, 0, 32); reinjectBtn.Position = UDim2.new(0, 10, 0, 308); reinjectBtn.TextColor3 = RED_MAIN; reinjectBtn.TextScaled = true; reinjectBtn.Font = Enum.Font.GothamBold; reinjectBtn.BorderSizePixel = 1; reinjectBtn.BorderColor3 = RED_MAIN; reinjectBtn.ZIndex = 51; reinjectBtn.Parent = frame; reinjectBtn.AutoButtonColor = false

    local function UpdateReinjectButton()
        if GetSetting("autoreinject", true) then reinjectBtn.Text = _("AutoReinjectOn"); reinjectBtn.TextColor3 = Color3.fromRGB(0, 255, 100); reinjectBtn.BackgroundColor3 = RED_DARK
        else reinjectBtn.Text = _("AutoReinjectOff"); reinjectBtn.TextColor3 = RED_MAIN; reinjectBtn.BackgroundColor3 = RED_BG end
    end
    UpdateReinjectButton()
    reinjectBtn.MouseButton1Click:Connect(function() SetSetting("autoreinject", not GetSetting("autoreinject", true)); UpdateReinjectButton(); ShowRobloxNotification(GetSetting("autoreinject", true) and _("AutoReinjectOn") or _("AutoReinjectOff"), 2) end)

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end); MakeResizable(frame, 280, 300, 700, 700)
end

-- ========== CUSTOM SCRIPT ==========
local function ShowCustomScript()
    local frame = Instance.new("Frame")
    frame.Name = "CSFrame"; frame.Size = UDim2.new(0, 350, 0, 175); frame.Position = UDim2.new(0.5, -175, 0.5, -87); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("CustomTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 30); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28); closeBtn.Position = UDim2.new(1, -35, 0, 2); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 0, 36); input.Position = UDim2.new(0, 10, 0, 40); input.BackgroundColor3 = RED_DARK; input.TextColor3 = RED_MAIN; input.PlaceholderText = _("CustomPlaceholder"); input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150); input.Text = ""; input.TextSize = 12; input.Font = Enum.Font.Gotham; input.BorderSizePixel = 1; input.BorderColor3 = RED_MAIN; input.ZIndex = 51; input.Parent = frame

    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(1, -20, 0, 36); runBtn.Position = UDim2.new(0, 10, 0, 100); runBtn.BackgroundColor3 = RED_MAIN; runBtn.TextColor3 = Color3.fromRGB(0, 0, 0); runBtn.Text = _("RunCustom"); runBtn.TextScaled = true; runBtn.Font = Enum.Font.GothamBold; runBtn.BorderSizePixel = 0; runBtn.ZIndex = 51; runBtn.Parent = frame; runBtn.AutoButtonColor = false

    runBtn.MouseButton1Click:Connect(function()
        local url = input.Text:match('game:HttpGet%s*%(%s*["\']([^"\']+)["\']') or input.Text:match("^https?://") and input.Text or nil
        if not url then ShowRobloxNotification("Invalid URL!", 3) return end
        local success = pcall(function() loadstring(game:HttpGet(url))() end)
        if success then ShowRobloxNotification("Custom - " .. _("ScriptExecuted"), 3) else ShowRobloxNotification("Custom - " .. _("Error"), 5) end
    end)
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end); MakeResizable(frame, 250, 150, 700, 500)
end

-- ========== CUSTOM COLOR ==========
local function ShowCustomColor()
    local frame = Instance.new("Frame")
    frame.Name = "CCFrame"; frame.Size = UDim2.new(0, 280, 0, 380); frame.Position = UDim2.new(0.5, -140, 0.5, -190); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 50; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 22); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("CustomColorTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 51; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 24); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 52; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 22); closeBtn.Position = UDim2.new(1, -28, 0, 4); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 51; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(1, -20, 0, 36); preview.Position = UDim2.new(0, 10, 0, 32); preview.BackgroundColor3 = Color3.fromRGB(GetSetting("cc_r", 255), GetSetting("cc_g", 0), GetSetting("cc_b", 0)); preview.BorderSizePixel = 2; preview.BorderColor3 = RED_MAIN; preview.ZIndex = 51; preview.Parent = frame

    local tempColor = {r = GetSetting("cc_r", 255), g = GetSetting("cc_g", 0), b = GetSetting("cc_b", 0)}
    local hexInput, setSliders
    local function UpdateAll() preview.BackgroundColor3 = Color3.fromRGB(tempColor.r, tempColor.g, tempColor.b); if hexInput then hexInput.Text = string.format("#%02X%02X%02X", tempColor.r, tempColor.g, tempColor.b) end end

    local function MakeSlider(label, yPos, channel)
        local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(0, 20, 0, 18); lbl.Position = UDim2.new(0, 10, 0, yPos); lbl.BackgroundTransparency = 1; lbl.TextColor3 = RED_MAIN; lbl.Text = label; lbl.TextScaled = true; lbl.Font = Enum.Font.GothamBold; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 51; lbl.Parent = frame
        local valLbl = Instance.new("TextLabel"); valLbl.Size = UDim2.new(0, 40, 0, 18); valLbl.Position = UDim2.new(1, -50, 0, yPos); valLbl.BackgroundTransparency = 1; valLbl.TextColor3 = RED_MAIN; valLbl.Text = tostring(tempColor[channel]); valLbl.TextScaled = true; valLbl.Font = Enum.Font.Gotham; valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl.ZIndex = 51; valLbl.Parent = frame
        local slider = Instance.new("Frame"); slider.Size = UDim2.new(1, -100, 0, 12); slider.Position = UDim2.new(0, 35, 0, yPos + 3); slider.BackgroundColor3 = RED_DARK; slider.BorderSizePixel = 1; slider.BorderColor3 = RED_MAIN; slider.ZIndex = 51; slider.Parent = frame
        local fill = Instance.new("Frame"); fill.Size = UDim2.new(tempColor[channel] / 255, 0, 1, 0); fill.BackgroundColor3 = RED_MAIN; fill.BorderSizePixel = 0; fill.ZIndex = 52; fill.Parent = slider
        local drag = false
        local function UpdateFromX(mouseX) local rel = math.clamp((mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1); local v = math.floor(rel * 255); tempColor[channel] = v; fill.Size = UDim2.new(rel, 0, 1, 0); valLbl.Text = tostring(v); UpdateAll() end
        slider.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = true; UpdateFromX(input.Position.X) end end)
        UserInputService.InputChanged:Connect(function(input) if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateFromX(input.Position.X) end end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end end)
        return function(v) tempColor[channel] = v; fill.Size = UDim2.new(v / 255, 0, 1, 0); valLbl.Text = tostring(v) end
    end

    setSliders = {R = MakeSlider("R", 76, "r"), G = MakeSlider("G", 100, "g"), B = MakeSlider("B", 124, "b")}

    local hexLbl = Instance.new("TextLabel"); hexLbl.Size = UDim2.new(0, 40, 0, 18); hexLbl.Position = UDim2.new(0, 10, 0, 150); hexLbl.BackgroundTransparency = 1; hexLbl.TextColor3 = RED_MAIN; hexLbl.Text = "HEX:"; hexLbl.TextScaled = true; hexLbl.Font = Enum.Font.GothamBold; hexLbl.TextXAlignment = Enum.TextXAlignment.Left; hexLbl.ZIndex = 51; hexLbl.Parent = frame
    hexInput = Instance.new("TextBox"); hexInput.Size = UDim2.new(1, -60, 0, 22); hexInput.Position = UDim2.new(0, 50, 0, 148); hexInput.BackgroundColor3 = RED_DARK; hexInput.TextColor3 = RED_MAIN; hexInput.PlaceholderText = "#FF0000"; hexInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150); hexInput.Text = string.format("#%02X%02X%02X", tempColor.r, tempColor.g, tempColor.b); hexInput.TextSize = 12; hexInput.Font = Enum.Font.Gotham; hexInput.ClearTextOnFocus = false; hexInput.BorderSizePixel = 1; hexInput.BorderColor3 = RED_MAIN; hexInput.ZIndex = 51; hexInput.Parent = frame

    hexInput.FocusLost:Connect(function()
        local text = hexInput.Text:gsub("#", ""):gsub("%s", "")
        if #text == 6 then local r, g, b = tonumber(text:sub(1, 2), 16), tonumber(text:sub(3, 4), 16), tonumber(text:sub(5, 6), 16); if r and g and b then tempColor.r = r; tempColor.g = g; tempColor.b = b; if setSliders then setSliders.R(r) setSliders.G(g) setSliders.B(b) end end end
        UpdateAll()
    end)

    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(1, -20, 0, 28); applyBtn.Position = UDim2.new(0, 10, 0, 308); applyBtn.BackgroundColor3 = RED_MAIN; applyBtn.TextColor3 = Color3.fromRGB(0, 0, 0); applyBtn.Text = _("Apply"); applyBtn.TextScaled = true; applyBtn.Font = Enum.Font.GothamBold; applyBtn.BorderSizePixel = 0; applyBtn.ZIndex = 51; applyBtn.Parent = frame; applyBtn.AutoButtonColor = false
    applyBtn.MouseButton1Click:Connect(function()
        SetSetting("cc_r", tempColor.r); SetSetting("cc_g", tempColor.g); SetSetting("cc_b", tempColor.b)
        THEMES.Custom.MAIN = Color3.fromRGB(tempColor.r, tempColor.g, tempColor.b)
        THEMES.Custom.DARK = Color3.fromRGB(math.floor(tempColor.r * 0.15), math.floor(tempColor.g * 0.15), math.floor(tempColor.b * 0.15))
        THEMES.Custom.BG = Color3.fromRGB(0, 0, 0); THEMES.Custom.TITLE = Color3.fromRGB(math.floor(tempColor.r * 0.08), math.floor(tempColor.g * 0.08), math.floor(tempColor.b * 0.08))
        if _G.ApplyTheme then _G.ApplyTheme("Custom") end; ShowRobloxNotification("Custom Color applied!", 3); frame:Destroy()
    end)
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end); MakeResizable(frame, 280, 350, 600, 800)
end

-- ========== ТЕМЫ ==========
local themeOrder = {"Red", "Blue", "Green", "Purple", "Pink", "Orange", "Cyan", "Yellow", "Lime", "Magenta", "White", "Rainbow", "Custom"}
local themeIndex = 1; for i, name in ipairs(themeOrder) do if name == THEME_NAME then themeIndex = i break end end

_G.ApplyTheme = function(themeName)
    THEME_NAME = themeName; SetSetting("theme", themeName)
    if themeName == "Custom" then local cr, cg, cb = GetSetting("cc_r", 255), GetSetting("cc_g", 0), GetSetting("cc_b", 0); THEMES.Custom.MAIN = Color3.fromRGB(cr, cg, cb); THEMES.Custom.DARK = Color3.fromRGB(math.floor(cr * 0.15), math.floor(cg * 0.15), math.floor(cb * 0.15)); THEMES.Custom.BG = Color3.fromRGB(0, 0, 0); THEMES.Custom.TITLE = Color3.fromRGB(math.floor(cr * 0.08), math.floor(cg * 0.08), math.floor(cb * 0.08)) end
    local t = THEMES[themeName]; RED_MAIN = t.MAIN; RED_DARK = t.DARK; RED_BG = t.BG; RED_TITLE = t.TITLE
    mainFrame.BackgroundColor3 = RED_BG; mainFrame.BorderColor3 = RED_MAIN; titleBar.BackgroundColor3 = RED_TITLE; titleLabel.TextColor3 = RED_MAIN
    for _, btn in ipairs({closeButton, langButton, playerBtn, serverBtn, customBtn, changelogButton, themeBtn, colorBtn, infoBtn}) do btn.BackgroundColor3 = RED_DARK; btn.TextColor3 = RED_MAIN; btn.BorderColor3 = RED_MAIN end
    searchBar.BackgroundColor3 = RED_DARK; searchBar.TextColor3 = RED_MAIN; searchBar.BorderColor3 = RED_MAIN; scrollFrame.ScrollBarImageColor3 = RED_MAIN
    for n, btn in pairs(tabButtons) do if n == currentTab then btn.BackgroundColor3 = RED_MAIN; btn.TextColor3 = Color3.fromRGB(0, 0, 0) else btn.BackgroundColor3 = RED_DARK; btn.TextColor3 = RED_MAIN end; btn.BorderColor3 = RED_MAIN end
    for _, entry in ipairs(buttons) do entry.Container.BackgroundColor3 = RED_BG; entry.Container.BorderColor3 = RED_MAIN; entry.Btn.TextColor3 = RED_MAIN; entry.Star.BackgroundColor3 = RED_BG; entry.Star.TextColor3 = RED_MAIN; entry.Star.BorderColor3 = RED_MAIN; entry.AutoBtn.BorderColor3 = RED_MAIN; if entry.DragStrip then entry.DragStrip.BackgroundColor3 = RED_MAIN end; if AUTOEXEC[entry.Data.Name] then entry.AutoBtn.BackgroundColor3 = RED_MAIN; entry.AutoBtn.TextColor3 = Color3.fromRGB(0, 0, 0) else entry.AutoBtn.BackgroundColor3 = RED_BG; entry.AutoBtn.TextColor3 = RED_MAIN end end
    removeTagsContainer.BorderColor3 = RED_MAIN; shareFavContainer.BorderColor3 = RED_MAIN; shareRctContainer.BorderColor3 = RED_MAIN; urlTestContainer.BorderColor3 = RED_MAIN; settingsContainer.BorderColor3 = RED_MAIN; resetOrderContainer.BorderColor3 = RED_MAIN; antiKickContainer.BorderColor3 = RED_MAIN; destroyContainer.BorderColor3 = RED_MAIN; removeTagsBtn.TextColor3 = RED_MAIN; shareFavBtn.TextColor3 = RED_MAIN; shareRctBtn.TextColor3 = RED_MAIN; urlTestBtn.TextColor3 = RED_MAIN; settingsBtn.TextColor3 = RED_MAIN; resetOrderBtn.TextColor3 = RED_MAIN; destroyBtnMain.TextColor3 = RED_MAIN; UpdateAntiKickText()
    topBar.BackgroundColor3 = RED_BG; topBar.BorderColor3 = RED_MAIN; topBarText.TextColor3 = RED_MAIN; hideTopBtn.BackgroundColor3 = RED_DARK; hideTopBtn.TextColor3 = RED_MAIN; hideTopBtn.BorderColor3 = RED_MAIN
    dockButton.BackgroundColor3 = RED_BG; dockButton.TextColor3 = RED_MAIN; dockButton.BorderColor3 = RED_MAIN
    if themeName ~= "Rainbow" then ShowRobloxNotification("Theme: " .. themeName, 2) end
end

themeBtn.MouseButton1Click:Connect(function() themeIndex = themeIndex + 1; if themeIndex > #themeOrder then themeIndex = 1 end; _G.ApplyTheme(themeOrder[themeIndex]); if THEME_NAME == "Rainbow" then ShowRobloxNotification("Theme: Rainbow", 2) end end)

task.spawn(function()
    local hue = 0
    while screenGui.Parent do
        if THEME_NAME == "Rainbow" then
            hue = (hue + 0.008) % 1; local c = Color3.fromHSV(hue, 1, 1); local darkHue = Color3.fromHSV(hue, 1, 0.18)
            mainFrame.BorderColor3 = c; titleBar.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.08); titleLabel.TextColor3 = c
            for _, btn in ipairs({closeButton, langButton, playerBtn, serverBtn, customBtn, changelogButton, themeBtn, colorBtn, infoBtn}) do btn.BackgroundColor3 = darkHue; btn.TextColor3 = c; btn.BorderColor3 = c end
            searchBar.TextColor3 = c; searchBar.BorderColor3 = c; searchBar.BackgroundColor3 = darkHue; scrollFrame.ScrollBarImageColor3 = c
            for n, btn in pairs(tabButtons) do if n == currentTab then btn.BackgroundColor3 = c; btn.TextColor3 = Color3.fromRGB(0, 0, 0); btn.BorderColor3 = c else btn.BackgroundColor3 = darkHue; btn.TextColor3 = c; btn.BorderColor3 = c end end
            for _, entry in ipairs(buttons) do entry.Container.BorderColor3 = c; entry.Btn.TextColor3 = c; entry.Star.TextColor3 = c; entry.Star.BorderColor3 = c; entry.Star.BackgroundColor3 = darkHue; entry.AutoBtn.BorderColor3 = c; if entry.DragStrip then entry.DragStrip.BackgroundColor3 = c end; if AUTOEXEC[entry.Data.Name] then entry.AutoBtn.BackgroundColor3 = c; entry.AutoBtn.TextColor3 = Color3.fromRGB(0, 0, 0) else entry.AutoBtn.BackgroundColor3 = darkHue; entry.AutoBtn.TextColor3 = c end end
            removeTagsContainer.BorderColor3 = c; shareFavContainer.BorderColor3 = c; shareRctContainer.BorderColor3 = c; urlTestContainer.BorderColor3 = c; settingsContainer.BorderColor3 = c; resetOrderContainer.BorderColor3 = c; antiKickContainer.BorderColor3 = c; destroyContainer.BorderColor3 = c; removeTagsBtn.TextColor3 = c; shareFavBtn.TextColor3 = c; shareRctBtn.TextColor3 = c; urlTestBtn.TextColor3 = c; settingsBtn.TextColor3 = c; resetOrderBtn.TextColor3 = c; destroyBtnMain.TextColor3 = c
            topBar.BorderColor3 = c; topBarText.TextColor3 = c; hideTopBtn.BackgroundColor3 = darkHue; hideTopBtn.TextColor3 = c; hideTopBtn.BorderColor3 = c; dockButton.TextColor3 = c; dockButton.BorderColor3 = c
        end
        task.wait(0.05)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed) if gameProcessed then return end; if input.UserInputType == Enum.UserInputType.Keyboard then if input.KeyCode.Name == GetSetting("bind", "RightShift") then if mainFrame.Visible then CloseGui() else OpenGui() end end end end)

local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "ResizeHandle"; resizeHandle.Size = UDim2.new(0, 14, 0, 14); resizeHandle.Position = UDim2.new(1, -14, 1, -14); resizeHandle.BackgroundColor3 = RED_MAIN; resizeHandle.Text = ""; resizeHandle.BorderSizePixel = 0; resizeHandle.ZIndex = 10; resizeHandle.Parent = mainFrame; resizeHandle.AutoButtonColor = false

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Name = "SizeLabel"; sizeLabel.Size = UDim2.new(0, 70, 0, 14); sizeLabel.Position = UDim2.new(1, -88, 1, -16); sizeLabel.BackgroundTransparency = 1; sizeLabel.TextColor3 = RED_MAIN; sizeLabel.Text = "280 x 340"; sizeLabel.TextSize = 10; sizeLabel.Font = Enum.Font.Gotham; sizeLabel.TextXAlignment = Enum.TextXAlignment.Right; sizeLabel.ZIndex = 10; sizeLabel.Parent = mainFrame

local resizing, resizeStart, resizeStartSize = false, nil, nil
resizeHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true; resizeStart = input.Position; resizeStartSize = mainFrame.Size end end)
UserInputService.InputChanged:Connect(function(input) if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - resizeStart; local newX = math.clamp(resizeStartSize.X.Offset + delta.X, 280, 900); local newY = math.clamp(resizeStartSize.Y.Offset + delta.Y, 340, 1000); mainFrame.Size = UDim2.new(0, newX, 0, newY); savedSize = mainFrame.Size; sizeLabel.Text = math.floor(newX) .. " x " .. math.floor(newY); UpdateTabLayout(); UpdateScriptButtonLayout(); UpdateHeaderLayout() end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end end)

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

closeButton.MouseButton1Click:Connect(CloseGui)

local function ShowWelcomeMessage()
    local frame = Instance.new("Frame")
    frame.Name = "WFrame"; frame.Size = UDim2.new(0, 340, 0, 340); frame.Position = UDim2.new(0.5, -170, 0.5, -170); frame.BackgroundColor3 = RED_BG; frame.BorderSizePixel = 2; frame.BorderColor3 = RED_MAIN; frame.ZIndex = 100; frame.Active = true; frame.ClipsDescendants = true; frame.Parent = screenGui

    local blocker = Instance.new("TextButton")
    blocker.Size = UDim2.new(1, 0, 1, 0); blocker.BackgroundTransparency = 1; blocker.Text = ""; blocker.Active = true; blocker.AutoButtonColor = false; blocker.ZIndex = 100; blocker.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 22); title.Position = UDim2.new(0, 5, 0, 5); title.BackgroundTransparency = 1; title.TextColor3 = RED_MAIN; title.Text = _("WelcomeTitle"); title.TextScaled = true; title.Font = Enum.Font.GothamBold; title.ZIndex = 101; title.Parent = frame

    local dragBar = Instance.new("TextButton")
    dragBar.Size = UDim2.new(1, -35, 0, 24); dragBar.Position = UDim2.new(0, 2, 0, 3); dragBar.BackgroundTransparency = 1; dragBar.Text = ""; dragBar.ZIndex = 102; dragBar.Parent = frame; dragBar.AutoButtonColor = false; MakeDraggable(frame, dragBar)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 22); closeBtn.Position = UDim2.new(1, -31, 0, 4); closeBtn.BackgroundTransparency = 1; closeBtn.Text = "X"; closeBtn.TextColor3 = RED_MAIN; closeBtn.TextScaled = true; closeBtn.Font = Enum.Font.GothamBold; closeBtn.ZIndex = 102; closeBtn.Parent = frame; closeBtn.AutoButtonColor = false
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)

    local docScroll = Instance.new("ScrollingFrame")
    docScroll.Size = UDim2.new(1, -10, 1, -40); docScroll.Position = UDim2.new(0, 5, 0, 35); docScroll.BackgroundTransparency = 1; docScroll.BorderSizePixel = 0; docScroll.CanvasSize = UDim2.new(0, 0, 0, 400); docScroll.ScrollBarThickness = 4; docScroll.ScrollBarImageColor3 = RED_MAIN; docScroll.ZIndex = 101; docScroll.Parent = frame

    local doc = Instance.new("TextLabel")
    doc.Size = UDim2.new(1, -10, 0, 390); doc.Position = UDim2.new(0, 5, 0, 0); doc.BackgroundTransparency = 1; doc.TextColor3 = RED_MAIN; doc.TextWrapped = true; doc.TextXAlignment = Enum.TextXAlignment.Left; doc.TextYAlignment = Enum.TextYAlignment.Top; doc.TextSize = 11; doc.Font = Enum.Font.Gotham
    doc.Text = "─── 7.6.0 DEFAULT MODE ───\n★ Обычная версия для игр БЕЗ античита.\n★ Быстрая загрузка (HttpGet).\n★ Стандартный интерфейс.\n★ Заголовок изменен на DEFAULT MODE!\n\n─── TITLE BAR ───\nTh - Theme\nCC - Custom Color\nCL - ChangeLog\nC - Custom Script\nP - Players\nS - Server Info\n\n─── BOTTOM BUTTONS ───\nRemove Tags, Test URLs, Settings,\nReset Order, AntiKick Settings,\nDestroy XyqwHub\n\nTikTok: xyqwerq.tvink\nTG: t.me/xyqwsquad"
    doc.ZIndex = 101; doc.Parent = docScroll

    MakeResizable(frame, 280, 250, 900, 1000)
end

UpdateTabLayout()
UpdateScriptButtonLayout()
UpdateHeaderLayout()
SwitchTab("All")

task.spawn(function() task.wait(0.5); ShowRobloxNotification(HUB_NAME .. " DEFAULT MODE Loaded!", 4) end)
task.spawn(function() task.wait(1.2); ShowWelcomeMessage() end)
task.spawn(function() task.wait(2.5); if IsOwner() then ShowRobloxNotification(_("OwnerWelcome"), 5) elseif IsBeta() then ShowRobloxNotification(_("BetaWelcome"), 5) end end)

task.spawn(function() while screenGui.Parent do task.wait(30); pcall(function() if writefile and game.JobId and game.JobId ~= "" then writefile(SESSION_FILE, game.JobId) end end) end end)

task.spawn(function()
    while screenGui.Parent do task.wait(5); if not screenGui.Parent then break end end
    shared.XyqwHubRunning = nil
end)

-- ========== КОНЕЦ XYQWHUB DEFAULT ==========
