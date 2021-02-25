NetworkFriend = NetworkFriend or class()

-- Lines 17-21
function NetworkFriend:init(id, name, signin_status)
	self._id = id
	self._name = name
	self._signin_status = signin_status
end

-- Lines 23-25
function NetworkFriend:id()
	return self._id
end

-- Lines 27-29
function NetworkFriend:name()
	return self._name
end

-- Lines 31-33
function NetworkFriend:signin_status()
	return self._signin_status
end
