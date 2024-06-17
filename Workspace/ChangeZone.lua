-- 플레이어가 나를 밟으면 다른 스테이지로 텔레포트 시키고 싶다

local changeZone = script.Parent
local changeBlockZone = game:GetService("Workspace").Lobby2:WaitForChild("ChangeZoneBlockPart")

-- 파이트존 파트 선언 (파이트존 파트가 텔레포트파트랑 같은 워크스페이스에 있어야함)
local FightZoneParts = {"FightZonePart1", "FightZonePart2", "FightZonePart3", "FightZonePart4"}
-- local FightzonePart = "FightZonePart"

local Debounce = false

-- [게임 시작 전] 텔레포트 기능 선언
local function teleport (otherPart)
	if not Debounce then
		Debounce = true
		local partParent = otherPart.Parent
		local Humanoid = partParent:FindFirstChild("Humanoid")

		if Humanoid then
			-- 플레이어를 옮길 위치를 랜덤으로 정해주기 위해 랜덤 인덱스 구하기
			local randomIndex = math.random(1, #FightZoneParts)
			local selectedPartName = FightZoneParts[randomIndex]
			local selectedPart = game.Workspace:FindFirstChild(selectedPartName)
			
			-- 플레이어를 랜덤한 위치로 옮겨주기
			if selectedPart then
				partParent.HumanoidRootPart.CFrame = selectedPart.CFrame + Vector3.new(0, 3, 0)
			end
			
			
			-- 파이트존 입장
			-- local Pos = game.Workspace:FindFirstChild(FightZonePart)
			-- partParent.HumanoidRootPart.CFrame = Pos.CFrame + Vector3.new(0, 3, 0)
			-- wait(1)
		end
		
		wait(1)

		Debounce = false
	end
end

-- [게임 시작 후] 게임 시작으로 입장 불가 안내
local function notice(otherPart)
	if not Debounce then
		Debounce = true
		local character = otherPart.Parent
		local Humanoid = character:FindFirstChild("Humanoid")
		
		if Humanoid then -- 게임이 이미 시작되어 입장할 수 없다는 안내 띄우기 by 리모트이벤트
			-- RemoteEvent 가져와서, 접촉한 플레이어에 접근 불가 안내 띄우기
			local cantEnterFZEvent = game:GetService("ReplicatedStorage").Event:WaitForChild("cantEnterFZnotice")
			cantEnterFZEvent:FireClient(game.Players:GetPlayerFromCharacter(character))
			print("enter block trigger fired!")
		end
		
		wait(1)
		
		Debounce = false
	end
end

-- [게임 시작 전] 플레이어가 터치하면 파이트존으로 이동
changeZone.Touched:Connect(teleport)

-- [게임 시작 후] 플레이어가 부딛히면 입장 불가 안내
changeBlockZone.Touched:Connect(notice)

--local teleportPart = script.Parent
--local destination = Vector3.new(31.98, 45.482, 61.226) -- 텔레포트 목적지 위치 (원하는 좌표로 변경)

--local function onTouch(otherPart)
--	local character = otherPart.Parent
--	local humanoid = character:FindFirstChildOfClass("Humanoid")

--	if humanoid then

--		character:SetPrimaryPartCFrame(CFrame.new(destination))
--	end
--end

--teleportPart.Touched:Connect(onTouch)





