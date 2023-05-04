local RemoteEvent = game.ReplicatedStorage:WaitForChild("OpenGui")

RemoteEvent.OnClientEvent:Connect(function()
	script.Parent.UpgradeShop.Visible = true
end)