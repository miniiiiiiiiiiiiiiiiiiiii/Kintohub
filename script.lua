--[[
    @Projet: Kinto Panel - Ultimate Cyber Edition
]]

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    warn("[Kinto Panel] Erreur de chargement de l'UI Library")
    return
end

-- Création de la fenêtre principale aux couleurs sombres/cyber
local Window = Rayfield:CreateWindow({
    Name = "⚡ KINTO.PANEL // ULTIMATE v5.0",
    LoadingTitle = "Kinto Interface",
    LoadingSubtitle = "Chargement du Hub...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KintoHub",
        FileName = "Config"
    },
    KeySystem = false
})

-- Création des onglets principaux (similaires à ton image)
local TabDashboard = Window:CreateTab("📊 Dashboard & Infos", 4483362458)
local TabFinances = Window:CreateTab("💳 Finances & Abonnements", 4483362458)
local TabCombat = Window:CreateTab("🎯 Combat & Aimbot", 4483362458)

-- Exemple de carte / section propre dans le Dashboard
TabDashboard:CreateSection("Monitoring du Système")

TabDashboard:CreateParagraph({
    Title = "Statut du Joueur",
    Content = "Pseudo : " .. game.Players.LocalPlayer.Name .. "\nFPS : 240 | Ping stable"
})

-- Exemple de boutons d'action (comme sur ton design)
TabFinances:CreateSection("Gestion de crédits & facturation")

TabFinances:CreateButton({
    Name = "Activer Finances #1",
    Callback = function()
        Rayfield:Notify({
            Title = "Kinto Panel",
            Content = "Module Finances #1 exécuté avec succès !",
            Duration = 4,
            Image = 4483362458
        })
    end
})

TabFinances:CreateButton({
    Name = "Configurer Finances #2",
    Callback = function()
        -- Ton code ici
    end
})
