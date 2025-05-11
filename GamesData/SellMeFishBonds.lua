
-- Ads
local ScreenGui = Instance.new("ScreenGui")
local AdFrame = Instance.new("Frame")
local DiscordLabel = Instance.new("TextLabel")
local CopyButton = Instance.new("TextButton")
local ExitButton = Instance.new("TextButton")
local WaitButton = Instance.new("TextButton")
local UIGradientFrame = Instance.new("UIGradient")
local UIGradientText = Instance.new("UIGradient")
ScreenGui.Name = "AdsGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

AdFrame.Name = "AdFrame"
AdFrame.Parent = ScreenGui
AdFrame.Size = UDim2.new(0.4, 0, 0.3, 0)
AdFrame.Position = UDim2.new(0.5, 0, 0.35, 0)
AdFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AdFrame.BorderSizePixel = 2
AdFrame.Draggable = true
AdFrame.Active = true
AdFrame.BorderColor3 = Color3.fromRGB(0, 0, 139) -- Biru Gelap

-- Gradient untuk Background AdFrame
UIGradientFrame.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), -- Putih di atas
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 139)) -- Biru Gelap di bawah
}
UIGradientFrame.Parent = AdFrame

DiscordLabel.Name = "DiscordLabel"
DiscordLabel.Parent = AdFrame
DiscordLabel.Size = UDim2.new(1, 0, 0.6, 0)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "Stellar"
DiscordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordLabel.TextSize = 22
DiscordLabel.TextWrapped = true

UIGradientText.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), -- Putih di atas
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(70, 130, 180)), -- Gradasi Biru Muda
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 139)) -- Biru Gelap di bawah
}
UIGradientText.Parent = DiscordLabel

CopyButton.Name = "CopyButton"
CopyButton.Parent = AdFrame
CopyButton.Size = UDim2.new(0.4, 0, 0.2, 0)
CopyButton.Position = UDim2.new(0.1, 0, 0.7, 0)
CopyButton.Text = "Copy Link Discord"
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 139) -- Biru Gelap
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

ExitButton.Name = "ExitButton"
ExitButton.Parent = AdFrame
ExitButton.Size = UDim2.new(0.4, 0, 0.2, 0)
ExitButton.Position = UDim2.new(0.5, 0, 0.7, 0)
ExitButton.Text = "Exit"
ExitButton.Visible = false
ExitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ExitButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Putih

WaitButton.Name = "WaittoExit"
WaitButton.Parent = AdFrame
WaitButton.Size = UDim2.new(0.4, 0, 0.2, 0)
WaitButton.Position = UDim2.new(0.5, 0, 0.7, 0)
WaitButton.Text = "Waitting Delay Exit"
WaitButton.Visible = true
WaitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WaitButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Putih

task.delay(5, function()
    WaitButton.Visible = false
    ExitButton.Visible = true
end)

CopyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.com/invite/eTVvgvRq4s")
        task.wait()
        CopyButton.Text = "Copied To Discord Link"
        task.wait(0.6)
        CopyButton.Text = "Copy Link Discord"
    end
end)

ExitButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

-- Player Setup
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local StellarLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/loader/refs/heads/main/VentureData/StellarUI.lua"))()

local Window = StellarLibrary:CreateWindow({Title = "Stellar"})

print([[  
  ∧,,,∧
(  ̳• · • ̳)
/    づ You want my heart? Don't skid please :D
  ∧,,,∧
(  ̳• · • ̳)
/    づ♡ Ok here's my heart

🟢 Successfully Loaded!
]])
local Main = Window:AddTab({ Title = "General", Icon = "rbxassetid://10734966248" })
local Misc = Window:AddTab({Title = "Misc", Icon = "rbxassetid://10734976739"})
local Settings = Window:AddTab({Title = "Settings", Icon = "rbxassetid://10734950020"})
local Options = StellarLibrary.Options

task.spawn(function()
    wait(0.5)
    StellarLibrary:Notify({
        Title = "Stellar",
        Content = "The script has been loaded successfully!",
        Duration = 4
    })
end)

local replicated_storage = cloneref(game:GetService("ReplicatedStorage"))
local workspace = cloneref(game:GetService("Workspace"))
local enemies = workspace:FindFirstChild("Mobs")
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local HRP = function()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

getgenv().settings = {
    enabled = false,
    delay = 2,
    spinSpeed = 5,
    heightOffset = 5
}

-- Fungsi spiral ke target
local function spiralToTarget(target)
    local radius = 10
    local angle = 0

    while target and target.Parent and settings.enabled do
        if not HRP() then break end

        angle = angle + settings.spinSpeed * task.wait()

        local offsetX = math.cos(angle) * radius
        local offsetZ = math.sin(angle) * radius
        local height = settings.heightOffset
        local targetPos = target.Position + Vector3.new(offsetX, height, offsetZ)

        HRP().CFrame = CFrame.new(HRP().Position, target.Position) * CFrame.new(offsetX, height, offsetZ)
        HRP().Velocity = Vector3.new(0, 0, 0)

        replicated_storage:WaitForChild("Systems"):WaitForChild("Combat"):WaitForChild("PlayerAttack"):FireServer({target})

        if target:FindFirstChild("Humanoid") and target.Humanoid.Health <= 0 then
            break
        end
    end
end

-- Toggle Kill Aura
Main:AddToggle("killAuraToggle", {
    Title = "Kill Aura",
    Description = "Automatically fly and spiral to all mobs",
    Default = false
}):OnChanged(function(value)
    settings.enabled = value
    if value then
        task.spawn(function()
            while settings.enabled do
                for _, mob in ipairs(enemies:GetChildren()) do
                    if not settings.enabled then break end
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        spiralToTarget(mob.HumanoidRootPart or mob.PrimaryPart)
                        task.wait(0.1)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)
