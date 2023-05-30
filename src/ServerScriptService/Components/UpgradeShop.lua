local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpgradeShop = {}
UpgradeShop.__index = UpgradeShop

function UpgradeShop.new(tycoon, instance)
	local self = setmetatable({}, UpgradeShop)
	self.Tycoon = tycoon
	self.Instance = instance
	self.UpgradeType = instance:GetAttribute("UpgradeType")

	return self
end

function UpgradeShop:Init()
	self.prompt = self:CreatePrompt()
	self.openEvent = self:CreateOpenEvent()
	self.closeEvent = self:CreateCloseEvent()

	self.prompt.Triggered:Connect(function(player)
		self.openEvent:FireClient(player)
	end)

	--FIXME: close shop when player moves away from the shop
	--PromptHidden only triggers clientside
	--self.prompt.PromptHidden:Connect(function(player)
	--	self.closeEvent:FireClient(player)
	--end)
end

function UpgradeShop:CreatePrompt()
	local prompt = Instance.new("ProximityPrompt")
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 15
	prompt.ActionText = self.UpgradeType .. " Shop"
	prompt.Parent = self.Instance.Counter.PromptPosition

	return prompt
end

function UpgradeShop:CreateOpenEvent() 
	local openShopEvent = Instance.new("RemoteEvent")
	openShopEvent.Name = "Open" .. self.UpgradeType .. "ShopEvent"
	openShopEvent.Parent = ReplicatedStorage

	return openShopEvent
end

function UpgradeShop:CreateCloseEvent() 
	local closeShopEvent = Instance.new("RemoteEvent")
	closeShopEvent.Name = "Close" .. self.UpgradeType .. "ShopEvent"
	closeShopEvent.Parent = ReplicatedStorage

	return closeShopEvent
end

function UpgradeShop:UpgradeLane(player, laneNumber)
	if player == self.Tycoon.Owner then
		self.Tycoon:PublishTopic("UpgradeLane", laneNumber, player)
	end
end

return UpgradeShop
