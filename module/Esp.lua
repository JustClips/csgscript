local espSettings = {
    Name = false, HP = false, Armor = false, Distance = false,
    Team = false, Age = false, Holding = false, Highlight = false
}

local espObjects = {}

local function getArmor(prot)
    if prot:IsA("IntValue") or prot:IsA("NumberValue") then return prot.Value end
    if prot:IsA("Folder") or prot:IsA("Model") then
        local a = prot:FindFirstChild("Armor")
        if a and a:IsA("IntValue") then return a.Value end
        for _,v in ipairs(prot:GetChildren()) do
            if v:IsA("IntValue") then return v.Value end
        end
    end
    return nil
end

local function clearESP()
    for _,d in pairs(espObjects) do
        for _,o in pairs(d) do
            if o and o.Remove then o:Remove() end
        end
    end
    table.clear(espObjects)
end

-- Enhanced ESP Toggle Functions with FIXED CLEAN TOGGLES
local function createEnhancedESPToggle(section, xPos, yPos, labelText, setting)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.5, -25, 0, 50)
    row.Position = UDim2.new(xPos, 20, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(26, 28, 33)
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
    row.Parent = section
    
    local rowGlow = Instance.new("Frame")
    rowGlow.Size = UDim2.new(1, 4, 1, 4)
    rowGlow.Position = UDim2.new(0, -2, 0, -2)
    rowGlow.BackgroundColor3 = Color3.fromRGB(74, 255, 230) -- CYAN GLOW
    rowGlow.BackgroundTransparency = 0.95
    rowGlow.BorderSizePixel = 0
    rowGlow.ZIndex = row.ZIndex - 1
    rowGlow.Parent = row
    Instance.new("UICorner", rowGlow).CornerRadius = UDim.new(0, 12)
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(1, -90, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local setToggle = utility:createEnhancedToggle(row, UDim2.new(1, -90, 0.5, -10), function(val)
        espSettings[setting] = val
        TweenService:Create(rowGlow, AnimationPresets.colorShift, {
            BackgroundTransparency = val and 0.80 or 0.95
        }):Play()
        
        TweenService:Create(label, AnimationPresets.colorShift, {
            TextColor3 = val and Color3.fromRGB(74, 255, 230) or Color3.fromRGB(230, 230, 240)
        }):Play()
    end)
end

do
    local section = sections["ESP"]
    
    -- ESP Toggles in 2 columns with enhanced spacing
    createEnhancedESPToggle(section, 0, 60, "Show Names", "Name")
    createEnhancedESPToggle(section, 0, 116, "Show HP", "HP") 
    createEnhancedESPToggle(section, 0, 172, "Show Armor", "Armor")
    createEnhancedESPToggle(section, 0, 228, "Show Distance", "Distance")
    
    createEnhancedESPToggle(section, 0.5, 60, "Show Team", "Team")
    createEnhancedESPToggle(section, 0.5, 116, "Show Age", "Age")
    createEnhancedESPToggle(section, 0.5, 172, "Show Holding", "Holding")
    createEnhancedESPToggle(section, 0.5, 228, "Highlight Players", "Highlight")
end

RunService.RenderStepped:Connect(function()
    clearESP()
    
    local anyEnabled = false
    for _, enabled in pairs(espSettings) do
        if enabled then anyEnabled = true break end
    end
    if not anyEnabled then return end
    
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=player and pl.Character then
            local char = pl.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and head and hum and hum.Health > 0 then
                local pos, on = camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.3,0))
                if not on then continue end

                local hl = char:FindFirstChild("ESP_Highlight")
                if espSettings.Highlight then
                    if not hl then
                        hl = Instance.new("Highlight", char)
                        hl.Name = "ESP_Highlight"
                        hl.Adornee = char
                        hl.FillTransparency = 0.5
                        hl.OutlineColor = Color3.new(1,1,1)
                        hl.OutlineTransparency = 0
                    end
                    hl.FillColor = (pl.Team and pl.Team.TeamColor.Color) or Color3.new(1,1,1)
                elseif hl then
                    hl:Destroy()
                end

                local dist = math.floor((hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude)
                local hp = math.floor(hum.Health)
                local armor = "?"
                local vf = char:FindFirstChild("Values")
                if vf then
                    local prot = vf:FindFirstChild("Protection")
                    if prot then
                        local a = getArmor(prot)
                        if type(a)=="number" then armor = tostring(a) end
                    end
                end
                local age = char:FindFirstChild("Age") and tostring(char.Age.Value) or "?"
                local teamName = pl.Team and pl.Team.Name or "None"
                local tool = char:FindFirstChildOfClass("Tool")
                local toolName = tool and tool.Name

                local lines, L1, L2 = {}, {}, {}
                if espSettings.Name then table.insert(L1, pl.Name) end
                if espSettings.HP then table.insert(L1, hp.." HP") end
                if espSettings.Armor then table.insert(L1, armor.." Armor") end
                if espSettings.Distance then table.insert(L1, dist.." studs") end
                if #L1 > 0 then table.insert(lines, table.concat(L1, " | ")) end
                if espSettings.Team then table.insert(L2, "Team: "..teamName) end
                if espSettings.Age then table.insert(L2, "Age: "..age) end
                if #L2 > 0 then table.insert(lines, table.concat(L2, " | ")) end
                if espSettings.Holding and toolName then table.insert(lines, "Holding: "..toolName) end

                local lineH, totalH = 18, #lines * 18
                local startY = pos.Y - totalH/2
                local drawn = {}
                for i,txt in ipairs(lines) do
                    local d = Drawing.new("Text")
                    d.Text = txt
                    d.Size = 16
                    d.Center = true
                    d.Font = 2
                    d.Color = (pl.Team and pl.Team.TeamColor.Color) or Color3.new(1,1,1)
                    d.Outline = true
                    d.OutlineColor = Color3.new(0,0,0)
                    d.Position = Vector2.new(pos.X, startY + (i-1)*lineH)
                    d.Visible = true
                    table.insert(drawn, d)
                end
                espObjects[pl] = drawn
            end
        end
    end
end)

return espSettings
