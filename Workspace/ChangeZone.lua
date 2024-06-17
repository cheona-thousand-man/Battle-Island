-- �÷��̾ ���� ������ �ٸ� ���������� �ڷ���Ʈ ��Ű�� �ʹ�

local changeZone = script.Parent
local changeBlockZone = game:GetService("Workspace").Lobby2:WaitForChild("ChangeZoneBlockPart")

-- ����Ʈ�� ��Ʈ ���� (����Ʈ�� ��Ʈ�� �ڷ���Ʈ��Ʈ�� ���� ��ũ�����̽��� �־����)
local FightZoneParts = {"FightZonePart1", "FightZonePart2", "FightZonePart3", "FightZonePart4"}
-- local FightzonePart = "FightZonePart"

local Debounce = false

-- [���� ���� ��] �ڷ���Ʈ ��� ����
local function teleport (otherPart)
	if not Debounce then
		Debounce = true
		local partParent = otherPart.Parent
		local Humanoid = partParent:FindFirstChild("Humanoid")

		if Humanoid then
			-- �÷��̾ �ű� ��ġ�� �������� �����ֱ� ���� ���� �ε��� ���ϱ�
			local randomIndex = math.random(1, #FightZoneParts)
			local selectedPartName = FightZoneParts[randomIndex]
			local selectedPart = game.Workspace:FindFirstChild(selectedPartName)
			
			-- �÷��̾ ������ ��ġ�� �Ű��ֱ�
			if selectedPart then
				partParent.HumanoidRootPart.CFrame = selectedPart.CFrame + Vector3.new(0, 3, 0)
			end
			
			
			-- ����Ʈ�� ����
			-- local Pos = game.Workspace:FindFirstChild(FightZonePart)
			-- partParent.HumanoidRootPart.CFrame = Pos.CFrame + Vector3.new(0, 3, 0)
			-- wait(1)
		end
		
		wait(1)

		Debounce = false
	end
end

-- [���� ���� ��] ���� �������� ���� �Ұ� �ȳ�
local function notice(otherPart)
	if not Debounce then
		Debounce = true
		local character = otherPart.Parent
		local Humanoid = character:FindFirstChild("Humanoid")
		
		if Humanoid then -- ������ �̹� ���۵Ǿ� ������ �� ���ٴ� �ȳ� ���� by ����Ʈ�̺�Ʈ
			-- RemoteEvent �����ͼ�, ������ �÷��̾ ���� �Ұ� �ȳ� ����
			local cantEnterFZEvent = game:GetService("ReplicatedStorage").Event:WaitForChild("cantEnterFZnotice")
			cantEnterFZEvent:FireClient(game.Players:GetPlayerFromCharacter(character))
			print("enter block trigger fired!")
		end
		
		wait(1)
		
		Debounce = false
	end
end

-- [���� ���� ��] �÷��̾ ��ġ�ϸ� ����Ʈ������ �̵�
changeZone.Touched:Connect(teleport)

-- [���� ���� ��] �÷��̾ �ε����� ���� �Ұ� �ȳ�
changeBlockZone.Touched:Connect(notice)

--local teleportPart = script.Parent
--local destination = Vector3.new(31.98, 45.482, 61.226) -- �ڷ���Ʈ ������ ��ġ (���ϴ� ��ǥ�� ����)

--local function onTouch(otherPart)
--	local character = otherPart.Parent
--	local humanoid = character:FindFirstChildOfClass("Humanoid")

--	if humanoid then

--		character:SetPrimaryPartCFrame(CFrame.new(destination))
--	end
--end

--teleportPart.Touched:Connect(onTouch)





