GroupAIStateEmpty = GroupAIStateEmpty or class(GroupAIStateBase)

-- Lines 3-3
function GroupAIStateEmpty:assign_enemy_to_group_ai(unit)
	return
end

-- Lines 4-4
function GroupAIStateEmpty:on_enemy_tied(u_key)
	return
end

-- Lines 5-5
function GroupAIStateEmpty:on_enemy_untied(u_key)
	return
end

-- Lines 6-6
function GroupAIStateEmpty:on_civilian_tied(u_key)
	return
end

-- Lines 7-7
function GroupAIStateEmpty:can_hostage_flee()
	return
end

-- Lines 8-8
function GroupAIStateEmpty:add_to_surrendered(unit, update)
	return
end

-- Lines 9-9
function GroupAIStateEmpty:remove_from_surrendered(unit)
	return
end

-- Lines 10-10
function GroupAIStateEmpty:flee_point(start_nav_seg)
	return
end

-- Lines 11-11
function GroupAIStateEmpty:on_security_camera_spawned()
	return
end

-- Lines 12-12
function GroupAIStateEmpty:on_security_camera_broken()
	return
end

-- Lines 13-13
function GroupAIStateEmpty:on_security_camera_destroyed()
	return
end

-- Lines 14-14
function GroupAIStateEmpty:on_nav_segment_state_change(changed_seg, state)
	return
end

-- Lines 15-15
function GroupAIStateEmpty:set_area_min_police_force(id, force, pos)
	return
end

-- Lines 16-16
function GroupAIStateEmpty:set_wave_mode(flag)
	return
end

-- Lines 17-17
function GroupAIStateEmpty:add_preferred_spawn_points(id, spawn_points)
	return
end

-- Lines 18-18
function GroupAIStateEmpty:remove_preferred_spawn_points(id)
	return
end

-- Lines 19-19
function GroupAIStateEmpty:register_criminal(unit)
	return
end

-- Lines 20-20
function GroupAIStateEmpty:unregister_criminal(unit)
	return
end

-- Lines 21-21
function GroupAIStateEmpty:on_defend_travel_end(unit, objective)
	return
end

-- Lines 22-22
function GroupAIStateEmpty:is_area_safe()
	return true
end

-- Lines 23-23
function GroupAIStateEmpty:is_nav_seg_safe()
	return true
end

-- Lines 24-24
function GroupAIStateEmpty:set_mission_fwd_vector(direction)
	return
end

-- Lines 25-25
function GroupAIStateEmpty:set_drama_build_period(period)
	return
end

-- Lines 26-26
function GroupAIStateEmpty:add_special_objective(id, objective_data)
	return
end

-- Lines 27-27
function GroupAIStateEmpty:remove_special_objective(id)
	return
end

-- Lines 28-28
function GroupAIStateEmpty:save(save_data)
	return
end

-- Lines 29-29
function GroupAIStateEmpty:load(load_data)
	return
end

-- Lines 30-30
function GroupAIStateEmpty:on_cop_jobless(unit)
	return
end

-- Lines 31-31
function GroupAIStateEmpty:spawn_one_teamAI(unit)
	return
end

-- Lines 32-32
function GroupAIStateEmpty:remove_one_teamAI(unit)
	return
end

-- Lines 33-33
function GroupAIStateEmpty:fill_criminal_team_with_AI(unit)
	return
end

-- Lines 34-34
function GroupAIStateEmpty:set_importance_weight(cop_unit, dis_report)
	return
end

-- Lines 35-35
function GroupAIStateEmpty:on_criminal_recovered(criminal_unit)
	return
end

-- Lines 36-36
function GroupAIStateEmpty:on_criminal_disabled(unit)
	return
end

-- Lines 37-37
function GroupAIStateEmpty:on_criminal_neutralized(unit)
	return
end

-- Lines 38-38
function GroupAIStateEmpty:is_detection_persistent()
	return
end

-- Lines 39-39
function GroupAIStateEmpty:on_nav_link_unregistered()
	return
end

-- Lines 40-40
function GroupAIStateEmpty:save()
	return
end

-- Lines 41-41
function GroupAIStateEmpty:load()
	return
end
