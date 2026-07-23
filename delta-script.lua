print("=" .. string.rep("=", 50) .. "=")
print("AK3000 HUB - INICIANDO...")
print("=" .. string.rep("=", 50) .. "=")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("✅ Script iniciado!")
print("✅ Player: " .. LocalPlayer.Name)

-- Detectar mundo
local worldName = "Desconhecido"
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    worldName = "Sea 1"
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    worldName = "Sea 2"
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    worldName = "Sea 3"
end

print("🌍 Mundo detectado: " .. worldName)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    print("🔄 Anti-AFK ativado")
end)

-- Variables globais
_G.AutoFarm = false
_G.ShowESP = false
_G.ScriptRunning = true

-- Atalhos
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        _G.AutoFarm = not _G.AutoFarm
        print(_G.AutoFarm and "✅ Farm ATIVADO" or "❌ Farm DESATIVADO")
    end
    
    if input.KeyCode == Enum.KeyCode.E then
        _G.ShowESP = not _G.ShowESP
        print(_G.ShowESP and "✅ ESP ATIVADO" or "❌ ESP DESATIVADO")
    end
end)

print("\n" .. string.rep("=", 50))
print("✅ AK3000 HUB CARREGADO COM SUCESSO!")
print(string.rep("=", 50) .. "\n")
print("📋 CONTROLES:")
print("   F = Ativar/Desativar Farm")
print("   E = Ativar/Desativar ESP")
print("\n✨ Script rodando! Procure as mensagens acima.\n")
