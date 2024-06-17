local gameEndEvent = game:GetService("ReplicatedStorage").Event:WaitForChild("NowPlayerRespawn") -- 플레이어가 1명만 남았는데, 그마저 사망했을 경우 발생하는 이벤트
local gameEndNoticeEvent = game:GetService("ReplicatedStorage").Event:WaitForChild("FZgameEndNotice") -- 종료 알림 gui 발생 이벤트

local function playerWinUpdate(player)
	local winStack = player.leaderstats.win
	winStack.Value = winStack.Value + 1
end

gameEndEvent.OnServerEvent:Connect(function(player)
	-- 최종 생존 플레이어 승리 점수 갱신
	playerWinUpdate(player)
	print("player win score updated!")
	
	-- 파이트존 상태를 게임 종료로 변경
	local gameManagePart = game:GetService("Workspace"):WaitForChild("gameManagePart")
	gameManagePart:SetAttribute("gameState", "gameEnd") -- 게임 상태를 "게임 종료"로 설정
	print("FightZone state is GameEnd")
	
	-- 파이트존 입장 가능하게 변경
	local enterBlockpart = game:GetService("Workspace").Lobby2:WaitForChild("ChangeZoneBlockPart")
	enterBlockpart.CanTouch = false
	enterBlockpart.CanCollide = false
	local enterFZpart = game:GetService("Workspace").Lobby2:WaitForChild("ChangeZonePart")
	enterFZpart.CanTouch = true
	
	-- 게임 종료 & 승자 알림 GUI 발생 event
	gameEndNoticeEvent:FireAllClients("This Game Winner : " .. player.Name .. "!!")
end)

