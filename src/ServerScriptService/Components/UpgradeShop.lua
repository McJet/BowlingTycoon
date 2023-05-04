local RemoteEvent = game.ReplicatedStorage:WaitForChild("OpenGui")

local UpgradeShop = {}
UpgradeShop.__index = UpgradeShop

function UpgradeShop.new(tycoon, instance)
	local self = setmetatable({}, UpgradeShop)
	self.Tycoon = tycoon
	self.Instance = instance
	
	return self
end

function UpgradeShop:Init()
	self.prompt = self:CreatePrompt()
	self.prompt.Triggered:Connect(function(player)
		self:OpenShop(player)
	end)
	self.prompt.PromptHidden:Connect(function(player)
		self:CloseShop(player)
	end)
end

function UpgradeShop:CreatePrompt()
	local prompt = Instance.new("ProximityPrompt")
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 15
	prompt.ActionText = "Open Shop"
	prompt.Parent = self.Instance.PromptPosition
	return prompt
end

function UpgradeShop:OpenShop(player)
	print("OpenShop function called!")
	RemoteEvent:FireClient(player)
end

return UpgradeShop
