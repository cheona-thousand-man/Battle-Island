local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerRespawnEvent = ReplicatedStorage.Event:WaitForChild("NowPlayerRespawn")
local playerDieEvent = ReplicatedStorage.Event:WaitForChild("DiedPlayerCheck")
local onePlayerLeftEvent = ReplicatedStorage.Event:WaitForChild("onePlayerLeftCheck")

-- 관전모드 처리 변수
local player = game.Players.LocalPlayer
local screengui = script.Parent
local frame = screengui.controlPanel
local camera = workspace.Camera
local number = 1

-- 본인을 제외한 생존한 플레이어를 구하는 함수
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

-- 관전모드 작동 컨트롤 패널 함수(어떤 플레이어를 비출지 / 생존 플레이어를 순회하면서 반복)
frame["다음"].MouseButton1Click:Connect(function()
	local nonLocalPlayers = getNonLocalPlayers()
	if #nonLocalPlayers > 0 then
		number = (number + 1) % #nonLocalPlayers -- 순환 인덱스 계산
		if number == 0 then
			number = #nonLocalPlayers
		end
		camera.CameraSubject = nonLocalPlayers[number].Character.Humanoid
		print(nonLocalPlayers[number])
	end
end)

frame["이전"].MouseButton1Click:Connect(function()
	local nonLocalPlayers = getNonLocalPlayers()
	if #nonLocalPlayers > 0 then
		number = (number - 1) % #nonLocalPlayers -- 순환 인덱스 계산
		if number == 0 then
			number = #nonLocalPlayers
		end
		camera.CameraSubject = nonLocalPlayers[number].Character.Humanoid
		print(nonLocalPlayers[number])
	end
end)

-- 플레이어가 죽을 때 호출되는 함수
local function onPlayerDied()
	print("player die check on observerControl!")
	playerDieEvent:FireServer()

	local nonLocalPlayers = getNonLocalPlayers() -- (로컬 플레이어 제외) 생존한 플레이어 리스트
	print("Now alive player Number : " .. #nonLocalPlayers)
	
	-- 본인을 제외한 플레이어가 1명 이상일 때 / 본인 포함 2명 이상이 게임 플레이
	if #nonLocalPlayers > 0 then
		frame.Visible = true
		number = 1 -- 초기화
		camera.CameraSubject = nonLocalPlayers[number].Character.Humanoid
	-- 본인은 제외한 플레이어가 없을 때 / 본인도 죽었기 때문에 존에 1명도 없음 / 승리로 인정
	elseif #nonLocalPlayers == 0 then
		number = 1
		playerRespawnEvent:FireServer()
	else
		warn("can recall player died state.")
	end
end

local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

-- 모든 플레이어는 본인이 죽을 때마다 이벤트를 발생시킴
humanoid.Died:Connect(onPlayerDied)

-- 본인이 마지막 생존자일 경우의 안내문 : 수고했고, 잘 가라
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

-- 플레이어가 추가될 때마다 사망 이벤트 연결
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	humanoid.Died:Connect(onPlayerDied)
end)
