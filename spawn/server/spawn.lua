local package_name = GetPackageName()
local pprint = require( ( 'packages/%s/utils/server/pprint' ):format( GetPackageName() ) )

local shirtsModel = {
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt2_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted2_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_LPR",
}

local pantsModel = {
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_DenimPants_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"
}

local shoesModel = {
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR",
    "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"
}

local hairsModel = {
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP",
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Scientist_LP",
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR",
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR",
    "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_02_LPR"
}

local hairsColor = {
    { 250, 240, 190, 1 },
    { 0, 0, 0, 1 },
    { 255, 0, 0, 1 },
    { 139, 69, 19, 1 }
}

local spawnManager = {}

function spawnManager.setPlayerDimensionSpawn( player )
    SetPlayerDimension(player, BR.Config.DIMENSION_SPAWN)
    SetPlayerVoiceDimension(player, BR.Config.DIMENSION_SPAWN)
end

function spawnManager.OnPlayerJoin( player )
    spawnManager.setPlayerDimensionSpawn( player )
    
    SetPlayerSpawnLocation(player, 207078.484375, 192689.109375, 1306.94921875, 175.41589355469 )
    
	AddPlayerChat(player, '<span style="bold" size="14">============================</>')
	AddPlayerChat(player, '<span style="bold" size="14">Welcome to BattleRoyal (in development).</>')
	AddPlayerChat(player, 'You need to be at least '..BR.Config.MIN_PLAYERS..' players to start a new battle royal.')
	AddPlayerChat(player, '<span color="#f4f142ff" style="bold" size="14">Wait for the next game</>.')
    AddPlayerChat(player, '<span style="bold" size="14">============================</>')
end

function spawnManager.OnPlayerSpawn( player )
    SetPlayerWeapon(player, 12, 90, true, 1, true)
    SetPlayerWeapon(player, 7, 30, true, 2, true)
    
    spawnManager.randomPlayerClothes(player, player)
end

-- https://github.com/frederic2ec/onsetrp/blob/master/character/client.lua
function spawnManager.randomPlayerClothes(player, targetPlayer)
    local hairsColor = hairsColor[Random(1, 4)]
    CallRemoteEvent(player, "ClientChangeClothing", targetPlayer, 0, hairsModel[Random(1, 5)], hairsColor[1], hairsColor[2], hairsColor[3], hairsColor[4])
    CallRemoteEvent(player, "ClientChangeClothing", targetPlayer, 1, shirtsModel[Random(1, 6)], 0, 0, 0, 0)
    CallRemoteEvent(player, "ClientChangeClothing", targetPlayer, 4, pantsModel[Random(1, 3)], 0, 0, 0, 0)
    CallRemoteEvent(player, "ClientChangeClothing", targetPlayer, 5, shoesModel[Random(1, 2)], 0, 0, 0, 0)
end

function spawnManager.init()
    AddEvent("OnPlayerJoin", spawnManager.OnPlayerJoin)
    AddEvent("OnPlayerSpawn", spawnManager.OnPlayerSpawn)
end

AddFunctionExport( 'init', spawnManager.init )
AddFunctionExport( 'setPlayerDimensionSpawn', spawnManager.setPlayerDimensionSpawn )

return spawnManager
