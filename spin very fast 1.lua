local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- Wait for the HumanoidRootPart
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables to manage spinning state and speed
local spinning = false
local rotationSpeed = 720  -- Default rotation speed in degrees per second

-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpinToggleGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create gradient effect for background
local function applyGradient(guiElement, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color1), ColorSequenceKeypoint.new(1, color2)})
    gradient.Rotation = 45
    gradient.Parent = guiElement
end

-- Tweening function
local function createTween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    local tween = tweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Typing effect function
local function typeText(button, fullText, typingSpeed)
    button.Text = ""
    for i = 1, #fullText do
        button.Text = string.sub(fullText, 1, i)
        wait(typingSpeed)
    end
end

-- Create the toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 1, -140)
toggleButton.Text = ""
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.9)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Parent = screenGui

-- Apply rounded corners and gradient to the toggle button
local buttonCorner = Instance.new("UICorner", toggleButton)
buttonCorner.CornerRadius = UDim.new(0, 15)
applyGradient(toggleButton, Color3.new(0.4, 0.4, 1), Color3.new(0.1, 0.1, 0.5))

-- Add a stroke around the button
local buttonStroke = Instance.new("UIStroke", toggleButton)
buttonStroke.Color = Color3.new(0, 0, 0)
buttonStroke.Thickness = 2

-- Button hover animation
toggleButton.MouseEnter:Connect(function()
    createTween(toggleButton, {Size = UDim2.new(0, 130, 0, 55)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)
toggleButton.MouseLeave:Connect(function()
    createTween(toggleButton, {Size = UDim2.new(0, 120, 0, 50)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- Create the speed input TextBox
local speedTextBox = Instance.new("TextBox")
speedTextBox.Size = UDim2.new(0, 120, 0, 50)
speedTextBox.Position = UDim2.new(0, 10, 1, -80)
speedTextBox.Text = tostring(rotationSpeed)
speedTextBox.PlaceholderText = "Enter Speed"
speedTextBox.Font = Enum.Font.GothamBold
speedTextBox.TextScaled = true
speedTextBox.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
speedTextBox.TextColor3 = Color3.new(0, 0, 0)
speedTextBox.Parent = screenGui

-- Apply rounded corners and gradient to the TextBox
local textBoxCorner = Instance.new("UICorner", speedTextBox)
textBoxCorner.CornerRadius = UDim.new(0, 15)
applyGradient(speedTextBox, Color3.new(0.9, 0.9, 1), Color3.new(0.7, 0.7, 0.9))

-- Add a stroke around the TextBox
local textBoxStroke = Instance.new("UIStroke", speedTextBox)
textBoxStroke.Color = Color3.new(0, 0, 0)
textBoxStroke.Thickness = 2

-- TextBox hover animation
speedTextBox.MouseEnter:Connect(function()
    createTween(speedTextBox, {Size = UDim2.new(0, 130, 0, 55)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)
speedTextBox.MouseLeave:Connect(function()
    createTween(speedTextBox, {Size = UDim2.new(0, 120, 0, 50)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- Pop-up animations for the button and TextBox
toggleButton.Size = UDim2.new(0, 0, 0, 0)
speedTextBox.Size = UDim2.new(0, 0, 0, 0)
createTween(toggleButton, {Size = UDim2.new(0, 120, 0, 50)}, 0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
createTween(speedTextBox, {Size = UDim2.new(0, 120, 0, 50)}, 0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

-- Display "Start Spin" with typing effect
typeText(toggleButton, "Start Spin", 0.05)

-- Function to change button color based on spinning state
local function updateButtonColor()
    if spinning then
        createTween(toggleButton, {BackgroundColor3 = Color3.new(0.3, 1, 0.3)}, 0.2)  -- Green when spinning
    else
        createTween(toggleButton, {BackgroundColor3 = Color3.new(0.3, 0.3, 0.9)}, 0.2)  -- Default color
    end
end

-- Function to start/stop spinning
local function toggleSpin()
    spinning = not spinning
    typeText(toggleButton, spinning and "Stop Spin" or "Start Spin", 0.05)
    updateButtonColor()  -- Change button color
end

-- Connect button click to toggle function
toggleButton.MouseButton1Click:Connect(toggleSpin)

-- Function to update rotation speed from TextBox input
speedTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputSpeed = tonumber(speedTextBox.Text)
        if inputSpeed then
            rotationSpeed = inputSpeed
        else
            speedTextBox.Text = tostring(rotationSpeed)
        end
    end
end)

-- Rotate the player if spinning is active
runService.RenderStepped:Connect(function(deltaTime)
    if spinning and rootPart then
        local radSpeed = math.rad(rotationSpeed)
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, radSpeed * deltaTime, 0)
    end
end)
