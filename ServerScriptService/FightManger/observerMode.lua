local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerRespawnEvent = ReplicatedStorage.Event:WaitForChild("NowPlayerRespawn")
local playerDieEvent = ReplicatedStorage.Event:WaitForChild("DiedPlayerCheck")
local playerObserverEndEvent = ReplicatedStorage.Event:WaitForChild("observerModeEnd")
local onePlayerLeftEvent = ReplicatedStorage.Event:WaitForChild("onePlayerLeftCheck")

game.Players.CharacterAutoLoads = false

game.Players.PlayerAdded:Connect(function(player)
	player:LoadCharacter()
end)

-- �÷��̾� ��� ���¸� ������ ���̺�
local deadPlayers = {}

-- �÷��̾ ���� �� �ش� ���ӿ� ��� ���¸� ����ϰ�, ������ ���� üũ�ϴ� �Լ�
playerDieEvent.OnServerEvent:Connect(function(targetPlayer)
	local onlineState = game:GetService("Workspace").onlinePlayer:WaitForChild(targetPlayer.Name)
	onlineState.Value = "die"
	
	-- �÷��̾ ������, ���� ������ ���� Ȯ���ϴ� ��ũ��Ʈ
	deadPlayers[targetPlayer.Name] = true
	local alivePlayers = 0
	local lastAlivePlayer = nil
	for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
		if not deadPlayers[otherPlayer.Name] and game:GetService("Workspace").onlinePlayer:WaitForChild(otherPlayer.Name).Value == "enterFZ" then
			alivePlayers = alivePlayers + 1
			lastAlivePlayer = otherPlayer
		end
	end
	-- �÷��̾ 1�� ������ ��� �ش� �÷��̾ �׿�������(...!)
	if alivePlayers == 1 and lastAlivePlayer then
		-- �Ѹ� �����߱⿡ ���������� �ʵ� �� ������ٴ� �޽��� ����
		onePlayerLeftEvent:FireClient(lastAlivePlayer)
		wait(10) -- �޽��� ���� �� 10�� ���
		-- �÷��̾ ����ϰ� ����� ���� ����
		local humanoid = lastAlivePlayer.Character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Health = 0
		end
	end
end)

-- ��� �÷��̾ ���� �� ������ ��Ű�� �Լ�
playerRespawnEvent.OnServerEvent:Connect(function(player)
	local players = game.Players:GetPlayers()
	for _, targetPlayer in pairs(players) do
		if game:GetService("Workspace").onlinePlayer:WaitForChild(targetPlayer.Name).Value == "die" then
			-- �ش� �÷��̾��� ĳ���͸� ��������ŵ�ϴ�.
			targetPlayer:LoadCharacter()
			print("player Reapawn now!")
			-- �÷��̾� ������ �� ����(onlineState)�� ��������(Workspace.onlinePlayer)�� ����
			local onlineState = game:GetService("Workspace").onlinePlayer:WaitForChild(targetPlayer.Name)
			onlineState.Value = "wait"
		end
	end
	playerObserverEndEvent:FireAllClients() -- �÷��̾��� ������带 �����ϰ� �⺻ ī�޶� ���� �����ϴ� �̺�Ʈ
end)