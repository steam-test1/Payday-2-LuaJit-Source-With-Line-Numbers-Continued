NetworkTweakData = NetworkTweakData or class()

-- Lines 4-23
function NetworkTweakData:init(tweak_data)
	self.player_path_interpolation = 2
	self.player_distance_travel = 10000
	self.player_tick_rate = 20
	self.player_max_sync_t = 0
	self.player_husk_path_threshold = 30
	self.player_path_history = 20
	self.look_direction_smooth_step = 16
	self.camera = {
		network_angle_delta = 1,
		network_sync_delta_t = 0.5,
		network_max_sync_t = 0
	}
	self.stealth_speed_boost = 1.005
end
