print("TESTE 1")

local Players = game:GetService("Players")
print("TESTE 2")

local LocalPlayer = Players.LocalPlayer
print("TESTE 3: " .. LocalPlayer.Name)

_G.TestActive = true
print("TESTE 4: Script está funcionando!")

wait(1)
print("TESTE 5: Finalizado!")
