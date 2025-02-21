local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MainGUI"
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundTransparency = 0.5
    mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    mainFrame.Parent = gui

    -- Make the main frame draggable
    mainFrame.Active = true
    mainFrame.Draggable = true

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 100, 1, 0)
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.BackgroundTransparency = 0.5
    tabContainer.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    tabContainer.Parent = mainFrame

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -110, 1, 0)
    contentFrame.Position = UDim2.new(0, 110, 0, 0)
    contentFrame.BackgroundTransparency = 0.5
    contentFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    contentFrame.Parent = mainFrame

    local function createTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 30)
        tabButton.Position = UDim2.new(0, 0, 0, (#tabContainer:GetChildren() - 1) * 30)
        tabButton.BackgroundTransparency = 0
        tabButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        tabButton.Text = name
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.Parent = tabContainer

        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.Position = UDim2.new(0, 0, 0, 0)
        tabFrame.BackgroundTransparency = 0.5
        tabFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        tabFrame.Visible = false
        tabFrame.Parent = contentFrame

        tabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(contentFrame:GetChildren()) do
                child.Visible = false
            end
            tabFrame.Visible = true
        end)

        return tabFrame
    end

    local grappleTabFrame = createTab("Grapple Things")

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 180, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Ghosty's Hub"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = grappleTabFrame

    local yOffset = 50
    local buttonHeight = 30
    local buttonSpacing = 5

    local function createToggleButton(parent, text, toggleFunction, customCode)
        local button = Instance.new("TextButton")
        button.Text = text .. ": OFF"
        button.Size = UDim2.new(0, 180, 0, buttonHeight)
        button.Position = UDim2.new(0, 10, 0, yOffset)
        button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Parent = parent

        yOffset = yOffset + buttonHeight + buttonSpacing

        local isEnabled = false
        local function toggleButton()
            isEnabled = not isEnabled
            button.Text = text .. ": " .. (isEnabled and "ON" or "OFF")
            toggleFunction(isEnabled)
            if isEnabled and customCode then
                customCode()
            end
        end

        button.MouseButton1Click:Connect(toggleButton)
    end

    createToggleButton(grappleTabFrame, "Toggle Damage Size", function(isEnabled)
        if isEnabled then
            game.Workspace.Pit.Damage.Size = Vector3.new(42, 2000, 2000)
        else
            game.Workspace.Pit.Damage.Size = Vector3.new(0, 0, 0)
        end
    end)

    createToggleButton(grappleTabFrame, "Toggle Touch", function(isEnabled)
        for i, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanTouch = not isEnabled
            end
        end
    end)

    createToggleButton(grappleTabFrame, "Remove Ragdoll", function(isEnabled)
        if isEnabled then
            local LocalPlayer = Players.LocalPlayer
            LocalPlayer.Character.ragdollValue:Destroy()
        end
    end)

    createToggleButton(grappleTabFrame, "Boost Touch Detector Size", function(isEnabled)
        local touchDetector = game:GetService("Workspace").Map.Cool.Boosts.Jump.touchDetector
        touchDetector.Size = isEnabled and Vector3.new(40000, 40000, 40000) or Vector3.new(1, 1, 1)

        local touchDetector2 = game:GetService("Workspace").Map.Cool.Boosts.Speed.touchDetector
        touchDetector2.Size = isEnabled and Vector3.new(40000, 40000, 40000) or Vector3.new(1, 1, 1)
    end)

    local button5 = Instance.new("TextButton")
    button5.Text = "Anti grapple"
    button5.Size = UDim2.new(0, 180, 0, buttonHeight)
    button5.Position = UDim2.new(0, 10, 0, yOffset)
    button5.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    button5.TextColor3 = Color3.new(1, 1, 1)
    button5.Parent = grappleTabFrame
    button5.MouseButton1Click:Connect(function()
        -- Speed of the rapid up-down movement
        local rapidSpeed = 100
        -- Amount of time for each movement (in seconds)
        local moveTime = 0.01
        -- Flag to toggle the rapid movement
        local rapidEnabled = false

        -- References to the player's character and humanoid
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")

        -- Function to handle the rapid up-down movement without affecting the camera
        local function rapidMovement()
            while true do
                if rapidEnabled then
                    -- Move up without affecting the camera
                    rootPart.CFrame = rootPart.CFrame * CFrame.new(0, rapidSpeed, 0)
                    humanoid.CameraOffset = humanoid.CameraOffset + Vector3.new(0, -rapidSpeed, 0)
                    wait(moveTime)

                    -- Move back down without affecting the camera
                    rootPart.CFrame = rootPart.CFrame * CFrame.new(0, -rapidSpeed, 0)
                    humanoid.CameraOffset = humanoid.CameraOffset + Vector3.new(0, rapidSpeed, 0)
                    wait(moveTime)
                else
                    wait(0.1)
                end
            end
        end

        -- Start the rapid movement in a separate thread
        coroutine.wrap(rapidMovement)()

        -- Function to handle free movement input
        local function onMove(input, gameProcessed)
            if gameProcessed then return end

            -- Handle WASD input for free movement
            if input.KeyCode == Enum.KeyCode.W then
                humanoid:Move(Vector3.new(0, 0, -1))
            elseif input.KeyCode == Enum.KeyCode.A then
                humanoid:Move(Vector3.new(-1, 0, 0))
            elseif input.KeyCode == Enum.KeyCode.S then
                humanoid:Move(Vector3.new(0, 0, 1))
            elseif input.KeyCode == Enum.KeyCode.D then
                humanoid:Move(Vector3.new(1, 0, 0))
            elseif input.KeyCode == Enum.KeyCode.Space then
                -- Jump functionality
                rootPart.Velocity = Vector3.new(0, 50, 0) -- Adjust the jump force as necessary
            end
        end

        -- Function to handle the toggle button input
        local function onToggle(input, gameProcessed)
            if gameProcessed then return end

            -- Toggle rapid movement on pressing the "C" key
            if input.KeyCode == Enum.KeyCode.Q then
                rapidEnabled = not rapidEnabled
            end
        end

        -- Connect the input events to their respective functions
        game:GetService("User InputService").InputBegan:Connect(onMove)
        game:GetService("User InputService").InputBegan:Connect(onToggle)
    end)

    local antiFlingTabFrame = createTab("Anti Fling")

    local antiFlingButton = Instance.new("TextButton")
    antiFlingButton.Text = "Anti Fling"
    antiFlingButton.Size = UDim2.new(0, 180, 0, buttonHeight)
    antiFlingButton.Position = UDim2.new(0, 10, 0, yOffset)
    antiFlingButton.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    antiFlingButton.TextColor3 = Color3.new(1, 1, 1)
    antiFlingButton.Parent = antiFlingTabFrame

    yOffset = yOffset + buttonHeight + buttonSpacing

    antiFlingButton.MouseButton1Click:Connect(function()
        -- Anti Fling Script
        local RunService = game:GetService("RunService")
        local detected = false
        local character, primaryPart

        local function characterAdded(newCharacter)
            character = newCharacter
            repeat wait() until newCharacter:FindFirstChild("HumanoidRootPart")
            primaryPart = character:FindFirstChild("HumanoidRootPart")
            detected = false
        end

        characterAdded(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
        LocalPlayer.CharacterAdded:Connect(characterAdded)

        RunService.Heartbeat:Connect(function()
            if character and primaryPart then
                local angularVelocity = primaryPart.AssemblyAngularVelocity.Magnitude
                local linearVelocity = primaryPart.AssemblyLinearVelocity.Magnitude

                if angularVelocity > 50 or linearVelocity > 100 then
                    if not detected then
                        game.StarterGui:SetCore("ChatMakeSystemMessage", {
                            Text = "Fling Exploit detected, Player: " .. tostring(LocalPlayer),
                            Color = Color3.fromRGB(255, 200, 0)
                        })
                    end
                    detected = true
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                        end
                    end
                end
            end
        end)
    end)
end

-- Create the GUI when the player spawns
LocalPlayer.CharacterAdded:Connect(function()
    createGUI()
end)

-- Create the GUI for the first time if the character already exists
if LocalPlayer.Character then
    createGUI()
end