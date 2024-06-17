local gameManagePart = script.Parent

-- �÷��̾ ����Ʈ���� �����ϸ� ���� ����(wait �� enterFZ)�ϴ� �Լ�
local function playerEnterCheck(otherPart)
	local player = game.Players:GetPlayerFromCharacter(otherPart.Parent) -- otherPart.Parent�� ������ ��Ʈ�� ���� ĳ����
	if player then
		-- �÷��̾� ����Ʈ�� ���� �� ��������(Workspace.onlinePlayer)�� �ִ� �÷��̾� ����(onlineState) ����(�� enterFZ)
		local onlineState = game:GetService("Workspace").onlinePlayer:WaitForChild(player.Name)
		onlineState.Value = "enterFZ"
	end
end

-- �÷��̾ ��ġ�ϸ� �÷��̾� ����Ʈ�� ���� ���·� ����
gameManagePart.Touched:Connect(playerEnterCheck)