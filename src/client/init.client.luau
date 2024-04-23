--!strict

-- For asserts that are only used because of typing issues
local unneeded_assert = assert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local Packages = ReplicatedStorage:WaitForChild("Shared")

local Fusion = require(Packages:WaitForChild("Fusion"))
local New = Fusion.New
local Value = Fusion.Value
local Hydrate = Fusion.Hydrate
local OnEvent = Fusion.OnEvent
local gui = Instance.new("ScreenGui")

local storyText = Value("")
local storyTextMaxVisibleGraphemes = Value(-1)
New("TextLabel")({
	Name = "Story",
	Parent = gui,

	Text = storyText,
    TextColor3 = Color3.fromRGB(25, 25, 25),
    FontFace = Font.fromName("Inconsolata"),
	TextSize = 20,
	TextWrap = true,
    MaxVisibleGraphemes = storyTextMaxVisibleGraphemes,

    BackgroundColor3 = Color3.fromRGB(210, 85, 76),

	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.2),
	Size = UDim2.fromScale(0.6, 0.4),
})

local blockInputs = true

local function revealText(text)
    -- Types text out
    blockInputs = true
    storyText:set(text)
    local length = 0
    for _ in utf8.graphemes(text) do
        length += 1
        storyTextMaxVisibleGraphemes:set(length)
        task.wait(0.02)
    end
    blockInputs = false
end

local story = require(Packages:WaitForChild("story")).new(revealText)
story:update()

local input = New("TextBox")({
	Name = "Input",
	Parent = gui,

	PlaceholderText = "Respond...",
    TextColor3 = Color3.fromRGB(240, 240, 240),
	TextSize = 20,

    BackgroundColor3 = Color3.fromRGB(25, 25, 25),

	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.7),
	Size = UDim2.fromScale(0.25, 0.1),
})
unneeded_assert(input:IsA("TextBox"))
Hydrate(input) {
	[OnEvent("FocusLost")] = function()
        if blockInputs then return end

		story:next(input.Text)
	end,
}

gui.Parent = playerGui