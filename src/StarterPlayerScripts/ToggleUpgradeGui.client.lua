local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local openBallShopEvent = ReplicatedStorage:WaitForChild("OpenBallShopEvent")
local closeBallShopEvent = ReplicatedStorage:WaitForChild("CloseBallShopEvent")

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local BallShopGui = PlayerGui:WaitForChild("BallShopGui")

local closeBallButton = BallShopGui.UpgradeShop.CloseButton

openBallShopEvent.OnClientEvent:Connect(function()
    BallShopGui.UpgradeShop.Visible = true
end)
closeBallShopEvent.OnClientEvent:Connect(function()
    BallShopGui.UpgradeShop.Visible = false
end)
closeBallButton.Activated:Connect(function()
    BallShopGui.UpgradeShop.Visible = false
end)