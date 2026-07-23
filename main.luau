-- AK3000 Hub - Otimizado para Delta Executor
-- ============================================

local AK3000Hub = loadstring(game:HttpGet("https://storage.ak3000hub.com/ui/v1.lua"))()
local Window = AK3000Hub:Window({
	Title = "AK3000 Hub",
})

local Tabs = {
	CreditsTab = Window:Tab({Title = "Credits", Icon = "info"}),
	MainTab = Window:Tab({Title = "Main", Icon = "house"}),
	OthersTab = Window:Tab({Title = "Others", Icon = "inbox"}),
	ItemsTab = Window:Tab({Title = "Items", Icon = "box"}),
	SettingsTab = Window:Tab({Title = "Settings", Icon = "settings"}),
	LocalPlayerTab = Window:Tab({Title = "Local Player", Icon = "user"}),
	StatsTab = Window:Tab({Title = "Stats", Icon = "chart-no-axes-column"}),
	SeaEventTab = Window:Tab({Title = "Sea Event", Icon = "anchor"}),
	SeaStackTab = Window:Tab({Title = "Sea Stack", Icon = "waves"}),
	DragonDojoTab = Window:Tab({Title = "Dragon Dojo", Icon = "shield"}),
	RaceTab = Window:Tab({Title = "Race", Icon = "bot"}),
	CombatTab = Window:Tab({Title = "Combat", Icon = "sword"}),
	RaidTab = Window:Tab({Title = "Raid", Icon = "zap"}),
	EspTab = Window:Tab({Title = "Esp", Icon = "eye"}),
	TeleportTab = Window:Tab({Title = "Teleport", Icon = "map-pin"}),
	ShopTab = Window:Tab({Title = "Shop", Icon = "shopping-cart"}),
	FruitTab = Window:Tab({Title = "Fruit", Icon = "flask-conical"}),
	MiscTab = Window:Tab({Title = "Misc", Icon = "layout-grid"}),
	ServerTab = Window:Tab({Title = "Server", Icon = "server"})
}

-- [[ Initialize Script Variables ]] --
_G.GlobalDelay = 0.2
_G.SelectWeapon = "Melee"
_G.MasteryMethod = "Level"
_G.SelectedBoneFarmMethod = "No Quest"
_G.FarmDistance = 35
_G.PlayerTweenSpeed = 300
_G.BringDistance = 500
_G.BringMob = true
_G.AttackAura = true
_G.HideDamageText = true
_G.MasteryHealth = 25
_G.AutoSetSpawnPoint = true
_G.AutoRejoin = true
_G.ActiveRaceV4 = true
_G.SelectedFruitSkill = {"Z", "X", "C"}
_G.SelectedGunSkill = {"Z", "X"}
_G.DevilFruitSkillSeaEvent = {"Z", "X", "C"}
_G.MeleeSkillSeaEvent = {"Z", "X", "C", "V"}
_G.SelectedToolsSeaEvent = {"Blox Fruit", "Melee", "Gun", "Sword"}
_G.SelectedBoat = "Guardian"
_G.SelectedZone = "Zone 5"
_G.StoreRarityFruit = "Common - Mythical"

-- [[ World Detection ]] --
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
	World1 = true
	_G.WorldName = "Sea1"
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
	World2 = true
	_G.WorldName = "Sea2"
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
	World3 = true
	_G.WorldName = "Sea3"
end

-- [[ Declare Variables ]] --
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game.ReplicatedStorage
local Remotes = ReplicatedStorage.Remotes
local Enemies = Workspace.Enemies
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Net = require(Modules:WaitForChild("Net"))

local Character, Humanoid, HumanoidRootPart, MyLevel

local function SetupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end

if LocalPlayer.Character then
    SetupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    SetupCharacter(char)
end)

spawn(function()
	while wait() do
		pcall(function()
			MyLevel = LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
		end)
	end
end)

-- [[ Anti-AFK ]] --
LocalPlayer.Idled:connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- [[ Hook Functions ]] --
pcall(function()
	hookfunction(require(ReplicatedStorage.Effect.Container.Death), function() end)
	hookfunction(require(ReplicatedStorage:WaitForChild("GuideModule")).ChangeDisplayedNPC, function() end)
	hookfunction(error, function() end)
	hookfunction(warn, function() end)
end)

-- [[ Utility Functions ]] --
function sendKeyEvent(skill)
	local keyCode = typeof(skill) == "EnumItem" and skill or Enum.KeyCode[skill]
	if not keyCode then return end
	VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
end

function getBackpack(v)
    return LocalPlayer.Backpack:FindFirstChild(v) or LocalPlayer.Character:FindFirstChild(v)
end

function getInventory(v)
	local inventory = Remotes.CommF_:InvokeServer("getInventory")
	for i, item in pairs(inventory) do
		if item.Name == v then
			return true
		end
	end
	return false
end

function GetConnectionEnemies(a)
    for i, v in pairs(ReplicatedStorage:GetChildren()) do
        if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    for i, v in next, Enemies:GetChildren() do
        if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
end

function Hop()
	local module = loadstring(game:HttpGet("https://raw.githubusercontent.com/raw-scriptpastebin/FE/main/Server_Hop_Settings"))()
	module:Teleport(game.PlaceId)
end

function round(n)
	return math.floor(tonumber(n) + 0.5)
end

-- [[ ESP Functions ]] --
function InitEspIsland()
	for i, v in pairs(Workspace._WorldOrigin.Locations:GetChildren()) do
		pcall(function()
			if _G.EspIsland then
				if v.Name ~= "Sea" then
					if not v:FindFirstChild("EspIsland") then
						local bill = Instance.new("BillboardGui", v)
						bill.Name = "EspIsland"
						bill.ExtentsOffset = Vector3.new(0, 1, 0)
						bill.Size = UDim2.new(0, 200, 0, 30)
						bill.Adornee = v
						bill.AlwaysOnTop = true
						local name = Instance.new("TextLabel", bill)
						name.Font = Enum.Font.GothamMedium
						name.TextSize = 14
						name.TextWrapped = true
						name.Size = UDim2.new(1, 0, 1, 0)
						name.TextYAlignment = Enum.TextYAlignment.Top
						name.BackgroundTransparency = 1
						name.TextColor3 = Color3.fromRGB(255, 255, 255)
					else
						v.EspIsland.TextLabel.Text = v.Name .. "   \n" .. round(((Character.Head.Position - v.Position)).Magnitude / 3) .. " Distance"
					end
				end
			elseif v:FindFirstChild("EspIsland") then
				v:FindFirstChild("EspIsland"):Destroy()
			end
		end)
	end
end

spawn(function()
	while wait(1) do
		if _G.EspIsland then
			InitEspIsland()
		end
	end
end)

function InitEspPlayer()
	for i, v in pairs(Players:GetChildren()) do
		pcall(function()
			if v.Character ~= nil then
				if _G.EspPlayer then
					if not v.Character.Head:FindFirstChild("EspPlayer") then
						local bill = Instance.new("BillboardGui")
						bill.Name = "EspPlayer"
						bill.ExtentsOffset = Vector3.new(0, 1, 0)
						bill.Size = UDim2.new(0, 200, 0, 30)
						bill.Adornee = v.Character.Head
						bill.Parent = v.Character.Head
						bill.AlwaysOnTop = true
						local name = Instance.new("TextLabel", bill)
						name.Font = Enum.Font.GothamMedium
						name.TextSize = 14
						name.TextWrapped = true
						name.Size = UDim2.new(1, 0, 1, 0)
						name.TextYAlignment = Enum.TextYAlignment.Top
						name.BackgroundTransparency = 1
						name.Text = v.Name
						name.TextColor3 = Color3.fromRGB(0, 255, 0)
					end
				elseif v.Character.Head:FindFirstChild("EspPlayer") then
					v.Character.Head:FindFirstChild("EspPlayer"):Destroy()
				end
			end
		end)
	end
end

spawn(function()
	while wait(1) do
		if _G.EspPlayer then
			InitEspPlayer()
		end
	end
end)

-- [[ Raids List ]] --
local Raidslist = {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Magma", "Buddha", "Sand", "Phoenix", "Dough"}

-- [[ Sword List ]] --
local SwordList = {}
local Inventory = Remotes.CommF_:InvokeServer("getInventory")
task.spawn(function()
	for i, v in ipairs(Inventory) do
		if v.Type == "Sword" then
			table.insert(SwordList, v.Name)
		end
	end
end)

-- [[ Script Loaded ]] --
print("✅ AK3000 Hub carregado com sucesso no Delta Executor!")
print("🎮 WorldName: " .. (_G.WorldName or "Unknown"))
print("⚙️ Use os tabs acima para acessar as funcionalidades")

-- Script is ready
return {
	_G = _G,
	sendKeyEvent = sendKeyEvent,
	getBackpack = getBackpack,
	getInventory = getInventory,
	GetConnectionEnemies = GetConnectionEnemies,
	Hop = Hop,
	round = round
}
