local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UpdateLaneInfoEvent = ReplicatedStorage:WaitForChild("UpdateLaneInfoEvent")
local LaneUpgrades = require(ReplicatedStorage.Source.LaneUpgrades)
local UpgradeOrder = require(ReplicatedStorage.Source.UpgradeOrder)

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local LaneShopGui = PlayerGui:WaitForChild("LaneShopGui")
local closeLaneButton = LaneShopGui.FullScreenFill.UpgradeShop.Header.CloseButton
local CurrentTierFrame = LaneShopGui.FullScreenFill.UpgradeShop.CurrentTierFrame
local NextTierFrame = LaneShopGui.FullScreenFill.UpgradeShop.NextTierFrame
local LaneSelectorFrame = LaneShopGui.FullScreenFill.UpgradeShop.LaneSelectorFrame
local UpgradeButton = LaneShopGui.FullScreenFill.UpgradeShop.UpgradeButton

local openLaneShopEvent = ReplicatedStorage:WaitForChild("OpenLaneShopEvent")
local closeLaneShopEvent = ReplicatedStorage:WaitForChild("CloseLaneShopEvent")

local Data = {}
local LaneButtons = {}

LaneShopGui.FullScreenFill.Visible = false

openLaneShopEvent.OnClientEvent:Connect(function()
    Data = GetLaneInformation()
    LaneButtons = GetDescendantsOfClass(LaneSelectorFrame, "TextButton")
    UpdateLaneButtons()

    CurrentTierFrame.Visible = false
    NextTierFrame.Visible = false
    UpgradeButton.Visible = false

    LaneShopGui.FullScreenFill.Visible = true
end)

closeLaneShopEvent.OnClientEvent:Connect(function()
    LaneShopGui.FullScreenFill.Visible = false
end)

closeLaneButton.Activated:Connect(function()
    LaneShopGui.FullScreenFill.Visible = false
end)

function GetLaneInformation()
    local info = UpdateLaneInfoEvent:InvokeServer()

    return info
end

function UpdateLaneButtons()
    for _, button in ipairs(LaneButtons) do
        button.Visible = false
    end

    for laneIndex, _ in ipairs(Data) do
        for buttonNumber, button in ipairs(LaneButtons) do
            if buttonNumber == laneIndex then
                button.Visible = true
                button.Activated:Connect(function()
                    LaneButtonPressed(buttonNumber)
                end)
            end
        end
    end
end

function LaneButtonPressed(LaneNumber)
    for buttonNumber, _ in ipairs(LaneButtons) do
        if buttonNumber == LaneNumber then
            CurrentTierFrame.Visible = true
            NextTierFrame.Visible = true
            UpgradeButton.Visible = true
            
            UpdateInformation(LaneNumber)
        end
    end
end

function UpdateInformation(LaneNumber)
    for laneIndex, LaneType in ipairs(Data) do
        if laneIndex == LaneNumber then
            local currentTierStats = LaneUpgrades.getTierInfo(LaneType)
            CurrentTierFrame.CurrentTierName.Text = LaneType
            CurrentTierFrame.StatsInfo.CooldownFrame.CooldownValue.Text = currentTierStats["CooldownDuration"]
            CurrentTierFrame.StatsInfo.MultiplierFrame.MultiplierValue.Text = currentTierStats["BallValueMultiplier"]
            
            local nextTier = UpgradeOrder.getNextUpgradeTier("Lanes", LaneType)
            local nextTierStats = LaneUpgrades.getTierInfo(nextTier)
            NextTierFrame.NextTierName.Text = nextTier
            NextTierFrame.StatsInfo.CooldownFrame.CooldownValue.Text = nextTierStats["CooldownDuration"]
            NextTierFrame.StatsInfo.MultiplierFrame.MultiplierValue.Text = nextTierStats["BallValueMultiplier"]
            -- TODO: figure out a way to upgrade when button is sent
            UpgradeButton.Text = "UPGRADE: $" .. nextTierStats["Cost"]

        end
    end
end

function GetDescendantsOfClass(Parent, Type)
    local Table = {}

    for _, Object in ipairs(Parent:GetDescendants()) do
        if Object:IsA(Type) then
            table.insert(Table, Object)
        end
    end

    return Table
end
