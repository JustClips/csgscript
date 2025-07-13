--// Eps1llon Hub 2025 | Complete Full Script - All Features
--// Updated: 2025-07-12 23:18:49 UTC | Author: JustClips | User: JustClips

-- 1. LOAD EXTERNAL CHAT SYSTEM FIRST
if shared.Eps1llonHub then
    return warn("Cheat already loaded")
end

shared.Eps1llonHub = true

pcall(function()
    loadstring(game:HttpGet("https://pastebin.com/raw/VgbrkkM2"))()
end)

-- 2. Services and Globals
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local animals = workspace.Map.Resources.Animals

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=title, Text=text, Duration=3})
    end)
end

-- 3. Load UI Library
local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/Eps1llonUI/refs/heads/main/UILibrary.lua"))()

-- Load the Utility module via HTTP and execute it
local utility = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/csgscript/refs/heads/main/module/Utility.lua"))()

-- 4. Animation Presets and Gradients
local AnimationPresets = {
    toggleOn = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    toggleOff = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    sliderMove = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    buttonHover = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    buttonClick = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    guiResize = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    colorShift = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
}

local premiumGradientColors = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 255, 230))
}

local combatGradientColors = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 170, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 200, 255))
}

-- 5. Section Setup with Centered Headers
local sectionNames = {"Configuration","Combat","ESP","Inventory","Misc","Script Chat","UI Settings"}
local iconData = {
    Configuration = "134572329997100",
    Combat = "94883448905030",
    ESP = "92313485402528",
    Inventory = "135628846657243",
    Misc = "121583805460244",
    ["Script Chat"] = "15577991768",
    ["UI Settings"] = "93991072023597",
}

local sections = {}
for _, name in ipairs(sectionNames) do
    sections[name] = UILib:GetSection(name)
end

for name, section in pairs(sections) do
    for _, c in ipairs(section:GetChildren()) do
        if c:IsA("TextLabel") and c.Name == "__SectionTitle" then c:Destroy() end
        if c:IsA("ImageLabel") and c.Name == "__SectionIcon" then c:Destroy() end
        if c:IsA("Frame") and c.Name == "__SectionHeaderContainer" then c:Destroy() end
    end
    
    local header = Instance.new("Frame")
    header.Name = "__SectionHeaderContainer"
    header.Size = UDim2.new(1, -40, 0, 38)
    header.Position = UDim2.new(0, 20, 0, 10)
    header.BackgroundTransparency = 1
    header.Parent = section
    
    local layout = Instance.new("UIListLayout", header)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 6)
    
    local icon = Instance.new("ImageLabel")
    icon.Name = "__SectionIcon"
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.BackgroundTransparency = 1
    icon.Image = iconData[name] and ("rbxassetid://"..iconData[name]) or ""
    icon.ImageColor3 = Color3.fromRGB(74, 177, 255)
    icon.Parent = header
    
    coroutine.wrap(function()
        while true do
            TweenService:Create(icon, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.3}):Play()
            wait(2)
            TweenService:Create(icon, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0}):Play()
            wait(2)
        end
    end)()
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "__SectionTitle"
    sectionTitle.Size = UDim2.new(0, 200, 1, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = name
    sectionTitle.TextColor3 = Color3.fromRGB(215, 235, 255)
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextSize = 24
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.TextYAlignment = Enum.TextYAlignment.Center
    sectionTitle.Parent = header
    
    local titleGlow = sectionTitle:Clone()
    titleGlow.Name = "__TitleGlow"
    titleGlow.TextColor3 = Color3.fromRGB(74, 177, 255)
    titleGlow.TextTransparency = 0.8
    titleGlow.ZIndex = sectionTitle.ZIndex - 1
    titleGlow.Parent = header
end

-- Layout Constants
local ROW_Y_START = 60
local ROW_Y_SPACING = 50
local ROW_HEIGHT = 42
local SLIDER_WIDTH = 140
local SLIDER_HEIGHT = 30
local TOGGLE_OFFSET_X = 280

-- 7. Configuration Tab: Speedwalk, JumpPower, Inf Water
local speedwalkEnabled, currentSpeed = false, 12
do
    local section = sections["Configuration"]
    
    -- Speedwalk
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, ROW_HEIGHT)
    row.Position = UDim2.new(0, 20, 0, ROW_Y_START)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 13)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(74, 177, 255)
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 15)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 100, 1, 0)
    label.Position = UDim2.new(0, 13, 0, 0)
    label.Text = "Walkspeed"
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local min, max, default = 4, 15, 12
    local sliderPill = Instance.new("Frame", row)
    sliderPill.Size = UDim2.new(0, SLIDER_WIDTH, 0, SLIDER_HEIGHT)
    sliderPill.Position = UDim2.new(0, 115, 0.5, -SLIDER_HEIGHT/2)
    sliderPill.BackgroundColor3 = Color3.fromRGB(33, 41, 57)
    sliderPill.BorderSizePixel = 0
    Instance.new("UICorner", sliderPill).CornerRadius = UDim.new(1, 999)
    
    local pillShadow = Instance.new("ImageLabel", sliderPill)
    pillShadow.BackgroundTransparency = 1
    pillShadow.Image = "rbxassetid://1316045217"
    pillShadow.Size = UDim2.new(1, 8, 1, 8)
    pillShadow.Position = UDim2.new(0, -4, 0, -2)
    pillShadow.ImageTransparency = 0.78
    pillShadow.ZIndex = 0
    
    local sliderFill = Instance.new("Frame", sliderPill)
    sliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 2
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 999)
    
    local grad = Instance.new("UIGradient", sliderFill)
    grad.Color = premiumGradientColors
    
    local valueLabel = Instance.new("TextLabel", sliderPill)
    valueLabel.Size = UDim2.new(0, 48, 1, 0)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 3
    
    utility:setupEnhancedSliderDrag(sliderFill, sliderPill, min, max, function(val, percent)
        currentSpeed = val
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(74, 177, 255)
        }):Play()
        valueLabel.Text = tostring(val)
        wait(0.1)
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(220, 240, 255)
        }):Play()
    end)
    
    local setToggle = utility:createEnhancedToggle(row, UDim2.new(0, TOGGLE_OFFSET_X, 0.5, -10), function(val)
        speedwalkEnabled = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
    end)
end

RunService.RenderStepped:Connect(function(dt)
    if speedwalkEnabled then
        local c = player.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            local r = c:FindFirstChild("HumanoidRootPart")
            if h and r then
                local d = h.MoveDirection
                if d.Magnitude > .1 then
                    r.CFrame += d.Unit * currentSpeed * dt
                end
            end
        end
    end
end)

-- JumpPower
local jumppowerEnabled, currentJump, lastJump = false, 50, 0
do
    local section = sections["Configuration"]
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, ROW_HEIGHT)
    row.Position = UDim2.new(0, 20, 0, ROW_Y_START + ROW_Y_SPACING)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 13)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(74, 177, 255)
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 15)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 100, 1, 0)
    label.Position = UDim2.new(0, 13, 0, 0)
    label.Text = "JumpPower"
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local min, max, default = 5, 100, 50
    local sliderPill = Instance.new("Frame", row)
    sliderPill.Size = UDim2.new(0, SLIDER_WIDTH, 0, SLIDER_HEIGHT)
    sliderPill.Position = UDim2.new(0, 115, 0.5, -SLIDER_HEIGHT/2)
    sliderPill.BackgroundColor3 = Color3.fromRGB(33, 41, 57)
    sliderPill.BorderSizePixel = 0
    Instance.new("UICorner", sliderPill).CornerRadius = UDim.new(1, 999)
    
    local sliderFill = Instance.new("Frame", sliderPill)
    sliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 2
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 999)
    
    local grad = Instance.new("UIGradient", sliderFill)
    grad.Color = premiumGradientColors
    
    local valueLabel = Instance.new("TextLabel", sliderPill)
    valueLabel.Size = UDim2.new(0, 48, 1, 0)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 3
    
    utility:setupEnhancedSliderDrag(sliderFill, sliderPill, min, max, function(val, percent)
        currentJump = val
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(74, 177, 255)
        }):Play()
        valueLabel.Text = tostring(val)
        wait(0.1)
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(220, 240, 255)
        }):Play()
    end)
    
    local setToggle = utility:createEnhancedToggle(row, UDim2.new(0, TOGGLE_OFFSET_X, 0.5, -10), function(val)
        jumppowerEnabled = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
    end)
end

RunService.RenderStepped:Connect(function()
    if jumppowerEnabled then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart and humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                if tick() - lastJump > 0.15 then
                    rootPart.Velocity = Vector3.new(rootPart.Velocity.X, currentJump, rootPart.Velocity.Z)
                    lastJump = tick()
                end
            end
        end
    end
end)

-- Inf Water Toggle
local infWaterEnabled = false
local infWaterConnection = nil

do
    local section = sections["Configuration"]
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, ROW_HEIGHT)
    row.Position = UDim2.new(0, 20, 0, ROW_Y_START + ROW_Y_SPACING * 2)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 13)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 15)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 160, 1, 0)
    label.Position = UDim2.new(0, 13, 0, 0)
    label.Text = "Inf Water"
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local setInfWaterToggle = utility:createEnhancedToggle(row, UDim2.new(0, 177, 0.5, -10), function(val)
        infWaterEnabled = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
        
        TweenService:Create(label, AnimationPresets.colorShift, {
            TextColor3 = val and Color3.fromRGB(30, 144, 255) or Color3.fromRGB(230, 230, 240)
        }):Play()
        
        if val then
            if infWaterConnection then infWaterConnection:Disconnect() end
            infWaterConnection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local remote = ReplicatedStorage:FindFirstChild("WaterSource")
                    if remote then
                        remote:FireServer("Drank")
                    end
                end)
            end)
            notify("Eps1llon Hub", "💧 Infinite Water enabled!")
        else
            if infWaterConnection then
                infWaterConnection:Disconnect()
                infWaterConnection = nil
            end
            notify("Eps1llon Hub", "💧 Infinite Water disabled!")
        end
    end)
end

-- 8. Combat Tab: Reach Expander & Auto Hit
local reachEnabled, reachRadius = false, 12
local autoHitEnabled = false

do
    local section = sections["Combat"]
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -40, 0, ROW_HEIGHT)
    row.Position = UDim2.new(0, 20, 0, ROW_Y_START)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 13)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(74, 177, 255)
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 15)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0, 115, 1, 0)
    label.Position = UDim2.new(0, 13, 0, 0)
    label.Text = "Reach Radius"
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local min, max, default = 5, 15, 12
    local sliderPill = Instance.new("Frame", row)
    sliderPill.Size = UDim2.new(0, SLIDER_WIDTH, 0, SLIDER_HEIGHT)
    sliderPill.Position = UDim2.new(0, 130, 0.5, -SLIDER_HEIGHT/2)
    sliderPill.BackgroundColor3 = Color3.fromRGB(33, 41, 57)
    sliderPill.BorderSizePixel = 0
    Instance.new("UICorner", sliderPill).CornerRadius = UDim.new(1, 999)
    
    local sliderFill = Instance.new("Frame", sliderPill)
    sliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 2
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 999)
    
    local combatGrad = Instance.new("UIGradient", sliderFill)
    combatGrad.Color = combatGradientColors
    
    local valueLabel = Instance.new("TextLabel", sliderPill)
    valueLabel.Size = UDim2.new(0, 48, 1, 0)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 3
    
    utility:setupEnhancedSliderDrag(sliderFill, sliderPill, min, max, function(val, percent)
        reachRadius = val
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(74, 177, 255)
        }):Play()
        valueLabel.Text = tostring(val)
        wait(0.1)
        TweenService:Create(valueLabel, AnimationPresets.colorShift, {
            TextColor3 = Color3.fromRGB(220, 240, 255)
        }):Play()
    end)
    
    local setToggle = utility:createEnhancedToggle(row, UDim2.new(0, TOGGLE_OFFSET_X + 10, 0.5, -10), function(val)
        reachEnabled = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
    end)

    local row2 = Instance.new("Frame")
    row2.Size = UDim2.new(1, -40, 0, ROW_HEIGHT)
    row2.Position = UDim2.new(0, 20, 0, ROW_Y_START + ROW_Y_SPACING)
    row2.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row2.BackgroundTransparency = 0.08
    row2.BorderSizePixel = 0
    Instance.new("UICorner", row2).CornerRadius = UDim.new(0, 13)
    row2.Parent = section
    
    local rowGlow2 = Instance.new("Frame")
    rowGlow2.Size = UDim2.new(1, 4, 1, 4)
    rowGlow2.Position = UDim2.new(0, -2, 0, -2)
    rowGlow2.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    rowGlow2.BackgroundTransparency = 0.95
    rowGlow2.BorderSizePixel = 0
    rowGlow2.ZIndex = row2.ZIndex - 1
    rowGlow2.Parent = row2
    Instance.new("UICorner", rowGlow2).CornerRadius = UDim.new(0, 15)
    
    local label2 = Instance.new("TextLabel", row2)
    label2.Size = UDim2.new(0, 145, 1, 0)
    label2.Position = UDim2.new(0, 13, 0, 0)
    label2.Text = "Auto Hit"
    label2.TextColor3 = Color3.fromRGB(230, 230, 240)
    label2.BackgroundTransparency = 1
    label2.Font = Enum.Font.GothamBold
    label2.TextSize = 16
    label2.TextXAlignment = Enum.TextXAlignment.Left
    
    local setAutoHit = utility:createEnhancedToggle(row2, UDim2.new(0, 149, 0.5, -10), function(val)
        autoHitEnabled = val
        TweenService:Create(rowGlow2, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.85 or 0.95
        }):Play()
    end)
end

--// HITBOX EXPANDER MECHANIC
local function expandHitbox(tool)
    local hitbox = tool:FindFirstChild("Hitbox", true)
    local handle = tool:FindFirstChild("Handle")
    if hitbox and handle and hitbox:IsA("BasePart") and handle:IsA("BasePart") then
        hitbox.Size = Vector3.new(reachRadius*2, reachRadius*2, reachRadius*2)
        hitbox.Massless = true
        hitbox.CanCollide = false
        hitbox.Transparency = 1
        for _,c in ipairs(hitbox:GetChildren()) do
            if c:IsA("SpecialMesh") or c:IsA("Weld") or c:IsA("WeldConstraint") or c:IsA("BoxHandleAdornment") then
                c:Destroy()
            end
        end
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = hitbox
        weld.Parent = hitbox
    end
end

local function trackTool(tool)
    expandHitbox(tool)
    if tool:IsA("Tool") then
        tool.Equipped:Connect(function() expandHitbox(tool) end)
        tool.Unequipped:Connect(function() expandHitbox(tool) end)
    end
end

local function updateHitboxes()
    if player.Character then
        for _,tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then expandHitbox(tool) end
        end
    end
end

local function initHitboxSystem()
    if player.Character then
        for _,tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then trackTool(tool) end
        end
        player.Character.ChildAdded:Connect(function(c)
            if c:IsA("Tool") then wait(0.1) trackTool(c) end
        end)
    end
    player.CharacterAdded:Connect(function(ch)
        for _,tool in ipairs(ch:GetChildren()) do
            if tool:IsA("Tool") then trackTool(tool) end
        end
        ch.ChildAdded:Connect(function(c)
            if c:IsA("Tool") then wait(0.1) trackTool(c) end
        end)
    end)
end

local hitboxConn
local function enableReachSystem(val)
    if val then
        if not hitboxConn then
            hitboxConn = RunService.RenderStepped:Connect(updateHitboxes)
        end
        initHitboxSystem()
    else
        if hitboxConn then hitboxConn:Disconnect() hitboxConn = nil end
    end
end

coroutine.wrap(function()
    local prevEnabled = false
    while true do
        if reachEnabled ~= prevEnabled then
            enableReachSystem(reachEnabled)
            prevEnabled = reachEnabled
        end
        wait(0.22)
    end
end)()

coroutine.wrap(function()
    while true do
        if autoHitEnabled and player.Character then
            local tool = nil
            for _,v in ipairs(player.Character:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    tool = v
                    break
                end
            end
            if tool and tool.Activate then
                pcall(function() tool:Activate() end)
            end
        end
        wait(0.12)
    end
end)()

local espSettings = loadstring(game:HttpGet("https://raw.githubusercontent.com/JustClips/csgscript/refs/heads/main/module/Esp.lua"))(sections)

-- 10. Inventory Tab: Enhanced Smart Grabtools
local targetToolNames = {}
local grabtoolsConnection = nil
local toolCountDisplay = nil
local toolListFrame = nil
local toolListLabels = {}

local function shouldPickupTool(toolName)
    if #targetToolNames == 0 then return false end
    for _, targetName in ipairs(targetToolNames) do
        if string.lower(toolName):find(string.lower(targetName)) then return true end
    end
    return false
end

local function parseToolNames(inputText)
    local names = {}
    if inputText == "" then return names end
    for name in string.gmatch(inputText, "([^,]+)") do
        local trimmedName = string.match(name, "^%s*(.-)%s*$")
        if trimmedName ~= "" then table.insert(names, trimmedName) end
    end
    return names
end

local function getToolCounts()
    local toolCounts = {}
    local totalTools = 0
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Tool") and child:FindFirstChild("Handle") then
            local toolName = child.Name
            toolCounts[toolName] = (toolCounts[toolName] or 0) + 1
            totalTools = totalTools + 1
        end
    end
    return toolCounts, totalTools
end

local function equipSpecificTool(toolName)
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Tool") and child:FindFirstChild("Handle") and child.Name == toolName then
            humanoid:EquipTool(child)
            notify("Eps1llon Hub", "✅ Grabbed " .. toolName)
            return true
        end
    end
    return false
end

local function equipTools()
    if #targetToolNames == 0 then return end
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    for _, child in ipairs(workspace:GetChildren()) do
        if player.Character and child:IsA("Tool") and child:FindFirstChild("Handle") then
            if shouldPickupTool(child.Name) then
                humanoid:EquipTool(child)
                wait(0.05)
            end
        end
    end
end

local function updateToolCountDisplay()
    if not toolCountDisplay then return end
    
    local toolCounts, totalTools = getToolCounts()
    
    if totalTools > 0 then
        local targetText = #targetToolNames > 0 and " (Targeting: " .. #targetToolNames .. ")" or ""
        toolCountDisplay.Text = "Tools Available: " .. totalTools .. targetText
        toolCountDisplay.TextColor3 = Color3.fromRGB(74, 177, 255)
    else
        toolCountDisplay.Text = "No Tools Available"
        toolCountDisplay.TextColor3 = Color3.fromRGB(120, 120, 120)
    end
end

local function getCows()
    local cows = {}

    for _, v in animals:GetChildren() do
        if string.lower(v.Name) == "cow" then
            table.insert(cows, v)
        end
    end

    for _, v in workspace:GetChildren() do
        if string.lower(v.Name) == "cow" then
            table.insert(cows, v)
        end
    end

    return cows
end

local function updateToolList()
    if not toolListFrame then return end
    
    for _, label in pairs(toolListLabels) do
        if label then label:Destroy() end
    end
    toolListLabels = {}
    
    local toolCounts, totalTools = getToolCounts()
    local yOffset = 5
    
    if totalTools == 0 then
        local noToolsLabel = Instance.new("TextLabel")
        noToolsLabel.Size = UDim2.new(1, -10, 0, 20)
        noToolsLabel.Position = UDim2.new(0, 5, 0, yOffset)
        noToolsLabel.Text = "No tools found in workspace"
        noToolsLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        noToolsLabel.BackgroundTransparency = 1
        noToolsLabel.Font = Enum.Font.Gotham
        noToolsLabel.TextSize = 12
        noToolsLabel.TextXAlignment = Enum.TextXAlignment.Center
        noToolsLabel.Parent = toolListFrame
        table.insert(toolListLabels, noToolsLabel)
        return
    end
    
    local sortedTools = {}
    for toolName, count in pairs(toolCounts) do
        table.insert(sortedTools, {name = toolName, count = count})
    end
    table.sort(sortedTools, function(a, b) return a.name < b.name end)
    
    local maxItems = 5
    local itemsToShow = math.min(#sortedTools, maxItems)
    
    for i = 1, itemsToShow do
        local toolData = sortedTools[i]
        local itemFrame = Instance.new("TextButton")
        itemFrame.Size = UDim2.new(1, -10, 0, 18)
        itemFrame.Position = UDim2.new(0, 5, 0, yOffset)
        itemFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
        itemFrame.BackgroundTransparency = 0.3
        itemFrame.BorderSizePixel = 0
        itemFrame.Text = ""
        Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 4)
        itemFrame.Parent = toolListFrame
        
        local toolNameLabel = Instance.new("TextLabel")
        toolNameLabel.Size = UDim2.new(1, -35, 1, 0)
        toolNameLabel.Position = UDim2.new(0, 5, 0, 0)
        toolNameLabel.Text = toolData.name
        toolNameLabel.TextColor3 = shouldPickupTool(toolData.name) and Color3.fromRGB(74, 177, 255) or Color3.fromRGB(200, 200, 200)
        toolNameLabel.BackgroundTransparency = 1
        toolNameLabel.Font = Enum.Font.Gotham
        toolNameLabel.TextSize = 10
        toolNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        toolNameLabel.Parent = itemFrame
        
        local countLabel = Instance.new("TextLabel")
        countLabel.Size = UDim2.new(0, 30, 1, 0)
        countLabel.Position = UDim2.new(1, -30, 0, 0)
        countLabel.Text = "x" .. toolData.count
        countLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        countLabel.BackgroundTransparency = 1
        countLabel.Font = Enum.Font.GothamBold
        countLabel.TextSize = 9
        countLabel.TextXAlignment = Enum.TextXAlignment.Right
        countLabel.Parent = itemFrame
        
        itemFrame.MouseEnter:Connect(function()
            TweenService:Create(itemFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
            TweenService:Create(toolNameLabel, TweenInfo.new(0.15), {TextSize = 11}):Play()
        end)
        
        itemFrame.MouseLeave:Connect(function()
            TweenService:Create(itemFrame, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
            TweenService:Create(toolNameLabel, TweenInfo.new(0.15), {TextSize = 10}):Play()
        end)
        
        itemFrame.MouseButton1Click:Connect(function()
            local success = equipSpecificTool(toolData.name)
            if success then
                TweenService:Create(itemFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(74, 177, 255)}):Play()
                wait(0.1)
                TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 22, 26)}):Play()
                updateToolList()
            end
        end)
        
        table.insert(toolListLabels, itemFrame)
        yOffset = yOffset + 20
    end
    
    if #sortedTools > maxItems then
        local moreLabel = Instance.new("TextLabel")
        moreLabel.Size = UDim2.new(1, -10, 0, 16)
        moreLabel.Position = UDim2.new(0, 5, 0, yOffset)
        moreLabel.Text = "... and " .. (#sortedTools - maxItems) .. " more tools"
        moreLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        moreLabel.BackgroundTransparency = 1
        moreLabel.Font = Enum.Font.Gotham
        moreLabel.TextSize = 9
        moreLabel.TextXAlignment = Enum.TextXAlignment.Center
        moreLabel.Parent = toolListFrame
        table.insert(toolListLabels, moreLabel)
        yOffset = yOffset + 18
    end
    
    toolListFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 5)
end

do
    local section = sections["Inventory"]
    
    -- Enhanced Input Row with glow
    local inputRow = Instance.new("Frame")
    inputRow.Size = UDim2.new(1, -40, 0, 48)
    inputRow.Position = UDim2.new(0, 20, 0, ROW_Y_START)
    inputRow.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    inputRow.BackgroundTransparency = 0.08
    inputRow.BorderSizePixel = 0
    Instance.new("UICorner", inputRow).CornerRadius = UDim.new(0, 13)
    inputRow.Parent = section
    
    local inputGlow = Instance.new("Frame")
    inputGlow.Size = UDim2.new(1, 4, 1, 4)
    inputGlow.Position = UDim2.new(0, -2, 0, -2)
    inputGlow.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    inputGlow.BackgroundTransparency = 0.95
    inputGlow.BorderSizePixel = 0
    inputGlow.ZIndex = inputRow.ZIndex - 1
    inputGlow.Parent = inputRow
    Instance.new("UICorner", inputGlow).CornerRadius = UDim.new(0, 15)
    
    local inputLabel = Instance.new("TextLabel", inputRow)
    inputLabel.Size = UDim2.new(1, -20, 0, 20)
    inputLabel.Position = UDim2.new(0, 13, 0, 2)
    inputLabel.Text = "Target Tools (comma separated)"
    inputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Font = Enum.Font.Gotham
    inputLabel.TextSize = 12
    inputLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local toolInput = Instance.new("TextBox", inputRow)
    toolInput.Size = UDim2.new(1, -86, 0, 24)
    toolInput.Position = UDim2.new(0, 13, 0, 22)
    toolInput.PlaceholderText = "e.g: Spear, Stick"
    toolInput.Text = ""
    toolInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    toolInput.BackgroundColor3 = Color3.fromRGB(33, 41, 57)
    toolInput.BorderSizePixel = 0
    toolInput.Font = Enum.Font.Gotham
    toolInput.TextSize = 14
    toolInput.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", toolInput).CornerRadius = UDim.new(0, 8)
    
    local updateBtn = Instance.new("TextButton", inputRow)
    updateBtn.Size = UDim2.new(0, 60, 0, 24)
    updateBtn.Position = UDim2.new(1, -73, 0, 22)
    updateBtn.Text = "Update"
    updateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    updateBtn.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    updateBtn.BorderSizePixel = 0
    updateBtn.Font = Enum.Font.GothamBold
    updateBtn.TextSize = 14
    Instance.new("UICorner", updateBtn).CornerRadius = UDim.new(0, 8)
    local updateGrad = Instance.new("UIGradient", updateBtn)
    updateGrad.Color = premiumGradientColors
    
    local counterRow = Instance.new("Frame")
    counterRow.Size = UDim2.new(1, -40, 0, 36)
    counterRow.Position = UDim2.new(0, 20, 0, 115)
    counterRow.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    counterRow.BackgroundTransparency = 0.08
    counterRow.BorderSizePixel = 0
    Instance.new("UICorner", counterRow).CornerRadius = UDim.new(0, 13)
    counterRow.Parent = section
    
    toolCountDisplay = Instance.new("TextLabel", counterRow)
    toolCountDisplay.Size = UDim2.new(1, -90, 1, 0)
    toolCountDisplay.Position = UDim2.new(0, 13, 0, 0)
    toolCountDisplay.Text = "Tools Available: 0"
    toolCountDisplay.TextColor3 = Color3.fromRGB(120, 120, 120)
    toolCountDisplay.BackgroundTransparency = 1
    toolCountDisplay.Font = Enum.Font.GothamBold
    toolCountDisplay.TextSize = 14
    toolCountDisplay.TextXAlignment = Enum.TextXAlignment.Left
    
    local refreshBtn = Instance.new("TextButton", counterRow)
    refreshBtn.Size = UDim2.new(0, 68, 0, 28)
    refreshBtn.Position = UDim2.new(1, -78, 0.5, -14)
    refreshBtn.Text = "Refresh"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 14
    Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 8)
    local refreshGrad = Instance.new("UIGradient", refreshBtn)
    refreshGrad.Color = premiumGradientColors
    
    toolListFrame = Instance.new("ScrollingFrame")
    toolListFrame.Size = UDim2.new(1, -40, 0, 110)
    toolListFrame.Position = UDim2.new(0, 20, 0, 160)
    toolListFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
    toolListFrame.BackgroundTransparency = 0.1
    toolListFrame.BorderSizePixel = 0
    toolListFrame.ScrollBarThickness = 3
    toolListFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 170, 255)
    toolListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    toolListFrame.Visible = true
    toolListFrame.Parent = section
    Instance.new("UICorner", toolListFrame).CornerRadius = UDim.new(0, 13)
    
    -- Enhanced button interactions
    updateBtn.MouseEnter:Connect(function()
        TweenService:Create(updateBtn, AnimationPresets.buttonHover, { BackgroundColor3 = Color3.fromRGB(100, 190, 255) }):Play()
    end)
    updateBtn.MouseLeave:Connect(function()
        TweenService:Create(updateBtn, AnimationPresets.buttonHover, { BackgroundColor3 = Color3.fromRGB(80, 170, 255) }):Play()
    end)
    refreshBtn.MouseEnter:Connect(function()
        TweenService:Create(refreshBtn, AnimationPresets.buttonHover, { BackgroundColor3 = Color3.fromRGB(100, 190, 255) }):Play()
    end)
    refreshBtn.MouseLeave:Connect(function()
        TweenService:Create(refreshBtn, AnimationPresets.buttonHover, { BackgroundColor3 = Color3.fromRGB(80, 170, 255) }):Play()
    end)
    
    updateBtn.MouseButton1Click:Connect(function()
        targetToolNames = parseToolNames(toolInput.Text)
        local targetText = #targetToolNames > 0 and table.concat(targetToolNames, ", ") or "none (auto-grab disabled)"
        notify("Eps1llon Hub", "🎯 Target updated: " .. targetText)
        
        TweenService:Create(inputGlow, AnimationPresets.buttonClick, { BackgroundTransparency = 0.7 }):Play()
        wait(0.2)
        TweenService:Create(inputGlow, AnimationPresets.buttonClick, { BackgroundTransparency = 0.95 }):Play()
        
        updateToolCountDisplay()
        updateToolList()
    end)
    
    toolInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            targetToolNames = parseToolNames(toolInput.Text)
            updateToolCountDisplay()
            updateToolList()
        end
    end)
    
    refreshBtn.MouseButton1Click:Connect(function()
        updateToolCountDisplay()
        updateToolList()
        notify("Eps1llon Hub", "🔄 Tool list refreshed!")
    end)

    updateToolList()
    
    coroutine.wrap(function()
        while true do
            updateToolCountDisplay()
            updateToolList()
            wait(3)
        end
    end)()
    
    grabtoolsConnection = workspace.ChildAdded:Connect(function(child)
        if player.Character and child:IsA("Tool") and child:FindFirstChild("Handle") then
            if shouldPickupTool(child.Name) then
                wait(0.1)
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:EquipTool(child)
                end
            end
        end
    end)
    
    player.CharacterAdded:Connect(function(character)
        wait(1)
        equipTools()
    end)
end

-- 11. Misc Tab: Instant Pickup, Kill Carrier, Plant Tree, Job GUI
local instantPickupEnabled = false
local cowOrbitEnabled = false

function setInstantPickup(state)
    instantPickupEnabled = state
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.HoldDuration = state and 0.01 or 0.5
        end
    end
    notify("Eps1llon Hub", state and "Instant Pickup enabled!" or "Instant Pickup disabled!")
    
    if state then
        workspace.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("ProximityPrompt") and instantPickupEnabled then
                descendant.HoldDuration = 0.01
            end
        end)
    end
end

function setCowOrbit(state)
    cowOrbitEnabled = state
end

RunService.RenderStepped:Connect(function()
    local selfCharacter = player.Character
    local selfRoot = selfCharacter and selfCharacter:FindFirstChild("HumanoidRootPart")

    if not (cowOrbitEnabled and selfRoot) then
        return
    end

    local cows = getCows()
    local count = #cows

    for i = 1, #cows do
        local cow = cows[i]
        local root = cow:FindFirstChild("HumanoidRootPart")
        local basePosition = selfRoot.Position

        if not (root and isnetworkowner(root)) then
            continue
        end

        local angle = (tick() * 3) + ((2 * math.pi / count) * (i - 1))
        root.CFrame = CFrame.new(Vector3.new(basePosition.X + math.cos(angle) * 10, basePosition.Y, basePosition.Z + math.sin(angle) * 10), basePosition)
    end
end)

local function resetCharacter()
    local Player = game.Players.LocalPlayer
    local Old = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.HumanoidRootPart.CFrame
    
    local humanoid = Player.Character and Player.Character:FindFirstChildWhichIsA("Humanoid")
    if replicatesignal then
        replicatesignal(Player.Kill)
    elseif humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    else
        Player.Character:BreakJoints()
    end
    
    Player.CharacterAdded:Wait()
    
    for i = 1, 20 do 
        game:GetService("RunService").Heartbeat:Wait()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Old
        end
    end
end

local function plantTree()
    if not player.Character then 
        notify("Eps1llon Hub", "❌ Character not found!")
        return 
    end
    
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then 
        notify("Eps1llon Hub", "❌ HumanoidRootPart not found!")
        return 
    end
    
    local heldTool = nil
    for _, item in ipairs(player.Character:GetChildren()) do
        if item:IsA("Tool") and string.find(string.lower(item.Name), "seed") then
            heldTool = item
            break
        end
    end
    
    if not heldTool then
        notify("Eps1llon Hub", "❌ No seed found! Hold a seed first.")
        return
    end
    
    local playerCFrame = rootPart.CFrame
    local underFeetCFrame = playerCFrame - Vector3.new(0, 3, 0)
    local groundCFrame = underFeetCFrame - Vector3.new(0, 0.736, 0)
    
    local args = {
        heldTool.Name,
        underFeetCFrame,
        groundCFrame
    }
    
    pcall(function()
        ReplicatedStorage:WaitForChild("Deploy"):InvokeServer(unpack(args))
        notify("Eps1llon Hub", "🌱 Tree planted with " .. heldTool.Name .. "!")
    end)
end

do
    local section = sections["Misc"]
    local yPos = ROW_Y_START
    
    -- Instant Pickup Toggle
    local row1 = Instance.new("Frame")
    row1.Size = UDim2.new(1, -40, 0, ROW_HEIGHT)
    row1.Position = UDim2.new(0, 20, 0, yPos)
    row1.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row1.BackgroundTransparency = 0.08
    row1.BorderSizePixel = 0
    Instance.new("UICorner", row1).CornerRadius = UDim.new(0, 13)
    row1.Parent = section
    
    local rowGlow1 = Instance.new("Frame")
    rowGlow1.Size = UDim2.new(1, 4, 1, 4)
    rowGlow1.Position = UDim2.new(0, -2, 0, -2)
    rowGlow1.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    rowGlow1.BackgroundTransparency = 0.95
    rowGlow1.BorderSizePixel = 0
    rowGlow1.ZIndex = row1.ZIndex - 1
    rowGlow1.Parent = row1
    Instance.new("UICorner", rowGlow1).CornerRadius = UDim.new(0, 15)
    
    local label1 = Instance.new("TextLabel", row1)
    label1.Size = UDim2.new(0, 160, 1, 0)
    label1.Position = UDim2.new(0, 13, 0, 0)
    label1.Text = "Instant Pickup"
    label1.TextColor3 = Color3.fromRGB(230, 230, 240)
    label1.BackgroundTransparency = 1
    label1.Font = Enum.Font.GothamBold
    label1.TextSize = 16
    label1.TextXAlignment = Enum.TextXAlignment.Left
    
    local setInstantPickupToggle = utility:createEnhancedToggle(row1, UDim2.new(0, 177, 0.5, -10), function(val)
        setInstantPickup(val)
        TweenService:Create(rowGlow1, AnimationPresets.colorShift, { BackgroundTransparency = val and 0.85 or 0.95 }):Play()
        TweenService:Create(label1, AnimationPresets.colorShift, { TextColor3 = val and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(230, 230, 240) }):Play()
    end)
    yPos = yPos + ROW_Y_SPACING

    -- Cow Orbit Toggle
    local row2 = Instance.new("Frame")
    row2.Size = UDim2.new(1, -40, 0, ROW_HEIGHT)
    row2.Position = UDim2.new(0, 20, 0, yPos)
    row2.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row2.BackgroundTransparency = 0.08
    row2.BorderSizePixel = 0
    Instance.new("UICorner", row2).CornerRadius = UDim.new(0, 13)
    row2.Parent = section
    
    local rowGlow2 = Instance.new("Frame")
    rowGlow2.Size = UDim2.new(1, 4, 1, 4)
    rowGlow2.Position = UDim2.new(0, -2, 0, -2)
    rowGlow2.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    rowGlow2.BackgroundTransparency = 0.95
    rowGlow2.BorderSizePixel = 0
    rowGlow2.ZIndex = row2.ZIndex - 1
    rowGlow2.Parent = row2
    Instance.new("UICorner", rowGlow2).CornerRadius = UDim.new(0, 15)
    
    local label2 = Instance.new("TextLabel", row2)
    label2.Size = UDim2.new(0, 160, 1, 0)
    label2.Position = UDim2.new(0, 13, 0, 0)
    label2.Text = "Cow Orbit"
    label2.TextColor3 = Color3.fromRGB(230, 230, 240)
    label2.BackgroundTransparency = 1
    label2.Font = Enum.Font.GothamBold
    label2.TextSize = 16
    label2.TextXAlignment = Enum.TextXAlignment.Left
    
    local setCorwOrbitToggle = utility:createEnhancedToggle(row2, UDim2.new(0, 177, 0.5, -10), function(val)
        setCowOrbit(val)
        TweenService:Create(rowGlow2, AnimationPresets.colorShift, { BackgroundTransparency = val and 0.85 or 0.95 }):Play()
        TweenService:Create(label2, AnimationPresets.colorShift, { TextColor3 = val and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(230, 230, 240) }):Play()
    end)
    yPos = yPos + ROW_Y_SPACING
    
    -- Kill the Carrier Button
    local row3 = Instance.new("Frame")
    row3.Size = UDim2.new(1, -40, 0, ROW_HEIGHT)
    row3.Position = UDim2.new(0, 20, 0, yPos)
    row3.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row3.BackgroundTransparency = 0.08
    row3.BorderSizePixel = 0
    Instance.new("UICorner", row3).CornerRadius = UDim.new(0, 13)
    row3.Parent = section
    
    local rowGlow3 = Instance.new("Frame")
    rowGlow3.Size = UDim2.new(1, 4, 1, 4)
    rowGlow3.Position = UDim2.new(0, -2, 0, -2)
    rowGlow3.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    rowGlow3.BackgroundTransparency = 0.95
    rowGlow3.BorderSizePixel = 0
    rowGlow3.ZIndex = row3.ZIndex - 1
    rowGlow3.Parent = row3
    Instance.new("UICorner", rowGlow3).CornerRadius = UDim.new(0, 15)
    
    local label3 = Instance.new("TextLabel", row3)
    label3.Size = UDim2.new(0, 160, 1, 0)
    label3.Position = UDim2.new(0, 13, 0, 0)
    label3.Text = "Kill the Carrier"
    label3.TextColor3 = Color3.fromRGB(230, 230, 240)
    label3.BackgroundTransparency = 1
    label3.Font = Enum.Font.GothamBold
    label3.TextSize = 16
    label3.TextXAlignment = Enum.TextXAlignment.Left
    
    local killCarrierBtn = Instance.new("TextButton", row3)
    killCarrierBtn.Size = UDim2.new(0, 100, 0, 32)
    killCarrierBtn.Position = UDim2.new(0, 190, 0.5, -16)
    killCarrierBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    killCarrierBtn.BorderSizePixel = 0
    killCarrierBtn.Text = "EXECUTE"
    killCarrierBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    killCarrierBtn.Font = Enum.Font.GothamBold
    killCarrierBtn.TextSize = 14
    Instance.new("UICorner", killCarrierBtn).CornerRadius = UDim.new(0, 8)
    
    killCarrierBtn.MouseEnter:Connect(function() TweenService:Create(killCarrierBtn, AnimationPresets.buttonHover, { Size = UDim2.new(0, 104, 0, 36), BackgroundColor3 = Color3.fromRGB(255, 120, 120) }):Play() end)
    killCarrierBtn.MouseLeave:Connect(function() TweenService:Create(killCarrierBtn, AnimationPresets.buttonHover, { Size = UDim2.new(0, 100, 0, 32), BackgroundColor3 = Color3.fromRGB(255, 100, 100) }):Play() end)
    killCarrierBtn.MouseButton1Click:Connect(function()
        TweenService:Create(killCarrierBtn, AnimationPresets.buttonClick, { BackgroundColor3 = Color3.fromRGB(200, 50, 50) }):Play()
        TweenService:Create(rowGlow3, AnimationPresets.buttonClick, { BackgroundTransparency = 0.7 }):Play()
        notify("Eps1llon Hub", "💀 Executing Kill the Carrier...")
        resetCharacter()
        wait(0.2)
        TweenService:Create(killCarrierBtn, AnimationPresets.buttonClick, { BackgroundColor3 = Color3.fromRGB(255, 100, 100) }):Play()
        TweenService:Create(rowGlow3, AnimationPresets.buttonClick, { BackgroundTransparency = 0.95 }):Play()
    end)
    yPos = yPos + ROW_Y_SPACING
    
    -- Plant Tree Button
    local row4 = Instance.new("Frame")
    row4.Size = UDim2.new(1, -40, 0, ROW_HEIGHT)
    row4.Position = UDim2.new(0, 20, 0, yPos)
    row4.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row4.BackgroundTransparency = 0.08
    row4.BorderSizePixel = 0
    Instance.new("UICorner", row4).CornerRadius = UDim.new(0, 13)
    row4.Parent = section
    
    local rowGlow4 = Instance.new("Frame")
    rowGlow4.Size = UDim2.new(1, 4, 1, 4)
    rowGlow4.Position = UDim2.new(0, -2, 0, -2)
    rowGlow4.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    rowGlow4.BackgroundTransparency = 0.95
    rowGlow4.BorderSizePixel = 0
    rowGlow4.ZIndex = row4.ZIndex - 1
    rowGlow4.Parent = row4
    Instance.new("UICorner", rowGlow4).CornerRadius = UDim.new(0, 15)
    
    local label4 = Instance.new("TextLabel", row4)
    label4.Size = UDim2.new(0, 160, 1, 0)
    label4.Position = UDim2.new(0, 13, 0, 0)
    label4.Text = "Plant Tree"
    label4.TextColor3 = Color3.fromRGB(230, 230, 240)
    label4.BackgroundTransparency = 1
    label4.Font = Enum.Font.GothamBold
    label4.TextSize = 16
    label4.TextXAlignment = Enum.TextXAlignment.Left
    
    local plantTreeBtn = Instance.new("TextButton", row4)
    plantTreeBtn.Size = UDim2.new(0, 100, 0, 32)
    plantTreeBtn.Position = UDim2.new(0, 190, 0.5, -16)
    plantTreeBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    plantTreeBtn.BorderSizePixel = 0
    plantTreeBtn.Text = "PLANT"
    plantTreeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plantTreeBtn.Font = Enum.Font.GothamBold
    plantTreeBtn.TextSize = 14
    Instance.new("UICorner", plantTreeBtn).CornerRadius = UDim.new(0, 8)
    
    plantTreeBtn.MouseEnter:Connect(function() TweenService:Create(plantTreeBtn, AnimationPresets.buttonHover, { Size = UDim2.new(0, 104, 0, 36), BackgroundColor3 = Color3.fromRGB(70, 220, 70) }):Play() end)
    plantTreeBtn.MouseLeave:Connect(function() TweenService:Create(plantTreeBtn, AnimationPresets.buttonHover, { Size = UDim2.new(0, 100, 0, 32), BackgroundColor3 = Color3.fromRGB(50, 200, 50) }):Play() end)
    plantTreeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(plantTreeBtn, AnimationPresets.buttonClick, { BackgroundColor3 = Color3.fromRGB(30, 150, 30) }):Play()
        TweenService:Create(rowGlow4, AnimationPresets.buttonClick, { BackgroundTransparency = 0.7 }):Play()
        plantTree()
        wait(0.2)
        TweenService:Create(plantTreeBtn, AnimationPresets.buttonClick, { BackgroundColor3 = Color3.fromRGB(50, 200, 50) }):Play()
        TweenService:Create(rowGlow4, AnimationPresets.buttonClick, { BackgroundTransparency = 0.95 }):Play()
    end)
    yPos = yPos + ROW_Y_SPACING
    
    -- Job GUI Dropdown
    local row5 = Instance.new("Frame")
    row5.Size = UDim2.new(1, -40, 0, 48)
    row5.Position = UDim2.new(0, 20, 0, yPos)
    row5.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row5.BackgroundTransparency = 0.08
    row5.BorderSizePixel = 0
    Instance.new("UICorner", row5).CornerRadius = UDim.new(0, 13)
    row5.Parent = section
    
    local rowGlow5 = Instance.new("Frame")
    rowGlow5.Size = UDim2.new(1, 4, 1, 4)
    rowGlow5.Position = UDim2.new(0, -2, 0, -2)
    rowGlow5.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    rowGlow5.BackgroundTransparency = 0.95
    rowGlow5.BorderSizePixel = 0
    rowGlow5.ZIndex = row5.ZIndex - 1
    rowGlow5.Parent = row5
    Instance.new("UICorner", rowGlow5).CornerRadius = UDim.new(0, 15)
    
    local label5 = Instance.new("TextLabel", row5)
    label5.Size = UDim2.new(1, -20, 0, 25)
    label5.Position = UDim2.new(0, 13, 0, 5)
    label5.Text = "Job GUI"
    label5.TextColor3 = Color3.fromRGB(230, 230, 240)
    label5.BackgroundTransparency = 1
    label5.Font = Enum.Font.GothamBold
    label5.TextSize = 16
    label5.TextXAlignment = Enum.TextXAlignment.Left
    
    local function changeJob(jobName)
        pcall(function()
            local args = {[1] = ReplicatedStorage:WaitForChild("Jobs", 9e9):WaitForChild(jobName, 9e9)}
            ReplicatedStorage:WaitForChild("ChangeJob", 9e9):FireServer(unpack(args))
            notify("Eps1llon Hub", "💼 Changed job to " .. jobName .. "!")
        end)
    end
    
    local jobOptions = {"Harvester", "Hunter", "Warrior", "Engineer"}
    local jobDropdown = utility:createEnhancedDropdown(row5, UDim2.new(0, 13, 0, 35), jobOptions, function(selectedJob, index)
        changeJob(selectedJob)
        TweenService:Create(rowGlow5, AnimationPresets.buttonClick, { BackgroundTransparency = 0.7 }):Play()
        wait(0.2)
        TweenService:Create(rowGlow5, AnimationPresets.buttonClick, { BackgroundTransparency = 0.95 }):Play()
    end)
end

-- 12. Resizable MainFrame, Insert Key Visibility
local isGUIVisible = true
local function toggleGUIVisibility()
    if not UILib or not UILib.MainFrame then return end
    
    isGUIVisible = not isGUIVisible
    
    local targetTransparency = isGUIVisible and 0 or 1
    local targetScale = isGUIVisible and 1 or 0.8
    
    if isGUIVisible then
        UILib.MainFrame.Visible = true
    end

    local tween = TweenService:Create(UILib.MainFrame, 
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = targetTransparency
    })
    
    tween:Play()
    
    if not isGUIVisible then
        tween.Completed:Connect(function()
            if not isGUIVisible then
                UILib.MainFrame.Visible = false
            end
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleGUIVisibility()
    end
end)

local function makeResizable(frame)
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
    resizeHandle.BackgroundTransparency = 0.3
    resizeHandle.BorderSizePixel = 0
    resizeHandle.ZIndex = 1000
    resizeHandle.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = resizeHandle
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⤢"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextScaled = true
    icon.Font = Enum.Font.SourceSansBold
    icon.Parent = resizeHandle
    
    resizeHandle.MouseEnter:Connect(function()
        TweenService:Create(resizeHandle, AnimationPresets.buttonHover, {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(1, -25, 1, -25)
        }):Play()
    end)
    
    resizeHandle.MouseLeave:Connect(function()
        TweenService:Create(resizeHandle, AnimationPresets.buttonHover, {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -20, 1, -20)
        }):Play()
    end)
    
    local isResizing, resizeStart, originalSize = false, nil, nil
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isResizing = true
            resizeStart = input.Position
            originalSize = frame.Size
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newSize = UDim2.new(
                originalSize.X.Scale,
                math.max(400, originalSize.X.Offset + delta.X),
                originalSize.Y.Scale,
                math.max(300, originalSize.Y.Offset + delta.Y)
            )
            
            TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = newSize
            }):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isResizing then
            isResizing = false
            TweenService:Create(resizeHandle, AnimationPresets.buttonHover, {
                BackgroundTransparency = 0.3,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -20, 1, -20)
            }):Play()
        end
    end)
end

if UILib and UILib.MainFrame then
    makeResizable(UILib.MainFrame)
end

task.delay(1, notify, "Eps1llon Hub", "🚀 Hub with External Chat loaded successfully! Press Insert to toggle.")
