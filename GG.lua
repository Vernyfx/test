local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Vernyfx/Arrayfield/main/Modified.lua'))()

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
    SelectedUpgrades = {},
    AutoBuySelectedUpgrades = false,
    AutoClaimTapPassLevels = false,
    AutoBuyDailySpins = false,
    AutoUseSpins = false,
    SelectedBoosts = {},
    AutoUseBoosts = false,
    AutoCollectGemGenerator = false,
    SelectedPetsToLevel = {},
    AutoLevelSelectedPets = false,
    PetsUsedForRainbow = 1,
    AutoRainbowSelectedPets = false,
    SelectedPetsToRainbow = {},
    WebhookWaitMin = 1,
    AutoSendWebhook = false,
    WebhookURL = "",
    AutoSendWebhookPets = false,
    SelectedPetsWebhook = {},

}

-- Locals

local VirtualInputManager = game:GetService("VirtualInputManager")

local MX,MY = 500,500

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local PetFrame = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("PetInventory"):WaitForChild("Frame"):WaitForChild("ScrollingFrame")

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

local function BuyDailySpins(Number)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.SpinWheelService.RF.RequestBuySpins:InvokeServer(Number)
end

local function UseSpin()
    game:GetService("ReplicatedStorage").Packages.Knit.Services.SpinWheelService.RF.RequestSpin:InvokeServer()
end

local function CheckShiny(IsShiny)
    if IsShiny then
        return "Yes"
    else
        return "No"
    end
end

function SetIslandMultiplier(Island)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.MapService.RF.SetIsland:InvokeServer(Island)
end

function MakeGoldenPet(PetType)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.Golden:InvokeServer(PetType)
end

function MakeRainbowPet(PetsTable)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.PetService.RF.Rainbow:InvokeServer(PetsTable)
end

function MakeRadiantPet(PetsTable)
    game:GetService("ReplicatedStorage").Packages.Knit.Services.RadiantService.RF.requestRadiantPetSlot:InvokeServer(PetsTable)
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

local TaskTypes = {"Islands","Eggs","Unique Pets","Rebirth","Coins"}

local Upgrades = {}

for i,v in pairs(GetData("upgrades")) do
    table.insert(Upgrades,i)
end

local Boosts = {"Triple Coins Vial","Good Luck Vial","Ultra Luck Vial"}

local BoostsName = {
    ["Triple Coins Vial"] = "Triple Coins",
    ["Good Luck Vial"] = "Good Luck",
    ["Ultra Luck Vial"] = "Ultra Luck",
}


local Tab = Window:CreateTab("Main", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Main",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements


createOptimisedToggle(Tab,"Auto Click (Fast With Free Auto Click)", "AutoClick",
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

local Tab = Window:CreateTab("Eggs", 11642692687) -- Title, Image

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

local Tab = Window:CreateTab("Pets", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Level",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createMultiSelectDropdown(Tab,"SelectedPetsToLevel","SelectedPetsToLevel", "Pets To Level Up",Pets)


createOptimisedToggle(Tab,"Auto Level Up Selected Pets", "AutoLevelSelectedPets",
function()
    while task.wait() do

        for i,Name in pairs(_G.Settings.SelectedPetsToLevel) do
        
            for _,Pet in pairs(GetData("pets")) do

                if Pet.Name == Name then

                    LevelPet(Pet.id,Pet.Level + 1)
                    task.wait(.05)

                end

            end

        end

        task.wait(.25)

    end
end)

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

local Section = Tab:CreateSection("Rainbow",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createMultiSelectDropdown(Tab,"SelectedPetsToRainbow","SelectedPetsToRainbow", "Pets To Rainbow",Pets)

local Slider = Tab:CreateSlider({
   Name = "Pets To Use For Rainbow",
   Range = {1, 5},
   Increment = 1,
   Suffix = "Pets",
   CurrentValue = 5,
   Flag = "PetsUsedForRainbow",
   Callback = function(Value)
      _G.Settings.PetsUsedForRainbow = Value
   end,
})

_G.RainbowPetsTable = {}

createOptimisedToggle(Tab,"Auto Rainbow Selected Pets", "AutoRainbowSelectedPets",
function()
    while task.wait() do

        for i,Name in pairs(_G.Settings.SelectedPetsToRainbow) do
        
            for _,Pet in pairs(GetData("pets")) do

                if Pet.Name == Name and Pet.Modifier ~= "Rainbow" and Pet.Modifier ~= "Radiant" then

                    task.wait(.5)

                    repeat
                        table.insert(_G.RainbowPetsTable,Pet.id)
                        task.wait(.2)
                    until #_G.RainbowPetsTable >= _G.Settings.PetsUsedForRainbow or not _G.Settings.AutoRainbowSelectedPets
                    
                    task.wait(.5)
                    MakeRainbowPet(_G.RainbowPetsTable)
                    task.wait(.25)
                    table.clear(_G.RainbowPetsTable)
                    task.wait(.25)

                end

            end

        end

        task.wait(1)

    end
end)

local Tab = Window:CreateTab("Upgrades", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Main",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createMultiSelectDropdown(Tab,"SelectedUpgrades","SelectedUpgrades", "Upgrades",Upgrades)

createOptimisedToggle(Tab,"Auto Buy Selected Upgrades", "AutoBuySelectedUpgrades",
function()
    while task.wait() do

        for _,Upgrade in pairs(_G.Settings.SelectedUpgrades) do
        
            UpgradeStat(Upgrade)
            task.wait(1)

        end

    end
end)

local Tab = Window:CreateTab("Items", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Boosts",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createMultiSelectDropdown(Tab,"SelectedBoosts","SelectedBoosts", "Boosts",Boosts)

createOptimisedToggle(Tab,"Auto Use Boosts If Ran Out", "AutoUseBoosts",
function()
    while task.wait() do

        for _,Boost in pairs(_G.Settings.SelectedBoosts) do
        
            if not game:GetService("Players").LocalPlayer.PlayerGui.Boosts.Frame:FindFirstChild(BoostsName[Boost]) then

                UseItem(Boost)
                task.wait(1)

            end

        end

    end
end)

local Tab = Window:CreateTab("Misc", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Quests",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createOptimisedToggle(Tab,"Auto Claim Quests", "AutoClaimQuests",
function()
    while task.wait() do

        for a,b in pairs(TaskTypes) do
        
            for i,v in pairs(GetData("tasks")[b]) do
                
                game:GetService("ReplicatedStorage").Packages.Knit.Services.TasksService.RF.ClaimReward:InvokeServer(b,i)
                task.wait()

            end

        end

    end
end)

local Section = Tab:CreateSection("OP",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

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


createOptimisedToggle(Tab,"Set World Multiplier From Anywhere (Any World)", "SetWorldMultiplier",
function()
    while task.wait() do

        game:GetService("ReplicatedStorage").Packages.Knit.Services.MapService.RF.SetIsland:InvokeServer(_G.Settings.SelectedMultiWorld)
        task.wait(1)

    end
end)

local Section = Tab:CreateSection("Pass",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createOptimisedToggle(Tab,"Auto Claim Tap Pass Levels", "AutoClaimTapPassLevels",
function()
    while task.wait() do

        for i= GetData("tapPassLevel"), 21 do

            ClaimTapRewards(i)
            task.wait(.025)

        end

    end
end)

local Section = Tab:CreateSection("Spins",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createOptimisedToggle(Tab,"Auto Buy Daily Spins", "AutoBuyDailySpins",
function()
    while task.wait() do

        for i= 1,3 do

            BuyDailySpins(i)
            task.wait(.25)

        end

        task.wait(2.5)

    end
end)

createOptimisedToggle(Tab,"Auto Use Spins", "AutoUseSpins",
function()
    while task.wait() do

        UseSpin()

        task.wait(5)

    end
end)

local Section = Tab:CreateSection("Others",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createOptimisedToggle(Tab,"Auto Collect Gem Generator When Max", "AutoCollectGemGenerator",
function()
    while task.wait() do

        if game:GetService("Players").LocalPlayer.PlayerGui.GemCollector.Frame.Timer.Text:find("00:00:00") then

            ClaimGems("Earth")
            task.wait(1)

        end

    end
end)

local Tab = Window:CreateTab("Webhook", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Select",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

_G.Settings.WebhookURL = SaveTableRequest("WebhookURL","Get")
if type(_G.Settings.WebhookURL) == "table" then
    _G.Settings.WebhookURL = ""
end

local WebhookURLLabel = Tab:CreateLabel("Webhook URL: ".._G.Settings.WebhookURL)

Tab:CreateInput({
    Name = "Enter your Webhook URL",
    PlaceholderText = "link",
    NumbersOnly = false, -- If the user can only type numbers.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        Text = tostring(Text)
        _G.Settings.WebhookURL = Text
        SaveTableRequest("WebhookURL","Update",_G.Settings.WebhookURL)
        WebhookURLLabel:Set("Webhook URL: ".._G.Settings.WebhookURL)
    end
})

 local Slider = Tab:CreateSlider({
    Name = "Time To Wait Each Webhook",
    Range = {1, 60},
    Increment = 1,
    Suffix = "Minutes",
    CurrentValue = 3,
    Flag = "WebhookWaitMin", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.WebhookWaitMin = Value
    end,
})

createOptimisedToggle(Tab,"Auto Send Webhook", "AutoSendWebhook",
function()
    while task.wait() do
        if _G.Settings.WebhookURL ~= "" then

            local text = {

                "Coins: " ..  game:GetService("Players").LocalPlayer.leaderstats.Coins.Value,
                "Gems: " ..  game:GetService("Players").LocalPlayer.leaderstats.Gems.Value,
                "Pet Power: " ..  game:GetService("Players").LocalPlayer.leaderstats["Pet Power"].Value,
                "Rank: " ..  workspace[game.Players.LocalPlayer.Name].HumanoidRootPart.NameTag.DataHolder.Rank.Text,
                "Tap Pass Level: " ..  GetData("tapPassLevel"),
                "Gem Generator " ..  game:GetService("Players").LocalPlayer.PlayerGui.GemCollector.Frame.Timer.Text,
                
            }

            HttpService = game:GetService("HttpService")
            Webhook_URL = _G.Settings.WebhookURL

            local responce = request(
                {

                    Url = Webhook_URL,
                    Method = "POST",
                    Headers = {
                    ["Content-Type"] = "application/json"
                    },
                    Body = HttpService:JSONEncode({
                    ["content"] = "",
                    ["embeds"] = {{
                        ["title"] = "**Game: Click Simulator **",
                        ["type"] = "rich",
                        ["color"] = tonumber(0xffffff),
                        ["fields"] = {
                            {
                                ["name"] = "**Results: **",
                                ["value"] = table.concat(text,'\n'),
                                ["inline"] = true
                            }
                        }
                    }}
                    })
                }
                )
            task.wait(_G.Settings.WebhookWaitMin * 60) 
        end
    end
end)

createMultiSelectDropdown(Tab,"SelectedPetsWebhook","SelectedPetsWebhook", "Pets",Pets)



local Toggle = Tab:CreateToggle({
    Name = "Auto Send Webhook When New Pet",
    CurrentValue = false,
    Flag = "AutoSendWebhookPets", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        _G.Settings.AutoSendWebhookPets = Value
    end,
})

local PetsInventory = {}

for i,v in pairs(GetData("pets")) do
    if not table.find(PetsInventory,v.id) then
        table.insert(PetsInventory,v.id)
        task.wait()
    end
end

task.spawn(function()
    if not _G.Settings.AutoSendWebhookPets then
        repeat
            task.wait()
        until _G.Settings.AutoSendWebhookPets
        while task.wait(.25) do
            for i,v in pairs(GetData("pets")) do
                if not table.find(PetsInventory,v.id) then
                -- Send Webhook

                local PetInfo = {

                    "Name: " .. v.Name,
                    "Type: " .. v.Modifier,
                    "Shiny? " .. CheckShiny(v.Shiny),
                    "Temperament: " .. v.Temperament,
                    "Multiplier: " .. PetFrame[v.id].Inner.multiplier.Text,

                }

                HttpService = game:GetService("HttpService")
                Webhook_URL = _G.Settings.WebhookURL

                local responce = request({
                    Url = Webhook_URL,
                        Method = "POST",
                        Headers = {
                        ["Content-Type"] = "application/json"
                        },
                        Body = HttpService:JSONEncode({
                        ["content"] = "",
                        ["embeds"] = {{
                            ["title"] = "** Click Simulator **",
                            ["type"] = "rich",
                            ["color"] = tonumber(0xffffff),
                            ["fields"] = {{
                                    ["name"] = "**New Pet**",
                                    ["value"] = table.concat(PetInfo),
                                    ["inline"] = true
                            }}
                        }}
                    })
                })

                table.clear(PetsInventory)

                task.wait(.1)

                for i,v in pairs(GetData("pets")) do
                    if not table.find(PetsInventory,v.id) then
                        table.insert(PetsInventory,v.id)
                        task.wait()
                    end
                end

                end
            end
            task.wait(.25)
        end
    else
        while task.wait(.25) do
            for i,v in pairs(GetData("pets")) do
                if not table.find(PetsInventory,v.id) then
                -- Send Webhook

                local PetInfo = {

                    "Name: " .. v.Name,
                    "Type: " .. v.Modifier,
                    "Shiny? " .. CheckShiny(v.Shiny),
                    "Temperament: " .. v.Temperament,
                    "Multiplier: " .. PetFrame[v.id].Inner.multiplier.Text,

                }

                HttpService = game:GetService("HttpService")
                Webhook_URL = _G.Settings.WebhookURL

                local responce = request({
                    Url = Webhook_URL,
                        Method = "POST",
                        Headers = {
                        ["Content-Type"] = "application/json"
                        },
                        Body = HttpService:JSONEncode({
                        ["content"] = "",
                        ["embeds"] = {{
                            ["title"] = "** Click Simulator **",
                            ["type"] = "rich",
                            ["color"] = tonumber(0xffffff),
                            ["fields"] = {{
                                    ["name"] = "**New Pet**",
                                    ["value"] = table.concat(PetInfo),
                                    ["inline"] = true
                            }}
                        }}
                    })
                })

                table.clear(PetsInventory)

                task.wait(.1)

                for i,v in pairs(GetData("pets")) do
                    if not table.find(PetsInventory,v.id) then
                        table.insert(PetsInventory,v.id)
                        task.wait()
                    end
                end

                end
            end
            task.wait(.25)
        end
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
