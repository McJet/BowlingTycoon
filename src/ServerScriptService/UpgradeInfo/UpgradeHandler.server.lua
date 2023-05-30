local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LaneUpgrades = require(script.Parent.LaneUpgrades)
local UpgradeOrder = require(script.Parent.UpgradeOrder)

local GetLaneTierDataEvent = ReplicatedStorage:WaitForChild("GetLaneTierDataEvent")

local function GetLaneTierData(player, LaneTier)
    local data = {
        ["CurrentTier"] = {},
        ["NextTier"] = {}
    }
    local nextTier = UpgradeOrder.GetNextUpgradeTier("Lanes", LaneTier)

    data["CurrentTier"] = LaneUpgrades.GetTierInfo(LaneTier)
    data["NextTier"] = LaneUpgrades.GetTierInfo(nextTier)
    data["NextTierName"] = nextTier

    return data
end

GetLaneTierDataEvent.OnServerInvoke = GetLaneTierData