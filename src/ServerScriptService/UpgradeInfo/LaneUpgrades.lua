local LaneUpgrades = {
    ["Wood"] = {
        ["BallValueMultiplier"] = 1,
        ["CooldownDuration"] = 5
    },
    ["Stone"] = {
        ["Cost"] = 100,
        ["BallValueMultiplier"] = 2,
        ["CooldownDuration"] = 5
    },
    ["Brick"] = {
        ["Cost"] = 200,
        ["BallValueMultiplier"] = 3,
        ["CooldownDuration"] = 4
    },
    ["Concrete"] = {
        ["Cost"] = 300,
        ["BallValueMultiplier"] = 4,
        ["CooldownDuration"] = 3
    },
    ["Asphalt"] = {
        ["Cost"] = 400,
        ["BallValueMultiplier"] = 5,
        ["CooldownDuration"] = 2
    },
    ["Marble"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Rust"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Iron"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Bronze"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Silver"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Gold"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Platinum"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Quarts"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Tanzanite"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Emerald"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Ruby"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Diamond"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Neon"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Plasma"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    },
    ["Developer"] = {
        ["Cost"] = 500,
        ["BallValueMultiplier"] = 6,
        ["CooldownDuration"] = 1
    }
}

function LaneUpgrades.GetTierInfo(name)
    if LaneUpgrades[name] then
        return LaneUpgrades[name]
    end
end

return LaneUpgrades
