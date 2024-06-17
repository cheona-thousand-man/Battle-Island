local Players = game:GetService("Players")
local localPlayer = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent 가져오기
local killNotificationEvent = ReplicatedStorage.Event:WaitForChild("KillNotification")

local function onCharacterAdded(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		-- 최근 공격자를 저장할 변수
		local lastAttacker = nil
		-- 사망 상태를 추적하는 변수
		local isDead = false

		-- Health가 변할 때마다 호출되는 함수
		local function onHealthChanged(newHealth)
			-- 캐릭터 사망 조건은 Health <= 0 / 이 때 kill 갱신
			if humanoid.Health <= 0 and not isDead then
				isDead = true
				if lastAttacker then
					local killedPlayer = Players:GetPlayerFromCharacter(character)
					local killerPlayer = lastAttacker
					
					if killedPlayer and killerPlayer then
						print(character.Name .. " was killed by " .. lastAttacker.Name)
						-- Killer의 kill 점수를 1 갱신
						local killerLeaderstat = lastAttacker:FindFirstChild("leaderstats")
						local killer_kill = killerLeaderstat and killerLeaderstat:FindFirstChild("kill")
						if killer_kill then
							killer_kill.Value = killer_kill.Value + 1
						end
						-- 알림 전송
						killNotificationEvent:FireClient(killedPlayer, "You were killed by " .. killerPlayer.Name)
                        killNotificationEvent:FireClient(killerPlayer, "You killed " .. killedPlayer.Name)
					end
				else
					print(character.Name .. " died.")
				end
			end
		end

		-- 캐릭터가 피격될 때 호출되는 함수
		local function onHumanoidTouched(hit)
			local attacker = hit.Parent
			if attacker and attacker:FindFirstChildOfClass("Humanoid") then
				local player = Players:GetPlayerFromCharacter(attacker)
				if player then
					lastAttacker = player
				end
			end
		end

		-- HealthChanged 이벤트와 함수 연결
		humanoid.HealthChanged:Connect(onHealthChanged)

		-- 캐릭터가 피격될 때 호출되는 함수 연결
		humanoid.Touched:Connect(onHumanoidTouched)
	end
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(onCharacterAdded)

	if player.Character then
		onCharacterAdded(player.Character)
	end
end

--[[이벤트 연결의 지속성
	onPlayerAdded 함수는 새로운 플레이어가 접속할 때마다 호출되며, 해당 플레이어의 CharacterAdded 이벤트에 대한 연결을 설정합니다. 
	이 이벤트 연결은 한 번 설정되면 지속적으로 유지됩니다. 즉, 플레이어가 게임을 떠나지 않는 한, 플레이어의 캐릭터가 추가될 때마다 
	onCharacterAdded 함수가 계속해서 호출됩니다.
	이 이벤트 연결 방식은 로블록스에서 매우 일반적인 패턴으로, 이벤트를 한 번 연결하면 해당 이벤트가 발생할 때마다 지정된 콜백 함수가 호출되도록 합니다. 
	이를 통해 특정 조건이 충족될 때마다 원하는 코드를 실행할 수 있습니다.
	]]
Players.PlayerAdded:Connect(onPlayerAdded)

-- 이미 있는 플레이어들에 대해서도 적용
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
