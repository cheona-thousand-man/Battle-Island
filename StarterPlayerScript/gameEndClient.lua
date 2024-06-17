local ReplicatedStorage = game:GetService("ReplicatedStorage")
local gameEndNoticeEvent = ReplicatedStorage.Event:FindFirstChild("FZgameEndNotice")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ���� ���� �� ����/����Ʈ�� ���� ���� �˸� UI
local function gameEndNoticeGui(message)
	wait(3)
	
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:FindFirstChild("Head")
	
	-- �˸� ������GUI ����
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(10, 0, 3, 0) -- �ʺ�� ���̸� ����
	billboardGui.StudsOffset = Vector3.new(0, 3, 0) -- ĳ���� �Ӹ� ���� ������
	billboardGui.Adornee = rootPart
	billboardGui.Parent = rootPart

	-- ���� ���� �˸�
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0.5, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextSize = 20 -- �ؽ�Ʈ ũ�� �ڵ� ����
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Text = message
	textLabel.Parent = billboardGui

	-- ���� ���� �˸�
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, 0, 0.5, 0)
	textLabel2.Position = UDim2.new(0, 0, 0.3, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextSize = 20 -- �ؽ�Ʈ ũ�� �ڵ� ����
	textLabel2.TextColor3 = Color3.new(1, 1, 1)
	textLabel2.Text = "Now you can enter Fight Zone. Welcome Warriors LoL"
	textLabel2.Parent = billboardGui
	
	print("game end notice")
	print(message .. " + " .. textLabel2.Text)
	
	wait(3)
	billboardGui:Destroy()
end

-- ���� ���� �� �÷��̾� Gui�� ���� ǥ��
gameEndNoticeEvent.OnClientEvent:Connect(gameEndNoticeGui)
