-- AK3000 Hub - Delta Executor Standalone
-- Sem dependências externas

print("=" .. string.rep("=", 48) .. "=")
print("AK3000 HUB - INICIANDO...")
print("=" .. string.rep("=", 48) .. "=")

-- Teste básico
local test = pcall(function()
    return game:GetService("Players").LocalPlayer.Name
end)

if test then
    print("✅ Script rodando corretamente!")
else
    warn("❌ Erro ao executar script!")
    return
end

-- [[ Services ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

print("✅ Player detectado: " .. LocalPlayer.Name)

-- [[ Variables ]] --
_G.ScriptActive = true
_G.AutoFarm = false
_G.ShowESP = false
_G.WorldName = "Desconhecido"

-- Detectar mundo
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    _G.WorldName = "Sea 1"
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    _G.WorldName = "Sea 2"
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    _G.WorldName = "Sea 3"
end

print("🌍 Mundo: " .. _G.WorldName)

-- [[ Character Handler ]] --
local Character = LocalPlayer.Character
if Character then
    print("✅ Personagem detectado")
else
    print("⏳ Aguardando personagem...")
end

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    print("✅ Novo personagem carregado!")
end)

-- [[ Anti-AFK ]] --
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    print("🔄 Anti-AFK ativado")
end)

-- [[ Funções Úteis ]] --
function getLevel()
    local level = pcall(function()
        return LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    end)
    return level or 1
end

function getCurrentMoney()
    local money = pcall(function()
        return LocalPlayer:WaitForChild("Data"):WaitForChild("Money").Value
    end)
    return money or 0
end

function getTotalBounty()
    local bounty = pcall(function()
        return LocalPlayer:WaitForChild("Data"):WaitForChild("Bounty").Value
    end)
    return bounty or 0
end

-- [[ Info Principal ]] --
spawn(function()
    while _G.ScriptActive do
        wait(2)
        local level = getLevel()
        print("📊 Level: " .. level .. " | Mundo: " .. _G.WorldName)
    end
end)

-- [[ Atalhos do Teclado ]] --
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F para ativar/desativar Farm
    if input.KeyCode == Enum.KeyCode.F then
        _G.AutoFarm = not _G.AutoFarm
        print(_G.AutoFarm and "🟢 Farm ATIVADO" or "🔴 Farm DESATIVADO")
    end
    
    -- E para ativar/desativar ESP
    if input.KeyCode == Enum.KeyCode.E then
        _G.ShowESP = not _G.ShowESP
        print(_G.ShowESP and "👁️ ESP ATIVADO" or "👁️ ESP DESATIVADO")
    end
end)

print("=" .. string.rep("=", 48) .. "=")
print("✅ AK3000 HUB CARREGADO COM SUCESSO!")
print("=" .. string.rep("=", 48) .. "=")
print("")
print("📋 CONTROLES:")
print("F - Ativar/Desativar AutoFarm")
print("E - Ativar/Desativar ESP")
print("")
print("✨ Script está rodando! Veja o console para mais detalhes.")
print("")

_G.AK3000HubLoaded = true
