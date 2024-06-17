local Players = game:GetService("Players")
local localPlayer = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent ��������
local killNotificationEvent = ReplicatedStorage.Event:WaitForChild("KillNotification")

local function onCharacterAdded(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		-- �ֱ� �����ڸ� ������ ����
		local lastAttacker = nil
		-- ��� ���¸� �����ϴ� ����
		local isDead = false

		-- Health�� ���� ������ ȣ��Ǵ� �Լ�
		local function onHealthChanged(newHealth)
			-- ĳ���� ��� ������ Health <= 0 / �� �� kill ����
			if humanoid.Health <= 0 and not isDead then
				isDead = true
				if lastAttacker then
					local killedPlayer = Players:GetPlayerFromCharacter(character)
					local killerPlayer = lastAttacker
					
					if killedPlayer and killerPlayer then
						print(character.Name .. " was killed by " .. lastAttacker.Name)
						-- Killer�� kill ������ 1 ����
						local killerLeaderstat = lastAttacker:FindFirstChild("leaderstats")
						local killer_kill = killerLeaderstat and killerLeaderstat:FindFirstChild("kill")
						if killer_kill then
							killer_kill.Value = killer_kill.Value + 1
						end
						-- �˸� ����
						killNotificationEvent:FireClient(killedPlayer, "You were killed by " .. killerPlayer.Name)
                        killNotificationEvent:FireClient(killerPlayer, "You killed " .. killedPlayer.Name)
					end
				else
					print(character.Name .. " died.")
				end
			end
		end

		-- ĳ���Ͱ� �ǰݵ� �� ȣ��Ǵ� �Լ�
		local function onHumanoidTouched(hit)
			local attacker = hit.Parent
			if attacker and attacker:FindFirstChildOfClass("Humanoid") then
				local player = Players:GetPlayerFromCharacter(attacker)
				if player then
					lastAttacker = player
				end
			end
		end

		-- HealthChanged �̺�Ʈ�� �Լ� ����
		humanoid.HealthChanged:Connect(onHealthChanged)

		-- ĳ���Ͱ� �ǰݵ� �� ȣ��Ǵ� �Լ� ����
		humanoid.Touched:Connect(onHumanoidTouched)
	end
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(onCharacterAdded)

	if player.Character then
		onCharacterAdded(player.Character)
	end
end

--[[�̺�Ʈ ������ ���Ӽ�
	onPlayerAdded �Լ��� ���ο� �÷��̾ ������ ������ ȣ��Ǹ�, �ش� �÷��̾��� CharacterAdded �̺�Ʈ�� ���� ������ �����մϴ�. 
	�� �̺�Ʈ ������ �� �� �����Ǹ� ���������� �����˴ϴ�. ��, �÷��̾ ������ ������ �ʴ� ��, �÷��̾��� ĳ���Ͱ� �߰��� ������ 
	onCharacterAdded �Լ��� ����ؼ� ȣ��˴ϴ�.
	�� �̺�Ʈ ���� ����� �κ�Ͻ����� �ſ� �Ϲ����� ��������, �̺�Ʈ�� �� �� �����ϸ� �ش� �̺�Ʈ�� �߻��� ������ ������ �ݹ� �Լ��� ȣ��ǵ��� �մϴ�. 
	�̸� ���� Ư�� ������ ������ ������ ���ϴ� �ڵ带 ������ �� �ֽ��ϴ�.
	]]
Players.PlayerAdded:Connect(onPlayerAdded)

-- �̹� �ִ� �÷��̾�鿡 ���ؼ��� ����
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
