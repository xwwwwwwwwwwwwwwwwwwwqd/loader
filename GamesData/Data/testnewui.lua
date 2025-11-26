local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Mouse = LocalPlayer:GetMouse()

-- Configuration System
if not isfolder("NovaX") then
    makefolder("NovaX")
end
if not isfolder("NovaX/Config") then
    makefolder("NovaX/Config")
end

local gameName = tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
gameName = gameName:gsub("[^%w_ ]", ""):gsub("%s+", "_")
local ConfigFile = "NovaX/Config/Nova_" .. gameName .. ".json"

ConfigData = {}
Elements = {}
CURRENT_VERSION = nil

function SaveConfig()
    if writefile then
        ConfigData._version = CURRENT_VERSION
        writefile(ConfigFile, HttpService:JSONEncode(ConfigData))
    end
end

function LoadConfigFromFile()
    if not CURRENT_VERSION then return end
    if isfile and isfile(ConfigFile) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigFile))
        end)
        if success and type(result) == "table" then
            if result._version == CURRENT_VERSION then
                ConfigData = result
            else
                ConfigData = { _version = CURRENT_VERSION }
            end
        else
            ConfigData = { _version = CURRENT_VERSION }
        end
    else
        ConfigData = { _version = CURRENT_VERSION }
    end
end

function LoadConfigElements()
    for key, element in pairs(Elements) do
        if ConfigData[key] ~= nil and element.Set then
            element:Set(ConfigData[key], true)
        end
    end
end

-- Modern Icons
local Icons = {
    player = "rbxassetid://12120698352",
    settings = "rbxassetid://107349491331766",
    gamepad = "rbxassetid://107349491331766",
    sword = "rbxassetid://107349491331766",
    star = "rbxassetid://107349491331766",
    user = "rbxassetid://107349491331766",
    chart = "rbxassetid://107349491331766",
    shield = "rbxassetid://107349491331766",
    gear = "rbxassetid://107349491331766",
    home = "rbxassetid://107349491331766",
    search = "rbxassetid://107349491331766",
    bell = "rbxassetid://107349491331766",
    heart = "rbxassetid://107349491331766",
    flash = "rbxassetid://107349491331766",
    lock = "rbxassetid://107349491331766",
    unlock = "rbxassetid://107349491331766"
}

-- Utility Functions
local function isMobileDevice()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
end

local isMobile = isMobileDevice()

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- Modern Notification System
local NovaX = {}
function NovaX:Notify(NotifyConfig)
    local NotifyConfig = NotifyConfig or {}
    NotifyConfig.Title = NotifyConfig.Title or "Nova X"
    NotifyConfig.Message = NotifyConfig.Message or "Notification"
    NotifyConfig.Duration = NotifyConfig.Duration or 5
    NotifyConfig.Type = NotifyConfig.Type or "info" -- info, success, warning, error

    local typeColors = {
        info = Color3.fromRGB(0, 162, 255),
        success = Color3.fromRGB(0, 255, 127),
        warning = Color3.fromRGB(255, 193, 7),
        error = Color3.fromRGB(255, 87, 87)
    }

    spawn(function()
        if not CoreGui:FindFirstChild("NotificationHolder") then
            local NotificationHolder = Instance.new("ScreenGui")
            NotificationHolder.Name = "NotificationHolder"
            NotificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            NotificationHolder.Parent = CoreGui
        end

        local Notification = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local UIStroke = Instance.new("UIStroke")
        local Content = Instance.new("Frame")
        local Icon = Instance.new("ImageLabel")
        local TextContainer = Instance.new("Frame")
        local Title = Instance.new("TextLabel")
        local Message = Instance.new("TextLabel")
        local CloseButton = Instance.new("ImageButton")
        local ProgressBar = Instance.new("Frame")
        local ProgressFill = Instance.new("Frame")

        Notification.Name = "Notification"
        Notification.Parent = CoreGui.NotificationHolder
        Notification.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        Notification.BorderSizePixel = 0
        Notification.Size = UDim2.new(0, 320, 0, 80)
        Notification.Position = UDim2.new(1, 350, 0.1, 0)
        Notification.ClipsDescendants = true

        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = Notification

        UIStroke.Color = Color3.fromRGB(60, 60, 80)
        UIStroke.Thickness = 1
        UIStroke.Parent = Notification

        Content.Name = "Content"
        Content.Parent = Notification
        Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Content.BackgroundTransparency = 1
        Content.Size = UDim2.new(1, 0, 1, 0)

        Icon.Name = "Icon"
        Icon.Parent = Content
        Icon.BackgroundTransparency = 1
        Icon.Size = UDim2.new(0, 24, 0, 24)
        Icon.Position = UDim2.new(0, 15, 0, 15)
        Icon.Image = "rbxassetid://107349491331766"
        Icon.ImageColor3 = typeColors[NotifyConfig.Type]

        TextContainer.Name = "TextContainer"
        TextContainer.Parent = Content
        TextContainer.BackgroundTransparency = 1
        TextContainer.Position = UDim2.new(0, 50, 0, 12)
        TextContainer.Size = UDim2.new(1, -90, 1, -24)

        Title.Name = "Title"
        Title.Parent = TextContainer
        Title.BackgroundTransparency = 1
        Title.Size = UDim2.new(1, 0, 0, 20)
        Title.Font = Enum.Font.GothamSemibold
        Title.Text = NotifyConfig.Title
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left

        Message.Name = "Message"
        Message.Parent = TextContainer
        Message.BackgroundTransparency = 1
        Message.Position = UDim2.new(0, 0, 0, 22)
        Message.Size = UDim2.new(1, 0, 1, -22)
        Message.Font = Enum.Font.Gotham
        Message.Text = NotifyConfig.Message
        Message.TextColor3 = Color3.fromRGB(200, 200, 200)
        Message.TextSize = 12
        Message.TextXAlignment = Enum.TextXAlignment.Left
        Message.TextYAlignment = Enum.TextYAlignment.Top
        Message.TextWrapped = true

        CloseButton.Name = "CloseButton"
        CloseButton.Parent = Content
        CloseButton.BackgroundTransparency = 1
        CloseButton.Size = UDim2.new(0, 20, 0, 20)
        CloseButton.Position = UDim2.new(1, -30, 0, 12)
        CloseButton.Image = "rbxassetid://107349491331766"
        CloseButton.ImageColor3 = Color3.fromRGB(150, 150, 150)

        ProgressBar.Name = "ProgressBar"
        ProgressBar.Parent = Notification
        ProgressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        ProgressBar.BorderSizePixel = 0
        ProgressBar.Size = UDim2.new(1, 0, 0, 3)
        ProgressBar.Position = UDim2.new(0, 0, 1, -3)

        ProgressFill.Name = "ProgressFill"
        ProgressFill.Parent = ProgressBar
        ProgressFill.BackgroundColor3 = typeColors[NotifyConfig.Type]
        ProgressFill.BorderSizePixel = 0
        ProgressFill.Size = UDim2.new(1, 0, 1, 0)

        -- Animation
        local slideIn = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -350, 0.1, 0)
        })
        
        local progressTween = TweenService:Create(ProgressFill, TweenInfo.new(NotifyConfig.Duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 1, 0)
        })

        slideIn:Play()
        progressTween:Play()

        local function Close()
            local slideOut = TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, 350, 0.1, 0)
            })
            slideOut:Play()
            slideOut.Completed:Wait()
            Notification:Destroy()
        end

        CloseButton.MouseButton1Click:Connect(Close)
        
        delay(NotifyConfig.Duration, Close)
    end)
end

-- Main UI Window
function NovaX:Window(WindowConfig)
    WindowConfig = WindowConfig or {}
    WindowConfig.Name = WindowConfig.Name or "Nova X"
    WindowConfig.AccentColor = WindowConfig.AccentColor or Color3.fromRGB(0, 162, 255)
    WindowConfig.Size = WindowConfig.Size or UDim2.new(0, 600, 0, 400)
    WindowConfig.Theme = WindowConfig.Theme or "Dark" -- Dark, Light, Custom

    CURRENT_VERSION = WindowConfig.Version or 1
    LoadConfigFromFile()

    local Window = {}
    local Tabs = {}
    local CurrentTab = nil

    -- Create Main UI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NovaXUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = WindowConfig.Size
    MainContainer.Position = UDim2.new(0.5, -WindowConfig.Size.X.Offset/2, 0.5, -WindowConfig.Size.Y.Offset/2)
    MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainContainer.BorderSizePixel = 0
    MainContainer.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainContainer

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(50, 50, 70)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainContainer

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Header.BorderSizePixel = 0
    Header.Parent = MainContainer

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = WindowConfig.Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    Title.Position = UDim2.new(0, 20, 0, 0)

    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 80, 1, 0)
    Controls.Position = UDim2.new(1, -90, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = Header

    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(0, 10, 0.5, -15)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Image = "rbxassetid://107349491331766"
    MinimizeButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
    MinimizeButton.Parent = Controls

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton

    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(0, 50, 0.5, -15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 87, 87)
    CloseButton.BorderSizePixel = 0
    CloseButton.Image = "rbxassetid://107349491331766"
    CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Parent = Controls

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    -- Navigation
    local Navigation = Instance.new("Frame")
    Navigation.Name = "Navigation"
    Navigation.Size = UDim2.new(0, 180, 1, -50)
    Navigation.Position = UDim2.new(0, 0, 0, 50)
    Navigation.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Navigation.BorderSizePixel = 0
    Navigation.Parent = MainContainer

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = Navigation

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabContainer

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -180, 1, -50)
    ContentArea.Position = UDim2.new(0, 180, 0, 50)
    ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    ContentArea.BorderSizePixel = 0
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainContainer

    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, 0, 1, 0)
    PageContainer.BackgroundTransparency = 1
    PageContainer.Parent = ContentArea

    -- Make draggable
    MakeDraggable(Header, MainContainer)

    -- Control handlers
    MinimizeButton.MouseButton1Click:Connect(function()
        MainContainer.Visible = not MainContainer.Visible
    end)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Tab management
    function Window:CreateTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or "home"

        local Tab = {}
        local Sections = {}

        -- Create tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton"
        TabButton.Size = UDim2.new(1, -20, 0, 45)
        TabButton.Position = UDim2.new(0, 10, 0, 10 + (#Tabs * 50))
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        TabButton.BorderSizePixel = 0
        TabButton.Text = ""
        TabButton.Parent = TabContainer

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 15, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = Icons[TabConfig.Icon] or Icons.home
        TabIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        TabIcon.Parent = TabButton

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(1, -50, 1, 0)
        TabLabel.Position = UDim2.new(0, 45, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.Text = TabConfig.Name
        TabLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabLabel.TextSize = 14
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton

        local TabHighlight = Instance.new("Frame")
        TabHighlight.Name = "Highlight"
        TabHighlight.Size = UDim2.new(0, 3, 0.6, 0)
        TabHighlight.Position = UDim2.new(0, 0, 0.2, 0)
        TabHighlight.BackgroundColor3 = WindowConfig.AccentColor
        TabHighlight.BorderSizePixel = 0
        TabHighlight.Visible = false
        TabHighlight.Parent = TabButton

        local HighlightCorner = Instance.new("UICorner")
        HighlightCorner.CornerRadius = UDim.new(0, 2)
        HighlightCorner.Parent = TabHighlight

        -- Create tab content
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = TabConfig.Name
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 4
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.Visible = #Tabs == 0
        TabPage.Parent = PageContainer

        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 15)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = TabPage

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
        end)

        -- Tab selection
        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                CurrentTab.Button.Highlight.Visible = false
                TweenService:Create(CurrentTab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                }):Play()
                TweenService:Create(CurrentTab.Button.Icon, TweenInfo.new(0.2), {
                    ImageColor3 = Color3.fromRGB(150, 150, 150)
                }):Play()
                TweenService:Create(CurrentTab.Button.Label, TweenInfo.new(0.2), {
                    TextColor3 = Color3.fromRGB(200, 200, 200)
                }):Play()
                CurrentTab.Page.Visible = false
            end

            CurrentTab = Tab
            TabHighlight.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            }):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {
                ImageColor3 = WindowConfig.AccentColor
            }):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.2), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TabPage.Visible = true
        end)

        -- Update container size
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 10 + (#Tabs + 1) * 50)

        -- Section creation
        function Tab:CreateSection(SectionConfig)
            SectionConfig = SectionConfig or {}
            SectionConfig.Name = SectionConfig.Name or "Section"
            SectionConfig.LayoutOrder = SectionConfig.LayoutOrder or #Sections + 1

            local Section = {}
            local Elements = {}

            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section"
            SectionFrame.Size = UDim2.new(1, -30, 0, 50)
            SectionFrame.Position = UDim2.new(0, 15, 0, 15 + (#Sections * 65))
            SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            SectionFrame.BorderSizePixel = 0
            SectionFrame.LayoutOrder = SectionConfig.LayoutOrder
            SectionFrame.Parent = TabPage

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 10)
            SectionCorner.Parent = SectionFrame

            local SectionStroke = Instance.new("UIStroke")
            SectionStroke.Color = Color3.fromRGB(50, 50, 70)
            SectionStroke.Thickness = 1
            SectionStroke.Parent = SectionFrame

            local SectionHeader = Instance.new("Frame")
            SectionHeader.Name = "Header"
            SectionHeader.Size = UDim2.new(1, 0, 0, 40)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Parent = SectionFrame

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, -20, 1, 0)
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = SectionConfig.Name
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionHeader

            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, 0, 1, -40)
            SectionContent.Position = UDim2.new(0, 0, 0, 40)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = SectionFrame

            local ContentList = Instance.new("UIListLayout")
            ContentList.Padding = UDim.new(0, 8)
            ContentList.SortOrder = Enum.SortOrder.LayoutOrder
            ContentList.Parent = SectionContent

            ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, -30, 0, 40 + ContentList.AbsoluteContentSize.Y + 15)
            end)

            -- Element creation functions
            function Section:CreateButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Text = ButtonConfig.Text or "Button"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end

                local Button = Instance.new("TextButton")
                Button.Name = "Button"
                Button.Size = UDim2.new(1, -20, 0, 40)
                Button.Position = UDim2.new(0, 10, 0, 10 + (#Elements * 50))
                Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                Button.BorderSizePixel = 0
                Button.Text = ""
                Button.AutoButtonColor = false
                Button.LayoutOrder = #Elements + 1
                Button.Parent = SectionContent

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 8)
                ButtonCorner.Parent = Button

                local ButtonLabel = Instance.new("TextLabel")
                ButtonLabel.Name = "Label"
                ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
                ButtonLabel.BackgroundTransparency = 1
                ButtonLabel.Font = Enum.Font.GothamSemibold
                ButtonLabel.Text = ButtonConfig.Text
                ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ButtonLabel.TextSize = 14
                ButtonLabel.Parent = Button

                local ButtonStroke = Instance.new("UIStroke")
                ButtonStroke.Color = WindowConfig.AccentColor
                ButtonStroke.Thickness = 0
                ButtonStroke.Parent = Button

                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 75)
                    }):Play()
                    TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {
                        Thickness = 1
                    }):Play()
                end)

                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                    }):Play()
                    TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {
                        Thickness = 0
                    }):Play()
                end)

                Button.MouseButton1Click:Connect(function()
                    ButtonConfig.Callback()
                end)

                table.insert(Elements, Button)
                return Button
            end

            function Section:CreateToggle(ToggleConfig)
                ToggleConfig = ToggleConfig or {}
                ToggleConfig.Text = ToggleConfig.Text or "Toggle"
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end

                local configKey = "Toggle_" .. ToggleConfig.Text
                if ConfigData[configKey] ~= nil then
                    ToggleConfig.Default = ConfigData[configKey]
                end

                local Toggle = {}
                Toggle.Value = ToggleConfig.Default

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "Toggle"
                ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
                ToggleFrame.Position = UDim2.new(0, 10, 0, 10 + (#Elements * 50))
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.LayoutOrder = #Elements + 1
                ToggleFrame.Parent = SectionContent

                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Button"
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = ToggleConfig.Text
                ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame

                local ToggleSwitch = Instance.new("Frame")
                ToggleSwitch.Name = "Switch"
                ToggleSwitch.Size = UDim2.new(0, 50, 0, 25)
                ToggleSwitch.Position = UDim2.new(1, -55, 0.5, -12.5)
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                ToggleSwitch.BorderSizePixel = 0
                ToggleSwitch.Parent = ToggleFrame

                local SwitchCorner = Instance.new("UICorner")
                SwitchCorner.CornerRadius = UDim.new(1, 0)
                SwitchCorner.Parent = ToggleSwitch

                local ToggleKnob = Instance.new("Frame")
                ToggleKnob.Name = "Knob"
                ToggleKnob.Size = UDim2.new(0, 21, 0, 21)
                ToggleKnob.Position = UDim2.new(0, 2, 0.5, -10.5)
                ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleKnob.BorderSizePixel = 0
                ToggleKnob.Parent = ToggleSwitch

                local KnobCorner = Instance.new("UICorner")
                KnobCorner.CornerRadius = UDim.new(1, 0)
                KnobCorner.Parent = ToggleKnob

                function Toggle:Set(Value)
                    Toggle.Value = Value
                    if Value then
                        TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {
                            BackgroundColor3 = WindowConfig.AccentColor
                        }):Play()
                        TweenService:Create(ToggleKnob, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 27, 0.5, -10.5)
                        }):Play()
                    else
                        TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                        }):Play()
                        TweenService:Create(ToggleKnob, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 2, 0.5, -10.5)
                        }):Play()
                    end
                    
                    ToggleConfig.Callback(Value)
                    ConfigData[configKey] = Value
                    SaveConfig()
                end

                ToggleButton.MouseButton1Click:Connect(function()
                    Toggle:Set(not Toggle.Value)
                end)

                Toggle:Set(Toggle.Value)
                table.insert(Elements, ToggleFrame)
                Elements[configKey] = Toggle
                return Toggle
            end

            function Section:CreateSlider(SliderConfig)
                SliderConfig = SliderConfig or {}
                SliderConfig.Text = SliderConfig.Text or "Slider"
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Default = SliderConfig.Default or 50
                SliderConfig.Callback = SliderConfig.Callback or function() end

                local configKey = "Slider_" .. SliderConfig.Text
                if ConfigData[configKey] ~= nil then
                    SliderConfig.Default = ConfigData[configKey]
                end

                local Slider = {}
                Slider.Value = SliderConfig.Default

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "Slider"
                SliderFrame.Size = UDim2.new(1, -20, 0, 60)
                SliderFrame.Position = UDim2.new(0, 10, 0, 10 + (#Elements * 70))
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.LayoutOrder = #Elements + 1
                SliderFrame.Parent = SectionContent

                local SliderHeader = Instance.new("Frame")
                SliderHeader.Name = "Header"
                SliderHeader.Size = UDim2.new(1, 0, 0, 20)
                SliderHeader.BackgroundTransparency = 1
                SliderHeader.Parent = SliderFrame

                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.Size = UDim2.new(0.7, 0, 1, 0)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = SliderConfig.Text
                SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderHeader

                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "Value"
                SliderValue.Size = UDim2.new(0.3, 0, 1, 0)
                SliderValue.Position = UDim2.new(0.7, 0, 0, 0)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Font = Enum.Font.GothamSemibold
                SliderValue.Text = tostring(SliderConfig.Default)
                SliderValue.TextColor3 = WindowConfig.AccentColor
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderHeader

                local SliderTrack = Instance.new("Frame")
                SliderTrack.Name = "Track"
                SliderTrack.Size = UDim2.new(1, 0, 0, 6)
                SliderTrack.Position = UDim2.new(0, 0, 0, 30)
                SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Parent = SliderFrame

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderTrack

                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
                SliderFill.BackgroundColor3 = WindowConfig.AccentColor
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderTrack

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                local SliderThumb = Instance.new("Frame")
                SliderThumb.Name = "Thumb"
                SliderThumb.Size = UDim2.new(0, 16, 0, 16)
                SliderThumb.Position = UDim2.new(0.5, -8, 0.5, -8)
                SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderThumb.BorderSizePixel = 0
                SliderThumb.Parent = SliderTrack

                local ThumbCorner = Instance.new("UICorner")
                ThumbCorner.CornerRadius = UDim.new(1, 0)
                ThumbCorner.Parent = SliderThumb

                local ThumbStroke = Instance.new("UIStroke")
                ThumbStroke.Color = WindowConfig.AccentColor
                ThumbStroke.Thickness = 2
                ThumbStroke.Parent = SliderThumb

                local Dragging = false

                function Slider:Set(Value)
                    Value = math.clamp(Value, SliderConfig.Min, SliderConfig.Max)
                    Slider.Value = Value
                    
                    local percentage = (Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    SliderThumb.Position = UDim2.new(percentage, -8, 0.5, -8)
                    SliderValue.Text = tostring(Value)
                    
                    SliderConfig.Callback(Value)
                    ConfigData[configKey] = Value
                    SaveConfig()
                end

                local function UpdateSliderFromInput(input)
                    local relativeX = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                    local percentage = math.clamp(relativeX, 0, 1)
                    local value = SliderConfig.Min + (percentage * (SliderConfig.Max - SliderConfig.Min))
                    Slider:Set(value)
                end

                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = true
                        UpdateSliderFromInput(input)
                    end
                end)

                SliderTrack.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSliderFromInput(input)
                    end
                end)

                Slider:Set(Slider.Value)
                table.insert(Elements, SliderFrame)
                Elements[configKey] = Slider
                return Slider
            end

            function Section:CreateDropdown(DropdownConfig)
                DropdownConfig = DropdownConfig or {}
                DropdownConfig.Text = DropdownConfig.Text or "Dropdown"
                DropdownConfig.Options = DropdownConfig.Options or {}
                DropdownConfig.Default = DropdownConfig.Default or DropdownConfig.Options[1]
                DropdownConfig.Callback = DropdownConfig.Callback or function() end

                local configKey = "Dropdown_" .. DropdownConfig.Text
                if ConfigData[configKey] ~= nil then
                    DropdownConfig.Default = ConfigData[configKey]
                end

                local Dropdown = {}
                Dropdown.Value = DropdownConfig.Default
                Dropdown.Options = DropdownConfig.Options

                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = "Dropdown"
                DropdownFrame.Size = UDim2.new(1, -20, 0, 40)
                DropdownFrame.Position = UDim2.new(0, 10, 0, 10 + (#Elements * 50))
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.LayoutOrder = #Elements + 1
                DropdownFrame.Parent = SectionContent
                DropdownFrame.ClipsDescendants = true

                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 8)
                DropdownCorner.Parent = DropdownFrame

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Text = ""
                DropdownButton.Parent = DropdownFrame

                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.Size = UDim2.new(1, -40, 1, 0)
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.Text = DropdownConfig.Text
                DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownLabel.TextSize = 14
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame

                local DropdownValue = Instance.new("TextLabel")
                DropdownValue.Name = "Value"
                DropdownValue.Size = UDim2.new(0.6, -10, 1, 0)
                DropdownValue.Position = UDim2.new(0.4, 10, 0, 0)
                DropdownValue.BackgroundTransparency = 1
                DropdownValue.Font = Enum.Font.Gotham
                DropdownValue.Text = tostring(DropdownConfig.Default or "")
                DropdownValue.TextColor3 = WindowConfig.AccentColor
                DropdownValue.TextSize = 14
                DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
                DropdownValue.Parent = DropdownFrame

                local DropdownIcon = Instance.new("ImageLabel")
                DropdownIcon.Name = "Icon"
                DropdownIcon.Size = UDim2.new(0, 20, 0, 20)
                DropdownIcon.Position = UDim2.new(1, -25, 0.5, -10)
                DropdownIcon.BackgroundTransparency = 1
                DropdownIcon.Image = "rbxassetid://107349491331766"
                DropdownIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
                DropdownIcon.Rotation = 0
                DropdownIcon.Parent = DropdownFrame

                local OptionsFrame = Instance.new("Frame")
                OptionsFrame.Name = "Options"
                OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
                OptionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                OptionsFrame.BorderSizePixel = 0
                OptionsFrame.Visible = false
                OptionsFrame.Parent = DropdownFrame

                local OptionsCorner = Instance.new("UICorner")
                OptionsCorner.CornerRadius = UDim.new(0, 8)
                OptionsCorner.Parent = OptionsFrame

                local OptionsList = Instance.new("UIListLayout")
                OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
                OptionsList.Parent = OptionsFrame

                local Open = false

                function Dropdown:Set(Value)
                    Dropdown.Value = Value
                    DropdownValue.Text = tostring(Value)
                    DropdownConfig.Callback(Value)
                    ConfigData[configKey] = Value
                    SaveConfig()
                end

                function Dropdown:RefreshOptions(NewOptions)
                    Dropdown.Options = NewOptions
                    for _, child in ipairs(OptionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for i, option in ipairs(NewOptions) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Name = "Option"
                        OptionButton.Size = UDim2.new(1, 0, 0, 35)
                        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                        OptionButton.BorderSizePixel = 0
                        OptionButton.Text = ""
                        OptionButton.AutoButtonColor = false
                        OptionButton.LayoutOrder = i
                        OptionButton.Parent = OptionsFrame

                        local OptionCorner = Instance.new("UICorner")
                        OptionCorner.CornerRadius = UDim.new(0, 6)
                        OptionCorner.Parent = OptionButton

                        local OptionLabel = Instance.new("TextLabel")
                        OptionLabel.Name = "Label"
                        OptionLabel.Size = UDim2.new(1, -20, 1, 0)
                        OptionLabel.Position = UDim2.new(0, 10, 0, 0)
                        OptionLabel.BackgroundTransparency = 1
                        OptionLabel.Font = Enum.Font.Gotham
                        OptionLabel.Text = tostring(option)
                        OptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        OptionLabel.TextSize = 14
                        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                        OptionLabel.Parent = OptionButton

                        OptionButton.MouseEnter:Connect(function()
                            TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                                BackgroundColor3 = Color3.fromRGB(50, 50, 75)
                            }):Play()
                        end)

                        OptionButton.MouseLeave:Connect(function()
                            TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                                BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                            }):Play()
                        end)

                        OptionButton.MouseButton1Click:Connect(function()
                            Dropdown:Set(option)
                            Open = false
                            OptionsFrame.Visible = false
                            TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {
                                Size = UDim2.new(1, 0, 0, 0)
                            }):Play()
                            TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {
                                Rotation = 0
                            }):Play()
                        end)
                    end
                end

                DropdownButton.MouseButton1Click:Connect(function()
                    Open = not Open
                    if Open then
                        OptionsFrame.Visible = true
                        local optionCount = #Dropdown.Options
                        TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, optionCount * 35 + (optionCount - 1) * 5)
                        }):Play()
                        TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {
                            Rotation = 180
                        }):Play()
                    else
                        TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 0)
                        }):Play()
                        TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {
                            Rotation = 0
                        }):Play()
                        wait(0.2)
                        OptionsFrame.Visible = false
                    end
                end)

                Dropdown:RefreshOptions(Dropdown.Options)
                Dropdown:Set(Dropdown.Value)
                table.insert(Elements, DropdownFrame)
                Elements[configKey] = Dropdown
                return Dropdown
            end

            table.insert(Sections, Section)
            return Section
        end

        -- Set as first tab if no tabs exist
        if #Tabs == 0 then
            CurrentTab = Tab
            TabHighlight.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            TabIcon.ImageColor3 = WindowConfig.AccentColor
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        Tab.Button = TabButton
        Tab.Page = TabPage
        table.insert(Tabs, Tab)
        return Tab
    end

    -- Load configuration after UI is built
    spawn(function()
        wait(0.5)
        LoadConfigElements()
    end)

    return Window
end

-- Toggle UI key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        local ui = CoreGui:FindFirstChild("NovaXUI")
        if ui then
            ui.Enabled = not ui.Enabled
        end
    end
end)

return NovaX