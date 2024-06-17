local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local DEATH_ZONE_NAME = "DeathZone"  -- ReplicatedStorage에 저장된 파트의 이름
local DEATH_ZONE_DURATION = 10  -- 데드존이 유지되는 시간 (초)
--local SPAWN_INTERVAL = 15  -- 데드존이 생성되는 간격 (초)

local MIN_DEATH_ZONES = 1  -- 최소 생성 개수
local MAX_DEATH_ZONES = 5  -- 최대 생성 개수

local function createDeathZone()
	local template = ReplicatedStorage:FindFirstChild(DEATH_ZONE_NAME)
	if not template then
		warn("Could not find DeathZone in ReplicatedStorage")
		return
	end

	-- 랜덤한 개수의 데드존 생성
	local deathZoneCount = math.random(MIN_DEATH_ZONES, MAX_DEATH_ZONES)
	for i = 1, deathZoneCount do
		-- ReplicatedStorage에서 파트를 복제
		local deathZone = template:Clone()
		deathZone.Anchored = false

		-- 데드존의 위치를 랜덤하게 설정
		local randomX = math.random(-150, 150)
		local randomZ = math.random(-150, 150)
		deathZone.Position = Vector3.new(35 + randomX, 50, 60 + randomZ) -- 맵 중앙 설정 시 35, 35, 60

		-- 플레이어가 밟았을 때 죽게 하는 기능 추가
		deathZone.Touched:Connect(function(hit)
			local character = hit.Parent
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = humanoid.Health - 10  -- 플레이어를 죽임
			end
		end)

		-- Workspace에 추가하고 10초 뒤에 제거
		deathZone.Parent = Workspace
		Debris:AddItem(deathZone, DEATH_ZONE_DURATION)
	end
end

-- 데드존을 주기적으로 생성
while true do
	createDeathZone()
	--wait(SPAWN_INTERVAL)
	wait(math.random(3, 10))
end
