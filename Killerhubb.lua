-- =======================================================
-- KILLER MENU HUB (STABLE FULL VERSION + CUSTOM SENDER)
-- =======================================================
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ==========================================
-- 1. DISCORD WEBHOOKS
-- ==========================================
local WEBHOOK_MAIN = "https://discord.com/api/webhooks/1570008249091096627/sj_wLfzvlU04M1GY_bECguMJgPfC7S9cL2Phy3oeDa9atyjngaFMCX7ysGDjWTs5uhZt"
local WEBHOOK_CHECKER = "https://discord.com/api/webhooks/1570026388688216116/9ByHGOh0Lwh7AQhxSk9ELeikqkcrKmQ0ZxOVquN1fr-zCVSGp9RqzURYJwrabqXtrVCS"
local WEBHOOK_ONLINE = "https://discord.com/api/webhooks/1570031818663792711/0gOa6SHCWtF8A6TwG3mClo6Gv9Yh1oL1vi6gxHru6QyK34aJzFTYtQPGb6ic9hJ_Tcls"
local WEBHOOK_REGISTER = "https://discord.com/api/webhooks/1570063913297514496/tPJAiYFxkmFiSTQk9x1DGeudst0S6zDND1eZqao5aeCOPx7-qXhGoLza6Wb7xNyZ7dnQ"
local WEBHOOK_VULN_SCANNER = "https://discord.com/api/webhooks/1570320187578777630/L37RZZXdYwlSdHwv4JURO1JME5BXoCW9vWxtsGH0ZNzkzzxnbj4KMnIH3TuzcVLe3iu1"

local WEBHOOK_KILL_HUB_CHAT = "https://discord.com/api/webhooks/1570791618955714711/iQdsY89kIo_JqLvitJFkCxdS3_nSS2-tcSngLKgxuz59jJ4GcpJ16WyynDa6gprdWgDo"
local WEBHOOK_KEY_CHAT = "https://discord.com/api/webhooks/1570793049796124702/zjwz8iaIV_H_Cc3G2syQIeHrMtrmdGzhr3mM5yFVIgwjQmxw54vBgH-FCHGHbVdYMO5A"
local WEBHOOK_CURATOR = "https://discord.com/api/webhooks/1570796886955266058/nVJB7rTKjL1V48nhU-s8V6FtgW7Q1G24I07PXRfhT-s5UfgRHb7yTj6rk6ynN7VKrzyw"

local WEBHOOKS_KICK = {
    "https://discord.com/api/webhooks/1570791377841684654/ic22GDtzHzcyUYFnZgrDOA4PbnF5ROfGsMHmYEkxvz3vZX23aiIa9Gyb0NlOJ_q0EVqs",
    "https://discord.com/api/webhooks/1570791258216075334/OHJYHi09bOkPwd-68Pl2Bm6dO4LRKHKoFC1HCPATi5O_isO69bTVBJQo7TEhlWfG8wJS"
}

local WEBHOOKS_BAN = {
    "https://discord.com/api/webhooks/1570793518987874445/Gh_fFNpGH_77FFN_hWCNOb08Hpsl5h8EAHIXT-Cz40m5i3YhiKhW_pe3Vu89msvQQ-5Y",
    "https://discord.com/api/webhooks/1570791378470838354/NqwctTGKu2xER1FkahVY6oOHIzaJdKBaXxSaGeRwQyg7EU7AC35Ry59_T41tFJPsF0U7"
}

local WEBHOOKS_PLAYER_KEYS = {
    "https://discord.com/api/webhooks/1570792010728603791/OTFB9RncYYH2H2JjTZQq_RdPICNQV4lLjOHVeEeZNRmpPiyg1AZMAQRN_KV-S-J8nNeZ",
    "https://discord.com/api/webhooks/1570792053254922312/231WY5Bd1wrKJ6uRHOvlYi6wQO83WZHMrKxs1kOMqvhUV2nnw60o7YWRHIAMrnu90t-n",
    "https://discord.com/api/webhooks/1570792054949159015/uwSSjfKcanV3wWOKLphnVVIHGlEyJ1KYXs2vHJzNXUBKhSglz0c4TAWVspU4AU9SmFEU",
    "https://discord.com/api/webhooks/1570792114042835094/GDLYRelxU_QfJ7sdwhv0l934WOKPG7rnNN_d_c8o5wNkFdeJieomLVKEMlz8IN0IVkvh",
    "https://discord.com/api/webhooks/1570792174000537651/rXxEH9vGYMArKRzaE1EnlUAvLTx4ZZ5hQ3VyWHIMgLFdbcFqrbzo8g4iNfxd4WARLXXl"
}

_G.SelectedPlayer = nil 
_G.AutoClickX2 = false
_G.CustomSenderName = "" -- НОВАЯ ПЕРЕМЕННАЯ ДЛЯ КАСТОМНОГО НИКА

local function SendDiscordLog(url, title, desc, color)
    if not url or url == "" then return end
    task.spawn(function()
        local payload = HttpService:JSONEncode({ username = "🔪 Killer Hub", embeds = {{ title = title, description = desc, color = color or 16711680, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") }} })
        pcall(function() request({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload }) end)
    end)
end

local function SendDiscordMultiLog(urls, title, desc, color)
    for _, url in ipairs(urls) do SendDiscordLog(url, title, desc, color) end
end

-- УМНАЯ ОТПРАВКА ЧАТА (С КАСТОМНЫМ НИКОМ И РОЛЯМИ)
local function SendChatToDiscord(message, authorName, userId)
    if not message or message == "" then return end
    
    local finalName = authorName
    
    -- Если пишешь ты (Овнер) или Куратор и включен кастомный ник
    if authorName == LocalPlayer.Name and _G.CustomSenderName ~= "" then
        finalName = _G.CustomSenderName
    else
        local authorRole = "User"
        local isAuthorAdmin = false
        
        if authorName == LocalPlayer.Name then
            if isOwner then authorRole = "Owner"; isAuthorAdmin = true
            elseif myRole == "Curator" then authorRole = "Curator"; isAuthorAdmin = true
            elseif myRole ~= "User" then authorRole = myRole; isAuthorAdmin = true end
        else
            if HasRole(F_Curator, authorName) then authorRole = "Curator"; isAuthorAdmin = true
            elseif HasRole(F_Admin, authorName) then authorRole = "Admin"; isAuthorAdmin = true
            elseif HasRole(F_Mod, authorName) then authorRole = "Mod"; isAuthorAdmin = true end
        end

        if isAuthorAdmin then
            finalName = "[" .. authorRole .. "] " .. authorName
        end
    end

    task.spawn(function()
        local data = HttpService:JSONEncode({ 
            username = finalName, 
            content = message, 
            avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId="..(userId or LocalPlayer.UserId).."&width=150&height=150&format=png" 
        })
        pcall(function() request({ Url = WEBHOOK_KILL_HUB_CHAT, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = data }) end)
    end)
end

local function HookPlayerChat(plr)
    plr.Chatted:Connect(function(msg)
        if plr == LocalPlayer then
            SendChatToDiscord(msg, plr.Name, plr.UserId)
        else
            local originalCustom = _G.CustomSenderName
            _G.CustomSenderName = "" 
            SendChatToDiscord(msg, plr.Name, plr.UserId)
            _G.CustomSenderName = originalCustom
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do HookPlayerChat(p) end
Players.PlayerAdded:Connect(HookPlayerChat)

-- ==========================================
-- 2. АВТО-ЛОГГЕР И ОНЛАЙН
-- ==========================================
local lastActionLog = {}
local function LogUIAction(menuName, actionName, value)
    local key = menuName .. actionName .. tostring(value)
    if lastActionLog[key] and tick() - lastActionLog[key] < 1 then return end 
    lastActionLog[key] = tick()
    local statusStr = type(value) == "boolean" and (value and "ВКЛ" or "ВЫКЛ") or tostring(value)
    SendDiscordLog(WEBHOOK_MAIN, "🖱️ Функция: " .. actionName, "**Меню:** " .. menuName .. "\n**Действие:** " .. statusStr .. "\n**Кто:** `" .. LocalPlayer.Name .. "`", 16750848)
end

task.spawn(function()
    while task.wait(90) do 
        local plrs = Players:GetPlayers()
        local tableStr = "| Игрок | UserID |\n|---|---|\n"
        for _, p in ipairs(plrs) do tableStr = tableStr .. "| " .. p.Name .. " | " .. p.UserId .. " |\n" end
        local payload = HttpService:JSONEncode({ username = "📊 Killer Hub | Online", embeds = {{ title = "📋 Таблица Онлайна", description = "**Всего в игре:** " .. #plrs .. "\n\n" .. tableStr, color = 3447003, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") }} })
        pcall(function() request({ Url = WEBHOOK_ONLINE, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload }) end)
    end
end)

-- ==========================================
-- 3. ФАЙЛЫ И РОЛИ
-- ==========================================
local function _r(f) local s, d = pcall(readfile, f); if s and d then return d end; return "" end
local function _w(f, d) pcall(function() writefile(f, d) end) end 
local function _add(f, n) local d = _r(f); if not string.find(d, "|" .. n .. "|") then _w(f, d .. "|" .. n .. "|") end end
local function _rem(f, n) _w(f, string.gsub(_r(f), "|" .. n .. "|", "")) end
local function HasRole(f, n) if string.find(_r(f), "|" .. n .. "|") then return true end; return false end

local F_Keys = "Killer_Keys.txt"
local F_UsedKeys = "Killer_UsedKeys.txt" 
local F_Session = "Killer_Session.txt"   
local F_Logs = "Killer_AdminLogs.txt"
local F_VIP = "Killer_VIP.txt"
local F_Tester = "Killer_Testers.txt"
local F_Mod = "Killer_Mods.txt"
local F_ChiefMod = "Killer_ChiefMod.txt"
local F_Admin = "Killer_Admins.txt"
local F_DeputyChiefAdmin = "Killer_DeputyChiefAdmin.txt"
local F_ChiefAdmin = "Killer_ChiefAdmin.txt"
local F_TechAdmin = "Killer_TechAdmin.txt"
local F_StaffLeader = "Killer_StaffLeader.txt"
local F_Curator = "Killer_Curators.txt"
local F_Deputy = "Killer_Deputy.txt"
local F_DeputyOwner = "Killer_ChiefDeputy.txt"
local F_Banned = "Killer_Banned.txt"

if _r(F_Keys) == "" then _w(F_Keys, "") end
if _r(F_UsedKeys) == "" then _w(F_UsedKeys, "") end

local _a = {58,91,100,95,105,39,41,38,46,39,47,46,47}
local _b = ""
for _, v in ipairs(_a) do _b = _b .. string.char(v + 10) end
local isOwner = (LocalPlayer.Name == _b or LocalPlayer.Name == "Denis13081989")

local function CheckKey(key)
    if not key or key == "" then return false, "Пустой ключ" end
    local usedData = _r(F_UsedKeys)
    if string.find(usedData, "|" .. string.upper(key) .. "|") then return false, "Ключ уже использован" end
    local keysData = _r(F_Keys)
    for k, exp, role in string.gmatch(keysData, "|([^|]+)|(%d+)|([^|]+)|") do
        if string.upper(k) == string.upper(key) then
            local expTime = tonumber(exp)
            if expTime == 0 or os.time() < expTime then return true, role, (expTime == 0 and math.huge or expTime)
            else return false, "Ключ истек" end
        end
    end
    return false, "Неверный ключ"
end

if HasRole(F_Banned, LocalPlayer.Name) then LocalPlayer:Kick("❌ Вы забанены в Killer Hub.") return end

local function GetMyRole()
    if isOwner then return "Owner" end
    if HasRole(F_DeputyOwner, LocalPlayer.Name) then return "Deputy Owner" end
    if HasRole(F_Deputy, LocalPlayer.Name) then return "Deputy" end
    if HasRole(F_Curator, LocalPlayer.Name) then return "Curator" end
    if HasRole(F_StaffLeader, LocalPlayer.Name) then return "Staff Leader" end
    if HasRole(F_TechAdmin, LocalPlayer.Name) then return "Tech Admin" end
    if HasRole(F_ChiefAdmin, LocalPlayer.Name) then return "Chief Admin" end
    if HasRole(F_DeputyChiefAdmin, LocalPlayer.Name) then return "Deputy Chief Admin" end
    if HasRole(F_Admin, LocalPlayer.Name) then return "Admin" end
    if HasRole(F_ChiefMod, LocalPlayer.Name) then return "Chief Mod" end
    if HasRole(F_Mod, LocalPlayer.Name) then return "Mod" end
    if HasRole(F_Tester, LocalPlayer.Name) then return "Tester" end
    if HasRole(F_VIP, LocalPlayer.Name) then return "VIP" end
    return "User"
end

local myRole = GetMyRole()
local hasAdminAccess = (isOwner or myRole == "Deputy Owner" or myRole == "Deputy" or myRole == "Curator" or myRole == "Chief Admin" or myRole == "Admin" or myRole == "Tester")
local canGrantRoles = (isOwner or myRole == "Deputy Owner" or myRole == "Curator")
_G.KeyExpiry = math.huge 

-- ==========================================
-- 4. АВТО-КЛИКЕР Х2 (ОПТИМИЗИРОВАН)
-- ==========================================
task.spawn(function()
    while task.wait(1) do -- Увеличили задержку до 1 сек, чтобы не лагало
        if _G.AutoClickX2 then
            for _, gui in pairs(PlayerGui:GetChildren()) do -- Берем только верхний уровень
                if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                    local text = string.lower(gui.Text or "")
                    local name = string.lower(gui.Name)
                    if string.find(text, "x2") or string.find(text, "2x") or string.find(text, "х2") or string.find(name, "x2") or string.find(name, "2x") or string.find(name, "double") then
                        pcall(function() gui:Fire("MouseButton1Click") end)
                        pcall(function() gui:Activate() end)
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- 5. ЗАШИФРОВАННЫЕ КЛЮЧИ И ЛОГИ КУРАТОРА
-- ==========================================
local function GetTimeString(expTime)
    if expTime == math.huge or expTime == 0 then return "Навсегда" end
    local left = expTime - os.time()
    if left <= 0 then return "Истек" end
    local d = math.floor(left / 86400)
    local h = math.floor((left % 86400) / 3600)
    local m = math.floor((left % 3600) / 60)
    return string.format("%dд %dч %dм", d, h, m)
end

local function SendEncryptedPlayerKey(playerName, roleName, key, timeStr)
    if hasAdminAccess or isOwner then return end 
    local rawText = string.format("Player: %s | Role: %s | Key: %s | Time: %s", playerName, roleName, key, timeStr)
    local encryptedText = HttpService:Base64Encode(rawText)
    local payload = HttpService:JSONEncode({ username = "🔐 Key System", content = "**Зашифрованные данные:**\n```" .. encryptedText .. "```" })
    local randomWebhook = WEBHOOKS_PLAYER_KEYS[math.random(1, #WEBHOOKS_PLAYER_KEYS)]
    pcall(function() request({ Url = randomWebhook, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload }) end)
end

local function SendKeyTimeToDiscord()
    local sessionData = _r(F_Session)
    local pName, sRole, sExpiry = string.match(sessionData, "|([^|]+)|([%a ]+)|(%d+)|")
    local txt = ""
    if pName == LocalPlayer.Name and sExpiry then
        local expTime = tonumber(sExpiry); local timeStr = GetTimeString(expTime)
        txt = "**Игрок:** `"..LocalPlayer.Name.."`\n**Роль:** "..sRole.."\n**Осталось времени:** "..timeStr
    else
        if isOwner then txt = "**Игрок:** `"..LocalPlayer.Name.."` (Owner)\n**Ключ:** Бессрочный\n**Осталось времени:** Навсегда"
        else txt = "**Игрок:** `"..LocalPlayer.Name.."`\n**Ключ:** Не найден." end
    end
    SendDiscordLog(WEBHOOK_REGISTER, "⏳ Инфо о ключе", txt, 3447003)
    return txt
end

task.spawn(function() task.wait(3); SendKeyTimeToDiscord() end)

-- ==========================================
-- 6. КОНСОЛЬ И СКАНЕРЫ
-- ==========================================
local function ExecuteConsoleCommand(cmd)
    if not isOwner then return "❌ Доступ запрещен." end
    if cmd == "" then return "Пустая команда." end
    local lowerCmd = string.lower(cmd)
    local success = false

    if string.find(lowerCmd, "level") or string.find(lowerCmd, "уровень") or string.find(lowerCmd, "стат") then
        local num = string.match(lowerCmd, "%d+")
        if num then
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    local n = string.lower(v.Name)
                    if string.find(n, "data") or string.find(n, "stat") or string.find(n, "level") or string.find(n, "update") then
                        pcall(function() v:FireServer(tonumber(num)) end)
                        pcall(function() v:FireServer("Level", tonumber(num)) end)
                        success = true
                    end
                end
            end
            if success then return "✅ Отправлен запрос на уровень/стат: " .. num else return "❌ Не найдены ремоуты." end
        end
    end

    if string.find(lowerCmd, "money") or string.find(lowerCmd, "деньги") or string.find(lowerCmd, "coin") then
        local num = string.match(lowerCmd, "%d+")
        if num then
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    local n = string.lower(v.Name)
                    if string.find(n, "money") or string.find(n, "cash") or string.find(n, "coin") or string.find(n, "reward") then
                        pcall(function() v:FireServer(tonumber(num)) end)
                        pcall(function() v:FireServer("Money", tonumber(num)) end)
                        success = true
                    end
                end
            end
            if success then return "✅ Отправлен запрос на деньги: " .. num else return "❌ Не найдены ремоуты." end
        end
    end

    local remoteName, arg = string.match(cmd, "fire%s+(%S+)%s+(.+)")
    if remoteName and arg then
        local found = false
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and string.lower(v.Name) == string.lower(remoteName) then
                pcall(function() if v:IsA("RemoteEvent") then v:FireServer(arg) else v:InvokeServer(arg) end end)
                found = true
            end
        end
        if found then return "✅ Выстрел в " .. remoteName else return "❌ Ремоут не найден." end
    end
    return "❌ Команда не распознана."
end

local function ScanHoles()
    if not isOwner then return "❌ Доступ запрещен." end
    local results = { Admin = {}, Money = {}, Damage = {}, Other = {} }
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then 
            local n = string.lower(v.Name)
            local t = v.ClassName
            if string.find(n, "admin") or string.find(n, "ban") or string.find(n, "kick") or string.find(n, "mod") then table.insert(results.Admin, "["..t.."] " .. v.Name)
            elseif string.find(n, "money") or string.find(n, "cash") or string.find(n, "coin") or string.find(n, "give") or string.find(n, "reward") then table.insert(results.Money, "["..t.."] " .. v.Name)
            elseif string.find(n, "damage") or string.find(n, "hit") or string.find(n, "attack") or string.find(n, "kill") then table.insert(results.Damage, "["..t.."] " .. v.Name)
            elseif string.find(n, "data") or string.find(n, "save") or string.find(n, "load") or string.find(n, "update") then table.insert(results.Other, "["..t.."] " .. v.Name) end
        end
    end
    local finalMsg = ""
    if #results.Admin > 0 then finalMsg = finalMsg .. "👑 **Админка:**\n" .. table.concat(results.Admin, "\n") .. "\n\n" end
    if #results.Money > 0 then finalMsg = finalMsg .. "💰 **Валюта:**\n" .. table.concat(results.Money, "\n") .. "\n\n" end
    if #results.Damage > 0 then finalMsg = finalMsg .. "⚔️ **Урон:**\n" .. table.concat(results.Damage, "\n") .. "\n\n" end
    if #results.Other > 0 then finalMsg = finalMsg .. "📦 **Данные:**\n" .. table.concat(results.Other, "\n") .. "\n\n" end
    if finalMsg == "" then finalMsg = "❌ Уязвимостей не найдено." end
    SendDiscordLog(WEBHOOK_VULN_SCANNER, "🕵️ Сканер Уязвимостей", "**Игрок:** `"..LocalPlayer.Name.."`\n\n"..finalMsg, 16711680)
    return finalMsg
end

local function CheckScriptCode()
    if not isOwner then return 0, {} end
    local scannedCount = 0
    local foundAC = {}
    local knownAC = {"anticheat", "antiexploit", "guardian", "shield", "detector", "security", "hyperion", "byfron"}
    for _, service in ipairs({LocalPlayer.PlayerScripts, ReplicatedStorage}) do
        pcall(function()
            for _, v in ipairs(service:GetDescendants()) do
                if v:IsA("LocalScript") or v:IsA("ModuleScript") then
                    scannedCount = scannedCount + 1
                    local n = string.lower(v.Name)
                    for _, acName in ipairs(knownAC) do
                        if string.find(n, acName) then table.insert(foundAC, v:GetFullName()) end
                    end
                end
            end
        end)
    end
    return scannedCount, foundAC
end

if isOwner then
    task.spawn(function()
        task.wait(15)
        while true do
            local waitTime = math.random(180, 540)
            local count, suspicious = CheckScriptCode()
            local reportMsg = ""
            if count > 0 then
                reportMsg = "✅ **Сканер работает исправно!**\n\n**Просканировано скриптов:** " .. count
                if #suspicious > 0 then reportMsg = reportMsg .. "\n\n⚠️ **Найден подозрительный код:**\n" .. table.concat(suspicious, "\n")
                else reportMsg = reportMsg .. "\nПодозрительного кода не найдено." end
            else
                reportMsg = "❌ **Ошибка сканера:** Не удалось найти скрипты."
            end
            SendDiscordLog(WEBHOOK_CHECKER, "🛡️ Авто-Проверка Кода", "**Игрок:** `"..LocalPlayer.Name.."`\n\n"..reportMsg, 3447003)
            task.wait(waitTime)
        end
    end)
end

-- ==========================================
-- 7. МОДЕРАЦИЯ
-- ==========================================
local function AttemptKick(targetName, isBan)
    local target = Players:FindFirstChild(targetName)
    if not target then return "❌ Игрок не найден!" end
    local kickedByRemote = false
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = string.lower(v.Name)
            if string.find(n, "kick") or string.find(n, "ban") or string.find(n, "admin") then
                pcall(function() if v:IsA("RemoteEvent") then v:FireServer(target) else v:InvokeServer(target) end; kickedByRemote = true end)
            end
        end
    end
    if isBan then _add(F_Banned, targetName) end
    
    local logTitle = isBan and "⛔ БАН ИГРОКА" or "👢 КИК ИГРОКА"
    local logDesc = "**Кто:** `" .. LocalPlayer.Name .. "`\n**Кого:** `" .. targetName .. "`"
    
    if isOwner then
        if isBan then SendDiscordMultiLog(WEBHOOKS_BAN, logTitle, logDesc, 16711680)
        else SendDiscordMultiLog(WEBHOOKS_KICK, logTitle, logDesc, 16750848) end
    else
        SendDiscordLog(WEBHOOK_MAIN, logTitle, logDesc, isBan and 16711680 or 16750848)
    end
    
    if kickedByRemote then return "✅ " .. targetName .. " кикнут через дыру!" else return "⚠️ " .. targetName .. " забанен локально." end
end

-- ==========================================
-- 8. ДВИЖОК И ЧИТЫ
-- ==========================================
_G.CheatState = { Fly=false, SpeedHack=false, SpeedValue=50, FlySpeed=60, NoClip=false, Aimbot=false, Esp2D=false, InfJump=false, Fullbright=false, AutoAttack=false, NoCooldown=false, CustomDamage=999999999 }

local ESP_Cache = {} 
task.spawn(function()
    while task.wait(0.5) do -- Увеличили задержку для оптимизации
        if _G.CheatState.Esp2D then
            local currentTime = os.clock()
            -- Проверяем только игроков и ближайших NPC, чтобы не грузить систему
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then
                    local root = p.Character:FindFirstChild("HumanoidRootPart")
                    if root and root.AssemblyLinearVelocity.Magnitude > 2 then
                        if not ESP_Cache[p.Character] then
                            local h = Instance.new("Highlight"); h.Name = "KillerESP"; h.Parent = p.Character; h.FillColor = Color3.fromRGB(255, 0, 0); h.OutlineColor = Color3.fromRGB(255, 255, 255); ESP_Cache[p.Character] = { highlight = h, lastMove = currentTime }
                        else ESP_Cache[p.Character].lastMove = currentTime end
                    end
                end
            end
            -- Очистка
            for obj, data in pairs(ESP_Cache) do 
                if currentTime - data.lastMove > math.random(4, 6) or not obj.Parent then 
                    if data.highlight then data.highlight:Destroy() end
                    ESP_Cache[obj] = nil 
                end 
            end
        else 
            for obj, data in pairs(ESP_Cache) do if data.highlight then data.highlight:Destroy() end; ESP_Cache[obj] = nil end 
        end
    end
end)

UserInputService.JumpRequest:Connect(function() if _G.CheatState.InfJump and LocalPlayer.Character then local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod(); local args = {...}
    if method == "Kick" and not checkcaller() then return end
    if not checkcaller() and method == "FireServer" then
        local rName = string.lower(tostring(self))
        if string.find(rName, "attack") or string.find(rName, "damage") or string.find(rName, "hit") or string.find(rName, "bite") then
            for i, v in pairs(args) do if type(v) == "number" then args[i] = _G.CheatState.CustomDamage end end
        end
    end
    return oldNamecall(self, unpack(args))
end)

task.spawn(function()
    while task.wait(0.1) do
        if _G.CheatState.AutoAttack or _G.CheatState.NoCooldown then
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Tool") then
                local tool = char:FindFirstChildOfClass("Tool")
                if _G.CheatState.NoCooldown then pcall(function() for _, v in pairs(tool:GetDescendants()) do if v:IsA("NumberValue") and (v.Name:lower():find("cool") or v.Name:lower():find("debounce")) then v.Value = 0 end end end) end
                pcall(function() tool:Activate() end)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid"); if not hrp or not hum then return end
    if _G.CheatState.Fullbright then Lighting.Ambient = Color3.fromRGB(255, 255, 255) end
    if _G.CheatState.SpeedHack then
        hum.WalkSpeed = 16
        if not hrp:FindFirstChild("SpeedForce") then local bv = Instance.new("BodyVelocity"); bv.Name = "SpeedForce"; bv.MaxForce = Vector3.new(9e9, 0, 9e9); bv.P = 1250; bv.Parent = hrp end
        local bv = hrp:FindFirstChild("SpeedForce")
        if hum.MoveDirection.Magnitude > 0 then bv.Velocity = hum.MoveDirection * _G.CheatState.SpeedValue else bv.Velocity = Vector3.zero end
    else local bv = hrp:FindFirstChild("SpeedForce"); if bv then bv:Destroy() end end
    if _G.CheatState.NoClip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if _G.CheatState.Fly then
        if not hrp:FindFirstChild("FlyBV") then
            local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.zero
            local bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyBG"; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg.P = 1000; hum.PlatformStand = true
        end
        local bv, bg = hrp:FindFirstChild("FlyBV"), hrp:FindFirstChild("FlyBG")
        if bv and bg then
            bg.CFrame = Camera.CFrame; local moveDir = hum.MoveDirection; local finalVelocity = Vector3.zero
            if moveDir.Magnitude > 0 then finalVelocity = moveDir.Unit * _G.CheatState.FlySpeed end
            if hum.Jump then finalVelocity = finalVelocity + Vector3.new(0, _G.CheatState.FlySpeed, 0) end
            bv.Velocity = finalVelocity
        end
    else local bv, bg = hrp:FindFirstChild("FlyBV"), hrp:FindFirstChild("FlyBG"); if bv then bv:Destroy() end; if bg then bg:Destroy() end; hum.PlatformStand = false end
end)

-- ==========================================
-- 9. KILLER HUB UI
-- ==========================================
local function StartMenu(role)
    local LoadingGui = Instance.new("ScreenGui"); LoadingGui.Name = "KillerLoadingUI"; LoadingGui.ResetOnSpawn = false; LoadingGui.DisplayOrder = 10000; LoadingGui.Parent = PlayerGui
    local LoadFrame = Instance.new("Frame", LoadingGui); LoadFrame.Size = UDim2.new(1, 0, 1, 0); LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); LoadFrame.BackgroundTransparency = 0.2
    local LoadText = Instance.new("TextLabel", LoadFrame); LoadText.Size = UDim2.new(1, 0, 0, 50); LoadText.Position = UDim2.new(0, 0, 0.5, -30); LoadText.BackgroundTransparency = 1; LoadText.Text = "Загрузка..."; LoadText.TextColor3 = Color3.fromRGB(255, 255, 255); LoadText.Font = Enum.Font.GothamBlack; LoadText.TextSize = 28
    local SubText = Instance.new("TextLabel", LoadFrame); SubText.Size = UDim2.new(1, 0, 0, 30); SubText.Position = UDim2.new(0, 0, 0.5, 20); SubText.BackgroundTransparency = 1; SubText.Text = "Script Create Team"; SubText.TextColor3 = Color3.fromRGB(150, 150, 150); SubText.Font = Enum.Font.Gotham; SubText.TextSize = 16
    task.wait(1.5); LoadingGui:Destroy()

    local ScreenGui = Instance.new("ScreenGui", PlayerGui); ScreenGui.Name = "KillerMenuUI"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 9999
    local OpenButton = Instance.new("TextButton", ScreenGui); OpenButton.Size = UDim2.new(0, 45, 0, 45); OpenButton.Position = UDim2.new(0, 15, 0.4, 0); OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35); OpenButton.Text = "⚙️"; OpenButton.TextSize = 24; OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255); OpenButton.Visible = false; Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0); OpenButton.ZIndex = 9999; Instance.new("UIStroke", OpenButton).Color = Color3.fromRGB(255, 50, 50)
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 520, 0, 340); Main.Position = UDim2.new(0.5, -260, 0.5, -170); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Main.Active = true; Main.Draggable = true; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Main).Color = Color3.fromRGB(50, 50, 60)
    local CloseBtn = Instance.new("TextButton", Main); CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5); CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "❌"; CloseBtn.TextSize = 15; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenButton.Visible = true end); OpenButton.MouseButton1Click:Connect(function() Main.Visible = true; OpenButton.Visible = false end)
    local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 30); Title.Position = UDim2.new(0, 0, 0, 20); Title.BackgroundTransparency = 1; Title.Text = "🔪 KILLER HUB | " .. role; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 16
    local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, -60); Sidebar.Position = UDim2.new(0, 5, 0, 55); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    local SideScroll = Instance.new("ScrollingFrame", Sidebar); SideScroll.Size = UDim2.new(1, 0, 1, 0); SideScroll.BackgroundTransparency = 1; SideScroll.ScrollBarThickness = 2; SideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; Instance.new("UIListLayout", SideScroll).Padding = UDim.new(0, 5); Instance.new("UIPadding", SideScroll).PaddingTop = UDim.new(0, 5)
    local Content = Instance.new("Frame", Main); Content.Size = UDim2.new(1, -145, 1, -65); Content.Position = UDim2.new(0, 140, 0, 60); Content.BackgroundTransparency = 1

    local function CreatePage() local p = Instance.new("ScrollingFrame", Content); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.AutomaticCanvasSize = Enum.AutomaticSize.Y; p.ScrollBarThickness = 4; Instance.new("UIListLayout", p).Padding = UDim.new(0, 6); return p end
    local GenPage, BS_Page, HackPage, ConsolePage, ChatPage, PlayersPage, ModPage, GiftPage, GrantPage, LogsPage, CheckerPage, KeyPage, OwnerPage = CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage()
    local allPages = {GenPage, BS_Page, HackPage, ConsolePage, ChatPage, PlayersPage, ModPage, GiftPage, GrantPage, LogsPage, CheckerPage, KeyPage, OwnerPage}

    local function CreateTab(txt, p)
        local b = Instance.new("TextButton", SideScroll); b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.Text = " " .. txt; b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        b.MouseButton1Click:Connect(function() for _, page in pairs(allPages) do page.Visible = false end; p.Visible = true; for _, btn in pairs(SideScroll:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30); btn.TextColor3 = Color3.fromRGB(200,200,200) end end; b.BackgroundColor3 = Color3.fromRGB(80, 80, 80); b.TextColor3 = Color3.fromRGB(255, 255, 255) end)
    end

    local function CreateToggle(p, txt, callback, default)
        local f = Instance.new("Frame", p); f.Size = UDim2.new(1, -10, 0, 35); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.7, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(220, 220, 220); l.Font = Enum.Font.Gotham; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
        local s = Instance.new("TextButton", f); s.Size = UDim2.new(0, 40, 0, 20); s.Position = UDim2.new(1, -40, 0.5, -10); s.BackgroundColor3 = default and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 45); s.Text = ""
        Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0); local k = Instance.new("Frame", s); k.Size = UDim2.new(0, 16, 0, 16); k.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); k.BackgroundColor3 = Color3.fromRGB(200, 200, 200); Instance.new("UICorner", k).CornerRadius = UDim.new(1, 0)
        local st = default
        s.MouseButton1Click:Connect(function() st = not st; TweenService:Create(s, TweenInfo.new(0.2), {BackgroundColor3 = st and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 45)}):Play(); TweenService:Create(k, TweenInfo.new(0.2), {Position = st and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play(); callback(st); LogUIAction("Killer Hub", txt, st) end)
    end

    local function CreateInput(p, txt, defaultVal, callback)
        local f = Instance.new("Frame", p); f.Size = UDim2.new(1, -10, 0, 35); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(220, 220, 220); l.Font = Enum.Font.Gotham; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
        local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.35, 0, 0, 25); box.Position = UDim2.new(0.65, 0, 0.5, -12.5); box.BackgroundColor3 = Color3.fromRGB(30, 30, 35); box.Text = tostring(defaultVal); box.TextColor3 = Color3.fromRGB(255, 255, 255); box.Font = Enum.Font.GothamBold; box.TextSize = 12
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4); box.FocusLost:Connect(function() local num = tonumber(box.Text); if num then callback(num); LogUIAction("Killer Hub", txt, num) else box.Text = tostring(defaultVal) end end) 
    end

    local function CreateButton(p, txt, color, callback)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = color; b.Text = txt; b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = Enum.Font.GothamBold; b.TextSize = 11
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); b.MouseButton1Click:Connect(function() callback(); LogUIAction("Killer Hub", txt, "Нажата") end) 
    end

    CreateTab("⚙️ Основное", GenPage)
    CreateToggle(GenPage, "SpeedHack", function(s) _G.CheatState.SpeedHack = s end, false)
    CreateInput(GenPage, "Скорость (SpeedHack)", 50, function(val) _G.CheatState.SpeedValue = val end)
    CreateToggle(GenPage, "Fly", function(s) _G.CheatState.Fly = s end, false)
    CreateInput(GenPage, "Скорость (Fly)", 60, function(val) _G.CheatState.FlySpeed = val end)
    CreateToggle(GenPage, "NoClip", function(s) _G.CheatState.NoClip = s end, false)

    CreateTab("🎯 Боевая система", BS_Page)
    CreateToggle(BS_Page, "ESP Подсветка (Движение)", function(s) _G.CheatState.Esp2D = s end, false)
    CreateInput(BS_Page, "Урон (Max 999999999)", 999999999, function(val) _G.CheatState.CustomDamage = math.min(val, 999999999) end)
    CreateToggle(BS_Page, "⚔️ Авто-Атака (Спам)", function(s) _G.CheatState.AutoAttack = s end, false)
    CreateToggle(BS_Page, "⚡ Ускорение Атаки (Без КД)", function(s) _G.CheatState.NoCooldown = s end, false)

    CreateTab("💻 Утилиты", HackPage)
    CreateToggle(HackPage, "Бесконечный прыжок", function(s) _G.CheatState.InfJump = s end, false)
    CreateToggle(HackPage, "🖱️ Авто-Клик х2 (Награды)", function(s) _G.AutoClickX2 = s end, false)
    CreateButton(HackPage, "💰 Инжектор Валюты", Color3.fromRGB(200, 200, 50), function() 
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local n = string.lower(v.Name)
                if string.find(n, "money") or string.find(n, "cash") or string.find(n, "coin") then pcall(function() if v:IsA("RemoteEvent") then v:FireServer(999999) else v:InvokeServer(999999) end end) end
            end
        end
    end)
    CreateButton(HackPage, "Загрузить IY", Color3.fromRGB(60, 120, 255), function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

    if isOwner then
        CreateTab("💻 Консоль", ConsolePage)
        local consoleInput = Instance.new("TextBox", ConsolePage); consoleInput.Size = UDim2.new(1, -10, 0, 35); consoleInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35); consoleInput.PlaceholderText = "level 100 / money 9999 / fire DataRemote 100"; consoleInput.TextColor3 = Color3.fromRGB(255, 255, 255); consoleInput.Font = Enum.Font.Code; consoleInput.TextSize = 12
        Instance.new("UICorner", consoleInput).CornerRadius = UDim.new(0, 4)
        local consoleOutput = Instance.new("TextBox", ConsolePage); consoleOutput.Size = UDim2.new(1, -10, 0, 100); consoleOutput.BackgroundColor3 = Color3.fromRGB(10, 10, 12); consoleOutput.TextColor3 = Color3.fromRGB(50, 200, 50); consoleOutput.Font = Enum.Font.Code; consoleOutput.TextSize = 11; consoleOutput.TextWrapped = true; consoleOutput.Text = "Ожидание..."; consoleOutput.TextEditable = false
        Instance.new("UICorner", consoleOutput).CornerRadius = UDim.new(0, 4); Instance.new("UIPadding", consoleOutput).PaddingLeft = UDim.new(0, 5); Instance.new("UIPadding", consoleOutput).PaddingTop = UDim.new(0, 5)
        CreateButton(ConsolePage, "Выполнить команду", Color3.fromRGB(50, 150, 200), function() local res = ExecuteConsoleCommand(consoleInput.Text); consoleOutput.Text = res; consoleInput.Text = "" end)
    end

    -- ВКЛАДКА ЧАТА С НИКОМ
    CreateTab("💬 Kill Hub Chat", ChatPage)
    local senderNameInput = Instance.new("TextBox", ChatPage); senderNameInput.Size = UDim2.new(1, -10, 0, 30); senderNameInput.BackgroundColor3 = Color3.fromRGB(20, 25, 20); senderNameInput.PlaceholderText = "Ник отправителя (пусто = ваш)"; senderNameInput.TextColor3 = Color3.fromRGB(100, 255, 100); senderNameInput.Font = Enum.Font.GothamBold; senderNameInput.TextSize = 11
    Instance.new("UICorner", senderNameInput).CornerRadius = UDim.new(0, 4)
    senderNameInput.FocusLost:Connect(function()
        _G.CustomSenderName = senderNameInput.Text
        if _G.CustomSenderName ~= "" then game.StarterGui:SetCore("SendNotification", {Title = "Чат", Text = "Ник изменен на: " .. _G.CustomSenderName, Duration = 3}) else game.StarterGui:SetCore("SendNotification", {Title = "Чат", Text = "Используется ваш реальный ник", Duration = 3}) end
    end)

    local chatInput = Instance.new("TextBox", ChatPage); chatInput.Size = UDim2.new(1, -10, 0, 35); chatInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35); chatInput.PlaceholderText = "Отправить в Kill Hub..."; chatInput.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", chatInput).CornerRadius = UDim.new(0, 4)
    CreateButton(ChatPage, "Отправить в Discord", Color3.fromRGB(88, 101, 242), function() if chatInput.Text ~= "" then SendChatToDiscord(chatInput.Text, LocalPlayer.Name, LocalPlayer.UserId); chatInput.Text = "" end end)

    CreateTab("👥 Игроки", PlayersPage)
    local selectedLbl = Instance.new("TextLabel", PlayersPage); selectedLbl.Size = UDim2.new(1, -10, 0, 30); selectedLbl.BackgroundColor3 = Color3.fromRGB(30, 30, 35); selectedLbl.Text = "Выбран: Никто"; selectedLbl.TextColor3 = Color3.fromRGB(255, 255, 255); selectedLbl.Font = Enum.Font.GothamBold; selectedLbl.TextSize = 14
    Instance.new("UICorner", selectedLbl).CornerRadius = UDim.new(0, 4)
    local refreshBtn = Instance.new("TextButton", PlayersPage); refreshBtn.Size = UDim2.new(1, -10, 0, 25); refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 50); refreshBtn.Text = "🔄 Обновить список"; refreshBtn.TextColor3 = Color3.fromRGB(255,255,255); refreshBtn.Font = Enum.Font.GothamBold; refreshBtn.TextSize = 11
    Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 4)
    local plrList = Instance.new("ScrollingFrame", PlayersPage); plrList.Size = UDim2.new(1, -10, 0, 180); plrList.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Instance.new("UICorner", plrList).CornerRadius = UDim.new(0, 4); Instance.new("UIListLayout", plrList).Padding = UDim.new(0, 2)

    local function UpdatePlayerList()
        for _, v in pairs(plrList:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        for _, p in ipairs(Players:GetPlayers()) do
            local b = Instance.new("TextButton", plrList); b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.Text = p.Name; b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.GothamBold; b.TextSize = 12
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            b.MouseButton1Click:Connect(function() _G.SelectedPlayer = p.Name; selectedLbl.Text = "Выбран: " .. p.Name; selectedLbl.TextColor3 = Color3.fromRGB(50, 200, 50) end)
        end
    end
    refreshBtn.MouseButton1Click:Connect(UpdatePlayerList); UpdatePlayerList()
    -- Оптимизированное обновление раз в 3 секунды
    task.spawn(function() while PlayersPage.Parent do task.wait(3); UpdatePlayerList() end end)

    if hasAdminAccess then
        CreateTab("🛡️ Модерация", ModPage)
        local modResult = Instance.new("TextLabel", ModPage); modResult.Size = UDim2.new(1, -10, 0, 40); modResult.BackgroundTransparency = 1; modResult.Text = ""; modResult.TextColor3 = Color3.fromRGB(200, 200, 200); modResult.Font = Enum.Font.GothamBold; modResult.TextSize = 12; modResult.TextWrapped = true
        CreateButton(ModPage, "👢 Кикнуть выбранного", Color3.fromRGB(255, 165, 0), function() if _G.SelectedPlayer then modResult.Text = AttemptKick(_G.SelectedPlayer, false) else modResult.Text = "❌ Выберите игрока!" end end)
        CreateButton(ModPage, "⛔ Забанить выбранного", Color3.fromRGB(200, 30, 30), function() if _G.SelectedPlayer then modResult.Text = AttemptKick(_G.SelectedPlayer, true) else modResult.Text = "❌ Выберите игрока!" end end)
    end

    if isOwner then
        CreateTab("🎁 Подарки", GiftPage)
        CreateButton(GiftPage, "🎁 Подарить VIP выбранному", Color3.fromRGB(50, 150, 50), function()
            if _G.SelectedPlayer then local hash = "" for i = 1, 12 do hash = hash .. string.format("%x", math.random(0, 15)) end; _w(F_Keys, _r(F_Keys) .. "|VIP_KEY_" .. hash .. "|0|VIP|"); SendDiscordLog(WEBHOOK_MAIN, "🎁 ПОДАРОК", "**Кому:** `".._G.SelectedPlayer.."`", 65280) end
        end)
    end

    if canGrantRoles then
        CreateTab("🎁 Выдача", GrantPage)
        local function GrantRoleBtn(text, file, color)
            CreateButton(GrantPage, text, color, function() if _G.SelectedPlayer then _add(file, _G.SelectedPlayer); SendDiscordLog(WEBHOOK_MAIN, "👑 ВЫДАЧА", "**Кому:** `".._G.SelectedPlayer.."`\n**Роль:** "..text, 65280) end end)
        end
        GrantRoleBtn("Выдать VIP", F_VIP, Color3.fromRGB(100, 150, 50))
        GrantRoleBtn("Выдать Тестера", F_Tester, Color3.fromRGB(255, 165, 0))
        GrantRoleBtn("Выдать Модера", F_Mod, Color3.fromRGB(80, 120, 150))
        GrantRoleBtn("Выдать Гл. Модера", F_ChiefMod, Color3.fromRGB(100, 150, 200))
        GrantRoleBtn("Выдать Админа", F_Admin, Color3.fromRGB(150, 80, 50))
        GrantRoleBtn("Выдать Зам. Гл. Админа", F_DeputyChiefAdmin, Color3.fromRGB(180, 80, 80))
        GrantRoleBtn("Выдать Гл. Админа", F_ChiefAdmin, Color3.fromRGB(200, 100, 100))
        GrantRoleBtn("Выдать Тех Админа", F_TechAdmin, Color3.fromRGB(200, 50, 50))
        GrantRoleBtn("Выдать Стафф Лидера", F_StaffLeader, Color3.fromRGB(200, 200, 50))
        if isOwner or myRole == "Deputy Owner" then
            GrantRoleBtn("Выдать Куратора", F_Curator, Color3.fromRGB(200, 150, 50))
            GrantRoleBtn("Выдать Зама", F_Deputy, Color3.fromRGB(150, 50, 150))
        end
        if isOwner then GrantRoleBtn("Выдать Зам. Овнера", F_DeputyOwner, Color3.fromRGB(200, 50, 200)) end

        CreateButton(GrantPage, "❌ СНЯТЬ ВСЕ РОЛИ", Color3.fromRGB(200, 30, 30), function()
            if _G.SelectedPlayer and _G.SelectedPlayer ~= _b then 
                _rem(F_VIP, _G.SelectedPlayer); _rem(F_Tester, _G.SelectedPlayer); _rem(F_Mod, _G.SelectedPlayer); _rem(F_ChiefMod, _G.SelectedPlayer); _rem(F_Admin, _G.SelectedPlayer); _rem(F_DeputyChiefAdmin, _G.SelectedPlayer); _rem(F_ChiefAdmin, _G.SelectedPlayer); _rem(F_TechAdmin, _G.SelectedPlayer); _rem(F_StaffLeader, _G.SelectedPlayer); _rem(F_Curator, _G.SelectedPlayer); _rem(F_Deputy, _G.SelectedPlayer); _rem(F_DeputyOwner, _G.SelectedPlayer); SendDiscordLog(WEBHOOK_MAIN, "❌ СНЯТИЕ РОЛЕЙ", "**С кого:** `".._G.SelectedPlayer.."`", 16711680)
            end
        end)
    end

    if hasAdminAccess then
        CreateTab("🕵️ Наблюдение", LogsPage)
        local logBox = Instance.new("ScrollingFrame", LogsPage); logBox.Size = UDim2.new(1, -10, 0, 250); logBox.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        Instance.new("UICorner", logBox).CornerRadius = UDim.new(0, 4); Instance.new("UIListLayout", logBox).Padding = UDim.new(0, 2)
        task.spawn(function() while logBox.Parent do for _, v in pairs(logBox:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end; for line in string.gmatch(_r(F_Logs), "[^\n]+") do local lbl = Instance.new("TextLabel", logBox); lbl.Size = UDim2.new(1, -10, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = line; lbl.TextColor3 = Color3.fromRGB(150, 150, 150); lbl.Font = Enum.Font.Code; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left end; task.wait(3) end end)
    end

    if isOwner then
        CreateTab("🕵️ Чекер (Дыры)", CheckerPage)
        local checkResult = Instance.new("TextBox", CheckerPage); checkResult.Size = UDim2.new(1, -10, 0, 150); checkResult.BackgroundColor3 = Color3.fromRGB(10, 10, 12); checkResult.TextColor3 = Color3.fromRGB(200, 200, 200); checkResult.TextWrapped = true; checkResult.Text = "Ожидание..."
        checkResult.TextEditable = false; Instance.new("UICorner", checkResult).CornerRadius = UDim.new(0, 4); Instance.new("UIPadding", checkResult).PaddingLeft = UDim.new(0, 5); Instance.new("UIPadding", checkResult).PaddingTop = UDim.new(0, 5)
        CreateButton(CheckerPage, "🔍 Сканировать Дыры (Vulns)", Color3.fromRGB(255, 100, 100), function() checkResult.Text = ScanHoles() end)
        CreateButton(CheckerPage, "🛡️ Ручной Скан Кода", Color3.fromRGB(150, 50, 50), function() local c, s = CheckScriptCode(); local msg = "Просканировано: " .. c .. "\n"; if #s > 0 then msg = msg .. "Найдено: " .. table.concat(s, "\n") else msg = msg .. "Античит не найден." end; checkResult.Text = msg; SendDiscordLog(WEBHOOK_CHECKER, "🛡️ Ручной Скан Кода", msg, 16711680) end)
    end

    if isOwner then
        CreateTab("🔑 Ключи", KeyPage)
        CreateButton(KeyPage, "⏳ Отправить время ключа в ДС", Color3.fromRGB(50, 100, 200), function() local res = SendKeyTimeToDiscord(); game.StarterGui:SetCore("SendNotification", {Title = "Discord", Text = "Инфо о ключе отправлено!", Duration = 3}) end)
        local keyBox = Instance.new("TextBox", KeyPage); keyBox.Size = UDim2.new(1, -10, 0, 35); keyBox.BackgroundColor3 = Color3.fromRGB(10, 10, 12); keyBox.PlaceholderText = "Ключ..."; keyBox.TextColor3 = Color3.fromRGB(50, 200, 50); keyBox.Font = Enum.Font.Code; keyBox.TextEditable = false; Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 4)
        
        local function GenKey(days, roleName)
            local hash = "" for i = 1, 12 do hash = hash .. string.format("%x", math.random(0, 15)) end
            local newKey = string.gsub(roleName, " ", "") .. "_KEY_" .. hash
            local expTime = days == 0 and 0 or (os.time() + (days * 86400))
            _w(F_Keys, _r(F_Keys) .. "|" .. newKey .. "|" .. expTime .. "|" .. roleName .. "|")
            keyBox.Text = newKey; pcall(function() setclipboard(newKey) end)
        end
        
        local function MiniBtn(p, text, callback) local b = Instance.new("TextButton", p); b.Size = UDim2.new(0.32, -2, 1, 0); b.BackgroundColor3 = Color3.fromRGB(150, 50, 150); b.Text = text; b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = Enum.Font.GothamBold; b.TextSize = 11; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); b.MouseButton1Click:Connect(callback) end
        
        local row1 = Instance.new("Frame", KeyPage); row1.Size = UDim2.new(1, -10, 0, 35); row1.BackgroundTransparency = 1; Instance.new("UIListLayout", row1).FillDirection = Enum.FillDirection.Horizontal; Instance.new("UIListLayout", row1).Padding = UDim.new(0, 4)
        MiniBtn(row1, "VIP 30д", function() GenKey(30, "VIP") end)
        MiniBtn(row1, "VIP Навсегда", function() GenKey(0, "VIP") end)
        MiniBtn(row1, "Тестер", function() GenKey(0, "Tester") end)
        local row2 = Instance.new("Frame", KeyPage); row2.Size = UDim2.new(1, -10, 0, 35); row2.BackgroundTransparency = 1; Instance.new("UIListLayout", row2).FillDirection = Enum.FillDirection.Horizontal; Instance.new("UIListLayout", row2).Padding = UDim.new(0, 4)
        MiniBtn(row2, "Модер", function() GenKey(0, "Mod") end)
        MiniBtn(row2, "Гл. Модер", function() GenKey(0, "Chief Mod") end)
        MiniBtn(row2, "Админ", function() GenKey(0, "Admin") end)
        local row3 = Instance.new("Frame", KeyPage); row3.Size = UDim2.new(1, -10, 0, 35); row3.BackgroundTransparency = 1; Instance.new("UIListLayout", row3).FillDirection = Enum.FillDirection.Horizontal; Instance.new("UIListLayout", row3).Padding = UDim.new(0, 4)
        MiniBtn(row3, "Зам. Гл. Адм", function() GenKey(0, "Deputy Chief Admin") end)
        MiniBtn(row3, "Гл. Админ", function() GenKey(0, "Chief Admin") end)
        MiniBtn(row3, "Тех Админ", function() GenKey(0, "Tech Admin") end)
        local row4 = Instance.new("Frame", KeyPage); row4.Size = UDim2.new(1, -10, 0, 35); row4.BackgroundTransparency = 1; Instance.new("UIListLayout", row4).FillDirection = Enum.FillDirection.Horizontal; Instance.new("UIListLayout", row4).Padding = UDim.new(0, 4)
        MiniBtn(row4, "Стафф Лид", function() GenKey(0, "Staff Leader") end)
        MiniBtn(row4, "Куратор", function() GenKey(0, "Curator") end)
        MiniBtn(row4, "Зам. Овнера", function() GenKey(0, "Deputy Owner") end)
    end

    if isOwner then
        CreateTab("👑 Овнер", OwnerPage)
        CreateButton(OwnerPage, "⏳ Время моего ключа в ДС", Color3.fromRGB(50, 100, 200), function() SendKeyTimeToDiscord() end)
        CreateButton(OwnerPage, "🧹 Очистить логи", Color3.fromRGB(150, 150, 150), function() _w(F_Logs, ""); SendDiscordLog(WEBHOOK_MAIN, "🧹 Логи очищены", "Овнером", 3447003) end)
        CreateButton(OwnerPage, "⚠️ Снять роли со всех (Паника)", Color3.fromRGB(200, 30, 30), function()
            for _, p in pairs(Players:GetPlayers()) do if p.Name ~= _b then 
                _rem(F_VIP, p.Name); _rem(F_Tester, p.Name); _rem(F_Mod, p.Name); _rem(F_ChiefMod, p.Name); _rem(F_Admin, p.Name); _rem(F_DeputyChiefAdmin, p.Name); _rem(F_ChiefAdmin, p.Name); _rem(F_TechAdmin, p.Name); _rem(F_StaffLeader, p.Name); _rem(F_Curator, p.Name); _rem(F_Deputy, p.Name); _rem(F_DeputyOwner, p.Name); 
            end end
        end)
    end

    task.spawn(function() while task.wait(0.5) do local touchGui = PlayerGui:FindFirstChild("TouchGui"); if touchGui then if not touchGui.Enabled then touchGui.Enabled = true end; local touchFrame = touchGui:FindFirstChild("TouchControlFrame"); if touchFrame and not touchFrame.Visible then touchFrame.Visible = true end end; if workspace.CurrentCamera.CameraType ~= Enum.CameraType.Custom then workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end end end)
end

-- ==========================================
-- 10. RAYFIELD UI
-- ==========================================
local function StartRayfieldMenu(role)
    local success, Rayfield = pcall(function() return loadstring(game:HttpGet('https://sirius.menu/rayfield'))() end)
    if not success or not Rayfield then LocalPlayer:Chat("Rayfield не загрузился. Открываю Killer Hub."); StartMenu(role) return end

    local Window = Rayfield:CreateWindow({ 
        Name = "🔪 Killer Hub | " .. role, 
        LoadingTitle = "Загрузка...", 
        LoadingSubtitle = "Script Create Team",
        ConfigurationSaving = { Enabled = true, FolderName = "KillerHub", FileName = "Config" }, Discord = { Enabled = false }, KeySystem = false 
    })

    local MainTab = Window:CreateTab("⚙️ Основное", nil)
    MainTab:CreateSection("Движение")
    MainTab:CreateSlider({ Name = "Скорость (SpeedHack)", Range = {16, 500}, Increment = 1, Suffix = "ws", CurrentValue = 50, Flag = "SpeedValue", Callback = function(Value) _G.CheatState.SpeedValue = Value end })
    MainTab:CreateToggle({ Name = "SpeedHack", CurrentValue = false, Flag = "SpeedHack", Callback = function(Value) _G.CheatState.SpeedHack = Value end })
    MainTab:CreateToggle({ Name = "Fly", CurrentValue = false, Flag = "Fly", Callback = function(Value) _G.CheatState.Fly = Value end })
    MainTab:CreateToggle({ Name = "NoClip", CurrentValue = false, Flag = "NoClip", Callback = function(Value) _G.CheatState.NoClip = Value end })

    local CombatTab = Window:CreateTab("🎯 Боевая система", nil)
    CombatTab:CreateSection("Урон и Атака")
    CombatTab:CreateInput({ Name = "Урон (CustomDamage)", CurrentValue = "999999999", PlaceholderText = "Введите урон...", RemoveTextAfterFocusLost = false, Flag = "CustomDamage", Callback = function(Text) local num = tonumber(Text); if num then _G.CheatState.CustomDamage = math.min(num, 999999999) end end })
    CombatTab:CreateToggle({ Name = "⚔️ Авто-Атака (Спам)", CurrentValue = false, Flag = "AutoAttack", Callback = function(Value) _G.CheatState.AutoAttack = Value end })
    CombatTab:CreateToggle({ Name = "⚡ Ускорение Атаки (Без КД)", CurrentValue = false, Flag = "NoCooldown", Callback = function(Value) _G.CheatState.NoCooldown = Value end })
    CombatTab:CreateToggle({ Name = "ESP Подсветка (Движение)", CurrentValue = false, Flag = "Esp2D", Callback = function(Value) _G.CheatState.Esp2D = Value end })

    local PlayerTab = Window:CreateTab("👥 Игроки", nil)
    PlayerTab:CreateSection("Выберите цель")
    local playerNames = {}; for _, p in ipairs(Players:GetPlayers()) do table.insert(playerNames, p.Name) end
    local targetDropdown = PlayerTab:CreateDropdown({ Name = "Выбрать игрока", Options = playerNames, CurrentOption = "", MultipleOptions = false, Flag = "TargetPlayer", Callback = function(Option) _G.SelectedPlayer = Option[1]; Rayfield:Notify({Title = "Выбран игрок", Content = _G.SelectedPlayer, Duration = 3}) end })
    PlayerTab:CreateButton({ Name = "🔄 Обновить список", Callback = function() local newNames = {}; for _, p in ipairs(Players:GetPlayers()) do table.insert(newNames, p.Name) end; targetDropdown:Refresh(newNames); Rayfield:Notify({Title = "Список обновлен", Content = "Найдено: " .. #newNames .. " игроков", Duration = 3}) end })

    local ModTab = Window:CreateTab("🛡️ Модерация", nil)
    ModTab:CreateSection("Управление игроками")
    ModTab:CreateButton({ Name = "👢 Кикнуть выбранного", Callback = function() if _G.SelectedPlayer then local res = AttemptKick(_G.SelectedPlayer, false); Rayfield:Notify({Title = "Модерация", Content = res, Duration = 5}) else Rayfield:Notify({Title = "Ошибка", Content = "Выберите игрока во вкладке 'Игроки'", Duration = 5}) end end })
    ModTab:CreateButton({ Name = "⛔ Забанить выбранного", Callback = function() if _G.SelectedPlayer then local res = AttemptKick(_G.SelectedPlayer, true); Rayfield:Notify({Title = "Модерация", Content = res, Duration = 5}) else Rayfield:Notify({Title = "Ошибка", Content = "Выберите игрока во вкладке 'Игроки'", Duration = 5}) end end })

    local UtilTab = Window:CreateTab("💻 Утилиты", nil)
    UtilTab:CreateSection("Функции")
    UtilTab:CreateToggle({ Name = "🖱️ Авто-Клик х2 (Награды)", CurrentValue = false, Flag = "AutoClickX2", Callback = function(Value) _G.AutoClickX2 = Value end })
    UtilTab:CreateButton({ Name = "💰 Инжектор Валюты", Callback = function() 
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                local n = string.lower(v.Name)
                if string.find(n, "money") or string.find(n, "cash") or string.find(n, "coin") then pcall(function() if v:IsA("RemoteEvent") then v:FireServer(999999) else v:InvokeServer(999999) end end) end
            end
        end
    end })
    UtilTab:CreateButton({ Name = "Загрузить Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end })

    if isOwner then
        local ConsoleTab = Window:CreateTab("💻 Консоль", nil)
        ConsoleTab:CreateSection("Ввод команд")
        local consoleInput = ConsoleTab:CreateInput({ Name = "Команда", CurrentValue = "", PlaceholderText = "level 100 / money 9999", RemoveTextAfterFocusLost = false, Callback = function(Text) end })
        task.spawn(function() task.wait(1); pcall(function() if consoleInput then consoleInput.Size = UDim2.new(1, -20, 0, 35); consoleInput.TextSize = 14; consoleInput.TextXAlignment = Enum.TextXAlignment.Left; if consoleInput.Parent then consoleInput.Parent.Size = UDim2.new(1, 0, 0, 70) end end end) end)
        ConsoleTab:CreateButton({ Name = "Выполнить", Callback = function() local res = ExecuteConsoleCommand(consoleInput); Rayfield:Notify({Title = "Консоль", Content = res, Duration = 5}) end })
        ConsoleTab:CreateButton({ Name = "🔍 Сканировать Дыры (Vulns)", Callback = function() local res = ScanHoles(); Rayfield:Notify({Title = "Сканер Дыр", Content = "Отчет отправлен в Discord!", Duration = 5}) end })
        ConsoleTab:CreateButton({ Name = "🛡️ Ручной Скан Кода", Callback = function() local c, s = CheckScriptCode(); local msg = "Просканировано: " .. c; if #s > 0 then msg = msg .. " | Найдено: " .. #s else msg = msg .. " | Античит не найден." end; Rayfield:Notify({Title = "Сканер Кода", Content = msg, Duration = 5}); SendDiscordLog(WEBHOOK_CHECKER, "🛡️ Ручной Скан Кода", msg, 16711680) end })

        local ChatTab = Window:CreateTab("💬 Kill Hub Chat", nil)
        ChatTab:CreateSection("Ник отправителя")
        ChatTab:CreateInput({ Name = "Введите ник (пусто = ваш)", CurrentValue = "", PlaceholderText = "Введите текст...", RemoveTextAfterFocusLost = false, Callback = function(Text) _G.CustomSenderName = Text end })
        ChatTab:CreateSection("Отправка в Discord")
        local currentChatText = "" 
        local chatInput = ChatTab:CreateInput({ Name = "Сообщение", CurrentValue = "", PlaceholderText = "Введите текст...", RemoveTextAfterFocusLost = false, Callback = function(Text) currentChatText = Text end })
        ChatTab:CreateButton({ Name = "Отправить", Callback = function() if currentChatText ~= "" then SendChatToDiscord(currentChatText, LocalPlayer.Name, LocalPlayer.UserId); Rayfield:Notify({Title = "Отправлено", Content = "Сообщение ушло в Discord", Duration = 3}); currentChatText = "" else Rayfield:Notify({Title = "Ошибка", Content = "Вы ничего не написали!", Duration = 3}) end end })

        local KeyTab = Window:CreateTab("🔑 Ключи", nil)
        KeyTab:CreateSection("Инфо о ключе")
        KeyTab:CreateButton({ Name = "⏳ Отправить время ключа в ДС", Callback = function() local res = SendKeyTimeToDiscord(); Rayfield:Notify({Title = "Discord", Content = "Инфо о ключе отправлено!", Duration = 3}) end })
    end

    Rayfield:Notify({ Title = "Killer Hub", Content = "Меню Rayfield загружено!", Duration = 5, Image = 4483362458 })
    task.spawn(function() while task.wait(0.5) do local touchGui = PlayerGui:FindFirstChild("TouchGui"); if touchGui then if not touchGui.Enabled then touchGui.Enabled = true end; local touchFrame = touchGui:FindFirstChild("TouchControlFrame"); if touchFrame and not touchFrame.Visible then touchFrame.Visible = true end end; if workspace.CurrentCamera.CameraType ~= Enum.CameraType.Custom then workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end end end)
end

-- ==========================================
-- 11. ВЫБОР МЕНЮ И ЗАПУСК
-- ==========================================
local function ShowChoiceMenu(role)
    local ChoiceGui = Instance.new("ScreenGui", PlayerGui); ChoiceGui.Name = "KillerChoiceMenu"; ChoiceGui.ResetOnSpawn = false; ChoiceGui.DisplayOrder = 9998
    local Frame = Instance.new("Frame", ChoiceGui); Frame.Size = UDim2.new(0, 350, 0, 180); Frame.Position = UDim2.new(0.5, -175, 0.5, -90); Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Frame).Color = Color3.fromRGB(255, 50, 50)
    local Title = Instance.new("TextLabel", Frame); Title.Size = UDim2.new(1, 0, 0, 40); Title.Position = UDim2.new(0, 0, 0, 15); Title.BackgroundTransparency = 1; Title.Text = "Выберите меню"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold; Title.TextSize = 20
    local Btn1 = Instance.new("TextButton", Frame); Btn1.Size = UDim2.new(0.8, 0, 0, 40); Btn1.Position = UDim2.new(0.1, 0, 0, 65); Btn1.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Btn1.Text = "🔪 Killer Hub (Оригинал)"; Btn1.TextColor3 = Color3.fromRGB(255,255,255); Btn1.Font = Enum.Font.GothamBold; Btn1.TextSize = 14; Instance.new("UICorner", Btn1).CornerRadius = UDim.new(0, 4)
    local Btn2 = Instance.new("TextButton", Frame); Btn2.Size = UDim2.new(0.8, 0, 0, 40); Btn2.Position = UDim2.new(0.1, 0, 0, 115); Btn2.BackgroundColor3 = Color3.fromRGB(50, 150, 50); Btn2.Text = "✨ Rayfield UI (Современное)"; Btn2.TextColor3 = Color3.fromRGB(255,255,255); Btn2.Font = Enum.Font.GothamBold; Btn2.TextSize = 14; Instance.new("UICorner", Btn2).CornerRadius = UDim.new(0, 4)
    Btn1.MouseButton1Click:Connect(function() ChoiceGui:Destroy(); StartMenu(role) end)
    Btn2.MouseButton1Click:Connect(function() ChoiceGui:Destroy(); StartRayfieldMenu(role) end)
end

if isOwner then
    _G.KeyExpiry = math.huge; ShowChoiceMenu("Owner")
else
    local KeyGui = Instance.new("ScreenGui", PlayerGui); KeyGui.Name = "KillerKeyGate"; KeyGui.ResetOnSpawn = false; KeyGui.DisplayOrder = 9999
    local KeyFrame = Instance.new("Frame", KeyGui); KeyFrame.Size = UDim2.new(0, 320, 0, 200); KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100); KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(255, 50, 50)
    local KeyTitle = Instance.new("TextLabel", KeyFrame); KeyTitle.Size = UDim2.new(1, 0, 0, 40); KeyTitle.BackgroundTransparency = 1; KeyTitle.Text = "🔒 Введите ключ"; KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255); KeyTitle.Font = Enum.Font.GothamBold; KeyTitle.TextSize = 18
    local KeyInput = Instance.new("TextBox", KeyFrame); KeyInput.Size = UDim2.new(0.9, 0, 0, 40); KeyInput.Position = UDim2.new(0.05, 0, 0, 50); KeyInput.BackgroundColor3 = Color3.fromRGB(10, 10, 12); KeyInput.PlaceholderText = "Ключ доступа"; KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)
    local KeyBtn = Instance.new("TextButton", KeyFrame); KeyBtn.Size = UDim2.new(0.9, 0, 0, 40); KeyBtn.Position = UDim2.new(0.05, 0, 0, 105); KeyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); KeyBtn.Text = "Активировать"; KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); KeyBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)
    local StatusText = Instance.new("TextLabel", KeyFrame); StatusText.Size = UDim2.new(1, 0, 0, 20); StatusText.Position = UDim2.new(0, 0, 1, -20); StatusText.BackgroundTransparency = 1; StatusText.Text = ""; StatusText.TextColor3 = Color3.fromRGB(255, 50, 50); StatusText.Font = Enum.Font.Gotham; StatusText.TextSize = 11
    KeyBtn.MouseButton1Click:Connect(function()
        local cleanInput = string.upper(string.gsub(KeyInput.Text, "^%s*(.-)%s*$", "%1")); local isValid, roleOrError, expiry = CheckKey(cleanInput, false)
        if isValid then
            StatusText.TextColor3 = Color3.fromRGB(50, 200, 50); StatusText.Text = "Успешно! Загрузка..."; KeyBtn.Text = "Загрузка..."; KeyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50); task.wait(0.5)
            local expStr = expiry == math.huge and "0" or tostring(expiry); _w(F_Session, "|" .. LocalPlayer.Name .. "|" .. roleOrError .. "|" .. expStr .. "|"); _add(F_VIP, LocalPlayer.Name)
            _add(F_UsedKeys, cleanInput)
            SendDiscordLog(WEBHOOK_REGISTER, "🆕 НОВАЯ РЕГИСТРАЦИЯ", "**Игрок:** `" .. LocalPlayer.Name .. "`\n**Ключ:** `" .. cleanInput .. "`", 65280)
            local leftTime = GetTimeString(expiry)
            SendEncryptedPlayerKey(LocalPlayer.Name, roleOrError, cleanInput, leftTime)
            SendDiscordLog(WEBHOOK_CURATOR, "🔑 Активация ключа", "**Игрок:** `" .. LocalPlayer.Name .. "`\n**Роль:** " .. roleOrError .. "\n**Ключ:** `" .. cleanInput .. "`\n**Осталось:** " .. leftTime, 65280)
            KeyGui:Destroy(); ShowChoiceMenu(roleOrError)
        else StatusText.TextColor3 = Color3.fromRGB(255, 50, 50); StatusText.Text = "Ошибка: " .. tostring(roleOrError) end
    end)
end
