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
	local vectorForce = Instance.new("VectorForce")
	local attachment = Instance.new("Attachment")
	attachment.Parent = self.Instance
	vectorForce.Attachment0 = attachment
	vectorForce.ApplyAtCenterOfMass = true
	vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
	vectorForce.Force = self.Instance.CFrame.LookVector * self.Speed * 10
	vectorForce.Parent = attachment
end

return Ball
