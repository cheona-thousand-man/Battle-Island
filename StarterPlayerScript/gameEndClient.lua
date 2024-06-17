local ReplicatedStorage = game:GetService("ReplicatedStorage")
local gameEndNoticeEvent = ReplicatedStorage.Event:FindFirstChild("FZgameEndNotice")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 게임 종료 후 승자/파이트존 입장 가능 알림 UI
local function gameEndNoticeGui(message)
	wait(3)
	
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:FindFirstChild("Head")
	
	-- 알림 빌보드GUI 생성
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(10, 0, 3, 0) -- 너비와 높이를 설정
	billboardGui.StudsOffset = Vector3.new(0, 3, 0) -- 캐릭터 머리 위로 오프셋
	billboardGui.Adornee = rootPart
	billboardGui.Parent = rootPart

	-- 최후 승자 알림
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0.5, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextSize = 20 -- 텍스트 크기 자동 조정
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Text = message
	textLabel.Parent = billboardGui

	-- 입장 가능 알림
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, 0, 0.5, 0)
	textLabel2.Position = UDim2.new(0, 0, 0.3, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextSize = 20 -- 텍스트 크기 자동 조정
	textLabel2.TextColor3 = Color3.new(1, 1, 1)
	textLabel2.Text = "Now you can enter Fight Zone. Welcome Warriors LoL"
	textLabel2.Parent = billboardGui
	
	print("game end notice")
	print(message .. " + " .. textLabel2.Text)
	
	wait(3)
	billboardGui:Destroy()
end

-- 게임 종료 시 플레이어 Gui로 승자 표시
gameEndNoticeEvent.OnClientEvent:Connect(gameEndNoticeGui)
