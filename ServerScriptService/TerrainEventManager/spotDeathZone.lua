local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local DEATH_ZONE_NAME = "DeathZone"  -- ReplicatedStorage�� ����� ��Ʈ�� �̸�
local DEATH_ZONE_DURATION = 10  -- �������� �����Ǵ� �ð� (��)
--local SPAWN_INTERVAL = 15  -- �������� �����Ǵ� ���� (��)

local MIN_DEATH_ZONES = 1  -- �ּ� ���� ����
local MAX_DEATH_ZONES = 5  -- �ִ� ���� ����

local function createDeathZone()
	local template = ReplicatedStorage:FindFirstChild(DEATH_ZONE_NAME)
	if not template then
		warn("Could not find DeathZone in ReplicatedStorage")
		return
	end

	-- ������ ������ ������ ����
	local deathZoneCount = math.random(MIN_DEATH_ZONES, MAX_DEATH_ZONES)
	for i = 1, deathZoneCount do
		-- ReplicatedStorage���� ��Ʈ�� ����
		local deathZone = template:Clone()
		deathZone.Anchored = false

		-- �������� ��ġ�� �����ϰ� ����
		local randomX = math.random(-150, 150)
		local randomZ = math.random(-150, 150)
		deathZone.Position = Vector3.new(35 + randomX, 50, 60 + randomZ) -- �� �߾� ���� �� 35, 35, 60

		-- �÷��̾ ����� �� �װ� �ϴ� ��� �߰�
		deathZone.Touched:Connect(function(hit)
			local character = hit.Parent
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.Health = humanoid.Health - 10  -- �÷��̾ ����
			end
		end)

		-- Workspace�� �߰��ϰ� 10�� �ڿ� ����
		deathZone.Parent = Workspace
		Debris:AddItem(deathZone, DEATH_ZONE_DURATION)
	end
end

-- �������� �ֱ������� ����
while true do
	createDeathZone()
	--wait(SPAWN_INTERVAL)
	wait(math.random(3, 10))
end
