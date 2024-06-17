-- �÷��̾� ������ �����ϴ� ���
local PlayerDataModule = require(game.ServerScriptService.PlayerScore:WaitForChild("PlayerDataModule"))
-- �÷��̾� ������ ���� ����� ����
local DataStoreService = game:GetService("DataStoreService")
local playerStore = DataStoreService:GetDataStore("PlayerScore")

local function logonPlayer(player)
	-- ������ ����� �÷��̾� ������ ����
	local playerUserId = player.UserId
	local playerScore = PlayerDataModule.GetPlayerScore(playerUserId)

	if playerScore then
		print("Player Score:", playerScore[1], playerScore[2])
	else
		print("No data found for player", playerUserId)
		-- �÷��̾� �����Ͱ� ������ �ʱ�ȭ
		playerScore = {0, 0}
		PlayerDataModule.SetPlayerScore(playerUserId, playerScore)
	end

	-- leaderstats ���� ����
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- kill �� ����
	local kill = Instance.new("NumberValue")
	kill.Name = "kill"
	kill.Value = playerScore[1]
	kill.Parent = leaderstats

	-- win �� ����
	local win = Instance.new("NumberValue")
	win.Name = "win"
	win.Value = playerScore[2]
	win.Parent = leaderstats
	
	-- ���� ���� �� ����(onlineState)�� ��������(Workspace.onlinePlayer)�� ����
	local onlineState = Instance.new("StringValue")
	onlineState.Name = player.Name
	onlineState.Value = "wait"
	onlineState.Parent = game:GetService("Workspace").onlinePlayer
end

-- ���� ���ൿ�� ���ŵ� kill/win ���� �÷��̾� leaderstats �������� ����/���ŵǰ�, ���� �� ������ ���� ����ҿ� �ݿ�
local function logoffPlayer(player)
	local playerUserId = player.UserId
	local leaderstats = player:FindFirstChild("leaderstats")

	if leaderstats then
		local killValue = leaderstats:FindFirstChild("kill")
		local winValue = leaderstats:FindFirstChild("win")

		if killValue and winValue then
			local killStack = killValue.Value
			local winStack = winValue.Value
			local playerScore = {killStack, winStack}

			PlayerDataModule.SetPlayerScore(playerUserId, playerScore)
		else
			warn("Player leaderstats are missing kill or win values.")
		end
	else
		warn("Player has no leaderstats folder.")
	end
end

game.Players.PlayerAdded:Connect(logonPlayer)
game.Players.PlayerRemoving:Connect(logoffPlayer)