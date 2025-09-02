local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
    local function API_Check()
    if Drawing == nil then
        return "No"
    else
        return "Yes"
    end
end

-- CoreV2
getgenv().S = false
getgenv().B = false
getgenv().O = false
getgenv().Sh = false
getgenv().Se = false
getgenv().Gc = false
getgenv().Cr = false
getgenv().Gr = false
getgenv().Bo = false
getgenv().Be = false

-- Module
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/VortexStecu/VORTEX-HUB/refs/heads/main/Aimbot.lua"))()



-- Config
local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)() -- Pepsi's UI Library
local Parts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm", "LeftFoot", "LeftLowerLeg", "UpperTorso", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "LowerTorso", "RightUpperLeg"}, {"UI", "System", "Plex", "Monospace"}, {"Bottom", "Center", "Mouse"}
local AimbotEnabled = true
local TeamCheck = true
local WallCheck = true


--// Cache

local game = game
local loadstring, typeof, select, next, pcall = loadstring, typeof, select, next, pcall
local tablefind, tablesort = table.find, table.sort
local mathfloor = math.floor
local stringgsub = string.gsub
local wait, delay, spawn = task.wait, task.delay, task.spawn
local osdate = os.date

-- FUNCTION
local function GetClosestTargett()
	local closest = nil
	local shortestDist = FOVRadius

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if TeamCheck and player.Team == LocalPlayer.Team then continue end

			local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
			if onScreen then
				local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
				local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude

				if dist <= shortestDist then
					if WallCheck then
						local origin = Camera.CFrame.Position
						local direction = (player.Character.HumanoidRootPart.Position - origin).Unit * 1000
						local raycastParams = RaycastParams.new()
						raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
						raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

						local result = workspace:Raycast(origin, direction, raycastParams)
						if result and result.Instance:IsDescendantOf(player.Character) then
							closest = player
							shortestDist = dist
						end
					else
						closest = player
						shortestDist = dist
					end
				end
			end
		end
	end

	return closest
end

RunService.RenderStepped:Connect(function()
	if FOVRainbow then
		local hue = tick() % 5 / 5
		local color = Color3.fromHSV(hue, 1, 1)
		UIStroke.Color = color
	end

	if AimbotEnabled then
		local target = GetClosestTarget()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local head = target.Character.HumanoidRootPart.Position
			local camPos = Camera.CFrame.Position
			local newCF = CFrame.new(camPos, head)
			Camera.CFrame = Camera.CFrame:Lerp(newCF, 0.4)
		end
	end
end)


local function ApplyHighlight(player)
	if not player.Character then return end
	local existing = player.Character:FindFirstChild("ESPHighlight")
	if existing then existing:Destroy() end

	local highlight = Instance.new("Highlight")
	highlight.Name = "ESPHighlight"
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 0
	highlight.OutlineColor = HighlightColor
	highlight.FillColor = HighlightColor
	highlight.Enabled = ESPEnabled and (not ESPTeamCheck or player.Team ~= LocalPlayer.Team)
	highlight.Parent = player.Character
end


-- FPS y Ping Display
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Parent = ScreenGui
StatsLabel.Size = UDim2.new(0, 200, 0, 50)
StatsLabel.Position = UDim2.new(1, -210, 0, 10)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Color3.new(1, 1, 1)
StatsLabel.TextStrokeTransparency = 0
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = 18
StatsLabel.TextXAlignment = Enum.TextXAlignment.Right

local lastUpdate = tick()
RunService.RenderStepped:Connect(function()
	local fps = math.floor(1 / RunService.RenderStepped:Wait())
	if tick() - lastUpdate >= 0.3 then
		local ping = tonumber(string.match(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString(), "%d+")) or 0
		StatsLabel.Text = "FPS: " .. fps .. " | Ping: " .. ping .. "ms"
		lastUpdate = tick()
	end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Window = Rayfield:CreateWindow({
   Name = "AimVortex Hub",
   LoadingTitle = "AimVortex Hub",
   LoadingSubtitle = "by VorStecu",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "VortexStecu Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key | Youtube Hub",
      Subtitle = "Key System",
      Note = "Key In Discord Server",
      FileName = "YoutubeHubKey1", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"VortexStecu"} -- List of keys that will be accepted by the system, can b file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})


local MainTab = Window:CreateTab("Main", 4483362458)


Rayfield:Notify({
   Title = "You executed the script",
   Content = "Very cool Bro",
   Duration = 5,
   Image = 13047715178,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
})


local Toggle = MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(bool)
    AimbotEnabled = (value)
    Aimbot = (value)
    LockParts = {"head"}
    getgenv().Bo = bool
     if bool then
         GetClosestTargett()
     end
    end,
})


 
 local Toggle = MainTab:CreateToggle({
    Name = "Aimcheck",
    CurrentValue = false,
    Callback = function(bool)
    TeamCheck = (value)
     getgenv().Bo = bool
     if bool then
         doBo()
     end
    end,
 })
 
 local Toggle = MainTab:CreateToggle({
    Name = "Aimsilent",
    CurrentValue = false,
    Callback = function(bool)
     getgenv().Bo = bool
     if bool then
         doBo()
     end
    end,
 })
 
 

 
 
 
local Toggle = MainTab:CreateSlider({
	Name = "Aim FOV",
	Range = {50, 300},
	Increment = 5,
	CurrentValue = 100,
	Callback = function(value)
		FOVRadius = value
		FOVCircle.Size = UDim2.new(0, value * 2, 0, value * 2)
	end
})

local VisualTab = Window:CreateTab("Visual", 4483362458)


local Toggle = VisualTab:CreateToggle({
    Name = "Esp Body Chams",
    CurrentValue = false,
    Callback = function(bool)
    -- Highlight all players in your own game
local function addHighlight(character)
    if character:FindFirstChild("HumanoidRootPart") and not character:FindFirstChild("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = Color3.fromRGB(255, 255, 0) -- yellow
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function onCharacterAdded(character)
    addHighlight(character)
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        addHighlight(player.Character)
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- highlight players already in-game when script runs
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        addHighlight(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end
	getgenv().Bo = bool
     if bool then
         doBo()
     end
    end,
})
     
 
 
 
local Toggle = VisualTab:CreateToggle({
    Name = "Esp Tracer",
    CurrentValue = false,
    Callback = function(bool)

local Find_Required = API_Check()

if Find_Required == "No" then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Exunys Developer";
        Text = "Tracer script could not be loaded because your exploit is unsupported.";
        Duration = math.huge;
        Button1 = "OK"
    })

    return
end

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TestService = game:GetService("TestService")

local Typing = false

_G.SendNotifications = true   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
_G.DefaultSettings = false   -- If set to true then the tracer script would run with default settings regardless of any changes you made.

_G.TeamCheck = false   -- If set to true then the script would create tracers only for the enemy team members.

--[!]-- ONLY ONE OF THESE VALUES SHOULD BE SET TO TRUE TO NOT ERROR THE SCRIPT --[!]--

_G.FromMouse = false   -- If set to true, the tracers will come from the position of your mouse curson on your screen.
_G.FromCenter = false   -- If set to true, the tracers will come from the center of your screen.
_G.FromBottom = true   -- If set to true, the tracers will come from the bottom of your screen.

_G.TracersVisible = true   -- If set to true then the tracers will be visible and vice versa.
_G.TracerColor = Color3.fromRGB(255, 80, 10)   -- The color that the tracers would appear as.
_G.TracerThickness = 4   -- The thickness of the tracers.
_G.TracerTransparency = 0.7   -- The transparency of the tracers.

_G.ModeSkipKey = Enum.KeyCode.E   -- The key that changes between modes that indicate where will the tracers come from.
_G.DisableKey = Enum.KeyCode.Q   -- The key that disables / enables the tracers.

local function CreateTracers()
    for _, v in next, Players:GetPlayers() do
        if v.Name ~= game.Players.LocalPlayer.Name then
            local TracerLine = Drawing.new("Line")
    
            RunService.RenderStepped:Connect(function()
                if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                    local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                    local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                    
                    TracerLine.Thickness = _G.TracerThickness
                    TracerLine.Transparency = _G.TracerTransparency
                    TracerLine.Color = _G.TracerColor

                    if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                        TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                        TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                        TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    end

                    if OnScreen == true  then
                        TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                        if _G.TeamCheck == true then 
                            if Players.LocalPlayer.Team ~= v.Team then
                                TracerLine.Visible = _G.TracersVisible
                            else
                                TracerLine.Visible = false
                            end
                        else
                            TracerLine.Visible = _G.TracersVisible
                        end
                    else
                        TracerLine.Visible = false
                    end
                else
                    TracerLine.Visible = false
                end
            end)

            Players.PlayerRemoving:Connect(function()
                TracerLine.Visible = false
            end)
        end
    end

    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(v)
            if v.Name ~= game.Players.LocalPlayer.Name then
                local TracerLine = Drawing.new("Line")
        
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                        local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                    	local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                        
                        TracerLine.Thickness = _G.TracerThickness
                        TracerLine.Transparency = _G.TracerTransparency
                        TracerLine.Color = _G.TracerColor

                        if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                        elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        end

                        if OnScreen == true  then
                            TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= Player.Team then
                                    TracerLine.Visible = _G.TracersVisible
                                else
                                    TracerLine.Visible = false
                                end
                            else
                                TracerLine.Visible = _G.TracersVisible
                            end
                        else
                            TracerLine.Visible = false
                        end
                    else
                        TracerLine.Visible = false
                    end
                end)

                Players.PlayerRemoving:Connect(function()
                    TracerLine.Visible = false
                end)
            end
        end)
    end)
end

UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == _G.ModeSkipKey and Typing == false then
        if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false and _G.TracersVisible == true then
            _G.FromCenter = false
            _G.FromBottom = true
            _G.FromMouse = false

            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Exunys Developer";
                    Text = "Tracers will be now coming from the bottom of your screen (Mode 1)";
                    Duration = 5;
                })
            end
        elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true and _G.TracersVisible == true then
            _G.FromCenter = true
            _G.FromBottom = false
            _G.FromMouse = false

            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Exunys Developer";
                    Text = "Tracers will be now coming from the center of your screen (Mode 2)";
                    Duration = 5;
                })
            end
        elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false and _G.TracersVisible == true then
            _G.FromCenter = false
            _G.FromBottom = false
            _G.FromMouse = true

            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Exunys Developer";
                    Text = "Tracers will be now coming from the position of your mouse cursor on your screen (Mode 3)";
                    Duration = 5;
                })
            end
        end
    elseif Input.KeyCode == _G.DisableKey and Typing == false then
        _G.TracersVisible = not _G.TracersVisible
        
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "The tracers' visibility is now set to "..tostring(_G.TracersVisible)..".";
                Duration = 5;
            })
        end
    end
end)

if _G.DefaultSettings == true then
    _G.TeamCheck = false
    _G.FromMouse = false
    _G.FromCenter = false
    _G.FromBottom = true
    _G.TracersVisible = true
    _G.TracerColor = Color3.fromRGB(40, 90, 255)
    _G.TracerThickness = 4
    _G.TracerTransparency = 0.5
    _G.ModeSkipKey = Enum.KeyCode.E
    _G.DisableKey = Enum.KeyCode.Q
end

local Success, Errored = pcall(function()
    CreateTracers()
end)

if Success and not Errored then
    if _G.SendNotifications == true then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "";
            Text = "";
            Duration = 5;
        })
    end
elseif Errored and not Success then
    if _G.SendNotifications == true then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "";
            Text = "";
            Duration = 5;
        })
    end
    TestService:Message("")
    warn(Errored)
    print("")
     getgenv().Bo = bool
     if bool then
         doBo()
     end
     end
    end,
})

local MiscTab = Window:CreateTab("Misc", 4483362458)
