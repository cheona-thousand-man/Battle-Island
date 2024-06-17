local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shrinkFightZoneEvent = ReplicatedStorage.Event:WaitForChild("shrinkFightZone")
local FightZoneGameStartEvent = ReplicatedStorage.Event:WaitForChild("FZgameStart")
local gameEndEvent = ReplicatedStorage.Event:WaitForChild("NowPlayerRespawn") -- �÷��̾ 1�� ���� ������� ��� �߻��ϴ� �̺�Ʈ = ��������

local CENTER_POSITION = Vector3.new(45, 15, 50)  -- �߾� ��ǥ / �� �߾� ���� �� 45, 15, 50
local INITIAL_RADIUS = 200  -- �ڱ��� �ʱ� ������
local SHRINK_DURATION = 15  -- �ڱ����� ��ҵǴ� �� �ɸ��� �ð� (��)
local FINAL_RADIUS = 65  -- ���� �ڱ��� ������

-- �ڱ����� �����ϴ� �Լ�
local function createForceField()
	local forceFieldTemplate = ReplicatedStorage:FindFirstChild("ForceField")
	forceField = forceFieldTemplate:clone()
	forceField.Size = Vector3.new(INITIAL_RADIUS * 2, INITIAL_RADIUS * 2, INITIAL_RADIUS * 2)
	forceField.Position = CENTER_POSITION
	forceField.Anchored = true
	forceField.CanCollide = false
	forceField.Transparency = 0.7
	forceField.BrickColor = BrickColor.new("Bright blue")
	forceField.Parent = game.Workspace

	return forceField
end

-- �ڱ����� �پ��� ���� ���� �Լ�
local function shrinkForceField(forceField)
	local startTime = tick()
	local endTime = startTime + SHRINK_DURATION

	RunService.Heartbeat:Connect(function(deltaTime)
		local currentTime = tick()
		local elapsedTime = currentTime - startTime

		if elapsedTime >= SHRINK_DURATION then
			gameEndEvent.OnServerEvent:Connect(function() -- ������ ����Ǳ� ������ �ڱ��� �� �����
				forceField:Destroy()
			end)
		else
			local progress = elapsedTime / SHRINK_DURATION
			local newRadius = INITIAL_RADIUS * (1 - progress) + FINAL_RADIUS * progress
			forceField.Size = Vector3.new(newRadius * 2, newRadius * 2, newRadius * 2)
		end
	end)
end

-- �÷��̾ ������ �״� �ܰ� ��ġ ���
local function isNearForceFieldEdge(characterPosition, forceField)
	local distanceFromCenter = (characterPosition - forceField.Position).Magnitude
	local forceFieldRadius = forceField.Size.X / 2
	local threshold = 20  -- �÷��̾ �״� �Ÿ��� ���� ���� ����

	return math.abs(distanceFromCenter - forceFieldRadius) < threshold
end

-- ��� �÷��̾�� ��� �޽��� ����
local function showWarningToAllPlayers()
	shrinkFightZoneEvent:FireAllClients()
end

-- ������ ���� �Ǿ����� Ȯ���ϴ� �Լ� / ����(gameStart) ���� �� ������ �̺�Ʈ ����� ���� Ʈ���� �۵�
local previousCondition = false -- ���ӽ���(gameStart) �� 1���� ����ǰ�, ����� �� ��쿡�� �ٽ� 1�� ����ǰ� �����ϴ� flag 

local function checkGameStart()
	local gameManagePart = game:GetService("Workspace"):WaitForChild("gameManagePart")
	local currentCondition = (gameManagePart:GetAttribute("gameState") == "gameStart") -- �ڱ����� �����Ǵ� ����

	-- ���� ���¸� �����ϴ� Workspace�� gameManagerPart�� �Ӽ�(gameState)�� ����Ǿ���, true("gameStart" ����)�� ��쿡 �̺�Ʈ Ʈ����
	if currentCondition ~= previousCondition and currentCondition then
		FightZoneGameStartEvent:Fire("Game Start now, and Triggered due to condition met!")
	end

	-- ������ �ٽ� �Լ� ȣ��Ǵ� �� ����ؼ�, ���� ���� ������Ʈ
	previousCondition = currentCondition
end

-- ������ ���۵Ǹ� �ڱ��� �̺�Ʈ ���� : ���δ��̺�Ʈ(FightZoneGameStartEvent)�� ���� Ʈ���ŵ�
FightZoneGameStartEvent.Event:Connect(function(message)
	print(message) -- debug print

	-- 5�ʵ� �ڱ��� �߻� ���
	showWarningToAllPlayers()

	wait(5) -- �ڱ��� ���� �� 5�� ��� �� �ڱ��� ����
	local forceField = createForceField()

	-- �ڱ��忡 ������ �÷��̾� ����
	forceField.Touched:Connect(function(hit)
		local character = hit.Parent
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			-- ĳ���Ͱ� �ܰ��� ��Ҵ��� Ȯ��
			if isNearForceFieldEdge(character.PrimaryPart.Position, forceField) then
				humanoid.Health = 0
			end
		end
	end)

	-- �ڱ��� ���� �� ���� �ð��� ������ �ڱ��� ���
	wait(5)  -- ��: �ڱ��� ���� �� 5�� �Ŀ� �ڱ��� ��� ����
	if forceField then
		shrinkForceField(forceField)
	end
end)

-- ���� ���� ������ �����Ǿ����� Ȯ���Ͽ�, 10�ʸ��� �ֱ������� �̺�Ʈ Ʈ���� ��ų �� ����
while true do
	checkGameStart()
	wait(10)
end

--[[
-- �÷��̾ ���ӿ� �߰��� �� GUI�� �����ϵ��� ����
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		wait(5)
		showWarningToAllPlayers()
	end)
end)
]]