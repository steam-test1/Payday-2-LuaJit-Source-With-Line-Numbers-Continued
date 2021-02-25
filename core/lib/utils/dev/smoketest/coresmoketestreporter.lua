core:module("CoreSmoketestReporter")
core:import("CoreClass")

Reporter = Reporter or CoreClass.class()

-- Lines 7-8
function Reporter:init()
end

-- Lines 10-12
function Reporter:begin_substep(name)
	cat_print("spam", "[Smoketest] begin_substep " .. name)
end

-- Lines 14-16
function Reporter:end_substep(name)
	cat_print("spam", "[Smoketest] end_substep " .. name)
end

-- Lines 18-20
function Reporter:fail_substep(name)
	cat_print("spam", "[Smoketest] fail_substep " .. name)
end

-- Lines 22-24
function Reporter:tests_done()
	cat_print("spam", "[Smoketest] tests_done")
end
