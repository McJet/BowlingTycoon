local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GetPlayerLanesEvent = ReplicatedStorage:WaitForChild("GetPlayerLanesEvent")
local OpenLaneShopEvent = ReplicatedStorage:WaitForChild("OpenLaneShopEvent")
local CloseLaneShopEvent = ReplicatedStorage:WaitForChild("CloseLaneShopEvent")
local GetLaneTierDataEvent = ReplicatedStorage:WaitForChild("GetLaneTierDataEvent")

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local LaneShopGui = PlayerGui:WaitForChild("LaneShopGui")
local closeLaneButton = LaneShopGui.FullScreenFill.UpgradeShop.Header.CloseButton
local CurrentTierFrame = LaneShopGui.FullScreenFill.UpgradeShop.CurrentTierFrame
local NextTierFrame = LaneShopGui.FullScreenFill.UpgradeShop.NextTierFrame
local LaneSelectorFrame = LaneShopGui.FullScreenFill.UpgradeShop.LaneSelectorFrame
local UpgradeButton = LaneShopGui.FullScreenFill.UpgradeShop.UpgradeButton

local PlayerLanes = {}
local LaneButtons = {}

LaneShopGui.FullScreenFill.Visible = false

OpenLaneShopEvent.OnClientEvent:Connect(function()
    PlayerLanes = GetPlayerLanes()
    LaneButtons = GetDescendantsOfClass(LaneSelectorFrame, "TextButton")
    UpdateLaneButtons()

    CurrentTierFrame.Visible = false
    NextTierFrame.Visible = false
    UpgradeButton.Visible = false

    LaneShopGui.FullScreenFill.Visible = true
end)

CloseLaneShopEvent.OnClientEvent:Connect(function()
    LaneShopGui.FullScreenFill.Visible = false
end)

closeLaneButton.Activated:Connect(function()
    LaneShopGui.FullScreenFill.Visible = false
end)

function GetPlayerLanes()
    local info = GetPlayerLanesEvent:InvokeServer()
    return info
end

function UpdateLaneButtons()
    for _, button in ipairs(LaneButtons) do
        button.Visible = false
    end

    for laneIndex, _ in ipairs(PlayerLanes) do
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
    for laneIndex, LaneType in ipairs(PlayerLanes) do
        if laneIndex == LaneNumber then
            local tierData = GetLaneTierDataEvent:InvokeServer(LaneType)

            local currentTierStats = tierData["CurrentTier"]
            CurrentTierFrame.CurrentTierName.Text = LaneType
            CurrentTierFrame.StatsInfo.CooldownFrame.CooldownValue.Text = currentTierStats["CooldownDuration"] .. " sec"
            CurrentTierFrame.StatsInfo.MultiplierFrame.MultiplierValue.Text = currentTierStats["BallValueMultiplier"] .. "x"
            
            local nextTierStats = tierData["NextTier"]
            NextTierFrame.NextTierName.Text = tierData["NextTierName"]
            NextTierFrame.StatsInfo.CooldownFrame.CooldownValue.Text = nextTierStats["CooldownDuration"] .. " sec"
            NextTierFrame.StatsInfo.MultiplierFrame.MultiplierValue.Text = nextTierStats["BallValueMultiplier"] .. "x"
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
