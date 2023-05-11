local Ball = {}
Ball.__index = Ball

function Ball.new(tycoon, instance)
	local self = setmetatable({}, Ball)
	self.Tycoon = tycoon
	self.Instance = instance
	self.Cost = instance:GetAttribute("Cost")
	self.Value = instance:GetAttribute("Value")
	self.Speed = instance:GetAttribute("Speed")
	
	return self
end

function Ball:Init()
	self:SetVelocity()
	self:SetRotation()
end

function Ball:SetVelocity()
	self.Instance.AssemblyLinearVelocity = Vector3.new(1, 0, -self.Speed * 10)
end

function Ball:SetRotation()
	self.Instance.AssemblyAngularVelocity = Vector3.new(-15, 0, 10)
end

return Ball
