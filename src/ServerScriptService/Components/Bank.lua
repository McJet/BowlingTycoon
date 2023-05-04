local PlayerManager = require(script.Parent.Parent.PlayerManager)

local Bank = {}
Bank.__index = Bank

function Bank.new(tycoon, instance)
	local self = setmetatable({}, Bank)
	self.Tycoon = tycoon
	self.Instance = instance
	self.Balance = 0
	
	return self
end

function Bank:Init()
	self.Tycoon:SubscribeTopic("MoneyEarned", function(...)
		self:UpdateMoney(...)
	end)
	self.Prompt = self:CreatePrompt()
	self.Prompt.Triggered:Connect(function(...)
		self:CollectMoney(...)
	end)
end

function Bank:UpdateMoney(value)
	self.Balance += value
	self:SetDisplay("$" .. self.Balance)
end

function Bank:SetDisplay(str)
	self.Instance.Display.Money.Text = str
end

function Bank:CreatePrompt()
	local prompt = Instance.new("ProximityPrompt")
	prompt.HoldDuration = 0.3
	prompt.MaxActivationDistance = 10
	prompt.ActionText = "Collect Money"
	prompt.Parent = self.Instance.Button
	return prompt
end

function Bank:CollectMoney(player)
	if player == self.Tycoon.Owner then
		local playerMoney = PlayerManager.GetMoney(player) + self.Balance
		PlayerManager.SetMoney(player, playerMoney)
		self.Balance = 0
		self:SetDisplay("$0")
	end
end

return Bank
