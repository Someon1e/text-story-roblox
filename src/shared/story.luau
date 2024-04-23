local Story = {}
Story.__index = Story

local storyLine = {
	[[You awaken in a dimly lit chamber with no memory of how you arrived. The air is thick with dust, and the only sound is the faint echo of your own breathing. As you stand up, you notice a mysterious inscription carved into the stone wall:
	"Welcome, traveler, to the forgotten realm of Eldoria. Long ago, this land flourished with magic and prosperity, but now it lies shrouded in darkness. You have been chosen to embark on a quest to restore light to Eldoria and uncover the truth of your own past. Beware, for many dangers lurk in the shadows, and not all is as it seems."
	You gather your courage and set forth into the unknown, determined to unravel the mysteries of Eldoria and fulfill your destiny.]],
}

function Story.new(output)
	return setmetatable({index = 1, output = output}, Story)
end

function Story:update()
	task.spawn(self.output, storyLine[self.index] or "THE END")
end

function Story:next(input: string)
	self.index += 1
	self:update()
end

return table.freeze(Story)