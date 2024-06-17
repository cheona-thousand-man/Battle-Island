local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerRespawnEvent = ReplicatedStorage.Event:WaitForChild("NowPlayerRespawn")
local playerDieEvent = ReplicatedStorage.Event:WaitForChild("DiedPlayerCheck")
local onePlayerLeftEvent = ReplicatedStorage.Event:WaitForChild("onePlayerLeftCheck")

-- ������� ó�� ����
local player = game.Players.LocalPlayer
local screengui = script.Parent
local frame = screengui.controlPanel
local camera = workspace.Camera
local number = 1

-- ������ ������ ������ �÷��̾ ���ϴ� �Լ�
local function getNonLocalPlayers()
	local players = game.Players:GetPlayers()
	local nonLocalPlayers = {}
	for _, targetPlayer in pairs(players) do
		if targetPlayer.Name ~= game.Players.LocalPlayer.Name then
			if game:GetService("Workspace").onlinePlayer:WaitForChild(targetPlayer.Name).Value == "enterFZ" then
				table.insert(nonLocalPlayers, targetPlayer)
			end
		end
	end
	return nonLocalPlayers
end

-- ������� �۵� ��Ʈ�� �г� �Լ�(� �÷��̾ ������ / ���� �÷��̾ ��ȸ�ϸ鼭 �ݺ�)
frame["����"].MouseButton1Click:Connect(function()
	local nonLocalPlayers = getNonLocalPlayers()
	if #nonLocalPlayers > 0 then
		number = (number + 1) % #nonLocalPlayers -- ��ȯ �ε��� ���
		if number == 0 then
			number = #nonLocalPlayers
		end
		camera.CameraSubject = nonLocalPlayers[number].Character.Humanoid
		print(nonLocalPlayers[number])
	end
end)

frame["����"].MouseButton1Click:Connect(function()
	local nonLocalPlayers = getNonLocalPlayers()
	if #nonLocalPlayers > 0 then
		number = (number - 1) % #nonLocalPlayers -- ��ȯ �ε��� ���
		if number == 0 then
			number = #nonLocalPlayers
		end
		camera.CameraSubject = nonLocalPlayers[number].Character.Humanoid
		print(nonLocalPlayers[number])
	end
end)

-- �÷��̾ ���� �� ȣ��Ǵ� �Լ�
local function onPlayerDied()
	print("player die check on observerControl!")
	playerDieEvent:FireServer()

	local nonLocalPlayers = getNonLocalPlayers() -- (���� �÷��̾� ����) ������ �÷��̾� ����Ʈ
	print("Now alive player Number : " .. #nonLocalPlayers)
	
	-- ������ ������ �÷��̾ 1�� �̻��� �� / ���� ���� 2�� �̻��� ���� �÷���
	if #nonLocalPlayers > 0 then
		frame.Visible = true
		number = 1 -- �ʱ�ȭ
		camera.CameraSubject = nonLocalPlayers[number].Character.Humanoid
	-- ������ ������ �÷��̾ ���� �� / ���ε� �׾��� ������ ���� 1�� ���� / �¸��� ����
	elseif #nonLocalPlayers == 0 then
		number = 1
		playerRespawnEvent:FireServer()
	else
		warn("can recall player died state.")
	end
end

local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

-- ��� �÷��̾�� ������ ���� ������ �̺�Ʈ�� �߻���Ŵ
humanoid.Died:Connect(onPlayerDied)

-- ������ ������ �������� ����� �ȳ��� : �����߰�, �� ����
onePlayerLeftEvent.OnClientEvent:Connect(function()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CongratulationGui"
	screenGui.Parent = player:WaitForChild("PlayerGui")

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0.1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundColor3 = Color3.new(0, 0, 1)
	textLabel.BackgroundTransparency = 0.5
	textLabel.BorderSizePixel = 0
	textLabel.TextSize = 20
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Parent = screenGui
	textLabel.Text = "Congratulations on your Victory Royale!"
	wait(3)
	for loop = 1, 3 do
		textLabel.Text = "I am in awe of your strength : " .. (3 - loop)
		wait(1)
	end
	textLabel.BackgroundColor3 = Color3.new(1, 0, 0)
	textLabel.BackgroundTransparency = 0.5
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Text = "Now : It's time for bed"

	wait(3)
	screenGui:Destroy()
end)

-- �÷��̾ �߰��� ������ ��� �̺�Ʈ ����
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	humanoid.Died:Connect(onPlayerDied)
end)
