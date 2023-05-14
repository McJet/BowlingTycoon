local ballsFolder = game:GetService("ServerStorage").Balls
local debris = game:GetService("Debris")
local LaneUpgrades = require(script.Parent.Parent.LaneUpgrades)
local UpgradeOrder = require(game:GetService("ReplicatedStorage").Source.UpgradeOrder)
local PlayerManager = require(script.Parent.Parent.PlayerManager)


local Lane = {}
Lane.__index = Lane

function Lane.new(tycoon, instance)
	local self = setmetatable({}, Lane)
	self.Tycoon = tycoon
	self.Instance = instance
	self.BallSpawnPosition = instance.BallSpawnPosition
	self.LaneNumber = instance:GetAttribute("LaneNumber")
	print(self.LaneNumber)

	return self
end

function Lane:Init()
	self.Prompt = self:CreatePrompt()
	self.Prompt.Triggered:Connect(function(...)
		self.Prompt.Enabled = false
		self:ThrowBall(...)
		task.wait(self.Instance:GetAttribute("CooldownDuration")) --TODO: Show player cooldown timer
		self.Prompt.Enabled = true
	end)
	self.Subscription = self.Tycoon:SubscribeTopic("UpgradeLane", function(...)
		self:UpgradeLane(...)
	end)
end

function Lane:CreatePrompt()
	local prompt = Instance.new("ProximityPrompt")
	prompt.HoldDuration = 0.5
	prompt.MaxActivationDistance = 5
	prompt.ActionText = "Bowl"
	prompt.ObjectText = self.Instance:GetAttribute("BallType")
	prompt.Parent = self.Instance.PromptPosition
	return prompt
end

function Lane:ThrowBall(player)
	if player == self.Tycoon.Owner then
		self.BallTemplate = ballsFolder[self.Instance:GetAttribute("BallType")]
		self.BallValueMultiplier = self.Instance:GetAttribute("BallValueMultiplier")

		local ball = self.BallTemplate:Clone()

		local ballValue = ball:GetAttribute("Value")
		ball:SetAttribute("Value", ballValue * self.BallValueMultiplier)

		ball.Position = self.BallSpawnPosition.WorldPosition
		ball.Parent = self.Instance
		self.Tycoon:AddComponents(ball)
		
		debris:AddItem(ball, 15)
	end
end

function Lane:UpgradeLane(laneNumber, player)
	if laneNumber == self.LaneNumber then
		local nextLaneTier = UpgradeOrder.getNextUpgradeTier("Lanes", self.Instance:GetAttribute("LaneType"))
		local nextLaneInfo = LaneUpgrades.getUpgradeInfo(nextLaneTier)
		local upgradeCost = nextLaneInfo["Cost"]
		local playerMoney = PlayerManager.GetMoney(player)
	
		if playerMoney >= upgradeCost then
			PlayerManager.SetMoney(player, playerMoney - upgradeCost)
		
			self.Instance:SetAttribute("LaneType", nextLaneTier)
			self.Instance:SetAttribute("BallValueMultiplier", nextLaneInfo["BallValueMultiplier"])
			self.Instance:SetAttribute("CooldownDuration", nextLaneInfo["CooldownDuration"])
			print("Upgraded", self.LaneNumber)
		end
	end
end

return Lane
