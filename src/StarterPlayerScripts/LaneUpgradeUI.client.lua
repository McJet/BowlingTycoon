local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UpdateLaneInfoEvent = ReplicatedStorage:WaitForChild("UpdateLaneInfoEvent")

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
                    LaneButtonActivated(buttonNumber)
                end)
            end
        end
    end
end

function LaneButtonActivated(LaneNumber)
    for buttonNumber, _ in ipairs(LaneButtons) do
        if buttonNumber == LaneNumber then
            CurrentTierFrame.Visible = true
            NextTierFrame.Visible = true
            UpgradeButton.Visible = true
            
            UpdateTierFrames(LaneNumber)
        end
    end
end

function UpdateTierFrames(LaneNumber)
    for laneIndex, LaneType in ipairs(Data) do
        if laneIndex == LaneNumber then
            CurrentTierFrame.CurrentTierName.Text = LaneType
            -- TODO: update all the texts in both CurrentTierFrame and NextTierFrame
            -- TODO: figure out a way to upgrade when button is sent
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

closeLaneShopEvent.OnClientEvent:Connect(function()
    LaneShopGui.FullScreenFill.Visible = false
end)
closeLaneButton.Activated:Connect(function()
    LaneShopGui.FullScreenFill.Visible = false
end)