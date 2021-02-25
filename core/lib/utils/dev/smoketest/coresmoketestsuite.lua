core:module("CoreSmoketestSuite")
core:import("CoreClass")

Suite = Suite or CoreClass.class()

-- Lines 7-9
function Suite:start(session_state, reporter, suite_arguments)
	assert(false, "Not implemented")
end

-- Lines 11-13
function Suite:is_done()
	assert(false, "Not implemented")
end

-- Lines 15-17
function Suite:update(t, dt)
	assert(false, "Not implemented")
end
