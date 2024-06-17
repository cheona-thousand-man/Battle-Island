local cantEnterFZEvent = game:GetService("ReplicatedStorage").Event:WaitForChild("cantEnterFZnotice")
local player = game:GetService("Players").LocalPlayer

-- 게임 시작 후 파이트존 입장 시도할 때 알림 UI
local function cantEnterNoticeGui()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "cantEnterNoticeGui"
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0.1, 0)
	textLabel.Position = UDim2.new(0, 0, 0.5, 0)
	textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
	textLabel.BackgroundTransparency = 0.8
	textLabel.BorderSizePixel = 0
	textLabel.TextSize = 15
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Text = "Notice : Game alleady started. Can't Enter the FightZone!"
	textLabel.Parent = screenGui

	wait(3)
	screenGui:Destroy()
end

cantEnterFZEvent.OnClientEvent:Connect(cantEnterNoticeGui)