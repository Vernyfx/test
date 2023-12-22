local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Vernyfx/Arrayfield/main/Modified.lua'))()

---------

_G.NowLoaded = false

local Window = Rayfield:CreateWindow({
	Name = "Banana Hub | Anime Souls X",
	LoadingTitle = "Anime Souls X",
	LoadingSubtitle = "by Vernyfr (discord)",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Banana Hub", -- Create a custom folder for your hub/game
		FileName = "ASX"..game.Players.LocalPlayer.Name
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


if not isfolder("Banana Hub") then
    makefolder("Banana Hub")
end


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

local function GetG(Setting)
    return _G.Settings[Setting]
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
            writefile("Banana Hub/"..game.PlaceId..TableName..game.Players.LocalPlayer.Name..".json",game:GetService("HttpService"):JSONEncode(Table))
            return true
        end
    elseif Request == "Get" then
        local table = {}
        if isfile and readfile and isfile("Banana Hub/"..game.PlaceId..TableName..game.Players.LocalPlayer.Name..".json") then
            table = game:GetService("HttpService"):JSONDecode(readfile("Banana Hub/"..game.PlaceId..TableName..game.Players.LocalPlayer.Name..".json"))
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
        if thing == "Farm" then
            return true
        elseif thing == "TimeTrial" then
            return _G.InTrial
        elseif thing == "Raid" then
            return _G.InRaid
        end
    end

    local function leaveNotDoing(thing)
        if thing == "Farm" then
        elseif thing == "TimeTrial" then
        elseif thing == "Raid" then
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



function Notify(Title,Content,Duration,DoFunction,ButtonTitle,Function)
    Rayfield:Notify({
        Title = Title,
        Content = Content,
        Duration = tonumber(Duration),
        Image = 4483362458,
        Actions = { -- Notification Buttons
            Ignore = {
                Name = ButtonTitle,
                Callback = function()
                    if DoFunction then
                        task.spawn(Function)
                    else
                        print("Ok")
                    end
                end
            },
        },
    })
end


function WriteFileMacroName(FolderName,FileName)
    if not isfile(MainFolderName .."/" .. FolderName.."/"..FileName..".json") then
        writefile(MainFolderName .."/" .. FolderName.."/"..FileName..".json","[]")
    end
end

function WriteFileMacro(FolderName,FileName,Content)
    if not isfile(MainFolderName .."/" .. FolderName.."/"..FileName..".json") then
        writefile(MainFolderName .."/" .. FolderName.."/"..FileName..".json",Content)
    end
end

function MakeFolderMacroName(FolderName)
    if not isfolder(MainFolderName .."/" .. FolderName) then
        makefolder(MainFolderName .."/" .. FolderName)
    end
end

 

_G.Settings = {
    Priorities = {
        ["Farm"] = 1,
        ["Trial"] = 2,
        ["Raid"] = 3,
    },
    -- Main
    SelectedMap = "",
    AutoFarmSelectedEnemies = "",
    SelectedEnemies = {},
    AutoClick = false,
    SelectedEggAmount = "",
    SelectedEgg = "",
    AutoEquipBestPets = false,
    AutoOpenSelectedEgg = false,
    AutoDungeon = false,
    SelectedDungeons = {},
    SelectedEasyRoomLeave = 25,
    SelectedMapToGoBack = "",

}

-- Locals
 
_G.InTrial = false

_G.InRaid = false

_G.CanClick = true

local DungeonData = game:GetService("ReplicatedStorage")._SERVER.Dungeon

-- Tables

local Dungeons = {"Easy"}

local Worlds = {}
 
for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Data.Areas)) do
    for i,v in pairs(v) do
        if i == "Name" then
            table.insert(Worlds,v)
        end
    end
end


local Enemies = {}

for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Data.Enemies)) do
    for i,v in pairs(v) do
        if i == "Name" then
            table.insert(Enemies,v)
        end
    end
end

local Raids = {}

for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Data.Raid)) do
    table.insert(Raids,i)
end

local Eggs = {}

for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Data.Eggs)) do
    table.insert(Eggs,i)
end

--[[ Module template
    for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Data.Eggs)) do
        -- for i,v in pairs(v) do
            warn(i,v)
        --end
    end
]]

for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Data.Areas)) do
    for i,v in pairs(v) do
        warn(i,v)
    end
end

-- Functions

local function Click()
    local ohTable1 = {
        [1] = {
            [1] = utf8.char(3),
            [2] = "Click",
            [3] = "Execute"
        }
    }

    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(ohTable1)
end

local function HitEnemy(Enemy)
    local ohTable1 = {
        [1] = {
            [1] = utf8.char(3),
            [2] = "Click",
            [3] = "Execute",
            [4] = Enemy

        }
    }

    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(ohTable1)
end

local function OpenChest(Chest,Amount)
    local ohTable1 = {
        [1] = {
            [1] = utf8.char(3),
            [2] = "Pets",
            [3] = "Open",
            [4] = Chest,
            [5] = Amount
        }
    }
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(ohTable1)
end

local function Teleport(Where)
    local ohTable1 = {
        [1] = {
            [1] = utf8.char(3),
            [2] = "Teleport",
            [3] = "To",
            [4] = Where
        }
    }
    game:GetService("ReplicatedStorage").RemoteEvent:FireServer(ohTable1)
end

function GetEnemyId(Name)
    for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Data.Enemies)) do
        if v.Name == Name then
            return i
        end
    end
end

function GetWorldId(World)
    for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Data.Areas)) do
        if v.Name == World then
            return i
        end
    end
end

function TweenFunc1(WhatToTween,Speed,CFrame)
    game:GetService("TweenService"):Create(WhatToTween,TweenInfo.new(tonumber(Speed)),{CFrame = CFrame}):Play()
end

function GetDungeonData(Type,Directory)
    return DungeonData[Type]:GetAttribute(Directory)
end

-- Main


local Tab = Window:CreateTab("Main", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Auto Farm",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements


local Dropdown = Tab:CreateDropdown({
    Name = "Select World",
    Options = Worlds,
    CurrentOption = "",
    Multi = false, -- If MultiSelections is allowed
    Flag = "SelectedMap", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        _G.Settings.SelectedMap = Option
    end,
})

createMultiSelectDropdown(Tab,"SelectedEnemies","SelectedEnemies", "Enemies",Enemies)

createOptimisedToggle(Tab,"Auto Farm Selected Enemies", "AutoFarmSelectedEnemies",
function()
    while task.wait() do

        if CanDoPriority("Farm") then

            for _,Enemy in pairs(workspace._ENEMIES[GetWorldId(GetG("SelectedMap"))]:GetChildren()) do

                for i,v in pairs(GetG("SelectedEnemies")) do

                    pcall(function()

                        if Enemy.Name == GetEnemyId(v) and Enemy._STATS.CurrentHP.Value > 0 then

                            repeat

                                if Enemy.Name ~= GetEnemyId(v) .. "111" then
                                    Enemy.Name = GetEnemyId(v) .. "111"
                                end

                                TweenFunc1(game.Players.LocalPlayer.Character.HumanoidRootPart,0,Enemy:GetModelCFrame() * CFrame.new(0,0,5))

                                HitEnemy(Enemy)

                                task.wait()

                                _G.CanClick = false

                            until not GetG("AutoFarmSelectedEnemies") or Enemy._STATS.CurrentHP.Value <= 0 or not CanDoPriority("Farm")
                            
                            _G.CanClick = true

                            for a,b in pairs(workspace._ENEMIES[GetWorldId(GetG("SelectedMap"))]:GetChildren()) do
                                if b.Name:find("111") then
                                    local gg = b.Name:split("111")
                                    b.Name = gg[1]
                                    task.wait()
                                end
                            end

                        end

                    end)

                end

            end

        end

    end
end)

local Section = Tab:CreateSection("Misc",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createOptimisedToggle(Tab,"Auto Click", "AutoClick",
function()
    while task.wait() do

        pcall(function()
            if not _G.InTrial then
                Click()
            end
        end)

        task.wait(.05)

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
    Name = "Select Amount",
    Options = {"One","Three"},
    CurrentOption = "",
    Multi = false, -- If MultiSelections is allowed
    Flag = "SelectedEggAmount", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        _G.Settings.SelectedEggAmount = Option
    end,
})

local Section = Tab:CreateSection("Auto",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createOptimisedToggle(Tab,"Auto Open Selected Egg (Must Be Close To Egg)", "AutoOpenSelectedEgg",
function()
    while task.wait() do

        pcall(function()
            OpenChest(GetG("SelectedEgg"),GetG("SelectedEggAmount"))
            task.wait(.25)
        end)

    end
end)

local Tab = Window:CreateTab("Dungeon", 11642692687) -- Title, Image

local Section = Tab:CreateSection("Settings",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createMultiSelectDropdown(Tab,"SelectedDungeons","SelectedDungeons", "Dungeons To Do",Dungeons)


local RoomLeaveEasy = Tab:CreateLabel("Room To Leave [Easy]: ".._G.Settings.SelectedEasyRoomLeave)

Tab:CreateInput({
    Name = "Room To Leave [Easy]",
    PlaceholderText = "Room",
    NumbersOnly = false, -- If the user can only type numbers.
    OnEnter = true, -- Will callback only if the user pressed ENTER while being focused.
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        Text = tostring(Text)
        _G.Settings.SelectedEasyRoomLeave = Text
        SaveTableRequest("SelectedEasyRoomLeave","Update",_G.Settings.SelectedEasyRoomLeave)
        RoomLeaveEasy:Set("Room To Leave [Easy]: ".._G.Settings.SelectedEasyRoomLeave)
    end
})

local Dropdown = Tab:CreateDropdown({
    Name = "Select World To Go Back To",
    Options = Worlds,
    CurrentOption = "",
    Multi = false, -- If MultiSelections is allowed
    Flag = "SelectedMapToGoBack", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Option)
        _G.Settings.SelectedMapToGoBack = Option
    end,
})

local Section = Tab:CreateSection("Main",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements

createOptimisedToggle(Tab,"Auto Complete Dungeon", "AutoDungeon",
function()
    while task.wait() do
    
        pcall(function()
            local ConvertedTimer = GetDungeonData("Easy","TimeToOpen"):split("Opens in")[2]:split("s")[1]
        end)
        
        if (GetDungeonData("Easy","Status") == "Opened" and GetDungeonData("Easy","TimeToStart") <= 20) and GetDungeonData("Easy","Mode") ~= "Dungeon" then
            if not _G.InTrial then

                _G.InTrial = true

                pcall(function()
                    task.wait(2.5)
                    Teleport("Lobby")
                    task.wait(2.5)
                    TweenFunc1(game.Players.LocalPlayer.Character.HumanoidRootPart,0.1,workspace._AREAS.Lobby.Dungeon.Easy:GetModelCFrame())
                end)
                
                repeat
                    task.wait()
                until GetDungeonData("Easy","Status") == "Running" or not GetG("AutoDungeon")

            end
        end

        if CanDoPriority("Trial") and GetDungeonData("Easy","Status") == "Running" then
            --if (GetDungeonData("Easy","Room") > tonumber(GetG("SelectedEasyRoomLeave"))) or (tonumber(game:GetService("Players").LocalPlayer.PlayerGui.Mode.Content.Dungeon.Info.Room.Amount.Text) >= tonumber(GetG("SelectedEasyRoomLeave"))) then
                local ClosestMob
                local ClosestMobRad = math.huge
                print("BBRUH")
                --pcall(function()
                    for i,v in pairs(workspace._ENEMIES.Dungeon.Easy[DungeonData.Easy:GetAttribute("Room")]:GetChildren()) do
                        if v._STATS.CurrentHP.Value > 0 then
                            if getStudLength(v:GetModelCFrame()) < ClosestMobRad then
                                ClosestMob = v
                                ClosestMobRad = getStudLength(v:GetModelCFrame())
                            end
                        end
                    end
                --end)

                if ClosestMob then
                    local v = ClosestMob        

                    pcall(function()
                        repeat

                            TweenFunc1(game.Players.LocalPlayer.Character.HumanoidRootPart,0,v:GetModelCFrame() * CFrame.new(0,0,5))

                            HitEnemy(v)

                            task.wait(.1)

                        until not v or v._STATS.CurrentHP.Value <= 0 or not CanDoPriority("Trial") or not GetG("AutoDungeon") or GetDungeonData("Easy","Room") <= GetG("SelectedEasyRoomLeave")
                        
                        if DungeonData.Easy:GetAttributeChangedSignal("Room") then
                            task.wait(2.5)
                        end

                    end)

                end

            --else
                --if game:GetService("Players").LocalPlayer.PlayerGui.Mode.Content.Dungeon.Visible then
                    --_G.InTrial = false
                    --Teleport(GetG("SelectedMapToGoBack"))
                    --task.wait(.25)
                --end
            --end
            
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

-- loadstring(game:HttpGet('https://raw.githubusercontent.com/Vernyfx/test/main/GG.lua'))()
