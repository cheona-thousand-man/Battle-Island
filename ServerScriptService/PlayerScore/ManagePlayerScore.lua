-- 플레이어 데이터 관리하는 모듈
local PlayerDataModule = require(game.ServerScriptService.PlayerScore:WaitForChild("PlayerDataModule"))
-- 플레이어 데이터 서버 저장소 연결
local DataStoreService = game:GetService("DataStoreService")
local playerStore = DataStoreService:GetDataStore("PlayerScore")

local function logonPlayer(player)
	-- 서버에 저장된 플레이어 데이터 변수
	local playerUserId = player.UserId
	local playerScore = PlayerDataModule.GetPlayerScore(playerUserId)

	if playerScore then
		print("Player Score:", playerScore[1], playerScore[2])
	else
		print("No data found for player", playerUserId)
		-- 플레이어 데이터가 없으면 초기화
		playerScore = {0, 0}
		PlayerDataModule.SetPlayerScore(playerUserId, playerScore)
	end

	-- leaderstats 폴더 생성
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- kill 값 생성
	local kill = Instance.new("NumberValue")
	kill.Name = "kill"
	kill.Value = playerScore[1]
	kill.Parent = leaderstats

	-- win 값 생성
	local win = Instance.new("NumberValue")
	win.Name = "win"
	win.Value = playerScore[2]
	win.Parent = leaderstats
	
	-- 게임 진행 시 상태(onlineState)를 공용폴더(Workspace.onlinePlayer)에 저장
	local onlineState = Instance.new("StringValue")
	onlineState.Name = player.Name
	onlineState.Value = "wait"
	onlineState.Parent = game:GetService("Workspace").onlinePlayer
end

-- 게임 진행동안 갱신된 kill/win 값은 플레이어 leaderstats 폴더에서 관리/갱신되고, 종료 시 데이터 서버 저장소에 반영
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