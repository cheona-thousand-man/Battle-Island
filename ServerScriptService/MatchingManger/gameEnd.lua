local gameEndEvent = game:GetService("ReplicatedStorage").Event:WaitForChild("NowPlayerRespawn") -- �÷��̾ 1�� ���Ҵµ�, �׸��� ������� ��� �߻��ϴ� �̺�Ʈ
local gameEndNoticeEvent = game:GetService("ReplicatedStorage").Event:WaitForChild("FZgameEndNotice") -- ���� �˸� gui �߻� �̺�Ʈ

local function playerWinUpdate(player)
	local winStack = player.leaderstats.win
	winStack.Value = winStack.Value + 1
end

gameEndEvent.OnServerEvent:Connect(function(player)
	-- ���� ���� �÷��̾� �¸� ���� ����
	playerWinUpdate(player)
	print("player win score updated!")
	
	-- ����Ʈ�� ���¸� ���� ����� ����
	local gameManagePart = game:GetService("Workspace"):WaitForChild("gameManagePart")
	gameManagePart:SetAttribute("gameState", "gameEnd") -- ���� ���¸� "���� ����"�� ����
	print("FightZone state is GameEnd")
	
	-- ����Ʈ�� ���� �����ϰ� ����
	local enterBlockpart = game:GetService("Workspace").Lobby2:WaitForChild("ChangeZoneBlockPart")
	enterBlockpart.CanTouch = false
	enterBlockpart.CanCollide = false
	local enterFZpart = game:GetService("Workspace").Lobby2:WaitForChild("ChangeZonePart")
	enterFZpart.CanTouch = true
	
	-- ���� ���� & ���� �˸� GUI �߻� event
	gameEndNoticeEvent:FireAllClients("This Game Winner : " .. player.Name .. "!!")
end)

