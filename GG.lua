local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/diepedyt/bui/main/arrayfield(rayfield)Modified.lua'))()

---------

_G.NowLoaded = false

local Window = Rayfield:CreateWindow({
	Name = "Banana Hub | Click Simulator",
	LoadingTitle = "Click Simulator",
	LoadingSubtitle = "by Vernyfr (discord)",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Banana Hub", -- Create a custom folder for your hub/game
		FileName = "CS"..game.Players.LocalPlayer.Name
	},
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Sirius Hub",
		Subtitle = "Key System",
		Note = "Join the discord (discord.gg/sirius)",
		FileName = "SiriusKey",
		SaveKey = true,
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = "Hello"
	}
})

_G.Theme = "Yellow"

if not LPH_OBFUSCATED then 
    LPH_JIT_ULTRA = function(...) return (...) end;
    LPH_JIT_MAX = function(...) return (...) end;
    LPH_NO_VIRTUALIZE = function(...) return (...) end;
end

local Toggles = {}
_G.SF = {}
_G.AreaDropdowns = {}
local insertedNumbers = {}
function createOptimisedToggle(Tab, Name, ValueName, DoFunction, DontSpawn, DoAfterDestroy)
    if true then
        local ToggleNum = #Toggles + 1
        table.insert(Toggles, ToggleNum)
        local randomNum = 0
        repeat
            randomNum = math.random(55,22222)
            task.wait(.01)
        until not table.find(insertedNumbers, randomNum)
        table.insert(insertedNumbers, randomNum)
        --_G.SF[randomNum] = false
        return Tab:CreateToggle({
            Name = Name,
            CurrentValue = _G.Settings[ValueName],
            Flag = "Toggle"..ValueName,
            Callback = function(Value)
                _G.Settings[ValueName] = Value

                if not _G.SF[randomNum] and _G.Settings[ValueName] then
                    _G.SF[randomNum] = true
                    if not DontSpawn then
                        local ab = task.spawn(DoFunction)
                        --warn("SPAWNED FUNCTION")
                        repeat task.wait(.1) until not _G.Settings[ValueName]
                        task.cancel(ab)
                        _G.SF[randomNum] = false
                        --warn("REMOVED FUNCTION")
                        if DoAfterDestroy then
                            task.spawn(DoAfterDestroy)
                        end
                    end
                end

            end
        })
    end
end


local LP = game.Players.LocalPlayer

function getStudLength(target, fromCFrame)
    if game.Players.LocalPlayer.Character and target then
        distanceInStuds = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - target.Position).Magnitude
    end
    if fromCFrame and target then   
        distanceInStuds = (fromCFrame.Position - target.Position).Magnitude
    end
    return distanceInStuds
end

local function SaveTableRequest(TableName, Request, Table)
    if Request == "Update" then
        if isfile and writefile then
            writefile("VernyHub/"..game.PlaceId..TableName..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(Table))
            return true
        end
    elseif Request == "Get" then
        local table = {}
        if isfile and readfile and isfile("VernyHub/"..game.PlaceId..TableName..game.Players.LocalPlayer.Name..".json") then
            table = game:GetService("HttpService"):JSONDecode(readfile("VernyHub/"..game.PlaceId..TableName..game.Players.LocalPlayer.Name..".json"))
        end
        return table
    end
end

local function InsertOptionsTable(GivenTable, Option)
    if not table.find(GivenTable, Option) then
        table.insert(GivenTable, Option)
    else
        local ItemToRemove = table.find(GivenTable, Option)
        table.remove(GivenTable, ItemToRemove)
    end
    return GivenTable
end

local function createMultiSelectDropdown(Tab, SaveName, TableName, SelectedThing, Options)
    
    _G.Settings[TableName] = SaveTableRequest(SaveName,"Get")
    print(_G.Settings[TableName], TableName)

    local Label = Tab:CreateLabel("Selected "..SelectedThing..": "..table.concat(_G.Settings[TableName],", "))
    
    Tab:CreateButton({
        Name = "Reset List",
        Interact = 'Reset',
        Callback = function()
            _G.Settings[TableName] = {}
            SaveTableRequest(SaveName, "Update", _G.Settings[TableName])
            Label:Set("Selected "..SelectedThing..": "..table.concat(_G.Settings[TableName],", "))
        end
    })

    local drop = Tab:CreateDropdown({
        Name = "Select / Remove "..SelectedThing,
        Options = Options,
        CurrentOption = "None",
        Flag = SaveName.."MultiDrop",
        Callback = function(Option)
            if _G.NowLoaded then
                _G.Settings[TableName] = InsertOptionsTable(_G.Settings[TableName], Option)
                SaveTableRequest(SaveName,"Update",_G.Settings[TableName])
                Label:Set("Selected "..SelectedThing..": "..table.concat(_G.Settings[TableName],", "))
            end
        end
    })

    Tab:CreateButton({
        Name = "Select All",
        Interact = 'Reset',
        Callback = function()
            _G.Settings[TableName] = Options
            SaveTableRequest(SaveName, "Update", _G.Settings[TableName])
            Label:Set("Selected "..SelectedThing..": "..table.concat(_G.Settings[TableName],", "))
        end
    })

    return {Label, drop}

end

local function CanDoPriority(Action)

    local function doingThing(thing)
        if thing == "Dungeon" then
            return true
        elseif thing == "PickUpItems" then
            return _G.PickingUp
        end
    end

    local function leaveNotDoing(thing)
        if thing == "Dungeon" then
        elseif thing == "PickUpItems" then
        end
    end

    table.sort(_G.Settings.Priorities, function(a, b)
        return Priorities[a] > Priorities[b]
    end)

    local highestAction = nil
    local highestPriority = 0
    for i,v in pairs(_G.Settings.Priorities) do
        if v > highestPriority then
            highestAction = i
            highestPriority = v
        end
    end

    local actionsOverAction = {}
    for i,v in pairs(_G.Settings.Priorities) do
        if v > _G.Settings.Priorities[Action] then
            table.insert(actionsOverAction, i)
        end

    end

    if Action == highestAction then
        coroutine.resume(coroutine.create(function()
            task.wait(5)
            if doingThing(Action) then
                for i,v in pairs(_G.Settings.Priorities) do
                    if i ~= Action then
                        ----warn(i, Action)
                        leaveNotDoing(i)
                    end
                end
            end
        end))
        return true
    end


    for i,v in pairs(_G.Settings.Priorities) do
        if table.find(actionsOverAction, i) and doingThing(i) then
            return false
        end
    end

    coroutine.resume(coroutine.create(function()
        task.wait(5)
        if doingThing(Action) then
            for i,v in pairs(_G.Settings.Priorities) do
                if i ~= Action then
                    ----warn(i, Action)
                    leaveNotDoing(i)
                end
            end
        end
    end))
    return true

end

_G.Settings = {
    -- Priorities
    Priorities = {
        ["Dungeon"] = 1,
        ["PickUpItems"] = 2,
    },
    -- Main
    AutoClick = false,
    AutoRebirth = false,
    AutoClaimGifts = false,
    AutoClaimLuckyGifts = false,
    SelectedOpenAmount = "",
    SelectedEgg = "",
    AutoOpenEgg = false,
    SelectedPetsToGolden = {},
    AutoGoldenSelectedPets = {},
    AutoClaimQuests = false,
    SetWorldMultiplier = false,
    SelectedMultiWorld = "",
}

-- Locals

local VirtualInputManager = game:GetService("VirtualInputManager")

local MX,MY = 500,500

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

-- Functions

local function Click()
    game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.Click:InvokeServer()
end

local function ClaimClickReward()
    game:GetService("ReplicatedStorage").Packages.Knit.Services.ClickService.RF.RedeemClickReward:InvokeServer()
end

local function RedeemTimeReward(Number)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.GiftsService.RF.RequestRedeemGift:InvokeServer(Number)
end

local function RequestRebirth()
    local ohInstance1 = game:GetService("Players").LocalPlayer

    game:GetService("ReplicatedStorage").Packages.Knit.Services.RebirthService.RF.RequestRebirth:InvokeServer(ohInstance1)
end

local function ClaimQuest(Type,Number)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.TasksService.RF.ClaimReward:InvokeServer(Type, Number)
end

local function ClaimGems(Map)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.GemCollectorService.RF.RequestCollect:InvokeServer(Map)
end

local function ClaimTapRewards(Number)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.TapPassService.RF.requestTapRewardClaim:InvokeServer(Number)
end

local function UseItem(Item)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.ItemsService.RF.RequestUseItem:InvokeServer(Item)
end

local function OpenEgg(Egg,Amount)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.EggService.RF.OpenEgg:InvokeServer(Egg, Amount)
end

local function UpgradeStat(Stat)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.UpgradesService.RF.RequestUpgrade:InvokeServer(Stat)
end

local function RequestTeleport(World,IslandNumber)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.MapService.RF.RequestTeleport:InvokeServer(World, IslandNumber)
end

function SetIslandMultiplier(Island)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.MapService.RF.SetIsland:InvokeServer(Island)
end

function MakeGoldenPet(PetType)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.Golden:InvokeServer(PetType)
end

function LevelPet(PetID,Level)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.RequestLevelUp:InvokeServer(PetID, Level)
end

function ClaimChest()
    game:GetService("ReplicatedStorage").Packages.Knit.Services.RebirthService.RF.RequestRebirthRewards:InvokeServer()
end

function GetData(Type)
    return Knit.GetController("DataController").GetReplica("PlayerData").Data[Type]
end

function ClickScreen(X,Y)
    VirtualInputManager:SendMouseButtonEvent(X, Y, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(X, Y, 0, false, game, 1)
end

-- Tables 

local Eggs = {}

for i,v in pairs(game:GetService("ReplicatedStorage").Assets.Eggs:GetChildren()) do
    table.insert(Eggs,v.Name)
end

local Pets = {}

for i,v in pairs(game:GetService("ReplicatedStorage").Assets.Pets:GetDescendants()) do
    if v:IsA("Model") and v.Parent:IsA("Folder") then
        table.insert(Pets,v.Name)
    end
end

local Worlds = {}

for i,v in pairs(workspace.Islands:GetChildren()) do
    table.insert(Worlds,v.Name)
end

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Main",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements


createOptimisedToggle(Tab,"Auto Click", "AutoClick",
function()
    while task.wait() do

        Click() -- Click Function

        task.wait(.01)

    end
end)

createOptimisedToggle(Tab,"Auto Rebirth", "AutoRebirth",
function()
    while task.wait() do

        RequestRebirth() -- Rebirth Function

        task.wait(1)

    end
end)

local Section = Tab:CreateSection("Misc",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createOptimisedToggle(Tab,"Auto Claim Gifts", "AutoClaimGifts",
function()
    while task.wait() do

        for i= 1,12 do
        
            RedeemTimeReward(i)
            task.wait(.25)
        end

        task.wait(1)

    end
end)

createOptimisedToggle(Tab,"Auto Claim Lucky Gifts", "AutoClaimLuckyGifts",
function()
    while task.wait() do

        if game:GetService("Players").LocalPlayer.PlayerGui.LuckyGift.Enabled then
            
            ClickScreen(MX,MY)

            task.wait(1)

        end

    end
end)

local Tab = Window:CreateTab("Eggs", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Select",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

local Dropdown = Tab:CreateDropdown({
    Name = "Select Egg",
    Options = Eggs,
    CurrentOption = "",
    Multi = false, -- If MultiSelections is allowed
    Flag = "SelectedEgg", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        _G.Settings.SelectedEgg = Option
    end,
})

local Dropdown = Tab:CreateDropdown({
    Name = "Select Open Amount",
    Options = {"Single","Triple"},
    CurrentOption = "",
    Multi = false, -- If MultiSelections is allowed
    Flag = "SelectedOpenAmount", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        _G.Settings.SelectedOpenAmount = Option
    end,
})

local Section = Tab:CreateSection("Main",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createOptimisedToggle(Tab,"Auto Open Selected Egg (Fast)", "AutoOpenEgg",
function()
    while task.wait() do

        OpenEgg(_G.Settings.SelectedEgg, _G.Settings.SelectedOpenAmount)
        task.wait(.25)

    end
end)

local Tab = Window:CreateTab("Pets", 4483362458) -- Title, Image

local Section = Tab:CreateSection("Golden",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createMultiSelectDropdown(Tab,"SelectedPetsToGolden","SelectedPetsToGolden", "Pets To Golden",Pets)

createOptimisedToggle(Tab,"Auto Golden Selected Pets", "AutoGoldenSelectedPets",
function()
    while task.wait() do

        for _,Pet in pairs(_G.Settings.SelectedPetsToGolden) do
        
            MakeGoldenPet(Pet)
            task.wait(.25)

        end

        task.wait(.25)

    end
end)

local Tab = Window:CreateTab("Misc", 4483362458) -- Title, Image

createOptimisedToggle(Tab,"Auto Claim Quests", "AutoClaimQuests",
function()
    while task.wait() do

        for a,v in pairs(GetData("tasks")) do
        
            for Quest,_ in pairs(v) do
            
                ClaimQuest(v,Quest)

                task.wait()
            end

        end

    end
end)


local WorldsDrop = Tab:CreateDropdown({
    Name = "Select World",
    Options = Worlds,
    CurrentOption = "",
    Multi = false, -- If MultiSelections is allowed
    Flag = "SelectedMultiWorld", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        _G.Settings.SelectedMultiWorld = Option
    end,
})

Tab:CreateButton({
    Name = "Refresh Worlds",
    Interact = 'Refresh',
    Callback = function()
        local Worlds2 = {}

        for i,v in pairs(workspace.Islands:GetChildren()) do
            table.insert(Worlds2,v.Name)
        end

        WorldsDrop:Refresh(Worlds2,"Select a World")
    end
})


createOptimisedToggle(Tab,"Set World Multiplier", "SetWorldMultiplier",
function()
    while task.wait() do



    end
end)

Rayfield:LoadConfiguration()
task.wait(2)
_G.NowLoaded = true


-- Anti Afk
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
wait(1)
vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
game.Players.LocalPlayer.AttributeChanged:Connect(function(n)
    if n == "Idle" then
        game.Players.LocalPlayer:SetAttribute("Idle", false)
    end
end)

warn("Loaded")

-- loadstring(game:HttpGet('https://raw.githubusercontent.com/Vernyfx/test/main/GG.lua'))()
