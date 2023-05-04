local button = script.Parent
local window = script.Parent.Parent

local function onButtonActivated()
	window.Visible = false
end

button.Activated:Connect(onButtonActivated)