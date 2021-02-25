PacketNetworkHandler = PacketNetworkHandler or class(BaseNetworkHandler)

-- Lines 7-13
function PacketNetworkHandler:_set_shared_data(packet_id, target_peer, sender_peer, cb_id, arb_cb_id)
	self._shared_data.packet_id = packet_id
	self._shared_data.target_peer = target_peer
	self._shared_data.sender_peer = sender_peer
	self._shared_data.cb_id = cb_id
	self._shared_data.arb_cb_id = arb_cb_id
end

-- Lines 15-17
function PacketNetworkHandler:forward_message_req_ack(packet_id, target_peer, sender_peer, cb_id)
	self:_set_shared_data(packet_id, target_peer, sender_peer, cb_id, nil)
end

-- Lines 18-20
function PacketNetworkHandler:message_req_ack(packet_id, sender_peer, cb_id)
	self:_set_shared_data(packet_id, nil, sender_peer, cb_id, nil)
end

-- Lines 21-23
function PacketNetworkHandler:forward_message_arb_req_ack(packet_id, target_peer, sender_peer, cb_id, arb_cb_id)
	self:_set_shared_data(packet_id, target_peer, sender_peer, cb_id, arb_cb_id)
end

-- Lines 24-26
function PacketNetworkHandler:message_arb_req_ack(packet_id, sender_peer, cb_id, arb_cb_id)
	self:_set_shared_data(packet_id, nil, sender_peer, cb_id, arb_cb_id)
end

-- Lines 28-30
function PacketNetworkHandler:message_arbitrate_answer(cb_id, answer, sender)
	self:_do_cb(cb_id, answer)
end

-- Lines 36-38
function PacketNetworkHandler:message_ack(target_peer, cb_id, sender)
	self:_do_cb(cb_id)
end
