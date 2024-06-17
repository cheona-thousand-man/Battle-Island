local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shrinkFightZoneEvent = ReplicatedStorage.Event:WaitForChild("shrinkFightZone")
local FightZoneGameStartEvent = ReplicatedStorage.Event:WaitForChild("FZgameStart")
local gameEndEvent = ReplicatedStorage.Event:WaitForChild("NowPlayerRespawn") -- 플레이어가 1명만 남고 사망했을 경우 발생하는 이벤트 = 게임종료

local CENTER_POSITION = Vector3.new(45, 15, 50)  -- 중앙 좌표 / 맵 중앙 설정 시 45, 15, 50
local INITIAL_RADIUS = 200  -- 자기장 초기 반지름
local SHRINK_DURATION = 15  -- 자기장이 축소되는 데 걸리는 시간 (초)
local FINAL_RADIUS = 65  -- 최종 자기장 반지름

-- 자기장을 생성하는 함수
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

-- 자기장이 줄어드는 동작 구현 함수
local function shrinkForceField(forceField)
	local startTime = tick()
	local endTime = startTime + SHRINK_DURATION

	RunService.Heartbeat:Connect(function(deltaTime)
		local currentTime = tick()
		local elapsedTime = currentTime - startTime

		if elapsedTime >= SHRINK_DURATION then
			gameEndEvent.OnServerEvent:Connect(function() -- 게임이 종료되기 전까지 자기장 안 사라짐
				forceField:Destroy()
			end)
		else
			local progress = elapsedTime / SHRINK_DURATION
			local newRadius = INITIAL_RADIUS * (1 - progress) + FINAL_RADIUS * progress
			forceField.Size = Vector3.new(newRadius * 2, newRadius * 2, newRadius * 2)
		end
	end)
end

-- 플레이어가 닿으면 죽는 외곽 위치 계산
local function isNearForceFieldEdge(characterPosition, forceField)
	local distanceFromCenter = (characterPosition - forceField.Position).Magnitude
	local forceFieldRadius = forceField.Size.X / 2
	local threshold = 20  -- 플레이어가 죽는 거리의 오차 범위 설정

	return math.abs(distanceFromCenter - forceFieldRadius) < threshold
end

-- 모든 플레이어에게 경고 메시지 전송
local function showWarningToAllPlayers()
	shrinkFightZoneEvent:FireAllClients()
end

-- 게임이 시작 되었는지 확인하는 함수 / 조건(gameStart) 만족 시 서버간 이벤트 통신을 위한 트리거 작동
local previousCondition = false -- 게임시작(gameStart) 시 1번만 실행되고, 재시작 될 경우에만 다시 1번 실행되게 점검하는 flag 

local function checkGameStart()
	local gameManagePart = game:GetService("Workspace"):WaitForChild("gameManagePart")
	local currentCondition = (gameManagePart:GetAttribute("gameState") == "gameStart") -- 자기장이 형성되는 조건

	-- 게임 상태를 저장하는 Workspace의 gameManagerPart의 속성(gameState)이 변경되었고, true("gameStart" 상태)일 경우에 이벤트 트리거
	if currentCondition ~= previousCondition and currentCondition then
		FightZoneGameStartEvent:Fire("Game Start now, and Triggered due to condition met!")
	end

	-- 다음에 다시 함수 호출되는 걸 고려해서, 이전 상태 업데이트
	previousCondition = currentCondition
end

-- 게임이 시작되면 자기장 이벤트 시작 : 바인더이벤트(FightZoneGameStartEvent)를 통해 트리거됨
FightZoneGameStartEvent.Event:Connect(function(message)
	print(message) -- debug print

	-- 5초뒤 자기장 발생 경고
	showWarningToAllPlayers()

	wait(5) -- 자기장 생성 전 5초 대기 후 자기장 생성
	local forceField = createForceField()

	-- 자기장에 닿으면 플레이어 죽음
	forceField.Touched:Connect(function(hit)
		local character = hit.Parent
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			-- 캐릭터가 외곽에 닿았는지 확인
			if isNearForceFieldEdge(character.PrimaryPart.Position, forceField) then
				humanoid.Health = 0
			end
		end
	end)

	-- 자기장 생성 후 일정 시간이 지나면 자기장 축소
	wait(5)  -- 예: 자기장 생성 후 5초 후에 자기장 축소 시작
	if forceField then
		shrinkForceField(forceField)
	end
end)

-- 게임 시작 조건이 충족되었는지 확인하여, 10초마다 주기적으로 이벤트 트리거 시킬 지 결정
while true do
	checkGameStart()
	wait(10)
end

--[[
-- 플레이어가 게임에 추가될 때 GUI를 생성하도록 설정
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		wait(5)
		showWarningToAllPlayers()
	end)
end)
]]