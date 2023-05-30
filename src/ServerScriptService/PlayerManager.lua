local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local PlayerData = DataStoreService:GetDataStore("PlayerData")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--[[ DEBUG VARIABLES ]]
local RESET_DATA = false  --default: false, set to true to reset data of every player that joins
local RESET_DATA_MONEY_VALUE = 100000
--[[ DEBUG VARIABLES END]]

local function LeaderboardSetup(value)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"

	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Value = value
	money.Parent = leaderstats

	return leaderstats
end

local function LoadData(player)
	local success, result = pcall(function()
		return PlayerData:GetAsync(player.UserId)
	end)
	if not success then
		warn(result)
	end
	print("Loaded Data:", result)
	return success, result
end

local function SaveData(player, data)
	local success, result = pcall(function()
		PlayerData:SetAsync(player.UserId, data)
	end)
	if not success then
		warn(result)
	end
	print("Saved Data:", data)
	return success
end

local playerAdded = Instance.new("BindableEvent")
local playerRemoving = Instance.new("BindableEvent")

--[[
 sessionData holds all of the player data
 Key: Player's UserId
 Value: Data
--]]
local sessionData = {}
local PlayerManager = {}

PlayerManager.PlayerAdded = playerAdded.Event
PlayerManager.PlayerRemoving = playerRemoving.Event

function PlayerManager.Start()
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerManager.OnPlayerAdded)(player) --make sure every player is loaded in correctly
	end

	Players.PlayerAdded:Connect(PlayerManager.OnPlayerAdded)
	Players.PlayerRemoving:Connect(PlayerManager.OnPlayerRemoving)

	game:BindToClose(PlayerManager.OnClose)
end

function PlayerManager.OnPlayerAdded(player)
	-- load player to correct tycoon
	player.CharacterAdded:Connect(function(character)
		PlayerManager.OnCharacterAdded(player, character)
	end)

	-- load player data
	local success, data = LoadData(player)
	if not RESET_DATA then
		sessionData[player.UserId] = success and data or {
			-- starting values
			Money = 0,
			UnlockIds = {},
			LaneTypes = {}
		}
	else
		sessionData[player.UserId] = {
			-- starting values
			Money = RESET_DATA_MONEY_VALUE,
			UnlockIds = {},
			LaneTypes = {}
		}
	end

	-- update player's leadearboard information
	local leaderstats = LeaderboardSetup(PlayerManager.GetMoney(player))
	leaderstats.Parent = player

	playerAdded:Fire(player)
end

function PlayerManager.OnCharacterAdded(player, character)
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			task.wait(3)
			player:LoadCharacter()
		end)
	end
end

function PlayerManager.GetMoney(player)
	return sessionData[player.UserId].Money
end

function PlayerManager.SetMoney(player, value)
	if value then
		sessionData[player.UserId].Money = value
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local money = leaderstats:FindFirstChild("Money")
			if money then
				money.Value = value
			end
		end
	end
end

function PlayerManager.AddUnlockId(player, id)
	local data = sessionData[player.UserId]

	if not table.find(data.UnlockIds, id) then
		table.insert(data.UnlockIds, id)
	end
end

function PlayerManager.GetUnlockIds(player)
	return sessionData[player.UserId].UnlockIds
end

function PlayerManager.AddLaneType(player, laneNumber, laneType)
	local laneTypesTable = sessionData[player.UserId].LaneTypes
	laneTypesTable[laneNumber] = laneType
end

function PlayerManager.GetLaneTypes(player)
	return sessionData[player.UserId].LaneTypes
end
local UpdateLaneInfoEvent = ReplicatedStorage:WaitForChild("UpdateLaneInfoEvent")
UpdateLaneInfoEvent.OnServerInvoke = PlayerManager.GetLaneTypes

function PlayerManager.OnPlayerRemoving(player)
	SaveData(player, sessionData[player.UserId])
	playerRemoving:Fire(player)
end

function PlayerManager.OnClose()
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerManager.OnPlayerRemoving(player))()
	end
end

return PlayerManager
