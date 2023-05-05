local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local openShopEvent = ReplicatedStorage:WaitForChild("OpenShopEvent")
local closeShopEvent = ReplicatedStorage:WaitForChild("CloseShopEvent")

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local UpgradeShopGui = PlayerGui:WaitForChild("UpgradeShopGui")
local closeButton = UpgradeShopGui.UpgradeShop.CloseButton

openShopEvent.OnClientEvent:Connect(function()
    UpgradeShopGui.UpgradeShop.Visible = true
end)

closeShopEvent.OnClientEvent:Connect(function()
    UpgradeShopGui.UpgradeShop.Visible = false
end)

closeButton.Activated:Connect(function()
    UpgradeShopGui.UpgradeShop.Visible = false
end)
