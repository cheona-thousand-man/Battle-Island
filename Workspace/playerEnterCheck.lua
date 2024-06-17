local gameManagePart = script.Parent

-- 플레이어가 파이트존에 접속하면 상태 변경(wait → enterFZ)하는 함수
local function playerEnterCheck(otherPart)
	local player = game.Players:GetPlayerFromCharacter(otherPart.Parent) -- otherPart.Parent는 접촉한 파트를 가진 캐릭터
	if player then
		-- 플레이어 파이트존 입장 시 공용폴더(Workspace.onlinePlayer)에 있는 플레이어 상태(onlineState) 변경(→ enterFZ)
		local onlineState = game:GetService("Workspace").onlinePlayer:WaitForChild(player.Name)
		onlineState.Value = "enterFZ"
	end
end

-- 플레이어가 터치하면 플레이어 파이트존 접속 상태로 변경
gameManagePart.Touched:Connect(playerEnterCheck)