local CollectionService = game:GetService("CollectionService")
local template = game:GetService("ServerStorage").Template
local tycoonStorage = game:GetService("ServerStorage").TycoonStorage
local componentFolder = script.Parent.Components
local playerManager = require(script.Parent.PlayerManager)

-- Duplicates a model and places it at a position cframe
local function NewModel(model, cframe)
	local newModel = model:Clone()
	newModel:SetPrimaryPartCFrame(cframe)
	newModel.Parent = workspace
	return newModel
end

local Tycoon = {}
Tycoon.__index = Tycoon

function Tycoon.new(player, tycoonSpawnPoint)
	local self = setmetatable({}, Tycoon)
	self.Owner = player
	
	self._spawn = tycoonSpawnPoint
	self._topicEvent = Instance.new("BindableEvent")
	
	return self
end

function Tycoon:Init()
	self.Model = NewModel(template, self._spawn.CFrame)
	self._spawn:SetAttribute("Occupied", true)
	self.Owner.RespawnLocation = self.Model.Spawn
	self.Owner:LoadCharacter()
	
	self:LockAll()
	self:LoadUnlocks()
	self:WaitForExit()
end

function Tycoon:LoadUnlocks()
	for _, id in ipairs(playerManager.GetUnlockIds(self.Owner)) do
		self:PublishTopic("Button", id)
	end
end

-- places the instance into TycoonStorage, which "locks" that instance from the Workspace
function Tycoon:Lock(instance)
	instance.Parent = tycoonStorage
	self:CreateComponent(instance, componentFolder.Unlockable)
end

-- iterates through the TycoonTemplate and locks anything with the tag "Unlockable" and unlocks anything without it
function Tycoon:LockAll()
	for _, instance in ipairs(self.Model:GetDescendants()) do
		if CollectionService:HasTag(instance, "Unlockable") then
			self:Lock(instance)
		else
			self:AddComponents(instance)
		end
	end
end

function Tycoon:Unlock(instance, id)
	playerManager.AddUnlockId(self.Owner, id)
	
	CollectionService:RemoveTag(instance, "Unlockable") --remove tag so that AddComponents won't add it again
	instance.Parent = self.Model
	self:AddComponents(instance)
end

-- checks if the tag for the instance exists
function Tycoon:AddComponents(instance)
	for _, tag in ipairs(CollectionService:GetTags(instance)) do
		local component = componentFolder:FindFirstChild(tag)
		if component then
			self:CreateComponent(instance, component)
		end
	end
end

-- creates the component and starts the script that is with the component
function Tycoon:CreateComponent(instance, componentScript)
	local compModule = require(componentScript)
	local newComp = compModule.new(self, instance)
	newComp:Init()
end


function Tycoon:PublishTopic(topicName, ...)
	self._topicEvent:Fire(topicName, ...)
end

function Tycoon:SubscribeTopic(topicName, callback)
	local connection = self._topicEvent.Event:Connect(function(name, ...)
		if name == topicName then
			callback(...)
		end
	end)
	return connection
end

function Tycoon:WaitForExit()
	playerManager.PlayerRemoving:Connect(function(player)
		if self.Owner == player then
			self:Destroy()
		end
	end)
end

function Tycoon:Destroy()
	self.Model:Destroy()
	self._spawn:SetAttribute("Occupied", false)
	self._topicEvent:Destroy()
	print("Tycoon was destroyed")
end

return Tycoon
