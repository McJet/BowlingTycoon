local ballsFolder = game:GetService("ServerStorage").Balls
local debris = game:GetService("Debris")

local Lane = {}
Lane.__index = Lane

function Lane.new(tycoon, instance)
	local self = setmetatable({}, Lane)
	self.Tycoon = tycoon
	self.Instance = instance
	self.CooldownDuration = instance:GetAttribute("CooldownDuration")
	self.BallValueMultiplier = instance:GetAttribute("BallValueMultiplier")
	self.BallTemplate = ballsFolder[instance:GetAttribute("BallType")]
	self.BallSpawnPosition = instance.BallSpawnPosition

	return self
end

function Lane:Init()
	self.Prompt = self:CreatePrompt()
	self.Prompt.Triggered:Connect(function(...)
		self.Prompt.Enabled = false
		self:ThrowBall(...)
		task.wait(self.CooldownDuration) --TODO: Show player cooldown timer
		self.Prompt.Enabled = true
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
		local ball = self.BallTemplate:Clone()

		ball.Position = self.BallSpawnPosition.WorldPosition
		ball.Parent = self.Instance
		self.Tycoon:AddComponents(ball)
		
		debris:AddItem(ball, 15)
	end
end

return Lane
