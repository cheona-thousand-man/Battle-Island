-- ����Ʈ���� ������ �÷��̾� ���� ���ϴ� �Լ�
local function checkPlayerNumber()
	local players = game.Players:GetPlayers()
	local enteredPlayers = {}

	for _,player in pairs(players) do
		local onlineState = game:GetService("Workspace").onlinePlayer:WaitForChild(player.Name)
		if onlineState.Value == "enterFZ" then
			table.insert(enteredPlayers, player)
		end
	end
	print("now enter FZ : " .. #enteredPlayers .. "players")
	return enteredPlayers
end

-- �÷��̾ ���� �� �̻��̸� ������ �����ϴ� �Լ�
local function gameStart(enteredPlayers)
	local gameManagePart = game:GetService("Workspace"):WaitForChild("gameManagePart")
	local currentState = gameManagePart:GetAttribute("gameState")

	-- �÷��̾ N �� �̻� & ���� ���°� "gameStart"�� �ƴϸ� ���� ���� ó��
	if #enteredPlayers > 2 and currentState ~= "gameStart" then 
		gameManagePart:SetAttribute("gameState", "gameStart") -- ���� ���¸� "���� ����"���� ����
		local enterFZpart = game:GetService("Workspace").Lobby2:WaitForChild("ChangeZonePart")
		enterFZpart.CanTouch = false
		local enterBlockpart = game:GetService("Workspace").Lobby2:WaitForChild("ChangeZoneBlockPart")
		enterBlockpart.CanTouch = true
		enterBlockpart.CanCollide = true
		print("game start now!")
	elseif currentState == "gameStart" then
		print("game aleady started...")
	else
		print("waiting time to game start")
	end
end

-- 3�ʸ��� ������ �����Ǵ��� Ȯ��
local function periodicCheck()
	while true do
		wait(3)
		local enteredPlayers = checkPlayerNumber()
		gameStart(enteredPlayers)
	end
end

-- spawn�Լ��� ���ο� �����带 �����Ͽ� �ֱ������� ���� üũ / ������ ������ �ʰ� �ϴ� Ʈ��
spawn(periodicCheck)