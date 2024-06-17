local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerObserverEndEvent = ReplicatedStorage.Event:WaitForChild("observerModeEnd")

playerObserverEndEvent.OnClientEvent:Connect(function() 
	local player = game.Players.LocalPlayer
	local screengui = player:WaitForChild("PlayerGui"):WaitForChild("observerModeClient")
	local frame = screengui.controlPanel
	local camera = workspace.Camera

	frame.Visible = false
	camera.CameraSubject = player.Character.Humanoid -- 캐릭터 리스폰 시, 카메라 패널/조작 초기화
end)
