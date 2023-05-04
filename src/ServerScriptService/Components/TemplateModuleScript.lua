local TemplateModuleScript = {}
TemplateModuleScript.__index = TemplateModuleScript

function TemplateModuleScript.new(tycoon, instance)
	local self = setmetatable({}, TemplateModuleScript)
	self.Tycoon = tycoon
	self.Instance = instance

	return self
end

function TemplateModuleScript:Init()

end

return TemplateModuleScript
