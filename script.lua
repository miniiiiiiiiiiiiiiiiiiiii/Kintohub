--[[
    @Projet: Kinto Panel - Ultimate Cyber Edition
]]

local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Fluent.lua"))()
end)

if not success or not Fluent then
    -- Second essai avec un autre lien miroir au cas où
    success, Fluent = pcall(function()
        return loadstring(game:HttpGet("https://github.com/violin-suzutsuki/Fluent/raw/main/Fluent.lua"))()
    end)
end

if not success or not Fluent then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kinto Erreur",
        Text = "Impossible de charger la librairie Fluent !",
        Duration = 5
    })
    return
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local Window = Fluent:CreateWindow({
    Title = "⚡ KINTO.PANEL // ULTIMATE v5.0",
    SubTitle = "by Kinto Team - Hub Universel",
    TabWidth = 180,
    Size = UDim2.fromOffset(620, 500),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

Fluent:ToggleAcrylic(true)

local Tabs = {
    Dashboard = Window:AddTab({ Title = "📊 Dashboard & Infos", Icon = "home" }),
    Combat = Window:AddTab({ Title = "🎯 Aimbot & Combat", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "👀 ESP & Wallhack", Icon = "eye" }),
    Movement = Window:AddTab({ Title = "⚡ Mouvements God", Icon = "zap" }),
    World = Window:AddTab({ Title = "🌍 Monde & Serveur", Icon = "globe" }),
    Troll = Window:AddTab({ Title = "💀 Trolling & Fun", Icon = "smile" }),
    Settings = Window:AddTab({ Title = "⚙️ Paramètres", Icon = "settings" })
}

local Options = Fluent.Options

Fluent:Notify({
    Title = "Kinto Panel v5.0 Chargé",
    Content = "Bienvenue dans l'interface Cyberpunk Kinto !",
    Duration = 5
})

-- ==========================================
-- 1. DASHBOARD & INFOS COMPTE
-- ==========================================

Tabs.Dashboard:AddParagraph({
    Title = "👤 Informations de ton Compte",
    Content = "Pseudo : " .. LocalPlayer.Name .. "\n" ..
              "ID Utilisateur : " .. LocalPlayer.UserId .. "\n" ..
              "Âge du compte : " .. LocalPlayer.AccountAge .. " jours\n" ..
              "Place ID actuel : " .. game.PlaceId
})

local StatsParagraph = Tabs.Dashboard:AddParagraph({
    Title = "📈 Monitoring du Système",
    Content = "Analyse des performances..."
})

task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        StatsParagraph:SetDesc("FPS Actuels : " .. fps .. " | Ping : " .. ping .. " ms\nStatut : Exécution sécurisée & indétectée")
    end
end)

-- ==========================================
-- 2. COMBAT & AIMBOT
-- ==========================================

Tabs.Combat:AddToggle("AimbotToggle", {
    Title = "🎯 Aimbot Universel (Caméra Lock)",
    Description = "Verrouille la vue sur la tête de la cible la plus proche.",
    Default = false
})

RunService.RenderStepped:Connect(function()
    if Options.AimbotToggle and Options.AimbotToggle.Value then
        local cam = Workspace.CurrentCamera
        local target, minDst = nil, math.huge
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local screenPt, onScreen = cam:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dst = (Vector2.new(screenPt.X, screenPt.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if dst < minDst then
                        minDst = dst
                        target = head
                    end
                end
            end
        end
        
        if target then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
        end
    end
end)

Tabs.Combat:AddButton({
    Title = "💥 Hitbox Extender (Têtes géantes)",
    Description = "Élargit les hitbox des ennemis pour ne jamais rater un tir.",
    Callback = function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                p.Character.Head.Size = Vector3.new(6, 6, 6)
                p.Character.Head.Transparency = 0.6
                p.Character.Head.CanCollide = false
            end
        end
        Fluent:Notify({Title = "Kinto Combat", Content = "Hitboxes étendues avec succès !", Duration = 3})
    end
})

-- ==========================================
-- 3. ESP & VISUELS
-- ==========================================

local ESPToggle = Tabs.Visuals:AddToggle("ESPToggle", {
    Title = "👀 ESP Joueurs (Highlight Néon)",
    Description = "Affiche une surbrillance orange sur les joueurs à travers les murs.",
    Default = false
})

ESPToggle:OnChanged(function(Value)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local exist = p.Character:FindFirstChild("KintoESP")
            if Value then
                if not exist then
                    local hl = Instance.new("Highlight")
                    hl.Name = "KintoESP"
                    hl.Adornee = p.Character
                    hl.FillColor = Color3.fromRGB(255, 102, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                end
            else
                if exist then exist:Destroy() end
            end
        end
    end
end)

Tabs.Visuals:AddButton({
    Title = "🌙 Fullbright Ultime (Mode Nuit Blanc)",
    Description = "Supprime les ombres et illumine toute la carte.",
    Callback = function()
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
        Fluent:Notify({Title = "Kinto Visuels", Content = "Fullbright activé.", Duration = 3})
    end
})

-- ==========================================
-- 4. MOUVEMENTS GODSPEED
-- ==========================================

Tabs.Movement:AddSlider("WalkSpeedSlider", {
    Title = "⚡ Vitesse de Course (WalkSpeed)",
    Description = "Modifie la vitesse de déplacement.",
    Default = 16,
    Min = 16,
    Max = 350,
    Rounding = 1,
    Callback = function(Val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Val
        end
    end
})

Tabs.Movement:AddSlider("JumpPowerSlider", {
    Title = "🚀 Puissance de Saut (JumpPower)",
    Description = "Saute beaucoup plus haut.",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 1,
    Callback = function(Val)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            hum.UseJumpPower = true
            hum.JumpPower = Val
        end
    end
})

local NoclipEnabled = false
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

Tabs.Movement:AddToggle("NoclipToggle", {
    Title = "👻 Noclip (Traverser les murs)",
    Description = "Permet de passer à travers n'importe quel obstacle.",
    Default = false
}):OnChanged(function(Val)
    NoclipEnabled = Val
end)

-- ==========================================
-- 5. MONDE & SERVEUR
-- ==========================================

Tabs.World:AddButton({
    Title = "🔄 Reconnexion Rapide (Rejoin)",
    Description = "Te reconnecte immédiatement au même serveur.",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

-- ==========================================
-- 6. TROLL & FUN
-- ==========================================

Tabs.Troll:AddButton({
    Title = "🛡️ Anti-Ragdoll / Anti-Stun",
    Description = "Empêche ton personnage d'être bloqué ou assommé.",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Fluent:Notify({Title = "Kinto Protection", Content = "Anti-Ragdoll activé !", Duration = 3})
        end
    end
})

Tabs.Troll:AddButton({
    Title = "⚡ Désancrage Instantané (Unfreeze)",
    Description = "Te débloque si le jeu t'immobilise de force.",
    Callback = function()
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                end
            end
            Fluent:Notify({Title = "Kinto Libération", Content = "Libéré avec succès !", Duration = 3})
        end
    end
})

Window:SelectTab(1)
Fluent:Notify({
    Title = "Kinto Panel Prêt !",
    Content = "Appuie sur 'RightControl' pour masquer/afficher le menu.",
    Duration = 6
})
