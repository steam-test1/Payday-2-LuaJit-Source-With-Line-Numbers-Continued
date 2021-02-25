SequenceActivator = SequenceActivator or class()

-- Lines 6-13
function SequenceActivator:init(unit)
	local count = #self._sequences

	for i = 1, count do
		unit:damage():run_sequence_simple(self._sequences[i])

		self._sequences[i] = nil
	end

	self._sequences = nil
end
