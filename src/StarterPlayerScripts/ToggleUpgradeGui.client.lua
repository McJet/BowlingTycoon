--[[
this local script is in charge of sending/receiving open/close UI events to the server.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local openLaneShopEvent = ReplicatedStorage:WaitForChild("OpenLaneShopEvent")
local closeLaneShopEvent = ReplicatedStorage:WaitForChild("CloseLaneShopEvent")

local openBallShopEvent = ReplicatedStorage:WaitForChild("OpenBallShopEvent")
local closeBallShopEvent = ReplicatedStorage:WaitForChild("CloseBallShopEvent")

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local LaneShopGui = PlayerGui:WaitForChild("LaneShopGui")
local BallShopGui = PlayerGui:WaitForChild("BallShopGui")

local closeLaneButton = LaneShopGui.FullScreenFill.UpgradeShop.Header.CloseButton
local closeBallButton = BallShopGui.UpgradeShop.CloseButton


openLaneShopEvent.OnClientEvent:Connect(function()
    LaneShopGui.FullScreenFill.Visible = true
end)
closeLaneShopEvent.OnClientEvent:Connect(function()
    LaneShopGui.FullScreenFill.Visible = false
end)

openBallShopEvent.OnClientEvent:Connect(function()
    BallShopGui.UpgradeShop.Visible = true
end)
closeBallShopEvent.OnClientEvent:Connect(function()
    BallShopGui.UpgradeShop.Visible = false
end)

closeLaneButton.Activated:Connect(function()
    LaneShopGui.FullScreenFill.Visible = false
end)
closeBallButton.Activated:Connect(function()
    BallShopGui.UpgradeShop.Visible = false
end)