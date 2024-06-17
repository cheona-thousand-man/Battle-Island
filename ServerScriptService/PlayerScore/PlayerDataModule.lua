local DataStoreService = game:GetService("DataStoreService")
local playerStore = DataStoreService:GetDataStore("PlayerScore")

local PlayerDataModule = {}

function PlayerDataModule.GetPlayerScore(playerUserId)
	local success, data = pcall(function()
		return playerStore:GetAsync(playerUserId) 
	end)
	
	if success then 
		return data
	else
		warn("Failed to get player data:", data)
		return nil
	end
end

function PlayerDataModule.SetPlayerScore(playerUserId, playerScore)
	local success, errorMessage = pcall(function() 
		playerStore:SetAsync(playerUserId, playerScore)	
	end)
	
	if not success then
		warn("Failed to set player data:", errorMessage)
	else
		print("Success to save player data")
	end
end

return PlayerDataModule