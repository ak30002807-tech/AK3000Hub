-- AK3000 Hub - Delta Executor
-- Versão Minimalista Funcional

print("Iniciando AK3000 Hub...")

local success, result = pcall(function()
    -- Carregar UI
    local ui = loadstring(game:HttpGet("https://storage.ak3000hub.com/ui/v1.lua"))()
    
    if not ui then
        warn("Erro ao carregar UI!")
        return false
    end
    
    local window = ui:Window({Title = "AK3000 Hub"})
    
    -- Tabs principais
    window:Tab({Title = "Main", Icon = "house"})
    window:Tab({Title = "Farm", Icon = "zap"})
    window:Tab({Title = "Combat", Icon = "sword"})
    window:Tab({Title = "Teleport", Icon = "map-pin"})
    window:Tab({Title = "Settings", Icon = "settings"})
    
    -- Global vars
    _G.WorldName = "Sea1"
    _G.AutoFarm = false
    _G.Level = 1
    
    print("✅ AK3000 Hub Carregado!")
    return true
end)

if not success then
    warn("❌ Erro ao executar: " .. tostring(result))
end

print("Script finalizado!")
