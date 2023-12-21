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

}

-- Tables

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


-- Locals
 


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
            print("GG1")
            for _,Enemy in pairs(workspace._ENEMIES[GetWorldId(GetG("SelectedMap"))]:GetChildren()) do
                print("GG2")
                for i,v in pairs(GetG("SelectedEnemies")) do
                    print("GG3")
                    if Enemy.Name == GetEnemyId(v) and Enemy._STATS.CurrentHP > 0 then
                        print("GG4")
                        local oldName = Enemy.Name
                        local Tweened = false

                        repeat
                            print("GG5")
                            if Enemy.Name ~= oldName .. "111" then
                                Enemy.Name = oldName .. "111"
                            end

                            if not Tweened then
                                TweenFunc1(game.Players.LocalPlayer.Character.HumanoidRootPart,0.05,v:GetModelCFrame())
                                Tweened = true
                            end

                            HitEnemy(Enemy)

                            task.wait(.1)

                        until not GetG("AutoFarmSelectedEnemies") or Enemy._STATS.CurrentHP <= 0 or not CanDoPriority("Farm")
                        
                        Enemy.Name = oldName

                    end

                end

            end

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

--loadstring(game:HttpGet('https://raw.githubusercontent.com/Vernyfx/test/main/GG.lua'))()
