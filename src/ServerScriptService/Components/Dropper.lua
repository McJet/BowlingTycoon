local dropsFolder = game:GetService("ServerStorage").Drops
local Debris = game:GetService("Debris")

local Dropper = {}
Dropper.__index = Dropper

function Dropper.new(tycoon, instance)
	local self = setmetatable({}, Dropper)
	self.Tycoon = tycoon
	self.Instance = instance
	self.Rate = instance:GetAttribute("Rate")
	self.DropTemplate = dropsFolder[instance:GetAttribute("Drop")]
	self.DropSpawn = instance.Spout.Spawn
	self.IsOn = false
	
	return self
end

function Dropper:Init()
	self.Prompt = self:CreatePrompt()
	self.Prompt.Triggered:Connect(function()
		self.IsOn = not self.IsOn
		if self.IsOn == true then
			self:TurnOn()
		end
	end)
	self:TurnOn()
end

function Dropper:Drop()
	local drop = self.DropTemplate:Clone()
	drop.Position = self.DropSpawn.WorldPosition
	drop.Parent = self.Instance
	Debris:AddItem(drop, 30) --sets the item to despawn in 30 seconds using the Debris service
end

function Dropper:CreatePrompt()
	local prompt = Instance.new("ProximityPrompt")
	prompt.HoldDuration = 0.5
	prompt.ActionText = "Toggle"
	prompt.Parent = self.Instance
	return prompt
end

function Dropper:TurnOn()
	coroutine.wrap(function()
		while self.IsOn do
			self:Drop()
			wait(self.Rate)
		end
	end)()
end


return Dropper
