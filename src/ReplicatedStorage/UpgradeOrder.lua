local UpgradeOrder = {
    ["Balls"] = {
        "HouseBallGray",
        "HouseBallBlue",
        "HouseBallPurple",
        "HouseBallRed",
        "PlasticGray",
        "PlasticBlue ",
        "PlasticPurple",
        "PlasticRed",
        "ReactiveGray",
        "ReactiveBlue",
        "ReactivePurple",
        "ReactiveRed",
        "UrethaneGray",
        "UrethaneBlue",
        "UrethanePurple",
        "UrethaneRed",
        "HouseBallGold",
        "PlasticGold",
        "ReactiveGold",
        "UrethaneGold"
    },

    ["Lanes"] = {
        "Wood",
        "Stone",
        "Brick",
        "Concrete",
        "Asphalt",
        "Marble",
        "Rust",
        "Iron",
        "Bronze",
        "Silver",
        "Gold",
        "Platinum",
        "Quarts",
        "Tanzanite",
        "Emerald",
        "Ruby",
        "Diamond",
        "Neon",
        "Plasma",
        "Developer"
    }
}

function UpgradeOrder.getNextUpgradeTier(type, currentTier)
    local currentTierIndex = -1
    if UpgradeOrder[type] then
        for index, tier in ipairs(UpgradeOrder[type]) do
            if tier == currentTier then
                currentTierIndex = index
            end
            if currentTierIndex + 1 == index then
                return tier
            end
        end
    end
end

return UpgradeOrder