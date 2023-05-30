local LaneUpgrades = {
    ["Wood"] = {
        ["Cost"] = 0,
        ["BallValueMultiplier"] = 1,
        ["CooldownDuration"] = 5
    },
    ["Stone"] = {
        ["Cost"] = 10,
        ["BallValueMultiplier"] = 2,
        ["CooldownDuration"] = 5
    },
    ["Brick"] = {
        ["Cost"] = 20,
        ["BallValueMultiplier"] = 3,
        ["CooldownDuration"] = 4
    },
    ["Concrete"] = {
        ["Cost"] = 30,
        ["BallValueMultiplier"] = 4,
        ["CooldownDuration"] = 3
    },
    ["Asphalt"] = {
        ["Cost"] = 40,
        ["BallValueMultiplier"] = 5,
        ["CooldownDuration"] = 2
    },
    ["Marble"] = {
        ["Cost"] = 50,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Rust"] = {},
    ["Iron"] = {},
    ["Bronze"] = {},
    ["Silver"] = {},
    ["Gold"] = {},
    ["Platinum"] = {},
    ["Quarts"] = {},
    ["Tanzanite"] = {},
    ["Emerald"] = {},
    ["Ruby"] = {},
    ["Diamond"] = {},
    ["Neon"] = {},
    ["Plasma"] = {},
    ["Developer"] = {}
}

function LaneUpgrades.GetTierInfo(name)
    if LaneUpgrades[name] then
        return LaneUpgrades[name]
    end
end

return LaneUpgrades
