local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shrinkFightZoneEvent = ReplicatedStorage.Event:WaitForChild("shrinkFightZone")

local function createAnnouncementGui()
	local localPlayer = Players.LocalPlayer
	local onlineState = game:GetService("Workspace").onlinePlayer:WaitForChild(localPlayer.Name)

	if onlineState.Value == "enterFZ" then -- 게임에 참가한 사람만, 자기장 생성 경고 메시지 수신
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "AnnouncementGui"
		screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 0.1, 0)
		textLabel.Position = UDim2.new(0, 0, 0, 0)
		textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
		textLabel.BackgroundTransparency = 0.8
		textLabel.BorderSizePixel = 0
		textLabel.TextSize = 20
		textLabel.TextColor3 = Color3.new(1, 0.219608, 0.219608)
		textLabel.Parent = screenGui
		textLabel.Text = "Warning : Force Field will appear in 5 seconds!"
		wait(1)
		for loop = 1, 4 do
			textLabel.Text = "Warning : Force Field will appear in " .. (5 - loop) .. " seconds!"
			wait(1)
		end
		textLabel.BackgroundColor3 = Color3.new(1, 0, 0)
		textLabel.BackgroundTransparency = 0.5
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.Text = "Warning : Force Field appeared and shrink now!"

		wait(3)
		screenGui:Destroy()
	end
end

shrinkFightZoneEvent.OnClientEvent:Connect(createAnnouncementGui)
