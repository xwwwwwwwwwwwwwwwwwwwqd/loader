repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
 
local Fluent = loadstring(Game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))() 



local Window = Fluent:CreateWindow({
    Title = "Dead Rails",
    SubTitle = "Feito por Lucas",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true
})


if getgenv().teste then
    local Tab = Window:AddTab({ Title = "testes", Icon = "home" })

    local defaultTpPos = Vector3.new(100, 10, 200)
    local currentTpPos = defaultTpPos

    Tab:AddButton({
        Title = "Teleportar",
        Description = "Tp normal",
        Callback = function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char:MoveTo(currentTpPos)
            end
        end
    })

    Tab:AddButton({
        Title = "Tp Spawn",
        Description = "Define o local atual como novo TP",
        Callback = function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                currentTpPos = char.HumanoidRootPart.Position
            end
        end
    })

    Tab:AddButton({
        Title = "Reset Tp",
        Description = "Volta o TP para o padrão",
        Callback = function()
            currentTpPos = defaultTpPos
        end
    })

    Tab:AddSlider("Slider", {
        Title = "Velocidade",
        Default = 16,
        Min = 10,
        Max = 150,
        Rounding = 1,
        Callback = function(Value)
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
            end
        end
    })

    local flying = false
    local RS = game:GetService("RunService")
    local speed = 3
    local bv, bg, char, hrp, humanoid

    Tab:AddToggle("FlyToggle", {
        Title = "Fly (Analógico Mobile)",
        Default = false,
        Callback = function(state)
            flying = state
            char = game.Players.LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            hrp = char:FindFirstChild("HumanoidRootPart")
            humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if flying then  
                bv = Instance.new("BodyVelocity")  
                bv.Velocity = Vector3.zero  
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)  
                bv.Parent = hrp  
                bg = Instance.new("BodyGyro")  
                bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)  
                bg.CFrame = hrp.CFrame  
                bg.Parent = hrp  

                humanoid.PlatformStand = true  

                RS:BindToRenderStep("Fly", Enum.RenderPriority.Input.Value, function()  
                    local cam = workspace.CurrentCamera  
                    local moveDir = humanoid.MoveDirection  

                    if moveDir.Magnitude > 0 then  
                        bv.Velocity = cam.CFrame:VectorToWorldSpace(moveDir.Unit * speed)  
                    else  
                        bv.Velocity = Vector3.zero  
                    end  

                    bg.CFrame = cam.CFrame  
                end)  
            else  
                RS:UnbindFromRenderStep("Fly")  
                if bv then bv:Destroy() end  
                if bg then bg:Destroy() end  
                if humanoid then humanoid.PlatformStand = false end  
            end  
        end
    })

    -- repeat task.wait() until game:IsLoaded()

    local bondLabel
    pcall(function()
        bondLabel = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BondGui"):WaitForChild("BondInfo"):WaitForChild("BondCount")
    end)

    Tab:AddParagraph({
        Title = "Seu Bond:",
        Content = bondLabel and bondLabel.Text or "N/A"
    })
 
    -- eterna linha 116 (sempre ficar na linha 127)
end

            
local main = Window:AddTab({
  Title = "main",
  Icon = "home"
 })

local Section = main:AddSection("auto collect/use")



main:AddToggle("AutoCollectToggle", {
    Title = "Auto Collect",
    Description = "Coleta automaticamente os itens do chão (em desenvolvimento)",
    Default = false,
    Callback = function(state)
        autoCollectRunning = state

        if state then
            local function collectItems()
                if not workspace:FindFirstChild("RuntimeItems") then return end

                local items = {
                    workspace.RuntimeItems:FindFirstChild("Rifle"),
                    workspace.RuntimeItems:FindFirstChild("RifleAmmo"),
                    workspace.RuntimeItems:FindFirstChild("Bandage"),
                    workspace.RuntimeItems:FindFirstChild("Shotgun"),
                    workspace.RuntimeItems:FindFirstChild("Revolver"),
                    workspace.RuntimeItems:FindFirstChild("ShotgunShells"),
                    workspace.RuntimeItems:FindFirstChild("Molotov"),
                    workspace.RuntimeItems:FindFirstChild("RevolverAmmo"),
                    workspace.RuntimeItems:FindFirstChild("Mauser"),
                    workspace.RuntimeItems:FindFirstChild("Snake Oil"),
                    workspace.RuntimeItems:FindFirstChild("Shovel"),
                    workspace.RuntimeItems:FindFirstChild("OpenableCrate"),
                    workspace.RuntimeItems:FindFirstChild("Navy Revolver"),
                    workspace.RuntimeItems:FindFirstChild("Bolt Action Rifle"),
                    workspace.RuntimeItems:FindFirstChild("Holy Water"),
                    workspace.RuntimeItems:FindFirstChild("Electrocutioner"),
                    workspace.RuntimeItems:FindFirstChild("Vampire Knife")
                }

                local rs = game:GetService("ReplicatedStorage")
                local pickUpRemote = rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("Tool") and rs.Remotes.Tool:FindFirstChild("PickUpTool")
                local activateRemote = rs:FindFirstChild("Packages") and rs.Packages:FindFirstChild("RemotePromise") and rs.Packages.RemotePromise.Remotes:FindFirstChild("C_ActivateObject")

                if not pickUpRemote or not activateRemote then return end

                for _, item in pairs(items) do
                    if item then
                        local args = { item }
                        pickUpRemote:FireServer(unpack(args))
                        activateRemote:FireServer(unpack(args))
                    end
                end
            end

            task.spawn(function()
                while autoCollectRunning do
                    task.wait(0.4)
                    pcall(collectItems)
                end
            end)
        end
    end
})



local bondRunning = false

main:AddToggle("ActivateBondToggle", {
    Title = "collect bonds (perto de você)",
    Description = "Coleta bonds proximos a você",
    Default = false,
    Callback = function(state)
        bondRunning = state

        if state then
            task.spawn(function()
                while bondRunning do
                    local bond = workspace:FindFirstChild("RuntimeItems") and workspace.RuntimeItems:FindFirstChild("Bond")
                    if bond then
                        local args = { bond }
                        game:GetService("ReplicatedStorage").Packages.RemotePromise.Remotes.C_ActivateObject:FireServer(unpack(args))
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})


local Section = main:AddSection("outros")


main:AddButton({
  Title = "fly (funcional)",
  Description = "ao clicar ativa uma ui, recomendo usar velocidade 10, para funcionar sente em uma cadeira",
  Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui'))()
  end
 })







local BondsTab = Window:AddTab({ Title = "aimbot", Icon = "list" })

BondsTab:AddToggle("AimLockToggle", {
    Title = "AimLock NPC",
    Description = "Tranca a câmera no NPC mais próximo",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local runService = game:GetService("RunService")
        local camera = workspace.CurrentCamera

        if not _G.AimLockData then
            _G.AimLockData = { Loop = nil }
        end

        local function stopAimLock()
            if _G.AimLockData.Loop then
                _G.AimLockData.Loop:Disconnect()
                _G.AimLockData.Loop = nil
            end
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
            end
        end

        local function startAimLock()
            stopAimLock()
            
            _G.AimLockData.Loop = runService.RenderStepped:Connect(function()
                if not state then return stopAimLock() end
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                
                local closestNPC = nil
                local closestDistance = math.huge
                
                for _, npc in ipairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc ~= player.Character then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        local hrp = npc:FindFirstChild("HumanoidRootPart")
                        
                        if humanoid and hrp and humanoid.Health > 0 then
                            local distance = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestNPC = npc
                            end
                        end
                    end
                end
                
                if closestNPC then
                    camera.CameraSubject = closestNPC:FindFirstChildOfClass("Humanoid")
                else
                    camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
                end
            end)
        end

        if state then
            player.CameraMode = Enum.CameraMode.Classic
            startAimLock()
        else
            stopAimLock()
        end
    end
})













            
local tabpt = Window:AddTab({ Title = "Teleports", Icon = "car" })

-- repeat task.wait() until game:IsLoaded()

local Section = tabpt:AddSection("Teleports: feito por Lucas: ")

tabpt:AddButton({
    Title = "Tp Tesla",
    Description = " TP para Tesla",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/tptotesla.github.io/refs/heads/main/Tptotesla.lua'))()
    end
})

tabpt:AddButton({
    Title = "Tp castelo",
    Description = " TP para castelo",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/castletpfast.github.io/refs/heads/main/FASTCASTLE.lua"))()
    end
})

tabpt:AddButton({
    Title = "Tp fort",
    Description = " TP para fort",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tpfort.github.io/refs/heads/main/Tpfort.lua"))()
    end
})


local section = tabpt:AddSection("Teleports feito por ringtaa: ")


tabpt:AddParagraph({
  Title = "Como usar:",
  Content = "tem chances de nao funcionar pois nao fui eu que fiz, para 100% de chance use o meu tp to end entre outros!"
 })
tabpt:AddButton({
    Title = "Tp to end",
    Description = "TP para o final feito por ringtaa (pacifista)",
    Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/newpacifisct/refs/heads/main/newpacifisct.lua"))()
  end 
})
  



tabpt:AddButton({
    Title = "Tp starling",
    Description = " TP para starling",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ringtaa/sterlingnotifcation.github.io/refs/heads/main/Sterling.lua'))()
    end
})

tabpt:AddButton({
    Title = "Tp Bank",
    Description = " TP para o banco mais próximo",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ringtaa/Tptobank.github.io/refs/heads/main/Banktp.lua"))()
    end
})


local section = tabpt:AddSection("seção da Páscoa feito por ringtaa")

tabpt:AddButton({
    Title = "Tp para os 6 golden eggs",
    Description = "funciona 100% | Recomendo usar um snake oil para recuperar hp.",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/r4mpage4/LuaCom/refs/heads/main/collect6eggs.fr'))()
    end
})

tabpt:AddButton({
    Title = "teleports UFO",
    Description = "Abre outra ui, script para o UFO",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/DeadRails"))()
    end
})





local visual = Window:AddTab({ Title = "Visual", Icon = "list"  })



visual:AddToggle("unicornesp", {
    Title = "esp unicórnio",
    Description = "feito por Lucas, mostra unicórnio num range de 10mil metros",
    Default = false,
    Callback = function(state)
        if state then
            local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
            ESP:Toggle(true)
            ESP.Players = false
            ESP.Boxes = true
            ESP.Names = true
            ESP.TeamColor = false
            ESP.FaceCamera = true
            ESP.Distance = 10000

            function AddIfAliveUnicorn(model)
                if model:IsA("Model") and string.lower(model.Name):find("unicorn") then
                    local humanoid = model:FindFirstChildWhichIsA("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
                        if part then
                            ESP:Add(model, {
                                Name = "Unicorn Atı",
                                PrimaryPart = part,
                                Color = Color3.fromRGB(255, 182, 193),
                                IsEnabled = true
                            })
                        end
                    end
                end
            end

            for _, obj in pairs(workspace:GetDescendants()) do
                AddIfAliveUnicorn(obj)
            end

            workspace.DescendantAdded:Connect(function(obj)
                task.wait(0.1)
                AddIfAliveUnicorn(obj)
            end)
        end
    end
})







  
local trainTab = Window:AddTab({ Title = "Train", Icon = "train" })

trainTab:AddButton({
    Title = "tp to train",
    Description = "Teleporta direto para o trem",
    Callback = function()
        task.spawn(function()
            for i = 1, 4 do
                local train = workspace:FindFirstChild("Train") or workspace:WaitForChild("Train")

                local function getVehicleSeat()
                    for _, v in pairs(train:GetDescendants()) do
                        if v:IsA("VehicleSeat") then
                            return v
                        end
                    end
                    return nil
                end

                local seat = getVehicleSeat()
                if seat then
                    local char = game.Players.LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char:MoveTo(seat.Position + Vector3.new(0, 5, 0))
                    end
                end

                task.wait(0.5)
            end
        end)
    end
})

trainTab:AddParagraph({
      Title = "Em breve",
      Content = "Em breve terá mais funcionalidades por aqui!"
   })


local andtab = Window:AddTab({
    Title = "end game",
    Icon = "list"
})




andtab:AddButton({
    Title = "my tp to end",
    Description = "Teleport para o fim (não pacifista) feito por Lucas",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local runService = game:GetService("RunService")
        local camera = workspace.CurrentCamera

        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local targetPos = Vector3.new(-424.4, 28.1, -49040.7)

        task.spawn(function()
            for i = 1, 450 do
                hrp.CFrame = CFrame.new(targetPos)
                task.wait(0.02)
            end
        end)

        local aimLockLoop

        local function stopAimLock()
            if aimLockLoop then
                aimLockLoop:Disconnect()
                aimLockLoop = nil
            end
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
            end
        end

        local function startAimLock()
            stopAimLock()

            aimLockLoop = runService.RenderStepped:Connect(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

                local closestNPC = nil
                local closestDistance = math.huge

                for _, npc in ipairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc ~= player.Character and not Players:GetPlayerFromCharacter(npc) then
                        local humanoid = npc:FindFirstChildOfClass("Humanoid")
                        local hrp = npc:FindFirstChild("HumanoidRootPart")

                        if humanoid and hrp and humanoid.Health > 0 then
                            local distance = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestNPC = npc
                            end
                        end
                    end
                end

                if closestNPC then
                    camera.CameraSubject = closestNPC:FindFirstChildOfClass("Humanoid")
                else
                    camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
                end
            end)
        end

        player.CameraMode = Enum.CameraMode.Classic
        startAimLock()

        
        local noclip = true
        runService.Stepped:Connect(function()
            if noclip and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)

        local TweenService = game:GetService("TweenService")
        local humanoid = character:WaitForChild("Humanoid")

        task.delay(25, function()
            stopAimLock()
        end)
    end
})









   
andtab:AddParagraph({
      Title = "Em breve",
      Content = "Em breve terá mais funcionalidades por aqui!"
   })





BondsTab:AddParagraph({
      Title = "Em breve",
      Content = "Em breve terá mais funcionalidades por aqui!"
   })







local creditos = Window:AddTab({ Title = "Créditos", Icon = "list" })



creditos:AddParagraph({
    Title = "Créditos de Criação do Script (ringtaa):",
    Content = "As TPs da seção 'ringtaa', os TPs de Páscoa e a função de voo foram criados por ringtaa."
})

creditos:AddParagraph({
  Title = "Créditos de Criação do Script:",
  Content = "As funções de aimbot, end game, teleport (da minha seção) e visão foram desenvolvidas por Lucas."
})

creditos:AddParagraph({
  Title = " ",
  TextSize = 25,
  Content = "O sistema principal (exceto a função de voo) e train também foram feitos por Lucas."
})
