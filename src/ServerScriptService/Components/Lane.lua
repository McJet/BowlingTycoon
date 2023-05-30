local ballsFolder = game:GetService("ServerStorage").Balls
local debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LaneUpgrades = require(ReplicatedStorage.Source.LaneUpgrades)
local UpgradeOrder = require(ReplicatedStorage.Source.UpgradeOrder)
local PlayerManager = require(script.Parent.Parent.PlayerManager)


local Lane = {}
Lane.__index = Lane

function Lane.new(tycoon, instance)
	local self = setmetatable({}, Lane)
	self.Tycoon = tycoon
	self.Instance = instance
	self.BallSpawnPosition = instance.BallSpawnPosition
	self.LaneNumber = instance:GetAttribute("LaneNumber")
	self:LoadLaneType(tycoon.Owner)
	self:SaveLaneInfo(instance:GetAttribute("LaneNumber"), tycoon.Owner)

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
		self:SaveLaneInfo(...)
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
		local nextLaneInfo = LaneUpgrades.getTierInfo(nextLaneTier)
		local upgradeCost = nextLaneInfo["Cost"]
		local playerMoney = PlayerManager.GetMoney(player)
	
		if playerMoney >= upgradeCost then
			PlayerManager.SetMoney(player, playerMoney - upgradeCost)
			self:SetLaneAttributes(nextLaneTier, nextLaneInfo["BallValueMultiplier"], nextLaneInfo["CooldownDuration"])
			print("Upgraded", self.LaneNumber)
		end
	end
end

function Lane:SetLaneAttributes(laneType, ballValueMultiplier, cooldownDuration)
	self.Instance:SetAttribute("LaneType", laneType)
	self.Instance:SetAttribute("BallValueMultiplier", ballValueMultiplier)
	self.Instance:SetAttribute("CooldownDuration", cooldownDuration)
end

function Lane:SaveLaneInfo(laneNumber, player)
	if laneNumber == self.LaneNumber and player == self.Tycoon.Owner then
		PlayerManager.AddLaneType(player, laneNumber, self.Instance:GetAttribute("LaneType"))
	end
end

function Lane:LoadLaneType(player)
	local savedLaneTypesList = PlayerManager.GetLaneTypes(player)
	local savedLaneType = savedLaneTypesList[self.LaneNumber]

	if savedLaneType then
		local laneInfo = LaneUpgrades.getTierInfo(savedLaneType)
		self:SetLaneAttributes(savedLaneType, laneInfo["BallValueMultiplier"], laneInfo["CooldownDuration"])
	end
end

return Lane
