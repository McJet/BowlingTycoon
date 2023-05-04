local Collector = {}
Collector.__index = Collector

function Collector.new(tycoon, instance)
	local self = setmetatable({}, Collector)
	self.Tycoon = tycoon
	self.Instance = instance
	
	return self
end

function Collector:Init()
	self.Instance.Collider.Touched:Connect(function(...)
		self:OnTouched(...)
	end)
end

function Collector:OnTouched(hitPart)
	local cost = hitPart:GetAttribute("Value")
	if cost then
		print("Earn Money")
		self.Tycoon:PublishTopic("MoneyEarned", cost)
		hitPart:Destroy()
	end
end

return Collector
