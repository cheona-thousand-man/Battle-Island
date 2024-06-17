local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerRespawnEvent = ReplicatedStorage.Event:WaitForChild("NowPlayerRespawn")
local playerDieEvent = ReplicatedStorage.Event:WaitForChild("DiedPlayerCheck")
local playerObserverEndEvent = ReplicatedStorage.Event:WaitForChild("observerModeEnd")
local onePlayerLeftEvent = ReplicatedStorage.Event:WaitForChild("onePlayerLeftCheck")

game.Players.CharacterAutoLoads = false

game.Players.PlayerAdded:Connect(function(player)
	player:LoadCharacter()
end)

-- 플레이어 사망 상태를 저장한 테이블
local deadPlayers = {}

-- 플레이어가 죽을 때 해당 게임에 사망 상태를 기록하고, 생존자 수를 체크하는 함수
playerDieEvent.OnServerEvent:Connect(function(targetPlayer)
	local onlineState = game:GetService("Workspace").onlinePlayer:WaitForChild(targetPlayer.Name)
	onlineState.Value = "die"
	
	-- 플레이어가 죽으면, 남은 생존자 수를 확인하는 스크립트
	deadPlayers[targetPlayer.Name] = true
	local alivePlayers = 0
	local lastAlivePlayer = nil
	for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
		if not deadPlayers[otherPlayer.Name] and game:GetService("Workspace").onlinePlayer:WaitForChild(otherPlayer.Name).Value == "enterFZ" then
			alivePlayers = alivePlayers + 1
			lastAlivePlayer = otherPlayer
		end
	end
	-- 플레이어가 1명만 남았을 경우 해당 플레이어를 죽여버리기(...!)
	if alivePlayers == 1 and lastAlivePlayer then
		-- 한명만 생존했기에 축하하지만 너도 곧 사라진다는 메시지 전송
		onePlayerLeftEvent:FireClient(lastAlivePlayer)
		wait(10) -- 메시지 전송 후 10초 대기
		-- 플레이어를 사망하게 만드는 설정 적용
		local humanoid = lastAlivePlayer.Character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Health = 0
		end
	end
end)

-- 모든 플레이어가 죽을 때 리스폰 시키는 함수
playerRespawnEvent.OnServerEvent:Connect(function(player)
	local players = game.Players:GetPlayers()
	for _, targetPlayer in pairs(players) do
		if game:GetService("Workspace").onlinePlayer:WaitForChild(targetPlayer.Name).Value == "die" then
			-- 해당 플레이어의 캐릭터를 리스폰시킵니다.
			targetPlayer:LoadCharacter()
			print("player Reapawn now!")
			-- 플레이어 리스폰 시 상태(onlineState)를 공용폴더(Workspace.onlinePlayer)에 저장
			local onlineState = game:GetService("Workspace").onlinePlayer:WaitForChild(targetPlayer.Name)
			onlineState.Value = "wait"
		end
	end
	playerObserverEndEvent:FireAllClients() -- 플레이어의 관전모드를 종료하고 기본 카메라 모드로 변경하는 이벤트
end)