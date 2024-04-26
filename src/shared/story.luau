local Story = {}
Story.__index = Story

local function lowercaseFind(text, matches)
	local lowered = string.lower(text)
	for _, match in matches do
		if string.find(lowered, match) then
			return true
		end
	end
	return false
end

local storyLine = {
	start = {
		text = [[You find yourself standing at the edge of a dense, mist-shrouded forest.
The air is thick with anticipation, and the trees seem to whisper secrets to each other.
A faint glow emanates from within the forest, drawing you closer.

What will you do?
    Enter the forest cautiously.
    Stay put and observe from a distance.
    Turn around and leave.]],
		processInput = function(input: string)
			local entering = lowercaseFind(input, { "enter", "forest" })
			local observing = lowercaseFind(input, { "stay", "observe" })
			local leaving = lowercaseFind(input, { "turn", "leave" })

			if entering then
				-- Only one choice
				if observing or leaving then
					return false
				end

				return "enterForest"
			elseif observing then
				-- Only one choice
				if entering or leaving then
					return false
				end

				return "observeAtStart"
			elseif leaving then
				-- Only one choice
				if entering or observing then
					return false
				end

				return "leaveAtStart"
			end

			return false
		end,
	},
	enterForest = {
		text = [[You take a deep breath and step into the forest, your senses tingling with excitement and trepidation.
The glow intensifies as you venture further, casting eerie shadows on the twisted branches above.
Suddenly, you come across a fork in the path.

	What will you do?
		Take the left path.
		Take the right path.]],
		processInput = function()
			return "ending"
		end,
	},
	observeAtStart = {
		text = [[You wait for 20 minutes... nothing interesting happens. Do you want to keep waiting?]],
		processInput = function(input: string)
			local yes = lowercaseFind(input, { "yes" })
			local no = lowercaseFind(input, { "no" })
			if yes then
				-- Only one choice
				if no then
					return false
				end

				return "observeAtStart"
			elseif no then
				-- Only one choice
				if yes then
					return false
				end

				return "start"
			else
				return false
			end
		end,
	},
	leaveAtStart = {
		text = [[A mysterious force keeps you from leaving...]],
		processInput = function()
			return "start"
		end,
	},
	ending = {
		text = "THE END",
		processInput = function() end,
	},
}

function Story.new(output)
	return setmetatable({ place = "start", output = output }, Story)
end

function Story:outputText()
	task.spawn(self.output, storyLine[self.place].text)
end

function Story:next(input: string)
	local newPlace = storyLine[self.place].processInput(input)
	if not newPlace then
		return false
	end

	self.place = newPlace
	self:outputText()
	return true
end

return table.freeze(Story)
