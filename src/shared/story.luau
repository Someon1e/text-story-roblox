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
		text = 
[[You awaken in a dimly lit chamber with no memory of how you arrived.
The air is thick with dust, and the only sound is the faint echo of your own breathing.

As you stand up, you notice a mysterious inscription carved into the stone wall:
	"Welcome, traveler, to the forgotten realm of Eldoria.
	Long ago, this land flourished with magic and prosperity, but now it lies shrouded in darkness.
	You have been chosen to embark on a quest to restore light to Eldoria and uncover the truth of your own past.
	Beware, for many dangers lurk in the shadows, and not all is as it seems."

You gather your courage and set forth into the unknown, determined to unravel the mysteries of Eldoria and fulfill your destiny.

You find yourself standing at the entrance of a dense forest. What will you do?
	Enter the forest and explore
	Search the area for clues
	Wait and observe]],
		processInput = function(input: string)
			local entering = lowercaseFind(input, {"enter", "forest"})
			local searching = lowercaseFind(input, {"search", "clues"})
			local waiting = lowercaseFind(input, {"wait", "observe"})

			if entering then
				-- Only one choice
				if searching or waiting then
					return false
				end

				return "ending"
			elseif searching then
				-- Only one choice
				if entering or waiting then
					return false
				end

				return "ending"
			elseif waiting then
				-- Only one choice
				if entering or searching then
					return false
				end

				return "ending"
			end

			return false
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
