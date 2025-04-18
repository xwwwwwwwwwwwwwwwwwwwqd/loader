-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Variables
local LocalPlayer = Players.LocalPlayer
local AimbotEnabled = false
local AimSmoothness = 0.1
local LineColor = Color3.fromRGB(0, 255, 0)
local BoxColor = Color3.fromRGB(255, 0, 0)
local AimbotRange = 200
local AimbotSection = AimbotTab:NewSection("Aimbot Settings")

AimbotSection:NewToggle("Enable Aimbot", "Toggle aimbot on/off", function(state)
    AimbotEnabled = state
end)

AimbotSection:NewSlider("Aim Smoothness", "Adjust aim smoothness", 100, 1, function(value)
    AimSmoothness = value / 100
end)

AimbotSection:NewSlider("Aimbot Range", "Adjust aimbot range", 500, 50, function(value)
    AimbotRange = value
end)

AimbotSection:NewColorPicker("Box Color", "Choose box color", BoxColor, function(color)
    BoxColor = color
end)

AimbotSection:NewColorPicker("Line Color", "Choose line color", LineColor, function(color)
    LineColor = color
end)

local Boxes = {}
local Lines = {}

local function GetAllPlayers()
    local allPlayers = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                table.insert(allPlayers, character)
            end
        end
    end
    
    return allPlayers
end

local function GetNearestTarget()
    local closestTarget = nil
    local shortestDistance = AimbotRange
    local mouseLocation = UserInputService:GetMouseLocation()
    
    for _, character in pairs(GetAllPlayers()) do
        local targetPart = character:FindFirstChild("HumanoidRootPart")
        if targetPart then
            local screenPosition, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mouseLocation).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = targetPart
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    for _, box in pairs(Boxes) do
        box.Visible = false
    end
    for _, line in pairs(Lines) do
        line.Visible = false
    end
    
    if AimbotEnabled then
        local players = GetAllPlayers()
        local nearestTarget = GetNearestTarget()
        
        for i, targetCharacter in pairs(players) do
            local target = targetCharacter:FindFirstChild("HumanoidRootPart")
            if target then
                if not Boxes[i] then
                    Boxes[i] = Drawing.new("Square")
                    Boxes[i].Thickness = 2
                    Boxes[i].Filled = false
                    Boxes[i].Visible = false
                end
                Boxes[i].Color = BoxColor
                
                if not Lines[i] then
                    Lines[i] = Drawing.new("Line")
                    Lines[i].Thickness = 2
                    Lines[i].Visible = false
                end
                Lines[i].Color = LineColor
                
                local targetScreenPosition, targetOnScreen = Camera:WorldToViewportPoint(target.Position)
                local localScreenPosition = Camera:WorldToViewportPoint(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0))
                
                if targetOnScreen then
                    Boxes[i].Position = Vector2.new(targetScreenPosition.X - 25, targetScreenPosition.Y - 50)
                    Boxes[i].Size = Vector2.new(50, 100)
                    Boxes[i].Visible = true
                    
                    Lines[i].From = Vector2.new(localScreenPosition.X, localScreenPosition.Y)
                    Lines[i].To = Vector2.new(targetScreenPosition.X, targetScreenPosition.Y)
                    Lines[i].Visible = true
                end
            end
        end
        
        if nearestTarget then
            local targetScreenPos = Camera:WorldToViewportPoint(nearestTarget.Position)
            local currentCameraCFrame = Camera.CFrame.Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(currentCameraCFrame, nearestTarget.Position), AimSmoothness)
        end
    end
end)