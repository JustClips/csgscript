local utility = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local AnimationPresets = {
    toggleOn = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    toggleOff = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    sliderMove = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    buttonHover = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    buttonClick = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
    guiResize = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    colorShift = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
}

function utility:createRippleEffect(parent, position)
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = position
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 10
    ripple.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local expandTween = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 100, 0, 100),
        Position = UDim2.new(position.X.Scale, position.X.Offset - 50, position.Y.Scale, position.Y.Offset - 50),
        BackgroundTransparency = 1
    })
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

function utility:createEnhancedToggle(parent, position, onToggle)
    local toggleBar = Instance.new("Frame", parent)
    toggleBar.Size = UDim2.new(0, 46, 0, 20)
    toggleBar.Position = UDim2.new(position.X.Scale, position.X.Offset + 13, position.Y.Scale, position.Y.Offset)
    toggleBar.BackgroundColor3 = Color3.fromRGB(22, 28, 38)
    toggleBar.BorderSizePixel = 0
    Instance.new('UICorner', toggleBar).CornerRadius = UDim.new(1, 999)

    local toggleKnob = Instance.new("Frame", toggleBar)
    toggleKnob.Size = UDim2.new(0, 18, 0, 18)
    toggleKnob.Position = UDim2.new(0, 1, 0, 1)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(245,245,250)
    toggleKnob.BorderSizePixel = 0
    Instance.new('UICorner', toggleKnob).CornerRadius = UDim.new(1, 999)

    local knobShadow = Instance.new("Frame", toggleKnob)
    knobShadow.Size = UDim2.new(1, 4, 1, 4)
    knobShadow.Position = UDim2.new(0, -2, 0, 1)
    knobShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    knobShadow.BackgroundTransparency = 0.8
    knobShadow.BorderSizePixel = 0
    knobShadow.ZIndex = toggleKnob.ZIndex - 1
    Instance.new('UICorner', knobShadow).CornerRadius = UDim.new(1, 999)

    local isOn = false

    toggleBar.MouseEnter:Connect(function()
        TweenService:Create(toggleBar, AnimationPresets.buttonHover, {
            Size = UDim2.new(0, 50, 0, 24)
        }):Play()
    end)

    toggleBar.MouseLeave:Connect(function()
        TweenService:Create(toggleBar, AnimationPresets.buttonHover, {
            Size = UDim2.new(0, 46, 0, 20)
        }):Play()
    end)

    local function setToggle(val)
        isOn = val

        local targetBarColor = val and Color3.fromRGB(80, 170, 255) or Color3.fromRGB(22, 28, 38)
        local targetKnobPos = val and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1)
        local targetKnobColor = val and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(245, 245, 250)

        TweenService:Create(toggleBar, AnimationPresets.toggleOn, {
            BackgroundColor3 = targetBarColor
        }):Play()

        TweenService:Create(toggleKnob, AnimationPresets.toggleOn, {
            Position = targetKnobPos,
            BackgroundColor3 = targetKnobColor,
            Size = val and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 18, 0, 18)
        }):Play()

        TweenService:Create(toggleKnob, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, val and 22 or 20, 0, val and 22 or 20)
        }):Play()

        wait(0.1)
        TweenService:Create(toggleKnob, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, val and 20 or 18, 0, val and 20 or 18)
        }):Play()

        if onToggle then onToggle(val) end
    end

    setToggle(false)

    toggleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self:createRippleEffect(toggleBar, UDim2.new(0.5, 0, 0.5, 0))
            setToggle(not isOn)
        end
    end)

    return setToggle, toggleBar
end

function utility:createEnhancedDropdown(parent, position, options, onSelect)
    local dropdownFrame = Instance.new("Frame", parent)
    dropdownFrame.Size = UDim2.new(0, 200, 0, 36)
    dropdownFrame.Position = position
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(33, 41, 57)
    dropdownFrame.BorderSizePixel = 0
    Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 8)

    local dropdownLabel = Instance.new("TextLabel", dropdownFrame)
    dropdownLabel.Size = UDim2.new(1, -30, 1, 0)
    dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    dropdownLabel.Text = options[1] or "Select Option"
    dropdownLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Font = Enum.Font.GothamBold
    dropdownLabel.TextSize = 14
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

    local dropdownArrow = Instance.new("TextLabel", dropdownFrame)
    dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
    dropdownArrow.Position = UDim2.new(1, -25, 0, 0)
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = Color3.fromRGB(220, 240, 255)
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Font = Enum.Font.GothamBold
    dropdownArrow.TextSize = 12
    dropdownArrow.TextXAlignment = Enum.TextXAlignment.Center

    local dropdownList = Instance.new("Frame", dropdownFrame)
    dropdownList.Size = UDim2.new(1, 0, 0, #options * 32)
    dropdownList.Position = UDim2.new(0, 0, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ZIndex = 100
    Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 8)

    local isOpen = false

    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton", dropdownList)
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 32)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        optionButton.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
        optionButton.BorderSizePixel = 0
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 14
        optionButton.ZIndex = 101

        if i == 1 then
            Instance.new("UICorner", optionButton).CornerRadius = UDim.new(0, 8)
        elseif i == #options then
            Instance.new("UICorner", optionButton).CornerRadius = UDim.new(0, 8)
        end

        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, AnimationPresets.buttonHover, {
                BackgroundColor3 = Color3.fromRGB(80, 170, 255),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)

        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, AnimationPresets.buttonHover, {
                BackgroundColor3 = Color3.fromRGB(26, 28, 33),
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end)

        optionButton.MouseButton1Click:Connect(function()
            dropdownLabel.Text = option
            dropdownList.Visible = false
            isOpen = false
            dropdownArrow.Text = "▼"
            if onSelect then onSelect(option, i) end
        end)
    end

    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isOpen = not isOpen
            dropdownList.Visible = isOpen
            dropdownArrow.Text = isOpen and "▲" or "▼"
        end
    end)

    return dropdownFrame
end

function utility:setupEnhancedSliderDrag(bar, pill, min, max, onChange)
    local dragging = false
    local hovered = false

    pill.MouseEnter:Connect(function()
        hovered = true
        TweenService:Create(pill, AnimationPresets.buttonHover, {
            Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 40)
        }):Play()

        local glow = Instance.new("Frame")
        glow.Name = "SliderGlow"
        glow.Size = UDim2.new(1, 10, 1, 10)
        glow.Position = UDim2.new(0, -5, 0, -5)
        glow.BackgroundColor3 = Color3.fromRGB(74, 177, 255)
        glow.BackgroundTransparency = 0.8
        glow.BorderSizePixel = 0
        glow.ZIndex = pill.ZIndex - 1
        glow.Parent = pill
        Instance.new("UICorner", glow).CornerRadius = UDim.new(1, 999)

        TweenService:Create(glow, AnimationPresets.colorShift, {
            BackgroundTransparency = 0.6
        }):Play()
    end)

    pill.MouseLeave:Connect(function()
        hovered = false
        if not dragging then
            TweenService:Create(pill, AnimationPresets.buttonHover, {
                Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 36)
            }):Play()

            local glow = pill:FindFirstChild("SliderGlow")
            if glow then
                TweenService:Create(glow, AnimationPresets.buttonHover, {
                    BackgroundTransparency = 1
                }):Play()
                game:GetService("Debris"):AddItem(glow, 0.15)
            end
        end
    end)

    local function updateInput(input)
        local absPos = pill.AbsolutePosition.X
        local absSize = pill.AbsoluteSize.X
        local percent = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
        local value = math.floor(min + (max - min) * percent + 0.5)

        TweenService:Create(bar, AnimationPresets.sliderMove, {
            Size = UDim2.new(percent, 0, 1, 0)
        }):Play()

        if onChange then onChange(value, percent) end
    end

    pill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            self:createRippleEffect(pill, UDim2.new(0, input.Position.X - pill.AbsolutePosition.X, 0, input.Position.Y - pill.AbsolutePosition.Y))
            updateInput(input)

            TweenService:Create(pill, AnimationPresets.buttonClick, {
                Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 42)
            }):Play()

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if not hovered then
                        TweenService:Create(pill, AnimationPresets.buttonHover, {
                            Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 36)
                        }):Play()
                    end
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)

    pill.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if not hovered then
                TweenService:Create(pill, AnimationPresets.buttonHover, {
                    Size = UDim2.new(pill.Size.X.Scale, pill.Size.X.Offset, 0, 36)
                }):Play()
            end
        end
    end)
end

return utility
