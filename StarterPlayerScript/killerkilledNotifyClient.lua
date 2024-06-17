local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- RemoteEvent 가져오기
local killNotificationEvent = ReplicatedStorage.Event:WaitForChild("KillNotification")

-- 현재 표시 중인 알림 추적
local currentNotification = nil

-- 알림 GUI 생성
local function createNotification(message)
	-- 기존 알림이 있으면 제거
	if currentNotification then
		currentNotification:Destroy()
		currentNotification = nil
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0.1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 0.75
	textLabel.BorderSizePixel = 0
	textLabel.Text = message
	textLabel.TextColor3 = Color3.new(0, 0, 0)
	textLabel.TextSize = 24
	textLabel.Parent = screenGui

	currentNotification = screenGui

	-- 3초 후 알림 제거
	game:GetService("Debris"):AddItem(screenGui, 3)
	delay(3, function()
		if currentNotification == screenGui then
			currentNotification = nil
		end
	end)
end

-- RemoteEvent 이벤트 핸들러
killNotificationEvent.OnClientEvent:Connect(createNotification)
