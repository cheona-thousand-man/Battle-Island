-- 파이트존에 참가한 플레이어 수를 구하는 함수
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

-- 플레이어가 일정 수 이상이면 게임을 시작하는 함수
local function gameStart(enteredPlayers)
	local gameManagePart = game:GetService("Workspace"):WaitForChild("gameManagePart")
	local currentState = gameManagePart:GetAttribute("gameState")

	-- 플레이어가 N 명 이상 & 게임 상태가 "gameStart"가 아니면 게임 시작 처리
	if #enteredPlayers > 2 and currentState ~= "gameStart" then 
		gameManagePart:SetAttribute("gameState", "gameStart") -- 게임 상태를 "게임 시작"으로 설정
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

-- 3초마다 조건이 만족되는지 확인
local function periodicCheck()
	while true do
		wait(3)
		local enteredPlayers = checkPlayerNumber()
		gameStart(enteredPlayers)
	end
end

-- spawn함수는 새로운 스레드를 생성하여 주기적으로 조건 체크 / 서버가 멈추지 않게 하는 트윅
spawn(periodicCheck)