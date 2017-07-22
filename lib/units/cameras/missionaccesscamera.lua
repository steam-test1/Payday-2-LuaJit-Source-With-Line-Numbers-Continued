MissionAccessCamera = MissionAccessCamera or class()

-- Lines: 3 to 25
function MissionAccessCamera:init(unit)
	self._unit = unit
	self._camera = World:create_camera()
	self._default_fov = 57
	self._fov = self._default_fov

	self._camera:set_fov(self._default_fov)
	self._camera:set_near_range(15)
	self._camera:set_far_range(250000)

	self._viewport = managers.viewport:new_vp(0, 0, 1, 1, "MissionAccessCamera", CoreManagerBase.PRIO_WORLDCAMERA)
	self._director = self._viewport:director()
	self._shaker = self._director:shaker()
	self._camera_controller = self._director:make_camera(self._camera, Idstring("previs_camera"))

	self._viewport:set_camera(self._camera)
	self._director:set_camera(self._camera_controller)
	self._director:position_as(self._camera)
	self._camera_controller:set_both(self._unit)
end

-- Lines: 27 to 37
function MissionAccessCamera:_setup_sound_listener()
	self._listener_id = managers.listener:add_listener("access_camera", self._camera, self._camera, nil, false)

	managers.listener:add_set("access_camera", {"access_camera"})

	self._listener_activation_id = managers.listener:activate_set("main", "access_camera")
	self._sound_check_object = managers.sound_environment:add_check_object({
		primary = true,
		active = true,
		object = self._unit:orientation_object()
	})
end

-- Lines: 39 to 42
function MissionAccessCamera:set_rotation(rotation)
	self._original_rotation = rotation

	self._unit:set_rotation(rotation)
end

-- Lines: 44 to 45
function MissionAccessCamera:get_original_rotation()
	return self._original_rotation
end

-- Lines: 48 to 49
function MissionAccessCamera:get_offset_rotation()
	return self._offset_rotation
end

-- Lines: 52 to 60
function MissionAccessCamera:start(time)
	self._playing = true

	self._unit:anim_stop(Idstring("camera_animation"))

	self._fov = self._default_fov

	self._viewport:set_active(true)
end

-- Lines: 62 to 68
function MissionAccessCamera:stop()
	self._viewport:set_active(false)
	self._unit:anim_stop(Idstring("camera_animation"))
	self._unit:anim_set_time(Idstring("camera_animation"), 0)

	self._playing = false
end

-- Lines: 76 to 77
function MissionAccessCamera:set_destroyed(destroyed)
end

-- Lines: 82 to 85
function MissionAccessCamera:modify_fov(fov)
	self._fov = math.clamp(self._fov + fov, 25, 75)

	self._camera:set_fov(self._fov)
end

-- Lines: 87 to 88
function MissionAccessCamera:zoomed_value()
	return self._fov / self._default_fov
end

-- Lines: 91 to 102
function MissionAccessCamera:set_offset_rotation(yaw, pitch, roll)
	self._offset_rotation = self._offset_rotation or Rotation()
	yaw = yaw + mrotation.yaw(self._original_rotation)
	pitch = pitch + mrotation.pitch(self._original_rotation)

	mrotation.set_yaw_pitch_roll(self._offset_rotation, yaw, pitch, roll)
	self._unit:set_rotation(self._offset_rotation)
end

-- Lines: 104 to 121
function MissionAccessCamera:destroy()
	if self._viewport then
		self._viewport:destroy()

		self._viewport = nil
	end

	if alive(self._camera) then
		World:delete_camera(self._camera)

		self._camera = nil
	end

	if self._listener_id then
		managers.sound_environment:remove_check_object(self._sound_check_object)
		managers.listener:remove_listener(self._listener_id)
		managers.listener:remove_set("access_camera")

		self._listener_id = nil
	end
end

return
