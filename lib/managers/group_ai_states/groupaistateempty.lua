GroupAIStateEmpty = GroupAIStateEmpty or class(GroupAIStateBase)

-- Lines 3-3
function GroupAIStateEmpty:assign_enemy_to_group_ai(unit)
end

-- Lines 4-4
function GroupAIStateEmpty:on_enemy_tied(u_key)
end

-- Lines 5-5
function GroupAIStateEmpty:on_enemy_untied(u_key)
end

-- Lines 6-6
function GroupAIStateEmpty:on_civilian_tied(u_key)
end

-- Lines 7-7
function GroupAIStateEmpty:can_hostage_flee()
end

-- Lines 8-8
function GroupAIStateEmpty:add_to_surrendered(unit, update)
end

-- Lines 9-9
function GroupAIStateEmpty:remove_from_surrendered(unit)
end

-- Lines 10-10
function GroupAIStateEmpty:flee_point(start_nav_seg)
end

-- Lines 11-11
function GroupAIStateEmpty:on_security_camera_spawned()
end

-- Lines 12-12
function GroupAIStateEmpty:on_security_camera_broken()
end

-- Lines 13-13
function GroupAIStateEmpty:on_security_camera_destroyed()
end

-- Lines 14-14
function GroupAIStateEmpty:on_nav_segment_state_change(changed_seg, state)
end

-- Lines 15-15
function GroupAIStateEmpty:set_area_min_police_force(id, force, pos)
end

-- Lines 16-16
function GroupAIStateEmpty:set_wave_mode(flag)
end

-- Lines 17-17
function GroupAIStateEmpty:add_preferred_spawn_points(id, spawn_points)
end

-- Lines 18-18
function GroupAIStateEmpty:remove_preferred_spawn_points(id)
end

-- Lines 19-19
function GroupAIStateEmpty:register_criminal(unit)
end

-- Lines 20-20
function GroupAIStateEmpty:unregister_criminal(unit)
end

-- Lines 21-21
function GroupAIStateEmpty:on_defend_travel_end(unit, objective)
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
end

-- Lines 25-25
function GroupAIStateEmpty:set_drama_build_period(period)
end

-- Lines 26-26
function GroupAIStateEmpty:add_special_objective(id, objective_data)
end

-- Lines 27-27
function GroupAIStateEmpty:remove_special_objective(id)
end

-- Lines 28-28
function GroupAIStateEmpty:save(save_data)
end

-- Lines 29-29
function GroupAIStateEmpty:load(load_data)
end

-- Lines 30-30
function GroupAIStateEmpty:on_cop_jobless(unit)
end

-- Lines 31-31
function GroupAIStateEmpty:spawn_one_teamAI(unit)
end

-- Lines 32-32
function GroupAIStateEmpty:remove_one_teamAI(unit)
end

-- Lines 33-33
function GroupAIStateEmpty:fill_criminal_team_with_AI(unit)
end

-- Lines 34-34
function GroupAIStateEmpty:set_importance_weight(cop_unit, dis_report)
end

-- Lines 35-35
function GroupAIStateEmpty:on_criminal_recovered(criminal_unit)
end

-- Lines 36-36
function GroupAIStateEmpty:on_criminal_disabled(unit)
end

-- Lines 37-37
function GroupAIStateEmpty:on_criminal_neutralized(unit)
end

-- Lines 38-38
function GroupAIStateEmpty:is_detection_persistent()
end

-- Lines 39-39
function GroupAIStateEmpty:on_nav_link_unregistered()
end

-- Lines 40-40
function GroupAIStateEmpty:save()
end

-- Lines 41-41
function GroupAIStateEmpty:load()
end
