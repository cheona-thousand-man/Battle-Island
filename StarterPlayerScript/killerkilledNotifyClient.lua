local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- RemoteEvent ��������
local killNotificationEvent = ReplicatedStorage.Event:WaitForChild("KillNotification")

-- ���� ǥ�� ���� �˸� ����
local currentNotification = nil

-- �˸� GUI ����
local function createNotification(message)
	-- ���� �˸��� ������ ����
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

	-- 3�� �� �˸� ����
	game:GetService("Debris"):AddItem(screenGui, 3)
	delay(3, function()
		if currentNotification == screenGui then
			currentNotification = nil
		end
	end)
end

-- RemoteEvent �̺�Ʈ �ڵ鷯
killNotificationEvent.OnClientEvent:Connect(createNotification)
